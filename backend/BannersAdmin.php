<?php

require_once('api/Okay.php');

class BannersAdmin extends Okay {
    public function fetch() {
        if($this->request->method('post')) {
            // Действия с выбранными
            $ids = $this->request->post('check');
            if(is_array($ids)) {
                switch($this->request->post('action')) {
                    case 'disable': {
                        foreach($ids as $id) {
                            $this->banners->update_banner($id, array('visible'=>0));
                        }
                        break;
                    }
                    case 'enable': {
                        foreach($ids as $id) {
                            $this->banners->update_banner($id, array('visible'=>1));
                        }
                        break;
                    }
                    case 'delete': {
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
        
        $this->design->assign('banners', $banners);
        return $this->design->fetch('banners.tpl');
    }
    
}
