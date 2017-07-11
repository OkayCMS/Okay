<?php

error_reporting(E_ALL^E_NOTICE);

class Okay {
    
    private $classes = array(
        'config'     => 'Config',
        'request'    => 'Request',
        'db'         => 'Database',
        'settings'   => 'Settings',
        'design'     => 'Design',
        'products'   => 'Products',
        'variants'   => 'Variants',
        'categories' => 'Categories',
        'brands'     => 'Brands',
        'features'   => 'Features',
        'money'      => 'Money',
        'pages'      => 'Pages',
        'blog'       => 'Blog',
        'cart'       => 'Cart',
        'image'      => 'Image',
        'delivery'   => 'Delivery',
        'payment'    => 'Payment',
        'orders'     => 'Orders',
        'users'      => 'Users',
        'coupons'    => 'Coupons',
        'comments'   => 'Comments',
        'feedbacks'  => 'Feedbacks',
        'notify'     => 'Notify',
        'managers'   => 'Managers',
        'languages'  => 'Languages',
        'translations'  => 'Translations',
        'comparison'   => 'Comparison',
        'subscribes' => 'Subscribes',
        'banners'     => 'Banners',
        'callbacks'  => 'Callbacks'
        ,'reportstat' => 'ReportStat'
        ,'validate'  => 'Validate'
        ,'orderlabels'    => 'OrderLabels'
        ,'orderstatus'    => 'OrderStatus'
        ,'supportinfo'=> 'SupportInfo'
        ,'support'   => 'Support'
        ,'import'    => 'Import'
    );
    
    private static $objects = array();
    
    public function __construct() {
        //error_reporting(E_ALL & !E_STRICT);
    }
    
    public function __get($name) {
        // Если такой объект уже существует, возвращаем его
        if(isset(self::$objects[$name])) {
            return(self::$objects[$name]);
        }

        // Если запрошенного API не существует - ошибка
        if(!array_key_exists($name, $this->classes)) {
            return null;
        }

        // Определяем имя нужного класса
        $class = $this->classes[$name];

        // Подключаем его
        include_once(dirname(__FILE__).'/'.$class.'.php');

        // Сохраняем для будущих обращений к нему
        self::$objects[$name] = new $class();

        // Возвращаем созданный объект
        return self::$objects[$name];
    }
    
    public function translit($text) {
        $ru = explode('-', "А-а-Б-б-В-в-Ґ-ґ-Г-г-Д-д-Е-е-Ё-ё-Є-є-Ж-ж-З-з-И-и-І-і-Ї-ї-Й-й-К-к-Л-л-М-м-Н-н-О-о-П-п-Р-р-С-с-Т-т-У-у-Ф-ф-Х-х-Ц-ц-Ч-ч-Ш-ш-Щ-щ-Ъ-ъ-Ы-ы-Ь-ь-Э-э-Ю-ю-Я-я");
        $en = explode('-', "A-a-B-b-V-v-G-g-G-g-D-d-E-e-E-e-E-e-ZH-zh-Z-z-I-i-I-i-I-i-J-j-K-k-L-l-M-m-N-n-O-o-P-p-R-r-S-s-T-t-U-u-F-f-H-h-TS-ts-CH-ch-SH-sh-SCH-sch---Y-y---E-e-YU-yu-YA-ya");
        
        $res = str_replace($ru, $en, $text);
        $res = preg_replace("/[\s]+/ui", '-', $res);
        $res = preg_replace("/[^a-zA-Z0-9\.\-\_]+/ui", '', $res);
        $res = strtolower($res);
        return $res;
    }
    
    public function translit_alpha($text) {
        $ru = explode('-', "А-а-Б-б-В-в-Ґ-ґ-Г-г-Д-д-Е-е-Ё-ё-Є-є-Ж-ж-З-з-И-и-І-і-Ї-ї-Й-й-К-к-Л-л-М-м-Н-н-О-о-П-п-Р-р-С-с-Т-т-У-у-Ф-ф-Х-х-Ц-ц-Ч-ч-Ш-ш-Щ-щ-Ъ-ъ-Ы-ы-Ь-ь-Э-э-Ю-ю-Я-я");
        $en = explode('-', "A-a-B-b-V-v-G-g-G-g-D-d-E-e-E-e-E-e-ZH-zh-Z-z-I-i-I-i-I-i-J-j-K-k-L-l-M-m-N-n-O-o-P-p-R-r-S-s-T-t-U-u-F-f-H-h-TS-ts-CH-ch-SH-sh-SCH-sch---Y-y---E-e-YU-yu-YA-ya");
        
        $res = str_replace($ru, $en, $text);
        $res = preg_replace("/[\s]+/ui", '', $res);
        $res = preg_replace("/[^a-zA-Z0-9]+/ui", '', $res);
        $res = strtolower($res);
        return $res;
    }
    
}
