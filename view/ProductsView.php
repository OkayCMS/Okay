<?php

require_once('View.php');

class ProductsView extends View {

    // ЧПУ
    private $meta_array = array();
    private $set_canonical = false;
    private $meta = array('h1'=>'','title'=>'','keywords'=>'','description'=>'');
    private $seo_filter_pattern = array('h1'=>'','title'=>'','keywords'=>'','meta_description'=>'','description'=>'');
    private $meta_delimiter = ', ';
    private $subdir = '';
    private $lang_label = '';
    private $catalog_type = '';
    private $uri_array = array();
    private $is_wrong_params = 0;
    private $features_urls = array();
    private $category_brands = array();
    private $max_filter_brands = 1;
    private $max_filter_filter = 1;
    private $max_filter_options = 1;
    private $max_filter_features = 1;
    private $max_filter_depth = 1;
    private $other_filters = array('discounted', 'featured');

    public function __construct() {
        parent::__construct();
        $this->lang_label = $this->language->label;
        if (strlen($this->config->subfolder) > 1) {
            $this->subdir = "/?".$this->config->subfolder;
        }
        $translations = $this->translations->get_translations(array('lang'=>$this->language->label));

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
        $this->uri_array = $this->filter_chpu_parse_url();
        foreach($this->uri_array as $k=>$v) {
            if(empty($v)) {
                continue;
            }
            if(!$k && $brand=$this->brands->get_brand((string)$v)) {
                //$_GET['brand'] = $brand->url;
                $this->is_wrong_params = 1;
            } else {
                @list($param_name, $param_values) = explode('-',$v);
                if (in_array($this->page->url, array('all-products', 'discounted', 'bestsellers'))
                        && !in_array($param_name, array('page', 'sort'))) {
                    $this->is_wrong_params = 1;
                    break;
                }
                switch($param_name) {
                    case 'brand': {
                        $_GET['b'] = array();
                        foreach(explode('_',$param_values) as $bv) {
                            if(($brand = $this->brands->get_brand((string)$bv)) && !in_array($brand->id, $_GET['b'])) {
                                $_GET['b'][] = $brand->id;
                                $this->meta_array['brand'][$brand->id] = $translations->products_brand.' '. $brand->name;
                            } else {
                                $this->is_wrong_params = 1;
                            }
                        }
                        break;
                    }
                    case 'filter': {
                        $_GET['filter'] = array();
                        foreach(explode('_',$param_values) as $f) {
                            if(!in_array($f, $_GET['filter']) && in_array($f, $this->other_filters)) {
                                $_GET['filter'][] = $f;
                                $this->meta_array['filter'][] = $translations->{"features_filter_".$f};
                            } else {
                                $this->is_wrong_params = 1;
                            }
                        }
                        break;
                    }
                    case 'page': {
                        $_GET['page'] = $param_values;
                        if ($param_values != 'all' && (!preg_match('~^[0-9]+$~', $param_values) || strpos($param_values, '0') === 0)) {
                            $this->is_wrong_params = 1;
                        }
                        break;
                    }
                    case 'sort': {
                        $_GET['sort'] = strval($param_values);
                        if (!in_array($_GET['sort'], array('position', 'price', 'price_desc', 'name', 'name_desc', 'rating', 'rating_desc'))) {
                            $this->is_wrong_params = 1;
                        }
                        break;
                    }
                    default: {
                        if(($feature = $this->features->get_feature($param_name)) && $feature->in_filter && !isset($_GET[$feature->id])) {
                            $_GET[$feature->id] = explode('_',$param_values);
                            // если нет повторяющихся значений свойства - ок, иначе 404
                            if (count($_GET[$feature->id]) == count(array_unique($_GET[$feature->id]))) {
                                $option_translits = array();
                                foreach ($this->features->get_options(array('feature_id' => $feature->id)) as $fo) {
                                    $option_translits[] = $fo->translit;
                                    if (in_array($fo->translit, $_GET[$feature->id])) {
                                        $this->meta_array['options'][$feature->id][] = $fo->value;
                                    }
                                }
                                foreach ($_GET[$feature->id] as $param_value) {
                                    if (!in_array($param_value, $option_translits)) {
                                        $this->is_wrong_params = 1;
                                        break;
                                    }
                                }
                            } else {
                                $this->is_wrong_params = 1;
                            }
                        } else {
                            $this->is_wrong_params = 1;
                        }
                    }
                }
            }
        }

        if(!empty($this->meta_array)) {
            foreach($this->meta_array as $type=>$_meta_array) {
                switch($type) {
                    case 'brand': {
                        if(count($_meta_array) > $this->max_filter_brands) {
                            $this->set_canonical = true;
                        }
                        $this->meta['h1'] = $this->meta['title'] = $this->meta['keywords'] = $this->meta['description'] = implode($this->meta_delimiter,$_meta_array);
                        break;
                    }
                    case 'filter': {
                        if(count($_meta_array) > $this->max_filter_filter) {
                            $this->set_canonical = true;
                        }
                        $this->meta['h1'] = $this->meta['title'] = $this->meta['keywords'] = $this->meta['description'] = implode($this->meta_delimiter,$_meta_array);
                        break;
                    }
                    case 'options': {
                        foreach($_meta_array as $f_id=>$f_array) {
                            if(count($f_array) > $this->max_filter_options || count($_meta_array) > $this->max_filter_features) {
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
            
            if (count($this->meta_array) > $this->max_filter_depth) {
                $this->set_canonical = true;
            }
            
            if ($languages = $this->design->get_var('languages')) {
                $first_lang = $this->languages->get_first_language();
                 $cp = $this->lang_link;
                foreach ($languages as $l) {
                    $this->lang_link = ($first_lang->id != $l->id) ? $l->label.'/' : '';
                    $l->url = $this->filter_chpu_url(array('sort'=>null, 'brand'=>null), $this->design);
                }
                $this->lang_link = $cp;
                $this->design->assign('languages', $languages);
            }
        }

        if(!empty($this->meta['h1'])) {
            $this->meta['h1']           = !empty($translations->ceo_filter_s_harakteristikami) ? ' ' : ''.$translations->ceo_filter_s_harakteristikami.' '.$this->meta['h1'];
        }
        if(!empty($this->meta['title'])) {
            $this->meta['title']        = !empty($translations->ceo_filter_s_harakteristikami) ? ' ' : ''.$translations->ceo_filter_s_harakteristikami.' '.$this->meta['title'];
        }
        if(!empty($this->meta['keywords'])) {
            $this->meta['keywords']     = !empty($translations->ceo_filter_s_harakteristikami) ? ' ' : ''.$translations->ceo_filter_s_harakteristikami.' '.$this->meta['keywords'];
        }
        if(!empty($this->meta['description'])) {
            $this->meta['description']  = !empty($translations->ceo_filter_s_harakteristikami) ? ' ' : ''.$translations->ceo_filter_s_harakteristikami.' '.$this->meta['description'];
        }

        if($this->set_canonical) {
            $this->meta['h1'] = $this->meta['title'] = $this->meta['keywords'] = $this->meta['description'] = '';
        }

        $this->design->assign('set_canonical',$this->set_canonical);
        $this->design->assign('filter_meta',(object)$this->meta);
        $this->design->assign('hide_alternate', !empty($this->meta_array));
        if (empty($this->meta_array)) {
            $this->design->assign('self_canonical', true);
        }

        $this->design->smarty->registerPlugin('function', 'furl', array($this, 'filter_chpu_url'));
    }

    public function filter_chpu_url($params, &$smarty) {
        if(is_array(reset($params))) {
            $params = reset($params);
        }

        $result_array = array('brand'=>array(),'features'=>array(), 'filter'=>array(), 'sort'=>null,'page'=>null);
        //Определяем, что у нас уже есть в строке
        foreach($this->uri_array as $k=>$v) {
            list($param_name, $param_values) = explode('-',$v);
            switch($param_name) {
                case 'brand': {
                    $result_array['brand'] = explode('_',$param_values);
                    break;
                }
                case 'filter': {
                    $result_array['filter'] = explode('_',$param_values);
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
                case 'filter': {
                    if (is_null($v)) {
                        unset($result_array['filter']);
                    } elseif (in_array($v, $result_array['filter'])) {
                        unset($result_array['filter'][array_search($v, $result_array['filter'])]);
                    } else {
                        $result_array['filter'][] = $v;
                    }
                    if (empty($result_array['filter'])) {
                        unset($result_array['filter']);
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
                    if(empty($result_array['features'][$k])) {
                        unset($result_array['features'][$k]);
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

        $filter_params_count = 0;
        $link_tag = "a";
        if(!empty($result_array['brand'])) {
            if (count($result_array['brand']) > $this->max_filter_brands) {
                $link_tag = "span";
            }
            $filter_params_count ++;
            $brands_string = $this->filter_chpu_sort_brands($result_array['brand']); // - это с сортировкой по брендам
            if (!empty($brands_string)) {
                $result_string .= '/brand-' . implode("_", $brands_string);
            }
        }
        foreach($result_array['features'] as $k=>$v) {
            if (count($result_array['features'][$k]) > $this->max_filter_options || count($result_array['features']) > $this->max_filter_features) {
                $link_tag = "span";
            }
        }
        if(!empty($result_array['filter'])) {
            if(count($result_array['filter']) > $this->max_filter_filter) {
                $link_tag = "span";
            }
            $filter_params_count ++;
            $result_string .= '/filter-' . implode("_", $result_array['filter']);
        }
        
        if(!empty($result_array['features'])) {
            $filter_params_count ++;
            $result_string .= $this->filter_chpu_sort_features($result_array['features']);
        }

        if ($filter_params_count > $this->max_filter_depth) {
            $link_tag = "span";
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
        $smarty->assign('link_tag', $link_tag);
        //отдаем сформированную ссылку
        return $result_string;
    }

    private function filter_chpu_sort_brands($brands_urls = array()) {
        if(empty($brands_urls)) {
            return false;
        }
        $result = array();
        foreach ($this->category_brands as $b) {
            if (in_array($b->url, $brands_urls)) {
                $result[] = $b->url;
            }
        }
        return $result;
    }

    private function filter_chpu_sort_features($features = array()) {
        if(empty($features)) {
            return false;
        }
        $result_string = '';
        foreach ($this->features_urls as $furl) {
            if (in_array($furl, array_keys($features))) {
                $result_string .= '/'.$furl.'-'.implode('_', $features[$furl]);
            }
        }
        return $result_string;
    }

    private function filter_chpu_parse_url() {
        $uri = @parse_url($_SERVER["REQUEST_URI"]);
        preg_match("~^$this->subdir(/?$this->lang_label)?/?(catalog|all-products|brands|discounted|bestsellers)/?~", $uri['path'], $this->catalog_type);
        $this->catalog_type = $this->catalog_type[2];
        //убираем модификатор каталога
        $uri = preg_replace("~^$this->subdir(/?$this->lang_label)?/?(catalog|all-products|brands|discounted|bestsellers)/?~",'',$uri['path']);
        $this->uri_array = (empty($uri) ? array() : explode('/',$uri));
        if ($this->catalog_type == 'catalog' || $this->catalog_type == 'brands') {
            array_shift($this->uri_array);
        }
        return $this->uri_array;
    }
    // ЧПУ END

    /*Отображение каталога*/
    public function fetch() {
        if ($this->is_wrong_params) {
            return false;
        }
        // GET-Параметры
        $category_url = $this->request->get('category', 'string');
        $brand_url    = $this->request->get('brand', 'string');

        $filter = array();
        $filter['visible'] = 1;

        // Если задан бренд, выберем его из базы
        $prices = array();
        $prices['current'] = $this->request->get('p');
        if (isset($prices['current']['min']) && isset($prices['current']['max']) && $prices['current']['max'] != '' && $prices['current']['min'] != '') {
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

        if ($f = $this->request->get("filter")) {
            $filter['other_filter'] = $f;
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

        // Если задано ключевое слово
        $keyword = $this->request->get('keyword');
        if (!empty($keyword)) {
            $this->design->assign('keyword', $keyword);
            $filter['keyword'] = $keyword;
        }

        $mode = $this->request->get('mode');
        if (!empty($mode)) {
            if ($mode == 'bestsellers') {
                $filter['featured'] = 1;
            } elseif ($mode == 'discounted') {
                $filter['discounted'] = 1;
            }
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
                $this->features_urls[] = $feature->url;
                if($val = $this->request->get($feature->id)) {
                    $filter['features'][$feature->id] = $val;
                }
            }

            // Выбираем бренды, они нужны нам в шаблоне
            foreach ($this->brands->get_brands(array('category_id'=>$category->children, 'visible'=>1, 'visible_brand'=>1)) as $b) {
                $this->category_brands[$b->id] = $b;
            }
            $category->brands = $this->brands->get_brands(array('category_id'=>$category->children, 'visible'=>1, 'features'=>$filter['features'], 'visible_brand'=>1, 'other_filter'=>$filter['other_filter']));
            // Если в строке есть параметры которые не должны быть в фильтре, либо параметры с другой категории, бросаем 404
            if (!empty($this->meta_array['options']) && array_intersect_key($this->meta_array['options'], $features) !== $this->meta_array['options'] ||
                !empty($this->meta_array['brand']) && array_intersect_key($this->meta_array['brand'], $this->category_brands) !== $this->meta_array['brand']) {
                return false;
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
            } elseif(isset($filter['brand_id'])) {
                $options_filter['brand_id'] = $filter['brand_id'];
            }

            if ($filter['other_filter']) {
                $options_filter['other_filter'] = $filter['other_filter'];
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

        $other_filters = array();
        if (!in_array($this->page->url, array('all-products', 'discounted', 'bestsellers'))) {
            $translations = $this->translations->get_translations(array('lang'=>$this->language->label));
            foreach ($this->other_filters as $f) {
                $label = 'features_filter_'.$f;
                $item = (object)array('url'=>$f, 'name'=>$translations->{$label}, 'translation'=>$label);
                if (!in_array($f, $filter['other_filter'])) {
                    $tm_filter = $filter;
                    $tm_filter['other_filter'] = array($f);
                    $cnt = $this->products->count_products($tm_filter);
                    if ($cnt > 0) {
                        $other_filters[] = $item;
                    }
                } else {
                    $other_filters[] = $item;
                }
            }
        }
        $this->design->assign('other_filters', $other_filters);
        
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

        if ($this->request->get('page') != 'all' && $current_page > 1 && $current_page > $pages_num) {
            return false;
        }
        //lastModify
        $last_modify = array();
        $brand_id_filter = '';
        $category_id_filter = '';
        if(!empty($filter['brand_id'])) {
            $brand_id_filter = $this->db->placehold('AND p.brand_id in(?@)', (array)$filter['brand_id']);
            if(!empty($brand)){
                $last_modify[] = $brand->last_modify;
            }
        }
        if(!empty($filter['category_id'])) {
            $category_id_filter = $this->db->placehold('INNER JOIN __products_categories pc ON pc.product_id = p.id AND pc.category_id in(?@)', (array)$filter['category_id']);
            $last_modify[] = $category->last_modify;
        }
        $this->db->query("SELECT MAX(p.last_modify) as last_modify
            FROM __products p
            $category_id_filter
            WHERE 1 $brand_id_filter");
        $res = $this->db->result('last_modify');
        if (!empty($res)) {
            $last_modify[] = $res;
        }
        if ($this->page) {
            $last_modify[] = $this->page->last_modify;
        }
        $this->setHeaderLastModify(max($last_modify));
        //lastModify END
        /*Постраничная навигация END*/

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

        if ($category) {
            $parts = array(
                '{$category}' => ($category->name ? $category->name : ''),
                '{$category_h1}' => ($category->name_h1 ? $category->name_h1 : ''),
                '{$sitename}' => ($this->settings->site_name ? $this->settings->site_name : '')
            );

            if (!empty($filter['features'])) {
                foreach ($this->features_aliases->get_feature_aliases_values(array('feature_id'=>array_keys($filter['features']))) as $fv) {
                    $parts['{$f_alias_'.$fv->variable.'}'] = $fv->value;
                }
                // Если только одно значение одного свойства, получим для него все алиасы значения
                if (count($filter['features']) == 1 && (count($translits = reset($filter['features']))) == 1) {
                    $option_translit = reset($translits);
                }
                foreach ($this->features_aliases->get_options_aliases_values(array('feature_id'=>array_keys($filter['features']), 'translit'=>$option_translit)) as $ov) {
                    $parts['{$o_alias_'.$ov->variable.'}'] = $ov->value;
                }
            }

            if ($this->meta_array['brand'] && count($this->meta_array['brand']) == 1 && !$this->meta_array['options']) {
                $parts['{$brand}'] = reset($this->meta_array['brand']);
                $seo_filter_patterns = $this->seo_filter_patterns->get_patterns(array('category_id'=>$category->id, 'type'=>'brand'));
                $seo_filter_pattern = reset($seo_filter_patterns);

            } elseif ($this->meta_array['options']  && count($this->meta_array['options']) == 1 && !$this->meta_array['brand']) {

                foreach($this->seo_filter_patterns->get_patterns(array('category_id'=>$category->id, 'type'=>'feature')) as $p) {
                    $key = 'feature'.(!empty($p->feature_id) ? '_'.$p->feature_id : '');
                    $seo_filter_patterns[$key] = $p;
                }

                reset($this->meta_array['options']);
                $feature_id = key($this->meta_array['options']);
                $feature = $this->features->get_feature((int)$feature_id);

                // Определяем какой шаблон брать, для категории + определенное свойство, или категории и любое свойство
                if (isset($seo_filter_patterns['feature_'.$feature->id])) {
                    $seo_filter_pattern = $seo_filter_patterns['feature_'.$feature->id];
                } else {
                    $seo_filter_pattern = $seo_filter_patterns['feature'];
                }

                $parts['{$feature_name}'] = $feature->name;
                $parts['{$feature_val}'] = implode($this->meta_delimiter, reset($this->meta_array['options']));
            }

            $this->seo_filter_pattern['h1']               = strtr($seo_filter_pattern->h1, $parts);
            $this->seo_filter_pattern['title']            = strtr($seo_filter_pattern->title, $parts);
            $this->seo_filter_pattern['keywords']         = strtr($seo_filter_pattern->keywords, $parts);
            $this->seo_filter_pattern['meta_description'] = strtr($seo_filter_pattern->meta_description, $parts);
            $this->seo_filter_pattern['description']      = strtr($seo_filter_pattern->description, $parts);

            $this->seo_filter_pattern['h1']               = preg_replace('/\{\$[^\$]*\}/', '', $this->seo_filter_pattern['h1']);
            $this->seo_filter_pattern['title']            = preg_replace('/\{\$[^\$]*\}/', '', $this->seo_filter_pattern['title']);
            $this->seo_filter_pattern['keywords']         = preg_replace('/\{\$[^\$]*\}/', '', $this->seo_filter_pattern['keywords']);
            $this->seo_filter_pattern['meta_description'] = preg_replace('/\{\$[^\$]*\}/', '', $this->seo_filter_pattern['meta_description']);
            $this->seo_filter_pattern['description']      = preg_replace('/\{\$[^\$]*\}/', '', $this->seo_filter_pattern['description']);

            $this->design->assign('seo_filter_pattern', (object)$this->seo_filter_pattern);
        }

        // Убираем короткое и полное описание, если клиент использует фильтры и сортировку
        if (!empty($this->uri_array)) {
            $this->design->assign('is_filter', true);
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

        $rel_prev_next = $this->design->fetch('products_rel_prev_next.tpl');
        $this->design->assign('rel_prev_next', $rel_prev_next);
        $this->design->assign('sort_canonical', $this->filter_chpu_url(array('sort'=>null), $this->design));

        $this->body = $this->design->fetch('products.tpl');
        return $this->body;
    }
    
}
