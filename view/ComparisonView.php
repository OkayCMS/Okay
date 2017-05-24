<?php

require_once('View.php');

class ComparisonView extends View {

    /*Отображение страницы списка сравнения*/
    public function fetch() {
        return $this->design->fetch('comparison.tpl');
    }
}
