<?php

require_once('api/Okay.php');

class StatsAdmin extends Okay {

    /*Отображение модуля статистики продаж*/
    public function fetch() {
        return $this->design->fetch('stats.tpl');
    }
    
}
