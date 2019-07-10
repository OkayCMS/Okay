<?php

error_reporting(E_ALL^E_NOTICE);

require_once(dirname(__DIR__).'/vendor/autoload.php');

class Okay {
    
    private $classes = array(
        'config'        => 'Config',
        'request'       => 'Request',
        'db'            => 'Database',
        'settings'      => 'Settings',
        'design'        => 'Design',
        'products'      => 'Products',
        'variants'      => 'Variants',
        'categories'    => 'Categories',
        'brands'        => 'Brands',
        'features'      => 'Features',
        'money'         => 'Money',
        'pages'         => 'Pages',
        'blog'          => 'Blog',
        'cart'          => 'Cart',
        'image'         => 'Image',
        'delivery'      => 'Delivery',
        'payment'       => 'Payment',
        'orders'        => 'Orders',
        'users'         => 'Users',
        'coupons'       => 'Coupons',
        'comments'      => 'Comments',
        'feedbacks'     => 'Feedbacks',
        'notify'        => 'Notify',
        'managers'      => 'Managers',
        'languages'     => 'Languages',
        'translations'  => 'Translations',
        'comparison'    => 'Comparison',
        'subscribes'    => 'Subscribes',
        'banners'       => 'Banners',
        'callbacks'     => 'Callbacks',
        'reportstat'    => 'ReportStat',
        'validate'      => 'Validate',
        'orderlabels'   => 'OrderLabels',
        'orderstatus'   => 'OrderStatus',
        'supportinfo'   => 'SupportInfo',
        'support'       => 'Support',
        'import'        => 'Import',
        'menu'          => 'Menu',
        'backend_translations' => 'BackendTranslations',
        'front_translations'   => 'FrontTranslations',
        'seo_filter_patterns'  => 'SEOFilterPatterns',
        'features_aliases'     => 'FeaturesAliases',
        'features_values'      => 'FeaturesValues',
        'recaptcha'            => 'Recaptcha',

    );
    
    private static $objects = array();

    public $translit_pairs = array(
        // русский
        array(
            'from'  => "А-а-Б-б-В-в-Ґ-ґ-Г-г-Д-д-Е-е-Ё-ё-Є-є-Ж-ж-З-з-И-и-І-і-Ї-ї-Й-й-К-к-Л-л-М-м-Н-н-О-о-П-п-Р-р-С-с-Т-т-У-у-Ф-ф-Х-х-Ц-ц-Ч-ч-Ш-ш-Щ-щ-Ъ-ъ-Ы-ы-Ь-ь-Э-э-Ю-ю-Я-я",
            'to'    => "A-a-B-b-V-v-G-g-G-g-D-d-E-e-E-e-E-e-ZH-zh-Z-z-I-i-I-i-I-i-J-j-K-k-L-l-M-m-N-n-O-o-P-p-R-r-S-s-T-t-U-u-F-f-H-h-TS-ts-CH-ch-SH-sh-SCH-sch---Y-y---E-e-YU-yu-YA-ya"
        ),
        // грузинский
        array(
            'from'  => "ა-ბ-გ-დ-ე-ვ-ზ-თ-ი-კ-ლ-მ-ნ-ო-პ-ჟ-რ-ს-ტ-უ-ფ-ქ-ღ-ყ-შ-ჩ-ც-ძ-წ-ჭ-ხ-ჯ-ჰ",
            'to'    => "a-b-g-d-e-v-z-th-i-k-l-m-n-o-p-zh-r-s-t-u-ph-q-gh-qh-sh-ch-ts-dz-ts-tch-kh-j-h"
        ),

    );

