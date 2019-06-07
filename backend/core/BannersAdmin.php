<?php

require_once('api/Okay.php');

class BannersAdmin extends Okay {
    public function fetch() {

        $filter = array();
        $filter['page'] = max(1, $this->request->get('page', 'integer'));

        if ($filter['limit'] = $this->request->get('limit', 'integer')) {
            $filter['limit'] = max(5, $filter['limit']);
            $filter['limit'] = min(100, $filter['limit']);
            $_SESSION['banners_num_admin'] = $filter['limit'];
        } elseif (!empty($_SESSION['banners_num_admin'])) {
            $filter['limit'] = $_SESSION['banners_num_admin'];
        } else {
            $filter['limit'] = 25;
        }
        $this->design->assign('current_limit', $filter['limit']);
        
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
        
        $banners_count = $this->banners->count_banners($filter);
        // Показать все страницы сразу
        if($this->request->get('page') == 'all') {
            $filter['limit'] = $banners_count;
        }

        if($filter['limit']>0) {
            $pages_count = ceil($banners_count/$filter['limit']);
        } else {
            $pages_count = 0;
        }
        $filter['page'] = min($filter['page'], $pages_count);
        $this->design->assign('banners_count', $banners_count);
        $this->design->assign('pages_count', $pages_count);
        $this->design->assign('current_page', $filter['page']);
        
        $banners = $this->banners->get_banners($filter);
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
