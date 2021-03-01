<?php

require_once('api/Okay.php');

class LicenseAdmin extends Okay {
    
    public function fetch() {
        return $this->design->fetch('license.tpl');
    }
    
}
