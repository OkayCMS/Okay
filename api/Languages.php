<?php

require_once('Okay.php');

class Languages extends Okay {

    /*Создание списка мультиязычных таблиц в БД*/
    public $tables = array('product'  => 'products',
        'variant'  => 'variants',
        'brand'    => 'brands',
        'category' => 'categories',
        'feature'  => 'features',
        'blog'     => 'blog',
        'page'     => 'pages',
        'currency' => 'currencies',
        'delivery' => 'delivery',
        'payment'  => 'payment_methods',
        'banner_image' => 'banners_images',
        'order_labels' => 'orders_labels',
        'order_status' => 'orders_status',
        'menu_item'    => 'menu_items',
        'seo_filter_pattern'    => 'seo_filter_patterns',
        'feature_alias'         => 'features_aliases',
        'feature_alias_value'   => 'features_aliases_values',
        'feature_value'         => 'features_values',
    );
    
    private $languages = array();
    private $first_language;
    private $lang_id;
    private $available_languages;
    private $has_languages;
    private $check_languages = false;

    /*Выборка списка языков сайта*/
    public function lang_list() {
        if (!isset($this->available_languages)) {
            include_once("backend/lang/languages_list.php");
            $this->available_languages = isset($langs) ? $langs : array();
        }
        return $this->available_languages;
    }

    /*Выборка мультиязычных полей из БД*/
    public function get_fields($object = '') {
        $fields['categories']      = array('name', 'name_h1', 'meta_title', 'meta_keywords', 'meta_description', 'annotation', 'description', 'auto_meta_title', 'auto_meta_keywords', 'auto_meta_desc', 'auto_description');
        $fields['brands']          = array('name', 'meta_title', 'meta_keywords', 'meta_description', 'annotation', 'description');
        $fields['products']        = array('name', 'meta_title', 'meta_keywords', 'meta_description', 'annotation', 'description', 'special');
        $fields['variants']        = array('name', 'units');
        $fields['blog']            = array('name', 'meta_title', 'meta_keywords', 'meta_description', 'annotation', 'description');
        $fields['pages']           = array('name', 'name_h1', 'meta_title', 'meta_keywords', 'meta_description', 'description');
        $fields['features']        = array('name');
        $fields['delivery']        = array('name', 'description');
        $fields['payment_methods'] = array('name', 'description');
        $fields['currencies']      = array('name', 'sign');
        $fields['banners_images']  = array('name', 'alt', 'title', 'description', 'url');
        $fields['orders_labels']   = array('name');
        $fields['orders_status']   = array('name');
        $fields['menu_items']      = array('name');
        $fields['features_values'] = array('value', 'translit');
        $fields['seo_filter_patterns'] = array('h1', 'title', 'keywords', 'meta_description', 'description');
        $fields['features_aliases']    = array('name');
        $fields['features_aliases_values'] = array('value');

        if($object && !empty($fields[$object])) {
            return $fields[$object];
        } else {
            return $fields;
        }
    }

    /*Выборка данных для связки таблиц и их мультиязычных данных*/
    public function get_query($params = array()) {
        $lang   = (isset($params['lang']) && $params['lang'] ? $params['lang'] : $this->lang_id());
        $object = $params['object'];

        if(!empty($params['px'])) {
            $px = $params['px'];
        } else {
            $px = $object[0];
        }

        if (!$this->check_languages) {
            $this->db->query("SHOW TABLES LIKE '%__languages%'");
            $this->has_languages = $this->db->result();
            $this->check_languages = true;
        }

        if (!empty($lang) && $this->has_languages && !empty($this->languages)) {
            $f = (isset($params['px_lang']) && $params['px_lang'] ? $params['px_lang'] : 'l');
            $lang_join = 'LEFT JOIN __lang_'.$this->tables[$object].' '.$f.' ON '.$f.'.'.$object.'_id='.$px.'.id AND '.$f.'.lang_id = '.(int)$lang;
        } else {
            $f = $px;
            $lang_join = '';
        }
        $lang_col = $f.'.'.implode(', '.$f.'.',$this->get_fields($this->tables[$object]));
        
        $result = new stdClass;
        $result->join   = $lang_join;
        $result->fields = $lang_col;
        
        return $result;
    }

