<?php

require_once('View.php');

class BrandsView extends View {

    /*Отображение страницы всех брендов*/
    public function fetch() {
        /*Выбираем все бренды*/
        $brands = $this->brands->get_brands(array('visible_brand'=>1));
        $this->design->assign('brands', $brands);
        if($this->page) {
            $this->design->assign('meta_title', $this->page->meta_title);
            $this->design->assign('meta_keywords', $this->page->meta_keywords);
            $this->design->assign('meta_description', $this->page->meta_description);
        }
        return $this->design->fetch('brands.tpl');
    }
    
}
