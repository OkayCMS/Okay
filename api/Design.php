<?php

require_once('Okay.php');

class Design extends Okay {
    
    public $smarty;
    public $detect;
    private $allowed_php_functions;

    /*Объявляем основные настройки для дизайна*/
    public function __construct() {
        parent::__construct();

        $this->detect = new Mobile_Detect();
        // Создаем и настраиваем Смарти
        $this->smarty = new Smarty();
        $this->smarty->compile_check = $this->config->smarty_compile_check;
        $this->smarty->caching = $this->config->smarty_caching;
        $this->smarty->cache_lifetime = $this->config->smarty_cache_lifetime;
        $this->smarty->debugging = $this->config->smarty_debugging;
        $this->smarty->error_reporting = E_ALL & ~E_NOTICE;
        
        // Берем тему из настроек
        $theme = $this->settings->theme;

        $smarty_security = $this->config->smarty_security;
        if ($smarty_security == true) {
            $this->allowed_php_functions = array(
                'escape',
                'cat',
                'count',
                'in_array',
                'nl2br',
                'str_replace',
                'reset',
                'floor',
                'round',
                'ceil',
                'max',
                'min',
                'number_format',
                'print_r',
                'var_dump',
                'printa',
                'file_exists',
                'stristr',
                'strtotime',
                'empty',
                'urlencode',
                'intval',
                'isset',
                'sizeof',
                'is_array',
                'time',
                'array',
                'base64_encode',
                'implode',
                'explode',
                'preg_replace',
                'preg_match',
                'key',
            );

            // Настраиваем безопасный режим
            $this->smarty->enableSecurity();
            $this->smarty->security_policy->php_modifiers = $this->allowed_php_functions;
            $this->smarty->security_policy->php_functions = $this->allowed_php_functions;

            $this->smarty->security_policy->secure_dir = array(
                $this->config->root_dir . '/design/' . $theme,
                $this->config->root_dir . '/backend/design',
                $this->config->root_dir . '/payment',
            );
        }

        $this->smarty->compile_dir = $this->config->root_dir.'/compiled/'.$theme;
        $this->smarty->template_dir = $this->config->root_dir.'/design/'.$theme.'/html';
        
        // Создаем папку для скомпилированных шаблонов текущей темы
        if(!is_dir($this->smarty->compile_dir)) {
            mkdir($this->smarty->compile_dir, 0777);
        }
        
        $this->smarty->cache_dir = 'cache';
        
        $this->smarty->registerPlugin('modifier', 'resize',        array($this, 'resize_modifier'));
        $this->smarty->registerPlugin('modifier', 'token',        array($this, 'token_modifier'));
        $this->smarty->registerPlugin('modifier', 'plural',        array($this, 'plural_modifier'));
        $this->smarty->registerPlugin('function', 'url',         array($this, 'url_modifier'));
        $this->smarty->registerPlugin('modifier', 'first',        array($this, 'first_modifier'));
        $this->smarty->registerPlugin('modifier', 'cut',        array($this, 'cut_modifier'));
        $this->smarty->registerPlugin('modifier', 'date',        array($this, 'date_modifier'));
        $this->smarty->registerPlugin('modifier', 'time',        array($this, 'time_modifier'));
        $this->smarty->registerPlugin('modifier', 'balance',    array($this, 'balance_modifier'));
        $this->smarty->registerPlugin('function', 'api',        array($this, 'api_plugin'));
        $this->smarty->registerPlugin('modifier', 'first_letter', array($this, 'first_letter_modifier'));
        
        if($this->config->smarty_html_minify) {
            $this->smarty->loadFilter('output', 'trimwhitespace');
        }
    }

    /*Подключение переменной в шаблон*/
    public function assign($var, $value) {
        return $this->smarty->assign($var, $value);
    }

    /*Отображение конкретного шаблона*/
    public function fetch($template) {
        // Передаем в дизайн то, что может понадобиться в нем
        $this->assign('config',        $this->config);
        $this->assign('settings',    $this->settings);
        
        return $this->smarty->fetch($template);
    }

    /*Установка директории файлов шаблона(отображения)*/
    public function set_templates_dir($dir) {
        $this->smarty->template_dir = $dir;
    }

    /*Установка директории для готовых файлов для отображения*/
    public function set_compiled_dir($dir) {
        $this->smarty->compile_dir = $dir;
    }

    /*Выборка переменой*/
    public function get_var($name) {
        return $this->smarty->getTemplateVars($name);
    }

    /*Очитска кэша Smarty*/
    public function clear_cache() {
        $this->smarty->clearAllCache();
    }

