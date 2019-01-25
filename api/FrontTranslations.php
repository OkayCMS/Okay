<?php

class FrontTranslations {
    
    private $lang = array();
    
    public function register($lang) {
        $this->lang = $lang;
    }
    
    public function __get($variable)
    {
        if (isset($this->lang[$variable])) {
            return $this->lang[$variable];
        }
        return '<b style="color: red!important;">Incorrect $lang->'.$variable.'</b>';
    }
}
