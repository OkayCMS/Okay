<?php

require_once('Okay.php');

class BackendTranslations extends Okay {
    
    public function get_translation($var)
    {
        return $this->$var;
    }
}
