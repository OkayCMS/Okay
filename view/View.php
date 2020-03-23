<?php

require_once('api/Okay.php');

class View extends Okay {
    
    /* Смысл класса в доступности следующих переменных в любом View */
    public $currency;
    public $currencies;
    public $user;
    public $group;
    public $page;
    public $language;
    public $lang_link;
    public $js_version;
    public $css_version;
    public $current_url;

    /* Класс View похож на синглтон, храним статически его инстанс */
    private static $view_instance;
    
    public function __construct() {



        // После переключения на язык по умолчанию, если не вызвать set_lang_id() до создания экземпляра класса settings,
        // то мультиязычные настройки первый раз приходят на предыдущем языке.
        if (empty($_GET['lang_label']) && empty($_GET['lang_id'])) {
            $first_language = $this->languages->get_first_language();
            $this->languages->set_lang_id($first_language->id);
        }
        $admin_theme = $this->settings->admin_theme;
        $admin_theme_managers = $this->settings->admin_theme_managers;
        if (!empty($_SESSION['admin']) && !empty($admin_theme) && $this->settings->theme != $this->settings->admin_theme) {
            if (empty($admin_theme_managers) || in_array($_SESSION['admin'], $this->settings->admin_theme_managers)) {
                $this->settings->theme = $this->settings->admin_theme;
            }
        }
        parent::__construct();

        if ($prg_seo_hide = $this->request->post("prg_seo_hide")) {
            header("Location: ".$prg_seo_hide);
            exit;
        }

        if (!defined('IS_CLIENT')) {
            define('IS_CLIENT', true);
        }
        
        // Если инстанс класса уже существует - просто используем уже существующие переменные
        if(self::$view_instance) {
            $this->currency     = &self::$view_instance->currency;
            $this->currencies   = &self::$view_instance->currencies;
            $this->user         = &self::$view_instance->user;
            $this->group        = &self::$view_instance->group;
            $this->page         = &self::$view_instance->page;
            $this->language     = &self::$view_instance->language;
            $this->lang_link    = &self::$view_instance->lang_link;
            $this->js_version   = &self::$view_instance->js_version;
            $this->css_version  = &self::$view_instance->css_version;
            $this->current_url  = &self::$view_instance->current_url;
        } else {
            // Сохраняем свой инстанс в статической переменной,
            // чтобы в следующий раз использовать его
            self::$view_instance = $this;

            /*Устанавливаем версию js и css*/
            if ($this->settings->theme == $this->settings->admin_theme) {
                $this->js_version  = time();
                $this->css_version = time();
            }
            if (empty($this->js_version)) {
                $this->js_version  = $this->settings->js_version;
            }
            if (empty($this->css_version)) {
                $this->css_version = $this->settings->css_version;
            }
            $this->design->assign('js_version', $this->js_version);
            $this->design->assign('css_version',$this->css_version);

            // Язык
            $languages = $this->languages->get_languages();
            $lang_link = '';
            if (!empty($languages)) {
                if($_GET['lang_label']) {
                    $this->language = $this->languages->get_language($this->languages->lang_id());
                    if ($this->language->enabled == 0) {
                        header('HTTP/1.1 503 Service Temporarily Unavailable');
                        header('Status: 503 Service Temporarily Unavailable');
                        header('Retry-After: 300');
                    }
                    if(!is_object($this->language)) {
                        $_GET['page_url'] = '404';
                        $_GET['module'] = 'PageView';
                        $this->language = $this->languages->get_first_language();
                    } else {
                        $lang_link = $this->language->label . '/';
                    }
                } else {
                    $this->language = $this->languages->get_first_language();
                    $this->languages->set_lang_id($this->language->id);
                }
                
                $first_lang = $this->languages->get_first_language();
                $ruri = $_SERVER['REQUEST_URI'];
                if (strlen($this->config->subfolder) > 1) {
                    $pos = strpos($_SERVER['REQUEST_URI'], $this->config->subfolder);
                    if ($pos === 1 || $pos === 0) {
                        $sf = $this->config->subfolder;
                        $ruri = preg_replace("~$sf~", '', $ruri);
                    }
                }
                $ruri = explode('/', $ruri);
                $as = $first_lang->id != $this->languages->lang_id() ? 2 : 1;

                if(is_array($ruri) && $first_lang->id == $this->languages->lang_id() && $ruri[1] == $first_lang->label) {
                    header("HTTP/1.1 301 Moved Permanently");
                    header('Location: '.$this->config->root_url.'/'.implode('/',array_slice($ruri, 2)));
                    exit();
                }
                
                foreach($languages as $l) {
                    // основному языку не нужна метка
                    if($first_lang->id != $l->id) {
                        $l->url = $l->label . ($ruri?'/'.implode('/',array_slice($ruri, $as)):'');
                    } else {
                        $l->url = ($ruri ? implode('/',array_slice($ruri, $as)) : '');
                    }

                    $l->url = $this->config->root_url.'/'.$l->url;
                }

                if(!$this->language->enabled && $this->language->id != $first_lang->id) {
                    header('HTTP/1.0 503 Service Temporarily Unavailable');
                    header('Status: 503 Service Temporarily Unavailable');
                    header('Retry-After: 86400');//86400 seconds - 1day
                }
            }
            $this->design->assign('lang_link', $lang_link);
            $this->lang_link = $lang_link;

            // Все валюты
            $this->currencies = $this->money->get_currencies(array('enabled'=>1));
            
            // Выбор текущей валюты
            if($currency_id = $this->request->get('currency_id', 'integer')) {
                $_SESSION['currency_id'] = $currency_id;
                header("Location: ".$this->request->url(array('currency_id'=>null)));
            }
            
            // Берем валюту из сессии
            if(isset($_SESSION['currency_id'])) {
                $this->currency = $this->money->get_currency($_SESSION['currency_id']);
            }
            // Или первую из списка
            else {
                $this->currency = reset($this->currencies);
            }
            
            // Пользователь, если залогинен
            if(isset($_SESSION['user_id'])) {
                $u = $this->users->get_user(intval($_SESSION['user_id']));
                if($u) {
                    $this->user = $u;
                    $this->group = $this->users->get_group($this->user->group_id);
                }
            }
            
            // Текущая страница (если есть)
            $subdir = substr(dirname(dirname(__FILE__)), strlen($_SERVER['DOCUMENT_ROOT']));
            $page_url = trim(substr($_SERVER['REQUEST_URI'], strlen($subdir)),"/");
            if(strpos($page_url, '?') !== false) {
                $page_url = substr($page_url, 0, strpos($page_url, '?'));
            }
            
            if(!empty($languages) && !empty($first_lang)) {
                $strlen = $first_lang->id == $this->language->id ? "" : $first_lang->label;
                $page_url = trim(substr($page_url, strlen($strlen)),"/");
            }
            
            // Сохраним урл, он может понадобиться в других view
            $this->current_url = $page_url;
            
            if (!empty($_GET['page_url']) && in_array($_GET['page_url'], array('all-products', 'discounted', 'bestsellers'))) {
                $page_url = $_GET['page_url'];
            }
            $this->design->assign('language', $this->language);
            $this->design->assign('languages', $languages);
            $this->translations->debug = (bool)$this->config->debug_translation;
            $this->design->assign('lang', $this->translations->get_translations(array('lang'=>$this->language->label)));

            $this->page = $this->pages->get_page((string)$page_url);
            $this->design->assign('page', $this->page);
            
            // Передаем в дизайн то, что может понадобиться в нем
            $this->design->assign('currencies', $this->currencies);
            $this->design->assign('currency',   $this->currency);
            $this->design->assign('user',       $this->user);
            $this->design->assign('group',      $this->group);
            
            $this->design->assign('config',     $this->config);
            $this->design->assign('settings',   $this->settings);
            
            // Настраиваем плагины для смарти
            /*Распаковка переменной под админом*/
            $this->design->smarty->registerPlugin('modifier', 'printa',                     array($this, 'printa'));
            /*Выборка записей*/
            $this->design->smarty->registerPlugin("function", "get_posts",                  array($this, 'get_posts_plugin'));
            /*Выборка брендов*/
            $this->design->smarty->registerPlugin("function", "get_brands",                 array($this, 'get_brands_plugin'));
            /*Выборка просмотренных товаров*/
            $this->design->smarty->registerPlugin("function", "get_browsed_products",       array($this, 'get_browsed_products'));
            /*Выборка товаров с пометкой "хит продаж"*/
            $this->design->smarty->registerPlugin("function", "get_featured_products",      array($this, 'get_featured_products_plugin'));
            /*Выборка новых товаров*/
            $this->design->smarty->registerPlugin("function", "get_new_products",           array($this, 'get_new_products_plugin'));
            /*Выборка акционных товаров*/
            $this->design->smarty->registerPlugin("function", "get_discounted_products",    array($this, 'get_discounted_products_plugin'));
            /*Выборка категорий*/
            $this->design->smarty->registerPlugin("function", "get_categories",             array($this, 'get_categories_plugin'));
            /*Выборка групп баннеров*/
            $this->design->smarty->registerPlugin("function", "get_banner",                 array($this, 'get_banner_plugin'));
            /*Иницализация капчи*/
            $this->design->smarty->registerPlugin("function", "get_captcha",                array($this, 'get_captcha_plugin'));
        }
    }
    
