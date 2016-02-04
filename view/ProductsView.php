<?php

require_once('View.php');

class ProductsView extends View {

    // ЧПУ
    private $meta_array = array();
    private $set_canonical = false;
    private $meta = array('h1'=>'','title'=>'','keywords'=>'','description'=>'');
    private $meta_delimiter = ', ';
    private $subdir = '';
    private $lang_label = '';
    private $catalog_type = '';
        
    public function __construct() {
        parent::__construct();
        $this->lang_label = $this->language->label;
        if (strlen($this->config->subfolder) > 1) {
            $this->subdir = "/?".$this->config->subfolder;
        }
        
        /**
         *
         * внешний вид параметров:
         * brand-brandUrl1_brandUrl2... - фильтр по брендам
         * paramUrl-paramValue1_paramValue2... - фильтр по мультисвойствам
         * page-pageNumber - постраничная навигация
         * sort-sortParam - параметры сортировки
         *
         */
        
        //определение текущего положения и выставленных параметров
        $uri = @parse_url($_SERVER["REQUEST_URI"]);
        preg_match("~$this->subdir(/?$this->lang_label)?/?(catalog|all-products)/?~",$uri['path'], $this->catalog_type);
        $this->catalog_type = $this->catalog_type[2];
        //убираем модификатор каталога
        $uri = preg_replace("~$this->subdir(/?$this->lang_label)?/?(catalog|all-products)/?~",'',$uri['path']);
        $uri_array = explode('/',$uri);
        if ($this->catalog_type == 'catalog') {
            array_shift($uri_array);
        }
        foreach($uri_array as $k=>$v) {
            if(empty($v)) {
                continue;
            }
            if(!$k && $brand=$this->brands->get_brand((string)$v)) {
                $_GET['brand'] = $brand->url;
            } else {
                list($param_name, $param_values) = explode('-',$v);
                switch($param_name) {
                    case 'brand': {
                        foreach(explode('_',$param_values) as $bv) {
                            if($brand = $this->brands->get_brand((string)$bv)) {
                                $_GET['b'][] = $brand->id;
                                $this->meta_array['brand'][] = 'Бренд '. $brand->name;
                            }
                        }
                        break;
                    }
                    case 'page': {
                        $_GET['page'] = $param_values;
                        break;
                    }
                    case 'sort': {
                        $_GET['sort'] = strval($param_values);
                        break;
                    }
                    default: {
                        if($feature = $this->features->get_feature($param_name)) {
                            $_GET[$feature->id] = explode('_',$param_values);
                            foreach($this->features->get_options(array('feature_id'=>$feature->id)) as $fo) {
                                if(in_array($fo->translit,$_GET[$feature->id])) {
                                    $this->meta_array['options'][$feature->id][] = $feature->name . ' '. $fo->value;
                                }
                            }
                        }
                    }
                }
            }
        }
        
        if(!empty($this->meta_array)) {
            foreach($this->meta_array as $type=>$_meta_array) {
                switch($type) {
                    case 'brand': {
                        if(count($_meta_array) > 1) {
                            $this->set_canonical = true;
                        }
                        $this->meta['h1'] = $this->meta['title'] = $this->meta['keywords'] = $this->meta['description'] = implode($this->meta_delimiter,$_meta_array);
                        break;
                    }
                    case 'options': {
                        foreach($_meta_array as $f_id=>$f_array) {
                            if(count($f_array) > 1 || count($_meta_array) > 2) {
                                $this->set_canonical = true;
                            }
                            $this->meta['h1']           .= (!empty($this->meta['h1'])           ? $this->meta_delimiter : '') . implode($this->meta_delimiter,$f_array);
                            $this->meta['title']        .= (!empty($this->meta['title'])        ? $this->meta_delimiter : '') . implode($this->meta_delimiter,$f_array);
                            $this->meta['keywords']     .= (!empty($this->meta['keywords'])     ? $this->meta_delimiter : '') . implode($this->meta_delimiter,$f_array);
                            $this->meta['description']  .= (!empty($this->meta['description'])  ? $this->meta_delimiter : '') . implode($this->meta_delimiter,$f_array);
                        }
                        break;
                    }
                }
            }
        }
        
        if(!empty($this->meta['h1'])) {
            $this->meta['h1']           = ' '.$this->translations->ceo_filter_s_harakteristikami.' '.$this->meta['h1'];
        }
        if(!empty($this->meta['title'])) {
            $this->meta['title']        = ' '.$this->translations->ceo_filter_s_harakteristikami.' '.$this->meta['title'];
        }
        if(!empty($this->meta['keywords'])) {
            $this->meta['keywords']     = ' '.$this->translations->ceo_filter_s_harakteristikami.' '.$this->meta['keywords'];
        }
        if(!empty($this->meta['description'])) {
            $this->meta['description']  = ' '.$this->translations->ceo_filter_s_harakteristikami.' '.$this->meta['description'];
        }
        
        if($this->set_canonical) {
            $this->meta['h1'] = $this->meta['title'] = $this->meta['keywords'] = $this->meta['description'] = '';
        }
        
        $this->design->assign('set_canonical',$this->set_canonical);
        $this->design->assign('filter_meta',(object)$this->meta);
        
        $this->design->smarty->registerPlugin('function', 'furl', array($this, 'filter_chpu_url'));
    }
    public function filter_chpu_url($params) {
        if(is_array(reset($params))) {
            $params = reset($params);
        }
        
        $result_array = array('brand'=>array(),'features'=>array(),'sort'=>null,'page'=>null);
        //Определяем, что у нас уже есть в строке
        $uri = @parse_url($_SERVER["REQUEST_URI"]);
        $uri = preg_replace("~$this->subdir(/?$this->lang_label)?/?(catalog|all-products)/?~",'',$uri['path']);
        $uri_array = explode('/',$uri);
        if ($this->catalog_type == 'catalog') {
            array_shift($uri_array);
        }
        foreach($uri_array as $k=>$v) {
            if($k>0 || !($brand=$this->brands->get_brand((string)$v))) {
                list($param_name, $param_values) = explode('-',$v);
                switch($param_name) {
                    case 'brand': {
                        $result_array['brand'] = explode('_',$param_values);
                        break;
                    }
                    case 'sort': {
                        $result_array['sort'] = strval($param_values);
                        break;
                    }
                    case 'page': {
                        $result_array['page'] = $param_values;
                        break;
                    }
                    default: {
                        $result_array['features'][$param_name] = explode('_',$param_values);
                    }
                }
            }
        }
        //Определяем переданные параметры для ссылки
        foreach($params as $k=>$v) {
            switch($k) {
                case 'brand': {
                    if(is_null($v)) {
                        unset($result_array['brand']);
                    } elseif(in_array($v,$result_array['brand'])) {
                        unset($result_array['brand'][array_search($v,$result_array['brand'])]);
                    } else {
                        $result_array['brand'][] = $v;
                    }
                    break;
                }
                case 'sort':
                    $result_array['sort'] = strval($v);
                    break;
                case 'page':
                    $result_array['page'] = $v;
                    break;
                default:
                    if(is_null($v)) {
                        unset($result_array['features'][$k]);
                    } elseif(!empty($result_array['features']) && in_array($k,array_keys($result_array['features'])) && in_array($v,$result_array['features'][$k])) {
                        unset($result_array['features'][$k][array_search($v,$result_array['features'][$k])]);
                    } else {
                        $result_array['features'][$k][] = $v;
                    }
                break;
            }
        }
        //формируем ссылку
        if (strlen($this->config->subfolder) > 1) {
            $result_string = '/'.$this->config->subfolder.$this->lang_link.$this->catalog_type;
        } else {
            $result_string = '/'.$this->lang_link.$this->catalog_type;
        }
        if(!empty($_GET['category'])) {
            $result_string .= '/' . $_GET['category'];
        }
        if(!empty($_GET['brand'])) {
            $result_string .= '/' . $_GET['brand'];
        }
        
        if(!empty($result_array['brand'])) {
            $result_string .= '/brand-' . implode('_',$this->filter_chpu_sort_brands($result_array['brand'])); // - это с сортировкой по брендам
            //$result_string .= '/brand-' . implode('_',$result_array['brand']); // - это без сортировки по брендам
        }
        foreach($result_array['features'] as $k=>$v) {
            if(empty($result_array['features'][$k])) {
                unset($result_array['features'][$k]);
            }
        }
        if(!empty($result_array['features'])) {
            $result_string .= $this->filter_chpu_sort_features($result_array['features']);
        }
        if(!empty($result_array['sort'])) {
            $result_string .= '/sort-' . $result_array['sort'];
        }
        if($result_array['page'] > 1 || $result_array['page'] == 'all') {
            $result_string .= '/page-' . $result_array['page'];
        }
        $keyword = $this->request->get('keyword');
        if (!empty($keyword)) {
            $result_string .= '?keyword='.$keyword;
        }
        //отдаем сформированную ссылку
        return $result_string;
    }
    private function filter_chpu_sort_brands($brands_urls = array()) {
        if(empty($brands_urls)) {
            return false;
        }
        $this->db->query("SELECT url FROM __brands WHERE url in(?@) ORDER BY name", (array)$brands_urls);
        return $this->db->results('url');
    }
    private function filter_chpu_sort_features($features = array()) {
        if(empty($features)) {
            return false;
        }
        $this->db->query("SELECT url FROM __features WHERE url in(?@) ORDER BY position", (array)array_keys($features));
        $result_string = '';
        foreach($this->db->results('url') as $v) {
            if(in_array($v,array_keys($features))) {
                $result_string .= '/' . $v . '-' . implode('_',$features[$v]);
            }
        }
        return $result_string;
    }
    // ЧПУ END

