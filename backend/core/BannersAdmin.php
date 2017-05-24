<?php

require_once('api/Okay.php');

class BannersAdmin extends Okay {
    public function fetch() {
        /*Принимаем выбранные группы баннеров*/
        if($this->request->method('post')) {
            $ids = $this->request->post('check');
            if(is_array($ids)) {
                switch($this->request->post('action')) {
                    case 'disable': {
                        /*Выключаем группы баннеров*/
                        foreach($ids as $id) {
                            $this->banners->update_banner($id, array('visible'=>0));
                        }
                        break;
                    }
                    case 'enable': {
                        /*Включаем группы банннеров*/
                        foreach($ids as $id) {
                            $this->banners->update_banner($id, array('visible'=>1));
                        }
                        break;
                    }
                    case 'delete': {
                        /*Удаляем группы баннеров*/
                        foreach ($ids as $id) {
                            $this->banners->delete_banner($id);
                        }
                        break;
                    }
                }
            }
            
            // Сортировка
            $positions = $this->request->post('positions');
            $ids = array_keys($positions);
            sort($positions);
            foreach($positions as $i=>$position) {
                $this->banners->update_banner($ids[$i], array('position'=>$position));
            }
        }
        
        $banners = $this->banners->get_banners();
        if($banners){
            $categories = $this->categories->get_categories();
            $brands     = $this->brands->get_brands();
            $pages      = $this->pages->get_pages();
            foreach ($banners as $banner){
                $banner->category_selected = explode(",",$banner->categories);//Создаем массив категорий
                $banner->brand_selected = explode(",",$banner->brands);//Создаем массив брендов
                $banner->page_selected = explode(",",$banner->pages);//Создаем массив страниц
                foreach ($brands as $b){
                    if(in_array($b->id,$banner->brand_selected)){
                        $banner->brands_show[] = $b;
                    }
                }
                foreach ($categories as $c){
                    if(in_array($c->id,$banner->category_selected)){
                        $banner->category_show[] = $c;
                    }
                }
                foreach ($pages as $p){
                    if(in_array($p->id,$banner->page_selected)){
                        $banner->page_show[] = $p;
                    }
                }
            }
        }
        $this->design->assign('banners', $banners);
        return $this->design->fetch('banners.tpl');
    }
    
}
