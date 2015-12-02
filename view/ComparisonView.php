<?php

require_once('View.php');

class ComparisonView extends View {
    
    public function fetch() {
        // Способы доставки
        $deliveries = $this->delivery->get_deliveries(array('enabled'=>1));
        $this->design->assign('deliveries', $deliveries);
        
        // Данные пользователя
        if($this->user) {
            $last_order = $this->orders->get_orders(array('user_id'=>$this->user->id, 'limit'=>1));
            $last_order = reset($last_order);
            if($last_order) {
                $this->design->assign('name', $last_order->name);
                $this->design->assign('email', $last_order->email);
                $this->design->assign('phone', $last_order->phone);
                $this->design->assign('address', $last_order->address);
            } else {
                $this->design->assign('name', $this->user->name);
                $this->design->assign('email', $this->user->email);
            }
        }
        
        // Если существуют валидные купоны, нужно вывести инпут для купона
        if($this->coupons->count_coupons(array('valid'=>1))>0) {
            $this->design->assign('coupon_request', true);
        }
        
        // Выводим корзину
        return $this->design->fetch('comparison.tpl');
    }
    
}