    function fetch() {
        return false;
    }

    public function get_captcha_plugin($params, &$smarty) {
        if(isset($params['var'])) {
            $number = 0;
            unset($_SESSION[$params['var']]);
            $total = rand(10,50);
            $secret = rand(1,10);
            $result[] = $total - $secret;
            $result[] = $total;
            $_SESSION[$params['var']] = $secret;
            $smarty->assign($params['var'], $result);
        } else {
            return false;
        }
    }

    public function get_categories_plugin($params, &$smarty) {
        if(!empty($params['var'])) {
            $smarty->assign($params['var'], $this->categories->get_categories($params));
        }
    }
    
    public function get_posts_plugin($params, &$smarty) {
        if(!isset($params['visible'])) {
            $params['visible'] = 1;
        }
        if(!empty($params['var'])) {
            $smarty->assign($params['var'], $this->blog->get_posts($params));
        }
    }
    
    public function get_brands_plugin($params, &$smarty) {
        if(!isset($params['visible'])) {
            $params['visible'] = 1;
        }
        if(!empty($params['var'])) {
            $smarty->assign($params['var'], $this->brands->get_brands($params));
        }
    }
    
    public function get_browsed_products($params, &$smarty) {
        if(!empty($_COOKIE['browsed_products']) && !empty($params['var'])) {
            $browsed_products_ids = explode(',', $_COOKIE['browsed_products']);
            $browsed_products_ids = array_reverse($browsed_products_ids);
            if(isset($params['limit'])) {
                $browsed_products_ids = array_slice($browsed_products_ids, 0, $params['limit']);
            }
            
            $products = array();
            $images_ids = array();
            foreach($this->products->get_products(array('id'=>$browsed_products_ids, 'visible'=>1)) as $p) {
                $products[$p->id] = $p;
                $images_ids[] = $p->main_image_id;
            }

            if (!empty($products)) {
                // Выбираем варианты товаров
                $variants = $this->variants->get_variants(array('product_id'=>$browsed_products_ids));
                // Для каждого варианта
                foreach($variants as $variant) {
                    if ($products[$variant->product_id]) {
                        $products[$variant->product_id]->variants[] = $variant;
                    }
                }

                if (!empty($images_ids)) {
                    $images = $this->products->get_images(array('id'=>$images_ids));
                    foreach ($images as $image) {
                        if (isset($products[$image->product_id])) {
                            $products[$image->product_id]->image = $image;
                        }
                    }
                }

                foreach ($browsed_products_ids as $id) {
                    if (isset($products[$id])) {
                        if (isset($products[$id]->variants[0])) {
                            $products[$id]->variant = $products[$id]->variants[0];
                        }
                        $result[] = $products[$id];
                    }
                }
            }
            $smarty->assign($params['var'], $result);
        }
    }
    
