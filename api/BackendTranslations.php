<?php

require_once('Okay.php');

class BackendTranslations {
    
    public function get_translation($var)
    {
        return $this->$var;
    }
}
