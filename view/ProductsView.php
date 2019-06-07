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
    private $is_filter_page = false;
    private $features_urls = array();
    private $category_brands = array();
    private $max_filter_brands;
    private $max_filter_filter;
    private $max_filter_features_values;
    private $max_filter_features;
    private $max_filter_depth;
    private $values_ids = array();
    private $other_filters = array('discounted', 'featured');
    private $category;
    private $category_features = array();
    private $category_features_by_url = array();
    private $selected_features_values = array();

    public function __construct() {
        parent::__construct();

        $this->max_filter_brands          = $this->settings->max_filter_brands;
        $this->max_filter_filter          = $this->settings->max_filter_filter;
        $this->max_filter_features_values = $this->settings->max_filter_features_values;
        $this->max_filter_features        = $this->settings->max_filter_features;
        $this->max_filter_depth           = $this->settings->max_filter_depth;
        
        $this->lang_label = $this->language->label;
        if (strlen($this->config->subfolder) > 1) {
            $this->subdir = "/?".$this->config->subfolder;
        }
        $this->translations->debug = (bool)$this->config->debug_translation;
        $translations = $this->translations->get_translations(array('lang'=>$this->language->label));

        if ($category_url = $this->request->get('category', 'string')) {
            $this->category = $this->categories->get_category((string)$category_url);

            if (empty($this->category) || (!$this->category->visible && empty($_SESSION['admin']))) {
                $this->is_wrong_params = 1;
            }
            
            foreach($this->features->get_features(array('category_id'=>$this->category->id, 'in_filter'=>1)) as $feature) {
                $this->category_features[$feature->id] = $feature;
                $this->category_features_by_url[$feature->url] = $feature;
                $this->features_urls[$feature->id] = $feature->url;
            }
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

        $_GET['b'] = array();
        //определение текущего положения и выставленных параметров
        $this->uri_array = $this->filter_chpu_parse_url();
        foreach($this->uri_array as $k=>$v) {
            if(empty($v)) {
                continue;
            }
            // TODO Сделать один get_brands() (подумать)
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
                        foreach(explode('_',$param_values) as $bv) {
                            // TODO Сделать один get_brands() (подумать)
                            if(($brand = $this->brands->get_brand((string)$bv)) && !in_array($brand->id, $_GET['b'])) {
                                $_GET['b'][] = $brand->id;
                                $this->meta_array['brand'][$brand->id] = $brand->name;
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
                        if(isset($this->category_features_by_url[$param_name])
                            && ($feature = $this->category_features_by_url[$param_name])
                            && !isset($selected_features[$feature->id])) {
                            
                            $selected_features[$feature->id] = explode('_',$param_values);
                        } else {
                            $this->is_wrong_params = 1;
                        }
                    }
                }
            }
        }
        
        if (!empty($selected_features)) {
            if (!empty($this->category_features)) {
                // Выше мы определили какие значения каких свойств выбраны, теперь достаем эти значения из базы, чтобы за один раз
                foreach ($this->features_values->get_features_values(array('selected_features'=>$selected_features, 'category_id'=>$this->category->children)) as $fv) {
                    $this->values_ids[$fv->feature_id][$fv->translit] = $fv->id;
                    $this->selected_features_values[$fv->feature_id][$fv->id] = $fv;
                }
            }
            
            foreach ($selected_features as $feature_id=>$values) {
                $_GET[$feature_id] = $values;
                // если нет повторяющихся значений свойства - ок, иначе 404
                if (count($_GET[$feature_id]) == count(array_unique($_GET[$feature_id]))) {
                    if (isset($this->selected_features_values[$feature_id])) {
                        foreach ($this->selected_features_values[$feature_id] as $fv) {
                            if (in_array($fv->translit, $_GET[$feature_id], true)) {
                                if (!$fv->to_index) {
                                    $this->set_canonical = true;
                                }
                                $this->meta_array['features_values'][$feature_id][$fv->id] = $fv->value;
                            }
                        }
                    }
                    foreach ($_GET[$feature_id] as $param_value) {
                        if (!in_array($param_value, array_keys($this->values_ids[$feature_id]))) {
                            $this->is_wrong_params = 1;
                            break;
                        }
                    }
                } else {
                    $this->is_wrong_params = 1;
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
                    case 'features_values': {
                        foreach($_meta_array as $f_id=>$f_array) {
                            if(count($f_array) > $this->max_filter_features_values || count($_meta_array) > $this->max_filter_features) {
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
            
            // Достаем выбранные значения свойств для других языков
            $lang_values_filter = array();
            foreach ($this->meta_array['features_values'] as $feature_id=>$values) {
                $lang_values_filter[$feature_id] = array_keys($values);
            }
            $lang_values = $this->features_values->get_features_values_all_lang($lang_values_filter);
            
            if ($languages = $this->design->get_var('languages')) {
                $first_lang = $this->languages->get_first_language();
                $cp = $this->lang_link;
                
                //  Заменяем url языка с учетом ЧПУ
                foreach ($languages as $l) {
                    $furl = array('sort'=>null);
                    // Для каждого значения, выбираем все его варианты на других языках
                    foreach ($this->meta_array['features_values'] as $feature_id=>$values) {
                        if (isset($this->features_urls[$feature_id])) {
                            foreach (array_keys($values) as $fv_id) {
                                if (isset($lang_values[$l->id][$feature_id][$fv_id])) {
                                    $translit = $lang_values[$l->id][$feature_id][$fv_id]->translit;
                                    $feature_url = $this->features_urls[$feature_id];
                                    $furl[$feature_url][$fv_id] = $translit;
                                    // Дополняем массив id значений для других языков
                                    $this->values_ids[$feature_id][$translit] = $fv_id;
                                }
                            }
                        }
                    }
                    
                    $this->lang_link = ($first_lang->id != $l->id) ? $l->label.'/' : '';
                    $l->url = $this->filter_chpu_url($furl, $this->design);
                }
                $this->lang_link = $cp;
                $this->design->assign('languages', $languages);
            }
        }

        if(!empty($this->meta['h1'])) {
            $this->meta['h1']           = ' '.$this->meta['h1'];
        }
        if(!empty($this->meta['title'])) {
            $this->meta['title']        = ' '.$this->meta['title'];
        }
        if(!empty($this->meta['keywords'])) {
            $this->meta['keywords']     = ' '.$this->meta['keywords'];
        }

        if($this->set_canonical) {
            $this->meta['h1'] = $this->meta['title'] = $this->meta['keywords'] = $this->meta['description'] = '';
        }

        $this->design->assign('set_canonical',$this->set_canonical);
        $this->design->assign('filter_meta',(object)$this->meta);
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
                    // Ключем массива должно быть id значения
                    $param_values_array = array();
                    $feature_id = array_search($param_name, $this->features_urls);
                    foreach (explode('_',$param_values) as $value_translit) {
                        if ($values_id = $this->values_ids[$feature_id][$value_translit]) {
                            $param_values_array[$values_id] = $value_translit;
                        }
                    }
                    $result_array['features'][$param_name] = $param_values_array;
                }
            }
        }
        
        //Определяем переданные параметры для ссылки
        foreach($params as $param_name=>$param_values) {
            switch($param_name) {
                case 'brand': {
                    if(is_null($param_values)) {
                        unset($result_array['brand']);
                    } elseif(in_array($param_values,$result_array['brand'])) {
                        unset($result_array['brand'][array_search($param_values,$result_array['brand'])]);
                    } else {
                        $result_array['brand'][] = $param_values;
                    }
                    break;
                }
                case 'filter': {
                    if (is_null($param_values)) {
                        unset($result_array['filter']);
                    } elseif (in_array($param_values, $result_array['filter'])) {
                        unset($result_array['filter'][array_search($param_values, $result_array['filter'])]);
                    } else {
                        $result_array['filter'][] = $param_values;
                    }
                    if (empty($result_array['filter'])) {
                        unset($result_array['filter']);
                    }
                    break;
                }
                case 'sort':
                    $result_array['sort'] = strval($param_values);
                    break;
                case 'page':
                    $result_array['page'] = $param_values;
                    break;
                default:
                    if(is_null($param_values)) {
                        unset($result_array['features'][$param_name]);
                    } elseif(!empty($result_array['features']) && in_array($param_name,array_keys($result_array['features']), true) && in_array($param_values,$result_array['features'][$param_name], true)) {
                        unset($result_array['features'][$param_name][array_search($param_values,$result_array['features'][$param_name])]);
                    } else {
                        $feature_id = array_search($param_name, $this->features_urls);
                        $param_values = (array)$param_values;
                        foreach ($param_values as $value_translit) {
                            if ($values_id = $this->values_ids[$feature_id][$value_translit]) {
                                $result_array['features'][$param_name][$values_id] = $value_translit;
                            }
                        }
                    }
                    if(empty($result_array['features'][$param_name])) {
                        unset($result_array['features'][$param_name]);
                    }
                break;
            }
        }
        
        $result_string = $this->config->root_url.'/'.$this->lang_link.$this->catalog_type;
        
        if(!empty($_GET['category'])) {
            $result_string .= '/' . $_GET['category'];
        }
        if(!empty($_GET['brand'])) {
            $result_string .= '/' . $_GET['brand'];
        }

        $filter_params_count = 0;
        $seo_hide_filter = false;
        if(!empty($result_array['brand'])) {
            if (count($result_array['brand']) > $this->max_filter_brands) {
                $seo_hide_filter = true;
            }
            $filter_params_count ++;
            $brands_string = $this->filter_chpu_sort_brands($result_array['brand']); // - это с сортировкой по брендам
            if (!empty($brands_string)) {
                $result_string .= '/brand-' . implode("_", $brands_string);
            }
        }
        foreach($result_array['features'] as $k=>$v) {
            if (count($result_array['features'][$k]) > $this->max_filter_features_values || count($result_array['features']) > $this->max_filter_features) {
                $seo_hide_filter = true;
            }
        }
        if(!empty($result_array['filter'])) {
            if(count($result_array['filter']) > $this->max_filter_filter) {
                $seo_hide_filter = true;
            }
            $filter_params_count ++;
            $result_string .= '/filter-' . implode("_", $result_array['filter']);
        }
        
        if(!empty($result_array['features'])) {
            $filter_params_count ++;
            $result_string .= $this->filter_chpu_sort_features($result_array['features']);
        }

        if ($filter_params_count > $this->max_filter_depth) {
            $seo_hide_filter = true;
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
        $smarty->assign('seo_hide_filter', $seo_hide_filter);
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
            if (in_array($furl, array_keys($features), true)) {
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
        $brand_url    = $this->request->get('brand', 'string');

        $filter = array();
        $filter['visible'] = 1;

        $prices = array();
        $prices['current'] = $this->request->get('p');
        if (isset($prices['current']['min'])) {
            $prices['current']['min'] = $this->money->convert($prices['current']['min'], null, false, true);
        }
        if (isset($prices['current']['max'])) {
            $prices['current']['max'] = $this->money->convert($prices['current']['max'], null, false, true);
        }
        
        if (isset($prices['current']['min']) && isset($prices['current']['max']) && $prices['current']['max'] != '' && $prices['current']['min'] != '') {
            $filter['price'] = $prices['current'];
        } else {
            unset($prices['current']);
        }

        // Если задан бренд, выберем его из базы
        if ($val = $this->request->get('b')) {
            $filter['brand_id'] = $val;
        } elseif (!empty($brand_url)) {
            $brand = $this->brands->get_brand((string)$brand_url);
            if (empty($brand) || (!$brand->visible && empty($_SESSION['admin']))) {
                return false;
            }
            $brand->categories = $this->categories->get_categories(array('brand_id'=>$brand->id, 'category_visible'=>1));
            $this->design->assign('brand', $brand);
            $filter['brand_id'] = $brand->id;
        }

        if ($f = $this->request->get("filter")) {
            $filter['other_filter'] = $f;
        }

        if (!empty($this->category)) {
            $this->design->assign('category', $this->category);
            $filter['category_id'] = $this->category->children;
        }
        
        $price_filter = $this->reset_price_filter();
        if (isset($_COOKIE['price_filter'])) {
            $price_filter = unserialize($_COOKIE['price_filter']);
        }
        
        // Когда перешли на другой тип каталога, забываем диапазон цен
        if ($price_filter['catalog_type'] != $this->catalog_type) {
            $price_filter = $this->reset_price_filter();
            $price_filter['catalog_type'] = $this->catalog_type;
        }
        
        if ($price_filter['catalog_type'] !== null) {
            switch ($this->catalog_type) {
                case 'catalog':
                    if ($price_filter['category_id'] != $this->category->id) {
                        $price_filter = $this->reset_price_filter();
                        $price_filter['category_id'] = $this->category->id;
                        $price_filter['catalog_type'] = $this->catalog_type;
                    }
                    break;
                case 'brands':
                    if ($price_filter['brand_id'] != $brand->id) {
                        $price_filter = $this->reset_price_filter();
                        $price_filter['brand_id'] = $brand->id;
                        $price_filter['catalog_type'] = $this->catalog_type;
                    }
                    break;
            }
        }

        // Если прилетела фильтрация по цене, запомним её
        if (!empty($filter['price'])) {
            $price_filter['price_range'] = $filter['price'];
        // Если в куках есть сохраненный фильтр по цене, применяем его
        } elseif ($price_filter['price_range']['min'] != '' && $price_filter['price_range']['max'] != '') {
            $prices['current'] = $filter['price'] = $price_filter['price_range'];
        }

        if (!empty($filter['price']['min'])) {
            $filter['price']['min'] = round($this->money->convert($filter['price']['min'], null, false));
        }

        if (!empty($filter['price']['max'])) {
            $filter['price']['max'] = round($this->money->convert($filter['price']['max'], null, false));
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
        if(!empty($this->category)) {
            foreach($this->category_features as $feature) {
                if($val = $this->request->get($feature->id)) {
                    $filter['features'][$feature->id] = $val;
                }
            }

            // Выбираем бренды, они нужны нам в шаблоне
            foreach ($this->brands->get_brands(array('category_id'=>$this->category->children, 'visible'=>1, 'visible_brand'=>1)) as $b) {
                $this->category_brands[$b->id] = $b;
            }
            
            // Если в строке есть параметры которые не должны быть в фильтре, либо параметры с другой категории, бросаем 404
            if (!empty($this->meta_array['features_values']) && array_intersect_key($this->meta_array['features_values'], $this->category_features) !== $this->meta_array['features_values'] ||
                !empty($this->meta_array['brand']) && array_intersect_key($this->meta_array['brand'], $this->category_brands) !== $this->meta_array['brand']) {
                return false;
            }

            if (($filter['price']['min'] != '' && $filter['price']['max'] != '') || $filter['features'] || $filter['other_filter'] || $filter['brand_id']) {
                $this->is_filter_page = true;
                $this->design->assign('is_filter_page', $this->is_filter_page);
            }
            
            $brands_filter = array(
                'category_id'   => $this->category->children,
                'visible'       => 1,
                'visible_brand' => 1
            );

            // В выборку указываем выбранные бренды, чтобы достать еще и все выбранные бренды, чтобы их можно было отменить
            if (!empty($_GET['b'])) {
                $brands_filter['selected_brands'] = $_GET['b'];
            }

            if (!empty($filter['features'])) {
                $brands_filter['features'] = $filter['features'];
            }

            if (!empty($filter['other_filter'])) {
                $brands_filter['other_filter'] = $filter['other_filter'];
            }

            if ($filter['price']['min'] != '' && $filter['price']['max'] != '') {
                $brands_filter['price'] = $filter['price'];
            }
            
            $this->category->brands = (array)$this->brands->get_brands($brands_filter);
            // Если в фильтре только один бренд и он не выбран, тогда вообще не выводим фильтр по бренду
            if (($first_brand = reset($this->category->brands)) && count($this->category->brands) <= 1 && !in_array($first_brand->id, $_GET['b'])) {
                unset($this->category->brands);
            }

            $features_values_filter['visible'] = 1;

            $features_ids = array_keys($this->category_features);
            if(!empty($features_ids)) {
                $features_values_filter['feature_id'] = $features_ids;
            }
            $features_values_filter['category_id'] = $this->category->children;

            /**
             * Получаем значения свойств для категории, чтобы на страницах фильтров убрать фильтры
             * у которых изначально был только один вариант выбора
             */
            $base_features_values = array();
            if ($this->is_filter_page === true) {
                foreach ($this->features_values->get_features_values($features_values_filter) as $fv) {
                    $base_features_values[$fv->feature_id][$fv->id] = $fv;
                }
            }
            
            if(isset($filter['features'])) {
                $features_values_filter['features'] = $filter['features'];
                $features_values_filter['selected_features'] = $filter['features'];
            }
            if(!empty($brand)) {
                $features_values_filter['brand_id'] = $brand->id;
            } elseif(isset($filter['brand_id'])) {
                $features_values_filter['brand_id'] = $filter['brand_id'];
            }

            if (!empty($filter['other_filter'])) {
                $features_values_filter['other_filter'] = $filter['other_filter'];
            }

            if ($filter['price']['min'] != '' && $filter['price']['max'] != '') {
                $features_values_filter['price'] = $filter['price'];
            }

            $features_values = $this->features_values->get_features_values($features_values_filter);
            
            foreach($features_values as $feature_value) {
                if(isset($this->category_features[$feature_value->feature_id])) {
                    $this->values_ids[$feature_value->feature_id][$feature_value->translit] = $feature_value->id;
                    $this->category_features[$feature_value->feature_id]->features_values[$feature_value->id] = $feature_value;
                }
            }
            
            foreach($this->category_features as $i=>$feature) {
                // Если хоть одно значение свойства выбранно, его убирать нельзя
                if (empty($this->selected_features_values[$feature->id])) {
                    // На странице фильтра убираем свойства у корорых вообще нет значений (отфильтровались)
                    // или они изначально имели только один вариант выбора
                    if ($this->is_filter_page === true) {
                        if (isset($base_features_values[$feature->id]) && (count($base_features_values[$feature->id]) <= 1 || !isset($feature->features_values) || count($feature->features_values) == 0)) {
                            unset($this->category_features[$i]);
                        }
                    // Иначе убираем свойства у которых только один вариант выбора
                    } elseif (!isset($feature->features_values) || count($feature->features_values) <= 1) {
                        unset($this->category_features[$i]);
                    }
                }
            }
            $this->design->assign('features', $this->category_features);
        }

        $other_filters = array();
        if (!in_array($this->page->url, array('all-products', 'discounted', 'bestsellers'))) {
            $this->translations->debug = (bool)$this->config->debug_translation;
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

        if(isset($prices['current'])) {
            $prices['current'] = (object)$prices['current'];
        }
        $prices = (object)$prices;
        $range_filter = $filter;
        $range_filter['get_price'] = 1;
        $prices->range = $this->products->get_products($range_filter);
        
        if (isset($prices->current->min)) {
            $prices->current->min = round($this->money->convert($prices->current->min, null, false));
        }
        
        if (isset($prices->current->max)) {
            $prices->current->max = round($this->money->convert($prices->current->max, null, false));
        }
        
        // Вдруг вылезли за диапазон доступного...
        if ($prices->range->min != '' && $prices->current->min < $prices->range->min) {
            $prices->current->min = $filter['price']['min'] = $prices->range->min;
        }
        if ($prices->range->max != '' && $prices->current->max > $prices->range->max) {
            $prices->current->max = $filter['price']['max'] = $prices->range->max;
        }
        
        $this->design->assign('prices', $prices);
        
        // Сохраняем фильтр в куки
        setcookie("price_filter", serialize($price_filter), time()+3600*24*1, "/");
        
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
            $last_modify[] = $this->category->last_modify;
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
            $images_ids = array();
            foreach($products as $product) {
                $product->variants = array();
                $product->properties = array();
                $images_ids[] = $product->main_image_id;
            }

            $variants = $this->variants->get_variants(array('product_id'=>$products_ids));

            foreach($variants as $variant) {
                $products[$variant->product_id]->variants[] = $variant;
            }

            if (!empty($images_ids)) {
                $images = $this->products->get_images(array('id'=>$images_ids));
                foreach ($images as $image) {
                    $products[$image->product_id]->image = $image;
                }
            }

            foreach($products as $product) {
                if(isset($product->variants[0])) {
                    $product->variant = $product->variants[0];
                }
            }
            $this->design->assign('products', $products);
        }
        
        if($this->request->get('ajax','boolean')) {
            $this->design->assign('ajax', 1);
            $result = new StdClass;
            $result->products_content = $this->design->fetch('products_content.tpl');
            $result->products_pagination = $this->design->fetch('chpu_pagination.tpl');
            $result->products_sort = $this->design->fetch('products_sort.tpl');
            $result->features = $this->design->fetch('features.tpl');
            $result->selected_features = $this->design->fetch('selected_features.tpl');
            header("Content-type: application/json; charset=UTF-8");
            header("Cache-Control: must-revalidate");
            header("Pragma: no-cache");
            header("Expires: -1");
            print json_encode($result);
            die;
        }

        if ($this->category) {
            $parts = array(
                '{$category}' => ($this->category->name ? $this->category->name : ''),
                '{$category_h1}' => ($this->category->name_h1 ? $this->category->name_h1 : ''),
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

            if ($this->meta_array['brand'] && count($this->meta_array['brand']) == 1 && !$this->meta_array['features_values']) {
                $parts['{$brand}'] = reset($this->meta_array['brand']);
                $seo_filter_patterns = $this->seo_filter_patterns->get_patterns(array('category_id'=>$this->category->id, 'type'=>'brand'));
                $seo_filter_pattern = reset($seo_filter_patterns);

            } elseif ($this->meta_array['features_values']  && count($this->meta_array['features_values']) == 1 && !$this->meta_array['brand']) {

                foreach($this->seo_filter_patterns->get_patterns(array('category_id'=>$this->category->id, 'type'=>'feature')) as $p) {
                    $key = 'feature'.(!empty($p->feature_id) ? '_'.$p->feature_id : '');
                    $seo_filter_patterns[$key] = $p;
                }

                reset($this->meta_array['features_values']);
                $feature_id = key($this->meta_array['features_values']);
                $feature = $this->features->get_feature((int)$feature_id);

                // Определяем какой шаблон брать, для категории + определенное свойство, или категории и любое свойство
                if (isset($seo_filter_patterns['feature_'.$feature->id])) {
                    $seo_filter_pattern = $seo_filter_patterns['feature_'.$feature->id];
                } else {
                    $seo_filter_pattern = $seo_filter_patterns['feature'];
                }

                $parts['{$feature_name}'] = $feature->name;
                $parts['{$feature_val}'] = implode($this->meta_delimiter, reset($this->meta_array['features_values']));
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

        // Устанавливаем мета-теги в зависимости от запроса
        if($this->page) {
            $this->design->assign('meta_title', $this->page->meta_title);
            $this->design->assign('meta_keywords', $this->page->meta_keywords);
            $this->design->assign('meta_description', $this->page->meta_description);
        } elseif(isset($this->category)) {
            $this->design->assign('meta_title', $this->category->meta_title);
            $this->design->assign('meta_keywords', $this->category->meta_keywords);
            $this->design->assign('meta_description', $this->category->meta_description);
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
    
    private function reset_price_filter() {
        return array(
            'category_id'   => null,
            'brand_id'      => null,
            'catalog_type'  => null,
            'price_range'   => array(
                'min' => null,
                'max' => null
            )
        );
    }
}