    public function get_featured_products_plugin($params, &$smarty) {
        if(!isset($params['visible'])) {
            $params['visible'] = 1;
        }
        $params['in_stock'] = 1;
        $params['featured'] = 1;
        if(!empty($params['var'])) {
            $images_ids = array();
            foreach($this->products->get_products($params) as $p) {
                $products[$p->id] = $p;
                $images_ids[] = $p->main_image_id;
            }

            if(!empty($products)) {
                // id выбраных товаров
                $products_ids = array_keys($products);

                // Выбираем варианты товаров
                $variants = $this->variants->get_variants(array('product_id'=>$products_ids));

                // Для каждого варианта
                foreach($variants as $variant) {
                    // добавляем вариант в соответствующий товар
                    $products[$variant->product_id]->variants[] = $variant;
                }

                // Выбираем изображения товаров
                if (!empty($images_ids)) {
                    $images = $this->products->get_images(array('id'=>$images_ids));
                    foreach ($images as $image) {
                        if (isset($products[$image->product_id])) {
                            $products[$image->product_id]->image = $image;
                        }
                    }
                }

                foreach($products as $product) {
                    if(isset($product->variants[0])) {
                        $product->variant = $product->variants[0];
                    }
                }
            }
            $smarty->assign($params['var'], $products);
        }
    }
    
