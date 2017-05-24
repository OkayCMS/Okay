<?php

require_once('api/Okay.php');

class PaymentMethodAdmin extends Okay {
    
    public function fetch() {
        $payment_method = new stdClass;
        /*Приме информации о способе оплаты*/
        if($this->request->method('post')) {
            $payment_method->id              = $this->request->post('id', 'intgeger');
            $payment_method->enabled         = $this->request->post('enabled', 'boolean');
            $payment_method->name            = $this->request->post('name');
            $payment_method->currency_id     = $this->request->post('currency_id');
            $payment_method->description     = $this->request->post('description');
            $payment_method->module          = $this->request->post('module', 'string');
            
            $payment_settings = $this->request->post('payment_settings');
            
            if(!$payment_deliveries = $this->request->post('payment_deliveries')) {
                $payment_deliveries = array();
            }
            
            if (empty($payment_method->name)) {
                $this->design->assign('message_error', 'empty_name');
            } else {
                /*Добавление/Обновление способа оплаты*/
                if(empty($payment_method->id)) {
                    $payment_method->id = $this->payment->add_payment_method($payment_method);
                    $this->design->assign('message_success', 'added');
                } else {
                    $this->payment->update_payment_method($payment_method->id, $payment_method);
                    $this->design->assign('message_success', 'updated');
                }

                // Удаление изображения
                if ($this->request->post('delete_image')) {
                    $this->image->delete_image($payment_method->id, 'image', 'payment_methods', $this->config->original_payments_dir, $this->config->resized_payments_dir);
                }
                // Загрузка изображения
                $image = $this->request->files('image');
                if (!empty($image['name']) && ($filename = $this->image->upload_image($image['tmp_name'], $image['name'], $this->config->original_payments_dir))) {
                    $this->image->delete_image($payment_method->id, 'image', 'payment_methods', $this->config->original_payments_dir, $this->config->resized_payments_dir);
                    $this->payment->update_payment_method($payment_method->id, array('image'=>$filename));
                }
                if($payment_method->id) {
                    $this->payment->update_payment_settings($payment_method->id, $payment_settings);
                    $this->payment->update_payment_deliveries($payment_method->id, $payment_deliveries);
                }
                $payment_method = $this->payment->get_payment_method($payment_method->id);
            }
        } else {
            $payment_method->id = $this->request->get('id', 'integer');
            if(!empty($payment_method->id)) {
                $payment_method = $this->payment->get_payment_method($payment_method->id);
                $payment_settings =  $this->payment->get_payment_settings($payment_method->id);
            } else {
                $payment_settings = array();
            }
            $payment_deliveries = $this->payment->get_payment_deliveries($payment_method->id);
        }
        $this->design->assign('payment_deliveries', $payment_deliveries);
        // Связанные способы доставки
        $deliveries = $this->delivery->get_deliveries();
        $this->design->assign('deliveries', $deliveries);
        
        $this->design->assign('payment_method', $payment_method);
        $this->design->assign('payment_settings', $payment_settings);
        $payment_modules = $this->payment->get_payment_modules();
        $this->design->assign('payment_modules', $payment_modules);
        
        $currencies = $this->money->get_currencies();
        $this->design->assign('currencies', $currencies);
        
        return $this->design->fetch('payment_method.tpl');
    }
    
}