    /*Функция ресайза для изображений*/
    public function resize_modifier($filename, $width=0, $height=0, $set_watermark=false, $resized_dir = null, $crop_position_x = null, $crop_position_y = null) {

        $crop_params = array(
            'x_pos' => null,
            'y_pos' => null,
        );
        if (!empty($crop_position_x) && !empty($crop_position_y)) {
            $crop_params['x_pos'] = $crop_position_x;
            $crop_params['y_pos'] = $crop_position_y;
        }

        $resized_filename = $this->image->add_resize_params($filename, $width, $height, $set_watermark, $crop_params);
        $resized_filename_encoded = $resized_filename;

        $size = $width.'x'.$height.$set_watermark;

        if ($resized_dir === null || $resized_dir == $this->config->resized_images_dir) {
            $image_sizes = explode('|', $this->settings->products_image_sizes);
            if (empty($image_sizes[0])) {
                $image_sizes = array();
            }
            if (!in_array($size, $image_sizes)) {
                if (empty($image_sizes[0])) {
                    $image_sizes = array();
                }
                $image_sizes[] = $size;
                $this->settings->products_image_sizes = implode('|', $image_sizes);
            }
        } else {
            $image_sizes = explode('|', $this->settings->image_sizes);
            if (empty($image_sizes[0])) {
                $image_sizes = array();
            }
            if (!in_array($size, $image_sizes)) {
                $image_sizes[] = $size;
                $this->settings->image_sizes = implode('|', $image_sizes);
            }
        }

        if (preg_match("~^https?://~", $resized_filename_encoded)) {
            $resized_filename_encoded = rawurlencode($resized_filename_encoded);
        }
        
        $resized_filename_encoded = rawurlencode($resized_filename_encoded);

        if (!$resized_dir) {
            $resized_dir = $this->config->resized_images_dir;
        }
        return $this->config->root_url.'/'.$resized_dir.$resized_filename_encoded;
    }

    /*Функция токена*/
    public function token_modifier($text) {
        return $this->config->token($text);
    }

    /*Функция для построения ссылки в шаблоне*/
    public function url_modifier($params) {
        if(is_array(reset($params))) {
            return $this->request->url(reset($params));
        } else {
            return $this->request->url($params);
        }
    }

    /*Функция для создания окончаний слов в зависимости от количества чего-либо*/
    public function plural_modifier($number, $singular, $plural1, $plural2=null) {
        $number = abs($number);
        if(!empty($plural2)) {
            $p1 = $number%10;
            $p2 = $number%100;
            if($number == 0) {
                return $plural1;
            }
            if($p1==1 && !($p2>=11 && $p2<=19)) {
                return $singular;
            } elseif($p1>=2 && $p1<=4 && !($p2>=11 && $p2<=19)) {
                return $plural2;
            } else {
                return $plural1;
            }
        } else {
            if($number == 1) {
                return $singular;
            } else {
                return $plural1;
            }
        }
    }

    /*Возвращение первого элемента в цикле*/
    public function first_modifier($params = array()) {
        if(!is_array($params)) {
            return false;
        }
        return reset($params);
    }

    /*Функция для среза массива данных*/
    public function cut_modifier($array, $num=1) {
        if($num>=0) {
            return array_slice($array, $num, count($array)-$num, true);
        } else {
            return array_slice($array, 0, count($array)+$num, true);
        }
    }

    /*Функция для отображения даты в разных видах*/
    public function date_modifier($date, $format = null) {
        if(empty($date)) {
            $date = date("Y-m-d");
        }

        $time = strtotime($date);
        if ($format !== null) {
            $language = $this->languages->get_language($this->languages->lang_id());
            $translations = $this->translations->get_translations(array('lang' => $language->label));

            $day_num = date('N', $time);
            $mon_num = date('n', $time);
            $custom_format = array(
                'cD' => addcslashes($translations->{"date_D_{$day_num}"}, 'A..z'), // Дни недели сокращенно
                'cl' => addcslashes($translations->{"date_l_{$day_num}"}, 'A..z'), // Дни недели полностью
                'cS' => addcslashes($translations->{"date_S_{$mon_num}"}, 'A..z'), // Месяцы сокращенно
                'cF' => addcslashes($translations->{"date_F_{$mon_num}"}, 'A..z'), // Месяцы полностью
                'cFR' => addcslashes($translations->{"date_FR_{$mon_num}"}, 'A..z') // Месяцы полностью, родительный падеж
            );

            $format = strtr($format, $custom_format);
        }
        
        return date(empty($format)?$this->settings->date_format:$format, $time);
    }

    /*Функция отображения времени в разных видах*/
    public function time_modifier($date, $format = null) {
        return date(empty($format)?'H:i':$format, strtotime($date));
    }

    /*Функция отображения баланса тех.поддержки*/
    public function balance_modifier($minutes = 0, $signed = true) {
        $sign = '';
        if ($signed === true) {
            if ($minutes > 0) {
                $sign = '+';
            } elseif ($minutes < 0) {
                $sign = '-';
            }
        }
        
        $minutes = abs($minutes);
        $hours = intval(floor($minutes/60));
        $minutes -= $hours*60;
        return $sign.($hours < 10 ? '0' : '').$hours.':'.($minutes < 10 ? '0' : '').$minutes;
    }

    /*Функция оторбажения первой буквы строки*/
    public function first_letter_modifier($str) {
        return function_exists("mb_substr") ? mb_substr($str, 0, 1) : "";
    }

    /*Функция вызова методов внутри шаблонов клиента*/
    public function api_plugin($params, &$smarty) {
        if(!isset($params['module'])) {
            return false;
        }
        if(!isset($params['method'])) {
            return false;
        }
        
        $module = $params['module'];
        $method = $params['method'];
        $var = $params['var'];
        unset($params['module']);
        unset($params['method']);
        unset($params['var']);
        $res = $this->$module->$method($params);
        $smarty->assign($var, $res);
    }

    /*Определение мобильного устройства*/
    public function is_mobile(){
        $res = $this->detect->isMobile();
        return $res;
    }

    /*Определение планшетного устройства*/
    public function is_tablet(){
        $res = $this->detect->isTablet();
        return $res;
    }
    
}
