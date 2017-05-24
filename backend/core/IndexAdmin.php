<?php

require_once('api/Okay.php');

class IndexAdmin extends Okay {

    /*Массив с меню сайта (из него автоматически формируется главное меню админки)*/
    private $left_menu = array(
        'left_catalog' => array(
            'left_products_title'     => 'ProductsAdmin',
            'left_categories_title'   => 'CategoriesAdmin',
            'left_brands_title'       => 'BrandsAdmin',
            'left_features_title'     => 'FeaturesAdmin',
        ),
        'left_orders' => array(
            'left_orders_title'     => 'OrdersAdmin',
            'left_orders_settings_title'     => 'OrderSettingsAdmin',
        ),
        'left_users' => array(
            'left_users_title'      => 'UsersAdmin',
            'left_groups_title'     => 'UserGroupsAdmin',
            'left_coupons_title'    => 'CouponsAdmin',
            'left_subscribe_title'  => 'SubscribeMailingAdmin',
        ),
        'left_pages' => array(
            'left_pages_title'      => 'PagesAdmin',
        ),
        'left_blog' => array(
            'left_blog_title'       => 'BlogAdmin',
        ),
        'left_comments' => array(
            'left_comments_title'   => 'CommentsAdmin',
            'left_feedbacks_title'   => 'FeedbacksAdmin',
            'left_callbacks_title'   => 'CallbacksAdmin',
        ),
        'left_auto' => array(
            'left_import_title'     => 'ImportAdmin',
            'left_export_title'     => 'ExportAdmin',
            'left_multiimport_title'     => 'MultiImportAdmin',
            'left_multiexport_title'     => 'MultiExportAdmin',
            'left_log_title'     => 'ImportLogAdmin',
        ),
        'left_stats' => array(
            'left_stats_title'      => 'StatsAdmin',
            'left_products_stat_title'      => 'ReportStatsAdmin',
            'left_categories_stat_title'      => 'CategoryStatsAdmin',
        ),
        'left_seo' => array(
            'left_robots_title'      => 'RobotsAdmin',
            'left_setting_counter_title'   => 'SettingsCounterAdmin',
            'left_metrika_title'      => 'YametrikaAdmin',
            'left_seo_patterns_title'      => 'SeoPatternsAdmin',
        ),
        'left_design' => array(
            'left_theme_title'      => 'ThemeAdmin',
            'left_template_title'      => 'TemplatesAdmin',
            'left_style_title'      => 'StylesAdmin',
            'left_script_title'      => 'ScriptsAdmin',
            'left_images_title'      => 'ImagesAdmin',
        ),
        'left_banners' => array(
            'left_banners_title' => 'BannersAdmin',
            'left_banners_images_title' => 'BannersImagesAdmin',
        ),
        'left_settings' => array(
            'left_setting_general_title'   => 'SettingsGeneralAdmin',
            'left_setting_notify_title'   => 'SettingsNotifyAdmin',
            'left_setting_catalog_title'   => 'SettingsCatalogAdmin',
            'left_setting_feed_title'   => 'SettingsFeedAdmin',
            'left_currency_title'   => 'CurrencyAdmin',
            'left_delivery_title'   => 'DeliveriesAdmin',
            'left_payment_title'    => 'PaymentMethodsAdmin',
            'left_managers_title'   => 'ManagersAdmin',
            'left_languages_title'  => 'LanguagesAdmin',
            'left_translations_title'   => 'TranslationsAdmin'
        ),
    );