    public function fetch() {
        // GET-Параметры
        $category_url = $this->request->get('category', 'string');
        $brand_url    = $this->request->get('brand', 'string');
        
        $filter = array();
        $filter['visible'] = 1;
        
        // Если задан бренд, выберем его из базы
        $prices = array();
        $prices['current'] = $this->request->get('p');
        if (!empty($prices['current']['min']) && !empty($prices['current']['max'])) {
            $filter['price'] = $prices['current'];
        } else {
            unset($prices['current']);
        }
        
        if ($val = $this->request->get('b')) {
            $filter['brand_id'] = $val;
        } elseif (!empty($brand_url)) {
            $brand = $this->brands->get_brand((string)$brand_url);
            if (empty($brand)) {
                return false;
            }
            $this->design->assign('brand', $brand);
            $filter['brand_id'] = $brand->id;
        }
        
        // Выберем текущую категорию
        if (!empty($category_url)) {
            $category = $this->categories->get_category((string)$category_url);
            if (empty($category) || (!$category->visible && empty($_SESSION['admin']))) {
                return false;
            }
            $this->design->assign('category', $category);
            $filter['category_id'] = $category->children;
        }
        
        //lastModify
        $last_modify = array();
        $brand_id_filter = '';
        $category_id_filter = '';
        if(!empty($filter['brand_id'])) {
            $brand_id_filter = $this->db->placehold('AND p.brand_id in(?@)', (array)$filter['brand_id']);
            $last_modify[] = $brand->last_modify;
        }
        if(!empty($filter['category_id'])) {
			$category_id_filter = $this->db->placehold('INNER JOIN __products_categories pc ON pc.product_id = p.id AND pc.category_id in(?@)', (array)$filter['category_id']);
            $last_modify[] = $category->last_modify;
		}
        $this->db->query("SELECT p.last_modify
			FROM __products p
			$category_id_filter
			WHERE 1 $brand_id_filter
			GROUP BY p.id");
        $res = $this->db->results('last_modify');
        if (!empty($res)) {
            $last_modify = array_merge($last_modify, $res);
        }
        if ($this->page) {
            $last_modify[] = $this->page->last_modify;
        }
        $this->setHeaderLastModify(max($last_modify));
        //lastModify END
        
        // Если задано ключевое слово
        $keyword = $this->request->get('keyword');
        if (!empty($keyword)) {
            $this->design->assign('keyword', $keyword);
            $filter['keyword'] = $keyword;
        }
        
        // Сортировка товаров, сохраняем в сесси, чтобы текущая сортировка оставалась для всего сайта
        if($sort = $this->request->get('sort', 'string')) {
            $_SESSION['sort'] = $sort;
        }
        if (!empty($_SESSION['sort'])) {
            $filter['sort'] = $_SESSION['sort'];
        } else {
            $filter['sort'] = 'position';
        }
        $this->design->assign('sort', $filter['sort']);
        
        // Свойства товаров
        if(!empty($category)) {
            $features = array();
            foreach($this->features->get_features(array('category_id'=>$category->id, 'in_filter'=>1)) as $feature) {
                $features[$feature->id] = $feature;
                if($val = $this->request->get($feature->id)) {
                    $filter['features'][$feature->id] = $val;
                }
            }
            
            $options_filter['visible'] = 1;
            
            $features_ids = array_keys($features);
            if(!empty($features_ids)) {
                $options_filter['feature_id'] = $features_ids;
            }
            $options_filter['category_id'] = $category->children;
            if(isset($filter['features'])) {
                $options_filter['features'] = $filter['features'];
            }
            if(!empty($brand)) {
                $options_filter['brand_id'] = $brand->id;
            } elseif($filter['brand_id']) {
                $options_filter['brand_id'] = $filter['brand_id'];
            }
            
            $options = $this->features->get_options($options_filter);
            
            foreach($options as $option) {
                if(isset($features[$option->feature_id])) {
                    $features[$option->feature_id]->options[] = $option;
                }
            }
            
            foreach($features as $i=>$feature) {
                if(empty($feature->options)) {
                    unset($features[$i]);
                }
            }
            $this->design->assign('features', $features);
        }
        
        // Постраничная навигация
        $items_per_page = $this->settings->products_num;
        // Текущая страница в постраничном выводе
        $current_page = $this->request->get('page', 'integer');
        // Если не задана, то равна 1
        $current_page = max(1, $current_page);
        $this->design->assign('current_page_num', $current_page);
        // Вычисляем количество страниц
        $products_count = $this->products->count_products($filter);
        
        // Показать все страницы сразу
        if($this->request->get('page') == 'all') {
            $items_per_page = $products_count;
        }
        
        $pages_num = ceil($products_count/$items_per_page);
        $this->design->assign('total_pages_num', $pages_num);
        $this->design->assign('total_products_num', $products_count);
        
        $filter['page'] = $current_page;
        $filter['limit'] = $items_per_page;
        
        ///////////////////////////////////////////////
        // Постраничная навигация END
        ///////////////////////////////////////////////
        
        
        $discount = 0;
        if(isset($_SESSION['user_id']) && $user = $this->users->get_user(intval($_SESSION['user_id']))) {
            $discount = $user->discount;
        }
        
        // Товары
        $products = array();
        foreach($this->products->get_products($filter) as $p) {
            $products[$p->id] = $p;
        }
        
        // Если искали товар и найден ровно один - перенаправляем на него
        if(!empty($keyword) && $products_count == 1 && !$this->request->get('ajax','boolean')) {
            header('Location: '.$this->config->root_url.'/'.$this->lang_link.'products/'.$p->url);
        }
        
        if(!empty($products)) {
            $products_ids = array_keys($products);
            foreach($products as $product) {
                $product->variants = array();
                $product->images = array();
                $product->properties = array();
            }

            $variants = $this->variants->get_variants(array('product_id'=>$products_ids));

            foreach($variants as $variant) {
                //$variant->price *= (100-$discount)/100;
                $products[$variant->product_id]->variants[] = $variant;
            }

            $images = $this->products->get_images(array('product_id'=>$products_ids));
            foreach($images as $image) {
                $products[$image->product_id]->images[] = $image;
            }

            foreach($products as $product) {
                if(isset($product->variants[0])) {
                    $product->variant = $product->variants[0];
                }
                if(isset($product->images[0])) {
                    $product->image = $product->images[0];
                }
            }
            $this->design->assign('products', $products);
        }
        
        // Выбираем бренды, они нужны нам в шаблоне
        if(!empty($category)) {
            $brands = $this->brands->get_brands(array('category_id'=>$category->children, 'visible'=>1));
            $category->brands = $brands;
        }
        
        if(isset($prices['current'])) {
            $prices['current'] = (object)$prices['current'];
        }
        $prices = (object)$prices;
        $range_filter = $filter;
        $range_filter['get_price'] = 1;
        $prices->range = $this->products->count_products($range_filter);
        $this->design->assign('prices', $prices);
        if($this->request->get('ajax','boolean')) {
            $this->design->assign('ajax', 1);
            $result = new StdClass;
            $result->products_content = $this->design->fetch('products_content.tpl');
            $result->products_pagination = $this->design->fetch('chpu_pagination.tpl');
            $result->products_sort = $this->design->fetch('products_sort.tpl');
            print json_encode($result);
            die;
        }
        
        // Устанавливаем мета-теги в зависимости от запроса
        if($this->page) {
            $this->design->assign('meta_title', $this->page->meta_title);
            $this->design->assign('meta_keywords', $this->page->meta_keywords);
            $this->design->assign('meta_description', $this->page->meta_description);
        } elseif(isset($category)) {
            $this->design->assign('meta_title', $category->meta_title);
            $this->design->assign('meta_keywords', $category->meta_keywords);
            $this->design->assign('meta_description', $category->meta_description);
        } elseif(isset($brand)) {
            $this->design->assign('meta_title', $brand->meta_title);
            $this->design->assign('meta_keywords', $brand->meta_keywords);
            $this->design->assign('meta_description', $brand->meta_description);
        } elseif(isset($keyword)) {
            $this->design->assign('meta_title', $keyword);
        }
        
        $this->body = $this->design->fetch('products.tpl');
        return $this->body;
    }
    
}