    public $spec_pairs = array(
        '+'  => 'p',
        '-'  => 'm',
        '—'  => 'ha',
        '–'  => 'hb',
        '−'  => 'hc',
        '‐'  => 'hd',
        '/'  => 'f',
        '°'  => 'deg',
        '±'  => 'pm',
        '_'  => 'u',
        '.'  => 'd',
        ','  => 'c',
        '@'  => 'at',
        '('  => 'lb',
        ')'  => 'rb',
        '{'  => 'lf',
        '}'  => 'rf',
        '['  => 'ls',
        ']'  => 'rs',
        ';'  => 'sem',
        ':'  => 'col',
        '%'  => 'pe',
        '$'  => 'do',
        ' '  => 'sp',
        '?'  => 'w',
        '&'  => 'a',
        '*'  => 's',
        '®'  => 'r',
        '©'  => 'co',
        '\'' => 'ap',
        '"'  => 'qu',
        '`'  => 'bt',
        '<'  => 'le',
        '>'  => 'mo',
        '#'  => 'sh',
        '№'  => 'n',
        '!'  => 'em',
        '~'  => 't',
        '^'  => 'h',
        '='  => 'eq',
        '|'  => 'vs',
        
    );
    
    public function __construct() {
        $debug = $this->config->debug_mode;
        if ($debug == true) {
            ini_set('display_errors', 'on');
            error_reporting(E_ALL);
        } else {
            ini_set('display_errors', 'off');
        }
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
        $res = $text;
        foreach ($this->translit_pairs as $pair) {
            $from = explode('-', $pair['from']);
            $to = explode('-', $pair['to']);
            $res = str_replace($from, $to, $res);
        }

        $res = preg_replace("/[\s]+/ui", '-', $res);
        $res = preg_replace("/[^a-zA-Z0-9\.\-\_]+/ui", '', $res);
        $res = strtolower($res);
        return $res;
    }
    
    public function translit_alpha($text) {
        $res = $text;
        foreach ($this->translit_pairs as $pair) {
            $pair['from'] = explode('-', $pair['from']);
            $pair['to'] = explode('-', $pair['to']);

            $pair = $this->spec_pairs($pair);

            $res = str_replace($pair['from'], $pair['to'], $res);
        }

        $res = preg_replace("/[\s]+/ui", '', $res);
        $res = preg_replace("/[^a-zA-Z0-9]+/ui", '', $res);
        $res = strtolower($res);
        return $res;
    }

    public function clear_catalog() {
        $this->db->query("DELETE FROM `__comments` WHERE `type`='product'");
        $this->db->query("UPDATE `__purchases` SET `product_id`=0, `variant_id`=0");
        $this->db->query("TRUNCATE TABLE `__brands`");
        $this->db->query("TRUNCATE TABLE `__categories`");
        $this->db->query("TRUNCATE TABLE `__categories_features`");
        $this->db->query("TRUNCATE TABLE `__features`");
        $this->db->query("TRUNCATE TABLE `__features_aliases_values`");
        $this->db->query("TRUNCATE TABLE `__features_values`");
        $this->db->query("TRUNCATE TABLE `__images`");
        $this->db->query("TRUNCATE TABLE `__import_log`");
        $this->db->query("TRUNCATE TABLE `__lang_brands`");
        $this->db->query("TRUNCATE TABLE `__lang_categories`");
        $this->db->query("TRUNCATE TABLE `__lang_features`");
        $this->db->query("TRUNCATE TABLE `__lang_features_aliases_values`");
        $this->db->query("TRUNCATE TABLE `__lang_features_values`");
        $this->db->query("TRUNCATE TABLE `__lang_products`");
        $this->db->query("TRUNCATE TABLE `__lang_variants`");
        $this->db->query("TRUNCATE TABLE `__options_aliases_values`");
        $this->db->query("TRUNCATE TABLE `__products`");
        $this->db->query("TRUNCATE TABLE `__products_categories`");
        $this->db->query("TRUNCATE TABLE `__products_features_values`");
        $this->db->query("TRUNCATE TABLE `__related_blogs`");
        $this->db->query("TRUNCATE TABLE `__related_products`");
        $this->db->query("TRUNCATE TABLE `__variants`");
    }
    
    //Добавляет к массиву пар для транслита, пары для замены спецсимволов на буквенные обозначения
    private function spec_pairs($pair) {
        foreach ($this->spec_pairs as $symbol => $alias) {
            $pair['from'][] = $symbol;
            $pair['to'][]   = $alias;
        }

        return $pair;
    }
    
}
