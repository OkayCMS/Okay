<?php

require_once('Okay.php');

class Translations extends Okay {
    
    private $vars = array();

    private $labels_ids = array();
    
    function __construct() {
        parent::__construct();
        $this->init_translations();
    }
    
    public function init_translations() {
        $language = $this->languages->languages(array('id'=>$this->languages->lang_id()));
        if (!empty($language)) {
            $translations = $this->languages->get_translations(array('lang'=>$language->label));
            if(!empty($translations)) {
                foreach($translations as $result) {
                	$this->vars[$result->label] = $result->value;
                    $this->labels_ids[$result->label] = $result->id;
                }
            }
        }
    }

    public function get_labels_ids() {
        return $this->labels_ids;
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
