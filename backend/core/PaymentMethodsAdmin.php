<?php

require_once('api/Okay.php');

class PaymentMethodsAdmin extends Okay {
    
    public function fetch() {
        // Обработка действий
        if($this->request->method('post')) {
            // Сортировка
            $positions = $this->request->post('positions');
            $ids = array_keys($positions);
            sort($positions);
            foreach($positions as $i=>$position) {
                $this->payment->update_payment_method($ids[$i], array('position'=>$position));
            }
            
            // Действия с выбранными
            $ids = $this->request->post('check');
            
            if(is_array($ids)) {
                switch($this->request->post('action')) {
                    case 'disable': {
                        /*Выключение способ оплаты*/
                        $this->payment->update_payment_method($ids, array('enabled'=>0));
                        break;
                    }
                    case 'enable': {
                        /*Включение способа оплаты*/
                        $this->payment->update_payment_method($ids, array('enabled'=>1));
                        break;
                    }
                    case 'delete': {
                        /*Удаление способа оплаты*/
                        foreach($ids as $id) {
                            $this->payment->delete_payment_method($id);
                        }
                        break;
                    }
                }
            }
        }
        
        // Отображение
        $payment_methods = $this->payment->get_payment_methods();
        $this->design->assign('payment_methods', $payment_methods);
        return $this->design->fetch('payment_methods.tpl');
    }
    
}

?>