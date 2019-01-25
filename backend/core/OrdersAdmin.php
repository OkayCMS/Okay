<?php

require_once('api/Okay.php');

class OrdersAdmin extends Okay {
    
    public function fetch() {
        $filter = array();
        $filter['page'] = max(1, $this->request->get('page', 'integer'));
        
        $filter['limit'] = 40;
        
        // Поиск
        $keyword = $this->request->get('keyword');
        if(!empty($keyword)) {
            $filter['keyword'] = $keyword;
            $this->design->assign('keyword', $keyword);
        }
        
        // Фильтр по метке
        $label = $this->orderlabels->get_label($this->request->get('label'));
        if(!empty($label)) {
            $filter['label'] = $label->id;
            $this->design->assign('label', $label);
        }

        $all_status = $this->orderstatus->get_status();
        if($all_status) {
            $orders_status = array();
            foreach ($all_status as $status_item) {
                $orders_status[$status_item->id] = $status_item;
            }
        }

        // Обработка действий

        if($this->request->method('post')) {
            // Действия с выбранными
            $ids = $this->request->post('check');
            if(is_array($ids)) {
                switch($this->request->post('action')) {
                    case 'delete': {
                        /*Удалить заказ*/
                        foreach($ids as $id) {
                                $this->orders->delete_order(intval($id));
                            }
                        break;
                    }
                    case 'change_status': {
                        /*Смена статуса заказа*/
                        if($this->request->post("change_status_id")) {
                            $new_status = $this->orderstatus->get_status(array("status"=>$this->request->post("change_status_id","integer")));
                            $error_orders = array();
                            foreach($ids as $id) {
                                if($new_status[0]->is_close == 1){
                                    if(!$this->orders->close(intval($id))) {
                                        $error_orders[] = $id;
                                        $this->design->assign('error_orders', $error_orders);
                                        $this->design->assign('message_error', 'error_closing');
                                    } else {
                                        $this->orders->update_order($id, array('status_id'=>$this->request->post("change_status_id","integer")));
                                    }
                                } else {
                                    if($this->orders->open(intval($id))) {
                                        $this->orders->update_order($id, array('status_id'=>$this->request->post("change_status_id","integer")));
                                    }
                                }

                            }
                        }
                        break;
                    }
                    case 'set_label': {
                        /*Добавить метку к заказу*/
                        if($this->request->post("change_label_id")) {
                            foreach($ids as $id) {
                                $this->orderlabels->add_order_labels($id, $this->request->post("change_label_id","integer"));
                            }
                        }
                        break;
                    }
                    case 'unset_label': {
                        /*Удалить метку из заказа*/
                        if($this->request->post("change_label_id")) {
                            foreach($ids as $id) {
                                $this->orderlabels->delete_order_labels($id, $this->request->post("change_label_id","integer"));
                            }
                        }
                        break;
                    }
                }
            }
        }
        
        if(empty($keyword)) {
            if($this->request->get('status')) {
                $status = $this->request->get('status', 'integer');
            } else {
                $status = 0;
            }

            $filter['status'] = $status;
            $this->design->assign('status', $status);
        }

        //Поиск до дате заказа
        $from_date = $this->request->get('from_date');
        $to_date = $this->request->get('to_date');
        if(!empty($from_date) || !empty($to_date)){
            $filter['from_date'] = $from_date;
            $filter['to_date'] = $to_date;
            $this->design->assign('from_date', $from_date);
            $this->design->assign('to_date', $to_date);
        }
        
        $orders_count = $this->orders->count_orders($filter);
        // Показать все страницы сразу
        if($this->request->get('page') == 'all') {
            $filter['limit'] = $orders_count;
        }

        // Отображение
        $orders = array();
        foreach($this->orders->get_orders($filter) as $o) {
            $orders[$o->id] = $o;
            $orders[$o->id]->purchases = $this->orders->get_purchases(array('order_id'=>$o->id));
        }
        // Метки заказов
        $orders_labels = array();
        $orders_labels = $this->orderlabels->get_order_labels(array_keys($orders));
        if($orders_labels){
            foreach ($orders_labels as $orders_label) {
                $orders[$orders_label->order_id]->labels[] = $orders_label;
                $orders[$orders_label->order_id]->labels_ids[] = $orders_label->id;
            }
        }

        $this->design->assign('pages_count', ceil($orders_count/$filter['limit']));
        $this->design->assign('current_page', $filter['page']);
        
        $this->design->assign('orders_count', $orders_count);
        
        $this->design->assign('orders', $orders);
        $this->design->assign('all_status', $all_status);
        $this->design->assign('orders_status', $orders_status);
        
        // Метки заказов
        $labels = $this->orderlabels->get_labels();
        $this->design->assign('labels', $labels);
        
        return $this->design->fetch('orders.tpl');
    }
    
}