    /*Выборка ID текущего языка*/
    public function lang_id() {
        if(empty($this->languages)) {
            return false;
        }
        
        if(isset($this->lang_id)) {
            return $this->lang_id;
        }

        if($this->request->get('lang_label', 'string')) {
            $lang_id = null;
            foreach($this->languages as $l) {
                if($this->request->get('lang_label', 'string') == $l->label) {
                    $lang_id = $l->id;
                    break;
                }
            }
            $this->lang_id = $_SESSION['lang_id'] = intval($lang_id);
            return $this->lang_id;
        }

        if($this->request->get('lang_id', 'integer')) {
            unset($_SESSION['lang_id']);
            $this->lang_id = $_SESSION['lang_id'] = $this->request->get('lang_id', 'integer');
        }
        
        if(empty($this->lang_id) && !empty($_SESSION['lang_id']) && !empty($this->languages[$_SESSION['lang_id']])) {
            $this->lang_id  = intval($_SESSION['lang_id']);
        }

        if(empty($this->lang_id)) {
            $this->lang_id = intval($this->first_language->id);
        }
        return $this->lang_id;
    }

    /*Установка ID языка*/
    public function set_lang_id($id) {
        $this->lang_id = $_SESSION['lang_id'] = intval($id);
    }

    public function __construct() {
        parent::__construct();
        $this->init_languages();
    }

    // Если нужно обновить список языков, в нужное место добавить вызов этой ф-ии
    /*Инициалищация языков*/
    public function init_languages() {
        $this->languages = array();
        $this->db->query("SELECT * FROM __languages WHERE 1 ORDER BY position");
        foreach ($this->db->results() as $l) {
            $this->languages[$l->id] = $l;
        }
        $this->first_language = reset($this->languages);
        $current_language = $this->get_language($this->lang_id());
        foreach ($this->languages as $l) {
            $l->current_name = $l->{'name_'.$current_language->label};
            foreach ($this->languages as $tl) {
                $l->names[$tl->id] = $l->{'name_'.$tl->label};
            }
        }
    }

    /*Выборка первого языка сайта*/
    public function get_first_language() {
        return $this->first_language;
    }

    /*Выборка конкретного языка*/
    public function get_language($id) {
        if (!empty($id)) {
            if(is_int($id) && isset($this->languages[$id])) {
                return $this->languages[$id];
            } elseif(is_string($id)) {
                foreach ($this->languages as $language) {
                    if ($language->label == $id) {
                        return $language;
                    }
                }
            }
        }
        return false;
    }

    /*Выборка всех языков*/
    public function get_languages() {
        return $this->languages;
    }

    // Если пустой lang_label в запросе, то ф-ия lang_id() может вернуть предыдущий язык сессии,
    // при переключении на основной язык. Так как сперва ищем lang_id в $_GET, потом lang_label,
    // и если этих параметров нету а в сессии есть язык(предыдущий по факту), то вернём его.
    // В этом случае должна быть вызвана ф-ия set_lang_id() до get_lang_link();
    public function get_lang_link() {
        $lang_link = '';
        $lang_id = $this->lang_id();
        $current_language = $this->languages[$lang_id];
        //$current_language = $this->languages[$this->lang_id];
        if (!empty($this->first_language) && !empty($current_language) && $current_language->id !== $this->first_language->id) {
            $lang_link = $current_language->label . '/';
        }
        return $lang_link;
    }

    /*Обновление языка*/
    public function update_language($id, $data) {
        $data = (object)$data;
        $query = $this->db->placehold("UPDATE __languages SET ?% WHERE id in(?@)", $data, (array)$id);
        $this->db->query($query);
        
        $this->init_languages();
        return $id;
    }

