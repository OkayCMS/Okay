<?php

require_once('Okay.php');

class Translations extends Okay {
    
    private $vars = array();
    
    function __construct() {
        parent::__construct();
        $this->init_translations();
    }
    
    public function init_translations() {
        $vars = array();
        $lang_label = $_SESSION['lang'] ? $_SESSION['lang'] : $this->settings->lang_label;
        $language   = $this->languages->languages(array('id'=>$this->languages->lang_id));
        if (!empty($language)) {
            $translations = $this->languages->get_translations(array('lang'=>$language->label));
            if(!empty($translations)) {
                foreach($translations as $result) {
                	$this->vars[$result->label] = $result->value;
                }
            }
        }
    }
    
    public function __get($name) {
        if($res = parent::__get($name)) {
            return $res;
        }
    
        if(isset($this->vars[$name])) {
            return $this->vars[$name];
        } else {
            return null;
        }
    }
    
}
