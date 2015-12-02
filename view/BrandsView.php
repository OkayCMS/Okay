<?php

require_once('View.php');

class BrandsView extends View {
    
    public function fetch() {
        $brands = $this->brands->get_brands();
        $this->design->assign('brands', $brands);
        if($this->page) {
            $this->design->assign('meta_title', $this->page->meta_title);
            $this->design->assign('meta_keywords', $this->page->meta_keywords);
            $this->design->assign('meta_description', $this->page->meta_description);
        }
        return $this->design->fetch('brands.tpl');
    }
    
}
