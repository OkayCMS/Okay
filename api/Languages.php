<?php

require_once('Okay.php');

class Languages extends Okay {
    
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
        'banner_image' => 'banners_images'
        
    );
    
    public $languages;
    public $lang_id;
    
    public function lang_list() {
        $langs['ru'] = (object)array('name' => 'Русский',     'label' => 'ru');
        $langs['uk'] = (object)array('name' => 'Украинский',  'label' => 'uk');
        $langs['by'] = (object)array('name' => 'Белорусский', 'label' => 'by');
        $langs['en'] = (object)array('name' => 'Английский',  'label' => 'en');
        $langs['ch'] = (object)array('name' => 'Китайский',   'label' => 'ch');
        $langs['de'] = (object)array('name' => 'Немецкий',    'label' => 'de');
        $langs['fr'] = (object)array('name' => 'Французский', 'label' => 'fr');
    
        return $langs;
    }
    
    public function get_fields($object = '') {
        $fields['categories']      = array('name', 'name_h1', 'meta_title', 'meta_keywords', 'meta_description', 'annotation', 'description', 'auto_meta_title', 'auto_meta_keywords', 'auto_meta_desc', 'auto_body');
        $fields['brands']          = array('name', 'meta_title', 'meta_keywords', 'meta_description', 'annotation', 'description');
        $fields['products']        = array('name', 'meta_title', 'meta_keywords', 'meta_description', 'annotation', 'body', 'special');
        $fields['variants']        = array('name');
        $fields['blog']            = array('name', 'meta_title', 'meta_keywords', 'meta_description', 'annotation', 'text');
        $fields['pages']           = array('name', 'meta_title', 'meta_keywords', 'meta_description', 'header', 'body');
        $fields['features']        = array('name');
        $fields['delivery']        = array('name', 'description');
        $fields['payment_methods'] = array('name', 'description');
        $fields['currencies']      = array('name', 'sign');
        $fields['banners_images']  = array('name', 'alt', 'title', 'description', 'url');
        
        if($object && !empty($fields[$object])) {
            return $fields[$object];
        } else {
            return $fields;
        }
    }
    
    public function get_query($params = array()) {
        $lang   = (isset($params['lang']) && $params['lang'] ? $params['lang'] : $this->lang_id());
        $object = $params['object'];
        
        if(!empty($params['px'])) {
            $px = $params['px'];
        } else {
            $px = $object[0];
        }
        
        $this->db->query("SHOW TABLES LIKE '%__languages%'");
        $exist = $this->db->result();
        
        if (isset($lang) && $exist && !empty($this->languages)) {
            /*$f = 'l';
            $lang_join = 'LEFT JOIN __lang_'.$this->tables[$object].' l ON l.'.$object.'_id='.$px.'.id AND l.lang_id = '.(int)$lang;*/
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
    
    public function lang_id() {
        if(empty($this->languages)) {
            return false;
        }
        
        if(isset($this->lang_id)) {
            return $this->lang_id;
        }
        
        if($this->request->get('lang_id', 'integer')) {
            unset($_SESSION['lang_id']);
            $this->lang_id = $_SESSION['lang_id'] = $this->request->get('lang_id', 'integer');
        }
        
        if($this->request->get('lang_label', 'string') && !$this->request->get('lang_id', 'integer')) {
            $lang_id = null;
            foreach($this->languages as $l) {
                if($this->request->get('lang_label', 'string') == $l->label) {
                    $lang_id = $l->id;
                    break;
                }
            }
            $this->lang_id = $_SESSION['lang_id'] = $lang_id;
            return $this->lang_id;
        }
        
        if(empty($this->lang_id) && !empty($_SESSION['lang_id']) && !empty($this->languages[$_SESSION['lang_id']])) {
            $this->lang_id  = $_SESSION['lang_id'];
        }

        if(empty($this->lang_id)) {
            $first_lang = reset($this->languages);
            $this->lang_id = $first_lang->id;
        }
        return $this->lang_id;
    }
    
    public function set_lang_id($id) {
        $this->lang_id = $_SESSION['lang_id'] = $id;
    }
    
    public function languages($filter=array()) {
        if(empty($this->languages)) {
            $this->init_languages();
        }
        
        if(!empty($filter['id'])) {
            return $this->languages[$filter['id']];
        }
        
        if(!empty($filter['label'])) {
            foreach($this->languages as $lang) {
                if($lang->label == $filter['label']) {
                    return $lang;
                }
            }
        }
        return $this->languages;
    }
    
    public function init_languages() {
        if(!empty($this->languages)) {
            return $this->languages;
        }
        
        if($langs = $this->get_languages()) {
            foreach($langs as $l) {
                $this->languages[$l->id] = $l;
            }
        } else {
            return false;
        }
    }
    
    public function get_language($id) {
        $query = $this->db->placehold("SELECT * FROM __languages WHERE id=? LIMIT 1", intval($id));
        $this->db->query($query);
        return $this->db->result();
    }
    
    public function get_languages($filter = array()) {
        $query = "SELECT * FROM __languages WHERE 1 ORDER BY position";
        if($this->db->query($query)) {
            return $this->db->results();
        } else {
            return false;
        }
    }
    
    public function update_language($id, $data) {
        $data = (object)$data;
        $language = $this->get_language($id);

        $query = $this->db->placehold("UPDATE __languages SET ?% WHERE id in(?@)", $data, (array)$id);
        $this->db->query($query);
        
        if($data->label && !empty($language) && $language->label!==$data->label) {
            foreach($this->tables as $table) {
                $this->db->query("UPDATE __lang_".$table." SET lang_label=? WHERE lang_id=?", $data->label, $id);
            }
        }
        return $id;
    }
    
    public function add_language($data) {
        $data = (object)$data;
        $languages = $this->get_languages();
        if(!empty($languages)) {
            $languag = reset($languages);
        }

        $query = $this->db->placehold('INSERT INTO __languages SET ?%', $data);
        if(!$this->db->query($query)) {
            return false;
        }
        $last_id = $this->db->insert_id();
        $this->db->query("UPDATE __languages SET position=id WHERE id=? LIMIT 1", $last_id);

        // если нету поля в переводах добавим его
        $this->db->query("SHOW FIELDS FROM __translations WHERE field=?", 'lang_'.$data->label);
        if (!$this->db->result()) {
            $this->db->query("ALTER TABLE __translations ADD COLUMN `lang_$data->label` VARCHAR(255) NOT NULL DEFAULT ''");
        }
        
        if($last_id) {
            $this->db->query("SHOW FIELDS FROM __languages WHERE field=?", 'name_'.$data->label);
            if (!$this->db->result()) {
                $this->db->query("ALTER TABLE __languages ADD COLUMN `name_$data->label` VARCHAR(255) NOT NULL DEFAULT ''");
            }
            $this->db->query("UPDATE __languages SET name_$data->label=name");

            $description_fields = $this->get_fields();
            foreach($this->tables as $object => $tab) {
                $this->db->query('INSERT INTO __lang_'.$tab.' ('.implode(',', $description_fields[$tab]).', '.$object.'_id, lang_id, lang_label)
                                    SELECT '.implode(',', $description_fields[$tab]).', id, ?, ?
                                    FROM __'.$tab.'', $last_id, $data->label);
            }
            
            if(!empty($languages)) {
                $this->db->query("SELECT * FROM __options WHERE lang_id=?", $languag->id);
                $options = $this->db->results();
                if(!empty($options)) {
                    foreach($options as $o) {
                        $this->db->query("REPLACE INTO __options SET lang_id=?, value=?, product_id=?, feature_id=?, translit=?", $last_id, $o->value, $o->product_id, $o->feature_id, $o->translit);
                    }
                }
            } else {
                $this->db->query("UPDATE __options SET lang_id=?", $last_id);
            }
            return $last_id;
        }
    }
    
    public function delete_language($id, $save_main = false) {
        if(!empty($id)) {
            $query = $this->db->placehold("DELETE FROM __languages WHERE id=? LIMIT 1", intval($id));
            $this->db->query($query);

            foreach($this->tables as $table) {
                $this->db->query("DELETE FROM  __lang_".$table." WHERE lang_id=?", intval($id));
            }

            if (!$save_main) {
                $this->db->query("DELETE FROM  __options WHERE lang_id=?", intval($id));
            } else {
                $this->db->query("UPDATE __options set lang_id=0 where lang_id=?", intval($id));
            }
        }
    }
    
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
    
    public function get_description($data, $object) {
        if(!in_array($object, array_keys($this->tables))) {
            return false;
        }
        
        $languages   = $this->languages();
        if (empty($languages)) {
            return false;
        }
        $languag     = reset($languages);
        $fields      = $this->get_fields($this->tables[$object]);
        $intersect   = array_intersect($fields, array_keys((array)$data));
        
        if(!empty($intersect)) {
            $description = new stdClass;
            foreach($fields as $f) {
                if (isset($data->$f)) {
                    $description->$f = $data->$f;
                }
                if($languag->id != $this->lang_id()) {
                    unset($data->$f);
                }
            }
            $result = new stdClass();
            $result->description = $description;
            return $result;
        }
        return false;
    }
    
    public function action_description($object_id, $description, $object, $update_lang = null) {
        if(!in_array($object, array_keys($this->tables))) {
            return false;
        }
        
        $languages = $this->languages();
        if (empty($languages)) {
            return;
        }
        
        $fields = $this->get_fields($this->tables[$object]);
        if(!empty($fields)) {
            if($update_lang) {
                $upd_languages[] = $languages[$update_lang];
            } else {
                $upd_languages = $languages;
            }
            foreach($upd_languages as $lang) {
                $description->lang_id = $lang->id;
                $this->action_data($object_id, $description, $object);
            }
            return;
        } else {
            return;
        }
    }
    
    /* Translation start */
    public function get_translation($id) {
        $query = $this->db->placehold("SELECT * FROM __translations WHERE id=? LIMIT 1", intval($id));
        $this->db->query($query);
        return $this->db->result();
    }
    
    public function get_translations($filter = array()) {
        $order = 'ORDER BY label';
        $lang = '*';
        if(!empty($filter['lang'])) {
            $lang = 'id, label, lang_'.$filter['lang'].' as value';
        }

        if (!empty($filter['sort'])) {
            switch ($filter['sort']) {
                case 'label_desc':
                    $order = 'ORDER BY label DESC';
                    break;
                case 'date':
                    $order = 'ORDER BY id';
                    break;
                case 'date_desc':
                    $order = 'ORDER BY id DESC';
                    break;
                case 'translation':
                    if (!empty($filter['lang'])) {
                        $order = 'ORDER BY value';
                    }
                    break;
                case 'translation_desc':
                    if (!empty($filter['lang'])) {
                        $order = 'ORDER BY value DESC';
                    }
                    break;
            }
        }
        
        $query = "SELECT ".$lang." FROM __translations WHERE 1 $order";
        if($this->db->query($query)) {
            return $this->db->results();
        }
    }
    
    public function update_translation($id, $data) {
        $query = $this->db->placehold("UPDATE __translations SET ?% WHERE id in(?@)", $data, (array)$id);
        $this->db->query($query);
        $this->dump_translation();
        return $id;
    }
    
    public function add_translation($data) {
        $query = $this->db->placehold('INSERT INTO __translations SET ?%', $data);
        if(!$this->db->query($query)) {
            return false;
        }
        $last_id = $this->db->insert_id();
        $this->dump_translation();
        return $last_id;
    }
    
    public function update_translation_config_js() {
        $translations = $this->get_translations();
        
        // THEME JS
        $theme_dir = 'design/'.$this->settings->theme;
        $filejs = $theme_dir.'/lang.js';
        $filejs = fopen($filejs, 'w');
        $js .= "var lang = new Array();\n";
        
        $lang_id  = $this->lang_id();
        $set_lang = $this->languages(array('id'=>$lang_id));
        
        foreach($translations as $t) {
            if($t->in_config){
                $lang = 'lang_'.$set_lang->label;
                $js .= "\nlang['".$t->label."'] = '".mysql_escape_string( $t->$lang )."';";
            }
        }
        fwrite($filejs, $js);
        fclose($filejs);
    }
    
    public function delete_translation($id) {
        if(!empty($id)) {
            $query = $this->db->placehold("DELETE FROM __translations WHERE id=? LIMIT 1", intval($id));
            $this->db->query($query);
        }
    }
    
    public function set_translation() {
        $this->db->query("TRUNCATE TABLE __translations");
        
        $theme_dir = 'design/'.$this->settings->theme;
        $filename = $theme_dir.'/translation.sql';
        if (file_exists($filename)) {
            $this->db->restore($filename);
        }
    }
    
    public function dump_translation() {
        $theme_dir = 'design/'.$this->settings->theme;
        $filename = $theme_dir.'/translation.sql';
        $filename = fopen($filename, 'w');
        
        $this->db->dump_table('s_translations', $filename);
        //chmod($filename, 0777);
    }
    /* Translation end */
    
}
