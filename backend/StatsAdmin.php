<?php

require_once('api/Okay.php');

class StatsAdmin extends Okay {
    
    public function fetch() {
        return $this->design->fetch('stats.tpl');
    }
    
}
