<?php

require_once('api/Okay.php');

class DeliveryAdmin extends Okay {
    
    public function fetch() {
        $delivery = new stdClass;
        /*Принимаем данные о способе доставки*/
        if($this->request->method('post')) {
            $delivery->id               = $this->request->post('id', 'intgeger');
            $delivery->enabled          = $this->request->post('enabled', 'boolean');
            $delivery->name             = $this->request->post('name');
            $delivery->description      = $this->request->post('description');
            $delivery->price            = $this->request->post('price');
            $delivery->free_from        = $this->request->post('free_from');
            $delivery->separate_payment    = $this->request->post('separate_payment','boolean');

            if(!$delivery_payments = $this->request->post('delivery_payments')) {
                $delivery_payments = array();
            }
            
            if(empty($delivery->name)) {
                $this->design->assign('message_error', 'empty_name');
            } else {
                /*Добавление/Обновление способа доставки*/
                if(empty($delivery->id)) {
                    $delivery->id = $this->delivery->add_delivery($delivery);
                    $this->design->assign('message_success', 'added');
                } else {
                    $this->delivery->update_delivery($delivery->id, $delivery);
                    $this->design->assign('message_success', 'updated');
                }

                // Удаление изображения
                if ($this->request->post('delete_image')) {
                    $this->image->delete_image($delivery->id, 'image', 'delivery', $this->config->original_deliveries_dir, $this->config->resized_deliveries_dir);
                }
                // Загрузка изображения
                $image = $this->request->files('image');
                if (!empty($image['name']) && ($filename = $this->image->upload_image($image['tmp_name'], $image['name'], $this->config->original_deliveries_dir))) {
                    $this->image->delete_image($delivery->id, 'image', 'delivery', $this->config->original_deliveries_dir, $this->config->resized_deliveries_dir);
                    $this->delivery->update_delivery($delivery->id, array('image'=>$filename));
                }
                $this->delivery->update_delivery_payments($delivery->id, $delivery_payments);
                $delivery = $this->delivery->get_delivery($delivery->id);
            }
            
        } else {
            $delivery->id = $this->request->get('id', 'integer');
            if(!empty($delivery->id)) {
                $delivery = $this->delivery->get_delivery($delivery->id);
            }
            $delivery_payments = $this->delivery->get_delivery_payments($delivery->id);
        }
        $this->design->assign('delivery_payments', $delivery_payments);
    
        // Все способы оплаты
        $payment_methods = $this->payment->get_payment_methods();
        $this->design->assign('payment_methods', $payment_methods);
    
        $this->design->assign('delivery', $delivery);
    
          return $this->design->fetch('delivery.tpl');
    }
    
}
