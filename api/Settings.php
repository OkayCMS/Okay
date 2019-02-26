<?php

/**
 * Управление настройками магазина, хранящимися в базе данных
 * В отличие от класса Config оперирует настройками доступными админу и хранящимися в базе данных.
 */

require_once('Okay.php');

class Settings extends Okay {
    
    private $vars;
    private $vars_lang;

    public function __construct() {
        parent::__construct();
        $this->init_settings();
    }
    
    public function __get($param) {
        if($res = parent::__get($param)) {
            return $res;
        }

        if (isset($this->vars_lang[$param])) {
            return $this->vars_lang[$param];
        } elseif (isset($this->vars[$param])) {
            return $this->vars[$param];
        } else {
            return null;
        }
    }

    /*Запись данных в общие настройки*/
    public function __set($param, $value) {

        if (!empty($this->vars['admin_theme']) && $param == 'theme' && $value == $this->vars['admin_theme']) {
            $this->vars[$param] = $value;
            return;
        }

        if (isset($this->vars_lang[$param])) {
            return;
        }
        $this->vars[$param] = $value;
        
        if(is_array($value)) {
            $value = serialize($value);
        } else {
            $value = (string) $value;
        }
        
        $this->db->query('SELECT count(*) as count FROM __settings WHERE param=?', $param);
        if($this->db->result('count')>0) {
            $this->db->query('UPDATE __settings SET value=? WHERE param=?', $value, $param);
        } else {
            $this->db->query('INSERT INTO __settings SET value=?, param=?', $value, $param);
        }
    }

    /*Выборка всех данных с таблиц настроек*/
    public function init_settings() {
        // Выбираем из базы ОБЩИЕ настройки и записываем их в переменную
        $this->vars = array();
        $this->db->query('SELECT param, value FROM __settings');
        foreach($this->db->results() as $result) {
            if(!($this->vars[$result->param] = @unserialize($result->value))) {
                $this->vars[$result->param] = $result->value;
            }
        }

        // Выбираем из базы настройки с переводами к текущему языку
        $this->vars_lang = array();
        $multi = $this->get_settings();
        if (is_array($multi)) {
            foreach ($multi as $s) {
                if(!($this->vars_lang[$s->param] = @unserialize($s->value))) {
                    $this->vars_lang[$s->param] = $s->value;
                }
            }
        }
    }

    /* Multilanguage settings */
    /**
     * Adding a new setting for all languages
     * @param string $param
     * @param string $value
     * @return bool
     */
    private function add($param, $value) {
        $languages = $this->languages->get_languages();
        if (!empty($languages)) {
            foreach ($languages as $l) {
                $this->db->query("REPLACE INTO __settings_lang SET lang_id=?, param=?, value=?", $l->id, $param, $value);
            }
        } else {
            $q = $this->db->placehold("REPLACE INTO __settings_lang SET param=?, value=?", $param, $value);
            if (!$this->db->query($q)) {
                return false;
            }
        }
        return true;
    }

    /**
     * Updating by @param $param(current language), or adding;
     * if a setting with specified $param is exist - it will be updated,
     * otherwise it will be added(called add() function).
     * @param string $param
     * @param string $value
     * @return bool
     */
    public function update($param, $value) {
        if (empty($param)) {
            return false;
        }
        $this->vars_lang[$param] = $value;
        $value = is_array($value) ? serialize($value) : (string) $value;

        $lang_id  = $this->languages->lang_id();
        $into_lang = '';
        if($lang_id) {
            $into_lang = $this->db->placehold("lang_id=?, ", $lang_id);
        }

        $this->db->query("SELECT 1 FROM __settings_lang WHERE param=? LIMIT 1", $param);
        if (!$this->db->result()) {
            return $this->add($param, $value);
        } else {
            $q = $this->db->placehold("REPLACE INTO __settings_lang SET $into_lang param=?, value=?", $param, $value);
            return $this->db->query($q) ? true : false;
        }
    }

    /**
     * Getting settings.
     * if $lang_id is not specified, a current language will be returned.
     * $lang_id = 0 is wrong, will be returned false.
     * @param string $lang_id
     * @return mixed
     */
    public function get_settings($lang_id = null) {
        if (!is_null($lang_id) && !($l = $this->languages->get_language(intval($lang_id)))) {
            return false;
        }
        $lang_id  = !is_null($lang_id) ? $lang_id : $this->languages->lang_id();
        $lang_id_filter = '';
        if($lang_id) {
            $lang_id_filter = $this->db->placehold("AND lang_id=?", $lang_id);
        }
        $this->db->query("SELECT * FROM __settings_lang WHERE 1 $lang_id_filter");
        return $this->db->results();
    }

}