    public function get_new_products_plugin($params, &$smarty) {
        if(!isset($params['visible'])) {
            $params['visible'] = 1;
        }
        if(!isset($params['sort'])) {
            $params['sort'] = 'created';
        }
        $params['in_stock'] = 1;
        if(!empty($params['var'])) {
            $images_ids = array();
            foreach($this->products->get_products($params) as $p) {
                $products[$p->id] = $p;
                $images_ids[] = $p->main_image_id;
            }
            
            if(!empty($products)) {
                // id выбраных товаров
                $products_ids = array_keys($products);
                
                // Выбираем варианты товаров
                $variants = $this->variants->get_variants(array('product_id'=>$products_ids));
                
                // Для каждого варианта
                foreach($variants as $variant) {
                    // добавляем вариант в соответствующий товар
                    $products[$variant->product_id]->variants[] = $variant;
                }
                
                // Выбираем изображения товаров
                if (!empty($images_ids)) {
                    $images = $this->products->get_images(array('id'=>$images_ids));
                    foreach ($images as $image) {
                        if (isset($products[$image->product_id])) {
                            $products[$image->product_id]->image = $image;
                        }
                    }
                }
                
                foreach($products as $product) {
                    if(isset($product->variants[0])) {
                        $product->variant = $product->variants[0];
                    }
                }
            }
            $smarty->assign($params['var'], $products);
        }
    }
    
    public function get_discounted_products_plugin($params, &$smarty) {
        if(!isset($params['visible'])) {
            $params['visible'] = 1;
        }
        $params['in_stock'] = 1;
        $params['discounted'] = 1;
        if(!empty($params['var'])) {
            $images_ids = array();
            foreach($this->products->get_products($params) as $p) {
                $products[$p->id] = $p;
                $images_ids[] = $p->main_image_id;
            }
            
            if(!empty($products)) {
                // id выбраных товаров
                $products_ids = array_keys($products);
                
                // Выбираем варианты товаров
                $variants = $this->variants->get_variants(array('product_id'=>$products_ids));
                
                // Для каждого варианта
                foreach($variants as $variant) {
                    // добавляем вариант в соответствующий товар
                    $products[$variant->product_id]->variants[] = $variant;
                }
                
                // Выбираем изображения товаров
                if (!empty($images_ids)) {
                    $images = $this->products->get_images(array('id'=>$images_ids));
                    foreach ($images as $image) {
                        if (isset($products[$image->product_id])) {
                            $products[$image->product_id]->image = $image;
                        }
                    }
                }
                
                foreach($products as $product) {
                    if(isset($product->variants[0])) {
                        $product->variant = $product->variants[0];
                    }
                }
            }
            $smarty->assign($params['var'], $products);
        }
    }
    
    public function printa($var) {
        if ($_SESSION['admin']) {
            print_r($var);
        }
    }
    
    public function get_banner_plugin($params, &$smarty){
        if(!isset($params['group']) || empty($params['group'])) {
            return false;
        }

        @$category = $this->design->smarty->getTemplateVars('category');
        @$brand = $this->design->smarty->getTemplateVars('brand');
        @$page = $this->design->smarty->getTemplateVars('page');
        
        $show_filter_array = array('categories'=>$category->id,'brands'=>$brand->id,'pages'=>$page->id);
        $banner = $this->banners->get_banner($params['group'], true, $show_filter_array);
        if(!empty($banner)) {
            if($items = $this->banners->get_banners_images(array('banner_id'=>$banner->id, 'visible'=>1))) {
                $banner->items = $items;
            }
            $smarty->assign($params['var'], $banner);
        }
    }
    
    public function setHeaderLastModify($lastModify) {
        $lastModify=empty($lastModify)?date("Y-m-d H:i:s"):$lastModify;
        $tmpDate=date_parse($lastModify);
        @$LastModified_unix=mktime( $tmpDate['hour'], $tmpDate['minute'], $tmpDate['second '], $tmpDate['month'],$tmpDate['day'],$tmpDate['year'] );
        //Проверка модификации страницы
        $LastModified = gmdate("D, d M Y H:i:s \G\M\T", $LastModified_unix);                
        $IfModifiedSince = false;
        if (isset($_ENV['HTTP_IF_MODIFIED_SINCE'])) {
            $IfModifiedSince = strtotime(substr($_ENV['HTTP_IF_MODIFIED_SINCE'], 5));
        }  
        if (isset($_SERVER['HTTP_IF_MODIFIED_SINCE'])) {
            $IfModifiedSince = strtotime(substr($_SERVER['HTTP_IF_MODIFIED_SINCE'], 5));
        }
        if ($IfModifiedSince && $IfModifiedSince >= $LastModified_unix) {
            header($_SERVER['SERVER_PROTOCOL'] . ' 304 Not Modified');
            exit;
        }
        //echo $lastModify."   (View.php)<br />";
        header('Last-Modified: '. $LastModified);
    }
    
}
