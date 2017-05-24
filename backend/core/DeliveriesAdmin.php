<?php

require_once('api/Okay.php');

class DeliveriesAdmin extends Okay {
    
    public function fetch() {
        // Обработка действий
        if($this->request->method('post')) {
            // Действия с выбранными
            $ids = $this->request->post('check');
            
            if(is_array($ids)) {
                switch($this->request->post('action')) {
                    case 'disable': {
                        /*Выключить способ доставки*/
                        $this->delivery->update_delivery($ids, array('enabled'=>0));
                        break;
                    }
                    case 'enable': {
                        /*Включить сопсоб доставки*/
                        $this->delivery->update_delivery($ids, array('enabled'=>1));
                        break;
                    }
                    case 'delete': {
                        /*Удалить способ доставки*/
                        foreach($ids as $id) {
                            $this->delivery->delete_delivery($id);
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
                $this->delivery->update_delivery($ids[$i], array('position'=>$position));
            }
        }
        
        // Отображение
        $deliveries = $this->delivery->get_deliveries();
        $this->design->assign('deliveries', $deliveries);
        return $this->design->fetch('deliveries.tpl');
    }
    
}