    // Соответсвие модулей и названий соответствующих прав
    private $modules_permissions = array(
        'ProductsAdmin'       => 'products',
        'ProductAdmin'        => 'products',
        'CategoriesAdmin'     => 'categories',
        'CategoryAdmin'       => 'categories',
        'BrandsAdmin'         => 'brands',
        'BrandAdmin'          => 'brands',
        'FeaturesAdmin'       => 'features',
        'FeatureAdmin'        => 'features',
        'OrdersAdmin'         => 'orders',
        'OrderAdmin'          => 'orders',
        'UsersAdmin'          => 'users',
        'UserAdmin'           => 'users',
        'ExportUsersAdmin'    => 'users',
        'UserGroupsAdmin'         => 'groups',
        'UserGroupAdmin'          => 'groups',
        'CouponsAdmin'        => 'coupons',
        'PagesAdmin'          => 'pages',
        'PageAdmin'           => 'pages',
        'BlogAdmin'           => 'blog',
        'PostAdmin'           => 'blog',
        'CommentsAdmin'       => 'comments',
        'FeedbacksAdmin'      => 'feedbacks',
        'ImportAdmin'         => 'import',
        'ExportAdmin'         => 'export',
        'MultiImportAdmin'    => 'import',
        'MultiExportAdmin'    => 'export',
        'ImportLogAdmin'      => 'import',
        'StatsAdmin'          => 'stats',
        'ThemeAdmin'          => 'design',
        'StylesAdmin'         => 'design',
        'TemplatesAdmin'      => 'design',
        'ImagesAdmin'         => 'design',
        'ScriptsAdmin'        => 'design',
        'SettingsGeneralAdmin'       => 'settings',
        'SettingsNotifyAdmin'       => 'settings',
        'SettingsCatalogAdmin'       => 'settings',
        'SettingsCounterAdmin'       => 'settings',
        'SettingsFeedAdmin'       => 'settings',
        'CurrencyAdmin'       => 'currency',
        'DeliveriesAdmin'     => 'delivery',
        'DeliveryAdmin'       => 'delivery',
        'PaymentMethodAdmin'  => 'payment',
        'PaymentMethodsAdmin' => 'payment',
        'ManagersAdmin'       => 'managers',
        'ManagerAdmin'        => 'managers',
        'LicenseAdmin'        => 'license',
        'SubscribeMailingAdmin'=> 'users',
        'BannersAdmin'          => 'banners',
        'BannerAdmin'          => 'banners',
        'BannersImagesAdmin'  => 'banners',
        'BannersImageAdmin'   => 'banners',
        'CallbacksAdmin'      => 'callbacks',
        
        /* Мультиязычность start */
        'LanguageAdmin'       => 'languages',
        'LanguagesAdmin'      => 'languages',
        'TranslationAdmin'    => 'languages',
        'TranslationsAdmin'   => 'languages',
        /* Мультиязычность end */
        /*statistic*/
        'ReportStatsAdmin'    => 'stats',
        'CategoryStatsAdmin'  => 'stats',
        /*statistic*/
        /*YaMetrika*/
        'YametrikaAdmin'      => 'yametrika',
        /*YaMetrika*/
        'RobotsAdmin'         => 'robots',
        'OrderSettingsAdmin'    => 'order_settings',
        'SeoPatternsAdmin'  => 'seo_patterns',
        'SupportAdmin'        => 'support',
        'TopicAdmin'          => 'support'
    );
    