    /*Добавление языка*/
    public function add_language($data) {
        $data = (object)$data;
        $query = $this->db->placehold('INSERT INTO __languages SET ?%', $data);
        if(!$this->db->query($query)) {
            return false;
        }
        $last_id = $this->db->insert_id();
        $this->db->query("UPDATE __languages SET position=id WHERE id=? LIMIT 1", $last_id);

        if($last_id) {
            $this->translations->copy_translations($this->first_language->label, $data->label);
            $this->db->query("SHOW FIELDS FROM __languages WHERE field=?", 'name_'.$data->label);
            if (!$this->db->result()) {
                $this->db->query("ALTER TABLE __languages ADD COLUMN `name_$data->label` VARCHAR(255) NOT NULL DEFAULT ''");
            }
            $this->db->query("UPDATE __languages SET name_$data->label=name");

            $description_fields = $this->get_fields();
            foreach($this->tables as $object => $tab) {
                $this->db->query('INSERT INTO __lang_'.$tab.' ('.implode(',', $description_fields[$tab]).', '.$object.'_id, lang_id)
                                    SELECT '.implode(',', $description_fields[$tab]).', id, ?
                                    FROM __'.$tab, $last_id);
            }
            
            if(isset($this->first_language) && !empty($this->first_language)) {
                $settings = $this->settings->get_settings($this->first_language->id);
                if (!empty($settings)) {
                    foreach ($settings as $s) {
                        $this->db->query("REPLACE INTO __settings_lang SET lang_id=?, param=?, value=?", $last_id, $s->param, $s->value);
                    }
                }
            } else {
                $this->db->query("UPDATE __settings_lang SET lang_id=?", $last_id);
            }
            $this->init_languages();
            return $last_id;
        }
    }

    /*Удаление языка*/
    public function delete_language($id, $save_main = false) {
        if(!empty($id)) {
            $query = $this->db->placehold("DELETE FROM __languages WHERE id=? LIMIT 1", intval($id));
            $this->db->query($query);

            foreach($this->tables as $table) {
                $this->db->query("DELETE FROM  __lang_".$table." WHERE lang_id=?", intval($id));
            }

            if (!$save_main) {
                $this->db->query("DELETE FROM __settings_lang WHERE lang_id=?", intval($id));
            } else {
                $this->db->query("UPDATE __settings_lang SET lang_id=0 WHERE lang_id=?", intval($id));
            }
            $this->init_languages();
        }
    }

    /*Действия над мультиязычным контентом*/
    public function action_data($object_id, $data, $object) {
        if(!in_array($object, array_keys($this->tables))) {
            return false;
        }
        
        $this->db->query("SELECT count(*) as count FROM __lang_".$this->tables[$object]." WHERE lang_id=? AND ".$object."_id=? LIMIT 1", $data->lang_id, $object_id);
        $data_lang = $this->db->result('count');
        
        if($data_lang == 0) {
            $object_fild   = $object.'_id';
            $data->$object_fild = $object_id;
            $query = $this->db->placehold('INSERT INTO __lang_'.$this->tables[$object].' SET ?%', $data);
            $this->db->query($query);
            $result = 'add';
        } elseif($data_lang == 1) {
            $this->db->query("UPDATE __lang_".$this->tables[$object]." SET ?% WHERE lang_id=? AND ".$object."_id=?", $data, $data->lang_id, $object_id);
            $result = 'update';
        }
        return $result;
    }

    /*Выборка мультиязычных данных*/
    public function get_description($data, $object, $clear = true) {
        if(!in_array($object, array_keys($this->tables)) || empty($this->languages)) {
            return false;
        }
        
        $fields      = $this->get_fields($this->tables[$object]);
        $intersect   = array_intersect($fields, array_keys((array)$data));
        if(!empty($intersect)) {
            $description = new stdClass;
            foreach($fields as $f) {
                if (isset($data->$f)) {
                    $description->$f = $data->$f;
                }
                if ($this->first_language->id != $this->lang_id() && $clear === true) {
                    unset($data->$f);
                }
            }
            $result = new stdClass();
            $result->description = $description;
            return $result;
        }
        return false;
    }

    /*Выборка мультиязычных данных и их дальнейшая обработка*/
    public function action_description($object_id, $description, $object, $update_lang = null) {
        if(!in_array($object, array_keys($this->tables)) || empty($this->languages)) {
            return false;
        }

        $fields = $this->get_fields($this->tables[$object]);
        if(!empty($fields)) {
            if($update_lang) {
                $upd_languages[] = $this->languages[$update_lang];
            } else {
                $upd_languages = $this->languages;
            }
            foreach($upd_languages as $lang) {
                $description->lang_id = $lang->id;
                $this->action_data($object_id, $description, $object);
            }
            return true;
        } else {
            return false;
        }
    }
    
}
