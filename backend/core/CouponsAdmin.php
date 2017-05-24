<?php

require_once('api/Okay.php');

class CouponsAdmin extends Okay {
    
    public function fetch() {
        // Обработка действий
        if($this->request->method('post')) {
            // Действия с выбранными
            $ids = $this->request->post('check');
            if(is_array($ids) && count($ids)>0) {
                switch($this->request->post('action')) {
                    case 'delete': {
                        /*Удаление купона*/
                        foreach($ids as $id) {
                            $this->coupons->delete_coupon($id);
                        }
                        break;
                    }
                }
            }

            /*Создание купона*/
            if($this->request->post("new_code")){
                $new_expire = $this->request->post('new_expire');
                $new_coupon = new stdClass();
                $new_coupon->id = $this->request->post('new_id', 'integer');
                $new_coupon->code = $this->request->post('new_code', 'string');
                if(!empty($new_expire)) {
                    $new_coupon->expire = date('Y-m-d', strtotime($new_expire));
                } else {
                    $new_coupon->expire = null;
                }
                $new_coupon->value = $this->request->post('new_value', 'float');
                $new_coupon->type = $this->request->post('new_type', 'string');
                $new_coupon->min_order_price = $this->request->post('new_min_order_price', 'float');
                $new_coupon->single = $this->request->post('new_single', 'float');

                // Не допустить одинаковые URL разделов.
                if(($a = $this->coupons->get_coupon((string)$new_coupon->code)) && $a->id != $new_coupon->id) {
                    $this->design->assign('message_error', 'code_exists');
                } elseif(empty($new_coupon->code)) {
                    $this->design->assign('message_error', 'empty_code');
                } else {
                    $new_coupon->id = $this->coupons->add_coupon($new_coupon);
                    $new_coupon = $this->coupons->get_coupon($new_coupon->id);
                    $this->design->assign('message_success', 'added');

                }
            }
        }
        
        $filter = array();
        $filter['page'] = max(1, $this->request->get('page', 'integer'));
        $filter['limit'] = 20;
        
        // Поиск
        $keyword = $this->request->get('keyword', 'string');
        if(!empty($keyword)) {
            $filter['keyword'] = $keyword;
            $this->design->assign('keyword', $keyword);
        }
        
        $coupons_count = $this->coupons->count_coupons($filter);
        
        $pages_count = ceil($coupons_count/$filter['limit']);
        $filter['page'] = min($filter['page'], $pages_count);
        $this->design->assign('coupons_count', $coupons_count);
        $this->design->assign('pages_count', $pages_count);
        $this->design->assign('current_page', $filter['page']);
        
        
        $coupons = $this->coupons->get_coupons($filter);
        
        $this->design->assign('coupons', $coupons);
        return $this->design->fetch('coupons.tpl');
    }
    
}
