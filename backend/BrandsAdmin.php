<?php

require_once('api/Okay.php');

class BrandsAdmin extends Okay {
    
    public function fetch() {
        // Обработка действий
        if($this->request->method('post')) {
            // Действия с выбранными
            $ids = $this->request->post('check');
            
            if(is_array($ids)) {
                switch($this->request->post('action')) {
                    case 'delete': {
                        foreach($ids as $id) {
                            $this->brands->delete_brand($id);
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
                $this->brands->update_brand($ids[$i], array('position'=>$position));
            }
        }
        
        $brands = $this->brands->get_brands();
        
        $this->design->assign('brands', $brands);
        return $this->body = $this->design->fetch('brands.tpl');
    }
    
}