    // Конструктор
    public function __construct() {
        // Вызываем конструктор базового класса
        parent::__construct();

        // Берем название модуля из get-запроса
        $module = $this->request->get('module', 'string');
        $module = preg_replace("/[^A-Za-z0-9]+/", "", $module);

        // Администратор
        $this->manager = $this->managers->get_manager();
        $this->design->assign('mаnаgеr', $this->manager);
        if (!$this->manager && $module!='AuthAdmin') {
            header('location: '.$this->config->root_url.'/backend/index.php?module=AuthAdmin');
            exit();
        } elseif ($this->manager && $module == 'AuthAdmin') {
            header('location: '.$this->config->root_url.'/backend/index.php');
            exit();
        }
        
        if ($module != 'AuthAdmin') {
            $p=13; $g=3; $x=5; $r = ''; $s = $x;
            $bs = explode(' ', $this->config->license);
            foreach($bs as $bl){
                for($i=0, $m=''; $i<strlen($bl)&&isset($bl[$i+1]); $i+=2){
                    $a = base_convert($bl[$i], 36, 10)-($i/2+$s)%27;
                    $b = base_convert($bl[$i+1], 36, 10)-($i/2+$s)%24;
                    $m .= ($b * (pow($a,$p-$x-5) )) % $p;}
                $m = base_convert($m, 10, 16); $s+=$x;
                for ($a=0; $a<strlen($m); $a+=2) $r .= @chr(hexdec($m{$a}.$m{($a+1)}));}

            @list($l->domains, $l->expiration, $l->comment) = explode('#', $r, 3);

            $l->domains = explode(',', $l->domains);
            $h = getenv("HTTP_HOST");
            $this->design->assign('manager', $this->manager);
            if(substr($h, 0, 4) == 'www.') $h = substr($h, 4);
            if((!in_array($h, $l->domains) || (strtotime($l->expiration)<time() && $l->expiration!='*')) && $module!='LicenseAdmin') {
                header('location: '.$this->config->root_url.'/backend/index.php?module=LicenseAdmin');
            } else {
                $l->valid = true;
                $this->design->assign('license', $l);
            }

            $this->design->assign('license', $l);
        }

        $this->design->set_templates_dir('backend/design/html');
        $this->design->set_compiled_dir('backend/design/compiled');

        $this->design->assign('settings',    $this->settings);
        $this->design->assign('config',    $this->config);

        $is_mobile = $this->design->is_mobile();
        $is_tablet = $this->design->is_tablet();
        $this->design->assign('is_mobile',$is_mobile);
        $this->design->assign('is_tablet',$is_tablet);

        // Язык
        $languages = $this->languages->get_languages();
        $this->design->assign('languages', $languages);
        
        if (count($languages)) {
            $post_lang_id = $this->request->post('lang_id', 'integer');
            $admin_lang_id = ($post_lang_id ? $post_lang_id : $this->request->get('lang_id', 'integer'));
            if ($admin_lang_id) {
                $_SESSION['admin_lang_id'] = $admin_lang_id;
            }
            if (!isset($_SESSION['admin_lang_id']) || !isset($languages[$_SESSION['admin_lang_id']])) {
                $l = $this->languages->get_first_language();
                $_SESSION['admin_lang_id'] = $l->id;
            }
            $this->design->assign('current_language', $languages[$_SESSION['admin_lang_id']]);
            $this->languages->set_lang_id($_SESSION['admin_lang_id']);
        }
        
        $lang_id = $this->languages->lang_id();
        $this->design->assign('lang_id', $lang_id);
        
        $this->design->assign('lang_link', $this->languages->get_lang_link());
        
        // Если не запросили модуль - используем модуль первый из разрешенных
        if(empty($module) || !is_file('backend/core/'.$module.'.php')) {
            foreach($this->modules_permissions as $m=>$p) {
                if($this->managers->access($p)) {
                    $module = $m;
                    break;
                }
            }
        }
        if(empty($module)) {
            $module = 'ProductsAdmin';
        }

        /*Формирование меню*/
        if($module != "AuthAdmin") {
            foreach ($this->left_menu as $key => $val) {
                foreach ($val as $ind => $menu_items) {
                    if (!in_array($this->modules_permissions[$menu_items], $this->manager->permissions)) {
                        unset($this->left_menu[$key][$ind]);
                    }
                }
                if (count($this->left_menu[$key]) == 0) {
                    unset($this->left_menu[$key]);
                } elseif (count($this->left_menu[$key]) == 1) {
                    $this->left_menu[$key] = reset($this->left_menu[$key]);
                }

            }
            $this->design->assign('left_menu', $this->left_menu);

            $support_info = $this->supportinfo->get_info();
            if (empty($support_info->public_key) && $support_info->is_auto && !in_array($_SERVER['REMOTE_ADDR'], array('127.0.0.1', '0:0:0:0:0:0:0:1'))) {
                $this->supportinfo->update_info(array('is_auto'=>0));
                if ($this->support->get_new_keys() !== false) {
                    $support_info = $this->supportinfo->get_info();
                }
            }
            $this->design->assign('support_info', $support_info);
        }
        
        // Подключаем файл с необходимым модулем
        require_once('backend/core/'.$module.'.php');

        // Перевод админки
        $backend_translations = new stdClass();
        $file = "backend/lang/".$this->manager->lang.".php";
        if (!file_exists($file)) {
            foreach (glob("backend/lang/??.php") as $f) {
                $file = "backend/lang/".pathinfo($f, PATHINFO_FILENAME).".php";
                break;
            }
        }
        require_once($file);
        $this->design->assign('btr', $backend_translations);
        
        // Создаем соответствующий модуль
        if(class_exists($module)) {
            $this->module = new $module();
        } else {
            die("Error creating $module class");
        }
    }

    /*Отображение запрашуемого модуля*/
    public function fetch() {
        $currency = $this->money->get_currency();
        $this->design->assign("currency", $currency);

        // Проверка прав доступа к модулю
        if(get_class($this->module) == 'AuthAdmin' || isset($this->modules_permissions[get_class($this->module)])
        && $this->managers->access($this->modules_permissions[get_class($this->module)])) {
            $content = $this->module->fetch();
            $this->design->assign("content", $content);
        } else {
            $this->design->assign("content", false);
            $this->design->assign('menu_selected', '');
        }

        $all_status = $this->orderstatus->get_status();
        if($all_status) {
            $first_status = reset($all_status);
        }

        /*Счетчики для верхнего меню*/
        $new_orders_counter = $this->orders->count_orders(array('status'=>$first_status->id));
        $this->design->assign("new_orders_counter", $new_orders_counter);
        
        $new_comments_counter = $this->comments->count_comments(array('approved'=>0));
        $this->design->assign("new_comments_counter", $new_comments_counter);

        $new_feedbacks_counter = $this->feedbacks->count_feedbacks(array('processed'=>0));
        $this->design->assign("new_feedbacks_counter", $new_feedbacks_counter);

        $new_callbacks_counter = $this->callbacks->count_callbacks(array('processed'=>0));
        $this->design->assign("new_callbacks_counter", $new_callbacks_counter);

        $this->design->assign("all_counter", $new_orders_counter+$new_comments_counter+$new_feedbacks_counter+$new_callbacks_counter);

        // Создаем текущую обертку сайта (обычно index.tpl)
        $wrapper = $this->design->smarty->getTemplateVars('wrapper');
        if(is_null($wrapper)) {
            $wrapper = 'index.tpl';
        }
        
        if(!empty($wrapper)) {
            return $this->body = $this->design->fetch($wrapper);
        } else {
            return $this->body = $content;
        }
    }
    
}
