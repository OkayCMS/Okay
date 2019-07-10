<?php

require_once('Okay.php');

class Managers extends Okay {

    /*Список параметров доступа для менеджера сайта*/
    public $permissions_list = array('products', 'categories', 'brands', 'features', 'orders', 'order_settings',
        'users', 'groups', 'coupons', 'pages', 'blog', 'comments', 'feedbacks', 'import', 'export',
        'stats', 'design', 'settings', 'currency', 'delivery', 'payment', 'managers', 'license', 'languages',
        'banners', 'callbacks','robots', 'seo_patterns', 'support', 'subscribes', 'menu', 'seo_filter_patterns', 
        'settings_counter', 'features_aliases', 'integration_1c'
        
    );

    private $all_managers = array();
    
    public function __construct() {}

    /*Инициализация менеджеров*/
    private function init_managers() {
        $this->all_managers = array();
        $this->db->query("SELECT * FROM __managers ORDER BY id");
        foreach ($this->db->results() as $m) {
            if (!empty($m->menu)) {
                $m->menu = unserialize($m->menu);
            } else {
                $m->menu = array();
            }
            $this->all_managers[$m->id] = $m;
            if (!is_null($m->permissions)) {
                $m->permissions = explode(',', $m->permissions);
                foreach ($m->permissions as &$permission) {
                    $permission = trim($permission);
                }
            } else {
                $m->permissions = $this->permissions_list;
            }
        }
    }

    /*Выборка списка всех менеджеров*/
    public function get_managers() {
        if (empty($this->all_managers)) {
            $this->init_managers();
        }
        return $this->all_managers;
    }

    /*Подсчет количества менеджеров*/
    public function count_managers($filter = array()) {
        return count($this->all_managers);
    }

    /*Выборка конкретного менеджера*/
    public function get_manager($id = null) {
        if (empty($this->all_managers)) {
            $this->init_managers();
        }
        // Если не запрашивается по логину, отдаём текущего менеджера или false
        if(empty($id)) {
            if (!empty($_SESSION['admin'])) {
                $id = $_SESSION['admin'];
            }
        }
        if(is_int($id) && isset($this->all_managers[$id])) {
            return $this->all_managers[$id];
        } elseif(is_string($id)) {
            foreach ($this->all_managers as $m) {
                if ($m->login == $id) {
                    return $m;
                }
            }
        }
        return false;
    }

    /*Добавление менеджера*/
    public function add_manager($manager) {
        $manager = (object)$manager;
        if(!empty($manager->password)) {
            // захешировать пароль
            $manager->password = $this->crypt_apr1_md5($manager->password);
        }

        if (!empty($manager->menu) && is_array($manager->menu)) {
            $manager->menu = serialize($manager->menu);
        }
        
        if(is_array($manager->permissions)) {
            if(count(array_diff($this->permissions_list, $manager->permissions))>0) {
                $manager->permissions = implode(",", $manager->permissions);
            } else {
                // все права
                $manager->permissions = null;
            }
        }
        $this->db->query("INSERT INTO __managers SET ?%", $manager);
        $id = $this->db->insert_id();
        $this->init_managers();
        return $id;
    }

    /*Обновление менеджеров*/
    public function update_manager($id, $manager) {
        $manager = (object)$manager;
        if(!empty($manager->password)) {
            // захешировать пароль
            $manager->password = $this->crypt_apr1_md5($manager->password);
        }

        if (!empty($manager->menu) && is_array($manager->menu)) {
            $manager->menu = serialize($manager->menu);
        }
        if(isset($manager->permissions) && is_array($manager->permissions)) {
            if(count(array_diff($this->permissions_list, $manager->permissions))>0) {
                $manager->permissions = implode(",", array_intersect($this->permissions_list, $manager->permissions));
            } else {
                // все права
                $manager->permissions = null;
            }
        }

        $this->db->query("UPDATE __managers SET ?% WHERE id=?", $manager, intval($id));
        $this->init_managers();
        return $id;
    }

    /*Удаление менеджера*/
    public function delete_manager($id) {
        if (!empty($id)) {
            $this->db->query("DELETE FROM __managers WHERE id=?", intval($id));
            $this->init_managers();
            return true;
        }
        return false;
    }

    /*Шифрование пароля*/
    private function crypt_apr1_md5($plainpasswd, $salt = '') {
        if (empty($salt)) {
            $salt = substr(str_shuffle("abcdefghijklmnopqrstuvwxyz0123456789"), 0, 8);
        }
        $len = strlen($plainpasswd);
        $text = $plainpasswd.'$apr1$'.$salt;
        $bin = pack("H32", md5($plainpasswd.$salt.$plainpasswd));
        for($i = $len; $i > 0; $i -= 16) { $text .= substr($bin, 0, min(16, $i)); }
        for($i = $len; $i > 0; $i >>= 1) { $text .= ($i & 1) ? chr(0) : $plainpasswd{0}; }
        $bin = pack("H32", md5($text));
        for($i = 0; $i < 1000; $i++) {
            $new = ($i & 1) ? $plainpasswd : $bin;
            if ($i % 3) $new .= $salt;
            if ($i % 7) $new .= $plainpasswd;
            $new .= ($i & 1) ? $bin : $plainpasswd;
            $bin = pack("H32", md5($new));
        }
        $tmp = '';
        for ($i = 0; $i < 5; $i++) {
            $k = $i + 6;
            $j = $i + 12;
            if ($j == 16) $j = 5;
            $tmp = $bin[$i].$bin[$k].$bin[$j].$tmp;
        }
        $tmp = chr(0).chr(0).$bin[11].$tmp;
        $tmp = strtr(strrev(substr(base64_encode($tmp), 2)),
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",
        "./0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz");
        return "$"."apr1"."$".$salt."$".$tmp;
    }

    /*Проверка доступа к определнному модулю сайта*/
    public function access($module, $manager = null) {
        if (empty($manager)) {
            $manager = $this->get_manager();
        }
        if(is_array($manager->permissions)) {
            return in_array($module, $manager->permissions);
        } else {
            return false;
        }
    }

    /*Проверка пароля*/
    public function check_password($password, $crypt_pass) {
        $salt = explode('$', $crypt_pass);
        $salt = $salt[2];
        return ($crypt_pass == $this->crypt_apr1_md5($password, $salt));
    }
}
