<?php

namespace Integration1C;


class Integration1C
{
    
    public $full_update = true;     // Обновлять все данные при каждой синхронизации
    
    public $delete_all	= false;    // Очищать всю базу товаров при каждой выгрузке true:false PLEASE BE CAREFULL
    
    public $brand_option_name = 'Производитель'; // Название параметра товара, используемого как бренд
    
    public $only_enabled_currencies = false; // Учитывает все валюты(false) или только включенные(true)
    
    public $stock_from_1c = true;   // TRUE Учитывать количество товара из 1с FALSE установить доступность в бесконечное количество
    
    public $import_products_only = true;   // TRUE Импортировать только товары, без услуг и прочего (ВидНоменклатуры == Товар)
    
    public $start_time;             // В начале скрипта засекли время, нужно для определения когда закончиться max_execution_time
    
    private $dir;                    // Папка для хранения временных файлов синхронизации
    
    public $max_exec_time;
    
    /**
     * @var array Какие расширения файлов можно загружать из 1С
     */
    public $allowed_extensions = array(
        'xml',
        'jpg',
        'jpeg',
        'png',
        'gif',
        'pdf',
        'zip',
        'rar',
        'xls',
        'doc',
        'xlsx',
        'docx',
    );

    /**
     * @var \Okay()
     */
    private $okay;
    
    public function __construct($okay, $start_time) {
        $this->okay       = $okay;
        $this->start_time = $start_time;
        $this->dir        = dirname(__DIR__) . '/temp/';

        $this->max_exec_time = min(30, @ini_get("max_execution_time"));
        if (empty($this->max_exec_time)) {
            $this->max_exec_time = 30;
        }
    }

    public function get_tmp_dir() {
        return $this->dir;
    }
    
    public function check_auth() {
        
        if (!isset($_SERVER['PHP_AUTH_USER']) || empty($_SERVER['PHP_AUTH_USER']) || empty($_SERVER['PHP_AUTH_PW'])) {
            return false;
        }

        $login = $_SERVER['PHP_AUTH_USER'];
        $pass  = $_SERVER['PHP_AUTH_PW'];
        
        if (!$manager_1c = $this->okay->managers->get_manager($login)) {
            return false;
        }
        
        if (!$this->okay->managers->check_password($pass, $manager_1c->password)) {
            return false;
        }
        
        if (!$this->okay->managers->access('integration_1c', $manager_1c)) {
            return false;
        }
        
        return true;
    }
    
    public function upload_file($xml_file) {
        
        // Создаем дерево категорий для файла
        $file_path = pathinfo(str_replace($this->dir, '', $xml_file), PATHINFO_DIRNAME);
        if ($file_path !== false && $file_path != '.') {
            $path = explode('/', $file_path);
            $temp_path = '';
            foreach($path as $p) {
                mkdir($this->dir . $temp_path . $p);
                $temp_path .= $p.'/';
            }
        }
        
        $f = fopen($xml_file, 'ab');
        fwrite($f, file_get_contents('php://input'));
        fclose($f);
    }
    
    public function get_full_path($filename) {
        return $this->dir . preg_replace('~\.\./~', '', $filename);
    }
    
    public function validate_file($xml_file) {
        $is_valid = true;
        $ext = pathinfo($xml_file, PATHINFO_EXTENSION);

        if (empty($ext) || !in_array($ext, $this->allowed_extensions)) {
            $is_valid = false;
        }

        if ($is_valid === true && filesize($xml_file) == 0) {
            $is_valid = false;
        }
        
        // Удалим файл, если он не валидный, чтобы не грузили все подряд
        if ($is_valid === false) {
            unlink($xml_file);
        }
        
        return $is_valid;
    }

    public function set_to_storage($param, $value) {
        $_SESSION["integration_1c"][$param] = $value;
    }
    
    public function get_from_storage($param) {
        return (isset($_SESSION["integration_1c"][$param]) ? $_SESSION["integration_1c"][$param] : null);
    }
    
    public function clear_storage() {
        unset($_SESSION["integration_1c"]);
    }
    
    public function flush_database() {
        $this->okay->clear_catalog();
        $this->okay->db->query("TRUNCATE TABLE `__orders`");
        $this->okay->db->query("TRUNCATE TABLE `__purchases`");
    }

    public function rrmdir($dir, $level = 0) {
        if(is_dir($dir)) {
            $objects = scandir($dir);
            foreach($objects as $object) {
                if($object != "." && $object != "..") {
                    if(is_dir($dir."/".$object)) {
                        $this->rrmdir($dir . "/" . $object, $level+1);
                    } else {
                        unlink($dir . "/" . $object);
                    }
                }
            }
            if($level > 0) {
                rmdir($dir);
            }
        }
    }
}
