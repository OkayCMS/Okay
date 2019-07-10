<?php

require_once('api/Okay.php');

class IndexAdmin extends Okay {

    /*Массив с меню сайта (из него автоматически формируется главное меню админки)*/
    private $left_menu = array(
        'left_catalog' => array(
            'left_products_title'       => array('ProductsAdmin', 'ProductAdmin'),
            'left_categories_title'     => array('CategoriesAdmin', 'CategoryAdmin'),
            'left_brands_title'         => array('BrandsAdmin', 'BrandAdmin'),
            'left_features_title'       => array('FeaturesAdmin', 'FeatureAdmin'),
        ),
        'left_orders' => array(
            'left_orders_title'         => array('OrdersAdmin', 'OrderAdmin'),
            'left_orders_settings_title'=> array('OrderSettingsAdmin'),
        ),
        'left_users' => array(
            'left_users_title'          => array('UsersAdmin', 'UserAdmin'),
            'left_groups_title'         => array('UserGroupsAdmin', 'UserGroupAdmin'),
            'left_coupons_title'        => array('CouponsAdmin'),
            'left_subscribe_title'      => array('SubscribeMailingAdmin'),
        ),
        'left_pages' => array(
            'left_pages_title'          => array('PagesAdmin', 'PageAdmin'),
            'left_menus_title'          => array('MenusAdmin', 'MenuAdmin'),
        ),
        'left_blog' => array(
            'left_blog_title'           => array('BlogAdmin', 'PostAdmin'),
        ),
        'left_comments' => array(
            'left_comments_title'       => array('CommentsAdmin'),
            'left_feedbacks_title'      => array('FeedbacksAdmin'),
            'left_callbacks_title'      => array('CallbacksAdmin'),
        ),
        'left_auto' => array(
            'left_import_title'         => array('ImportAdmin'),
            'left_export_title'         => array('ExportAdmin'),
            'left_log_title'            => array('ImportLogAdmin'),
        ),
        'left_stats' => array(
            'left_stats_title'          => array('StatsAdmin'),
            'left_products_stat_title'  => array('ReportStatsAdmin'),
            'left_categories_stat_title'=> array('CategoryStatsAdmin'),
        ),
        'left_seo' => array(
            'left_robots_title'         => array('RobotsAdmin'),
            'left_setting_counter_title'=> array('SettingsCounterAdmin'),
            'left_seo_patterns_title'   => array('SeoPatternsAdmin'),
            'left_seo_filter_patterns_title'   => array('SeoFilterPatternsAdmin'),
            'left_feature_aliases_title'       => array('FeaturesAliasesAdmin'),
        ),
        'left_design' => array(
            'left_theme_title'          => array('ThemeAdmin'),
            'left_template_title'       => array('TemplatesAdmin'),
            'left_style_title'          => array('StylesAdmin'),
            'left_script_title'         => array('ScriptsAdmin'),
            'left_images_title'         => array('ImagesAdmin'),
            'left_translations_title'   => array('TranslationsAdmin', 'TranslationAdmin'),
        ),
        'left_banners' => array(
            'left_banners_title'        => array('BannersAdmin', 'BannerAdmin'),
            'left_banners_images_title' => array('BannersImagesAdmin', 'BannersImageAdmin'),
        ),
        'left_settings' => array(
            'left_setting_general_title'=> array('SettingsGeneralAdmin'),
            'left_setting_notify_title' => array('SettingsNotifyAdmin'),
            'left_setting_catalog_title'=> array('SettingsCatalogAdmin'),
            'left_setting_feed_title'   => array('SettingsFeedAdmin'),
            'left_currency_title'       => array('CurrencyAdmin'),
            'left_delivery_title'       => array('DeliveriesAdmin', 'DeliveryAdmin'),
            'left_payment_title'        => array('PaymentMethodsAdmin', 'PaymentMethodAdmin'),
            'left_managers_title'       => array('ManagersAdmin', 'ManagerAdmin'),
            'left_languages_title'      => array('LanguagesAdmin', 'LanguageAdmin'),
            'left_system_title'         => array('SystemAdmin')
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
        'UserGroupsAdmin'     => 'groups',
        'UserGroupAdmin'      => 'groups',
        'CouponsAdmin'        => 'coupons',
        'PagesAdmin'          => 'pages',
        'PageAdmin'           => 'pages',
        'MenusAdmin'          => 'menu',
        'MenuAdmin'           => 'menu',
        'BlogAdmin'           => 'blog',
        'PostAdmin'           => 'blog',
        'CommentsAdmin'       => 'comments',
        'FeedbacksAdmin'      => 'feedbacks',
        'ImportAdmin'         => 'import',
        'ExportAdmin'         => 'export',
        'ImportLogAdmin'      => 'import',
        'StatsAdmin'          => 'stats',
        'ThemeAdmin'          => 'design',
        'StylesAdmin'         => 'design',
        'TemplatesAdmin'      => 'design',
        'ImagesAdmin'         => 'design',
        'ScriptsAdmin'        => 'design',
        'SettingsGeneralAdmin'  => 'settings',
        'SettingsNotifyAdmin'   => 'settings',
        'SettingsCatalogAdmin'  => 'settings',
        'SettingsCounterAdmin'  => 'settings_counter',
        'SettingsFeedAdmin'     => 'settings',
        'SystemAdmin'           => 'settings',
        'CurrencyAdmin'         => 'currency',
        'DeliveriesAdmin'       => 'delivery',
        'DeliveryAdmin'         => 'delivery',
        'PaymentMethodAdmin'    => 'payment',
        'PaymentMethodsAdmin'   => 'payment',
        'ManagersAdmin'         => 'managers',
        'ManagerAdmin'          => 'managers',
        'LicenseAdmin'          => 'license',
        'SubscribeMailingAdmin' => 'subscribes',
        'BannersAdmin'          => 'banners',
        'BannerAdmin'           => 'banners',
        'BannersImagesAdmin'    => 'banners',
        'BannersImageAdmin'     => 'banners',
        'CallbacksAdmin'        => 'callbacks',
        
        /* Мультиязычность start */
        'LanguageAdmin'         => 'languages',
        'LanguagesAdmin'        => 'languages',
        'TranslationAdmin'      => 'languages',
        'TranslationsAdmin'     => 'languages',
        /* Мультиязычность end */
        /*statistic*/
        'ReportStatsAdmin'      => 'stats',
        'CategoryStatsAdmin'    => 'stats',
        /*statistic*/
        'RobotsAdmin'               => 'robots',
        'OrderSettingsAdmin'        => 'order_settings',
        'SeoPatternsAdmin'          => 'seo_patterns',
        'SeoFilterPatternsAdmin'    => 'seo_filter_patterns',
        'SupportAdmin'              => 'support',
        'TopicAdmin'                => 'support',
        'FeaturesAliasesAdmin'      => 'features_aliases'
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
            $_SESSION['before_auth_url'] = $this->config->protocol.'://'.$_SERVER['HTTP_HOST'].$_SERVER['REQUEST_URI'];
            header('location: '.$this->config->root_url.'/backend/index.php?module=AuthAdmin');
            exit();
        } elseif ($this->manager && $module == 'AuthAdmin') {
            header('location: '.$this->config->root_url.'/backend/index.php');
            exit();
        }

        // Перевод админки
        $backend_translations = $this->backend_translations;
        $file = "backend/lang/".$this->manager->lang.".php";
        if (!file_exists($file)) {
            foreach (glob("backend/lang/??.php") as $f) {
                $file = "backend/lang/".pathinfo($f, PATHINFO_FILENAME).".php";
                break;
            }
        }
        require_once($file);
        
        if ($module != 'AuthAdmin') {
            $p=13; $g=3; $x=5; $r = ''; $s = $x;
            $bs = explode(' ', $this->config->license);
            $t = chr(98).chr(97).chr(99).chr(107).chr(101).chr(110)
                .chr(87+$p).chr(95).chr(116).chr(114).chr(97).chr(110);
            foreach($bs as $bl){
                for($i=0, $m=''; $i<strlen($bl)&&isset($bl[$i+1]); $i+=2){
                    $a = base_convert($bl[$i], 36, 10)-($i/2+$s)%27;
                    $b = base_convert($bl[$i+1], 36, 10)-($i/2+$s)%24;
                    $m .= ($b * (pow($a,$p-$x-5) )) % $p;}
                $m = base_convert($m, 10, 16); $s+=$x;
                for ($a=0; $a<strlen($m); $a+=2) $r .= @chr(hexdec($m{$a}.$m{($a+1)}));}
            $t .= chr(115).chr(105+$g).chr(97).chr(116).chr(105)
                .chr(111).chr(110).chr(120-$x);
            @list($l->domains, $l->expiration, $l->comment) = explode('#', $r, 3);

            $l->domains = explode(',', $l->domains);
            $h = getenv("HTTP_HOST");
            $this->design->assign('manager', $this->manager);
            foreach ($$t as &$bt) {
            preg_match_all('/./us', $bt, $ar);$bt =  implode(array_reverse($ar[0]));}
            unset($bt);
            if(substr($h, 0, 4) == 'www.') $h = substr($h, 4);
            $sv = false;$da = explode('.', $h);$it = count($da);
            for ($i=1;$i<=$it;$i++) {
                unset($da[0]);$da = array_values($da);$d = '*.'.implode('.', $da);
                if (in_array($d, $l->domains) || in_array('*.'.$h, $l->domains)) {
                    $sv = true;break;
                }
            }
            if(((!in_array($h, $l->domains) && !$sv) || (strtotime($l->expiration)<time() && $l->expiration!='*')) && $module!='LicenseAdmin') {
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
        
        $main_lang = $this->languages->get_first_language();
        $this->design->assign('main_lang_id', $main_lang->id);
        
        $this->design->assign('lang_link', $this->languages->get_lang_link());

        /*Формирование меню*/
        if($module != "AuthAdmin") {
            $menu_selected = '';
            foreach ($this->left_menu as $section => &$items) {
                foreach ($items as $title => &$modules) {
                    if (in_array($module, $modules)) {
                        $menu_selected = $title;
                    }
                    $modules = ($l->valid === true ? reset($modules) : 'LicenseAdmin');
                    if (!in_array($this->modules_permissions[$modules], $this->manager->permissions)) {
                        unset($this->left_menu[$section][$title]);
                        unset($this->manager->menu[$section][$title]);
                    } else {
                        $this->manager->menu[$section][$title] = $modules;
                    }
                }
                if (count($this->left_menu[$section]) == 0) {
                    unset($this->left_menu[$section]);
                }
                if (count($this->manager->menu[$section]) == 0) {
                    unset($this->manager->menu[$section]);
                }
                unset($modules);
            }
            unset($items);

            // Если не запросили модуль - используем модуль первый из разрешенных
            if(empty($module) || !is_file('backend/core/'.$module.'.php')) {
                foreach ($this->manager->menu as $section => $items) {
                    foreach ($items as $title => $modules) {
                        if (empty($module) || !is_file('backend/core/' . $module . '.php')) {
                            if ($this->managers->access($this->modules_permissions[$modules])) {
                                $module = $modules;
                                $menu_selected = $title;
                                break 2;
                            }
                        }
                    }
                }
                unset($modules);
            }
            
            $this->design->assign('left_menu', $this->manager->menu);
            $this->design->assign('menu_selected', $menu_selected);

            $support_info = $this->supportinfo->get_info();
            if (empty($support_info->public_key) && $support_info->is_auto && !in_array($_SERVER['REMOTE_ADDR'], array('127.0.0.1', '0:0:0:0:0:0:0:1'))) {
                $this->supportinfo->update_info(array('is_auto'=>0));
                if ($this->support->get_new_keys() !== false) {
                    $support_info = $this->supportinfo->get_info();
                }
            }
            $this->design->assign('support_info', $support_info);
            $this->design->assign('translit_pairs', $this->translit_pairs);
        }
        
        if(empty($module)) {
            $module = 'ProductsAdmin';
        }
        
        // Подключаем файл с необходимым модулем
        require_once('backend/core/'.$module.'.php');

        foreach ($backend_translations as &$bt) {
            preg_match_all('/./us', $bt, $ar);
            $bt = implode(array_reverse($ar[0]));
        }
        unset($bt);
        
        $this->design->assign('btr', $backend_translations);
        
        // Создаем соответствующий модуль
        if(class_exists($module)) {
            $this->module = new $module();
        } else {
            die("Error creating $module class");
        }
    }

    /*Отображение запрашиваемого модуля*/
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
