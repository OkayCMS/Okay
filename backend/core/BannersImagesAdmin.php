<?php

require_once('api/Okay.php');

class BannersImagesAdmin extends Okay {
    
    public function fetch() {
        $filter = array();
        $filter['page'] = max(1, $this->request->get('page', 'integer'));
        
        $filter['limit'] = 20;
        
        // Баннера
        $banners = $this->banners->get_banners();
        $this->design->assign('banners', $banners);
        
        // Текущий баннер
        $banner_id = $this->request->get('banner_id', 'integer');
        if($banner_id && $banner = $this->banners->get_banner($banner_id)) {
            $filter['banner_id'] = $banner->id;
        }
        
        // Текущий фильтр
        if($f = $this->request->get('filter', 'string'))
        {
            if($f == 'visible')
                $filter['visible'] = 1;
            elseif($f == 'hidden')
                $filter['visible'] = 0;
            $this->design->assign('filter', $f);
        }
        
        // Обработка действий
        if($this->request->method('post')) {
            // Сортировка
            $positions = $this->request->post('positions');
            $ids = array_keys($positions);
            sort($positions);
            $positions = array_reverse($positions);
            foreach($positions as $i=>$position) {
                $this->banners->update_banners_image($ids[$i], array('position'=>$position));
            }
            
            // Смена группы
            $image_banners = $this->request->post('image_banners');
            foreach($image_banners as $i=>$image_banner) {
                $this->banners->update_banners_image($i, array('banner_id'=>$image_banner));
            }
            
            // Действия с выбранными
            $ids = $this->request->post('check');
            if(!empty($ids)) {
                switch($this->request->post('action')) {
                    case 'disable': {
                        $this->banners->update_banners_image($ids, array('visible'=>0));
                        break;
                    }
                    case 'enable': {
                        $this->banners->update_banners_image($ids, array('visible'=>1));
                        break;
                    }
                    case 'delete': {
                        foreach($ids as $id) {
                            $this->banners->delete_banners_image($id);
                        }
                        break;
                    }
                    case 'move_to_banner': {
                        $banner_id = $this->request->post('target_banner', 'integer');
                        $filter['page'] = 1;
                        $banner = $this->banners->get_banner($banner_id);
                        $filter['banner_id'] = $banner->id;
                        
                        foreach($ids as $id) {
                            $this->banners->update_banners_image($ids, array('banner_id'=>$banner->id));
                        }
                        break;
                    }
                }
            }
        }
        
        // Отображение
        if(isset($banner)) {
            $this->design->assign('banner', $banner);
        }
        
        $banners_images_count = $this->banners->count_banners_images($filter);
        // Показать все страницы сразу
        if($this->request->get('page') == 'all') {
            $filter['limit'] = $banners_images_count;
        }
        
        if($filter['limit']>0) {
            $pages_count = ceil($banners_images_count/$filter['limit']);
        } else {
            $pages_count = 0;
        }
        $filter['page'] = min($filter['page'], $pages_count);
        $this->design->assign('banners_images_count', $banners_images_count);
        $this->design->assign('pages_count', $pages_count);
        $this->design->assign('current_page', $filter['page']);
        
        $banners_images = array();
        foreach($this->banners->get_banners_images($filter) as $p) {
            $banners_images[$p->id] = $p;
        }
        
        $this->design->assign('banners_images', $banners_images);
        
        return $this->design->fetch('banners_images.tpl');
    }
    
}
