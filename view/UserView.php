<?php

require_once('View.php');

class UserView extends View {

    /*Отображение личного кабинета пользователя*/
    public function fetch() {
        if(empty($this->user)) {
            header('Location: '.$this->config->root_url.'/'.$this->lang_link.'user/login');
            exit();
        }

        /*Обновление данных клиеньа*/
        if($this->request->method('post') && $this->request->post('user_save')) {
            $user = new stdClass();
            $user->name       = $this->request->post('name');
            $user->email      = $this->request->post('email');
            $user->phone      = $this->request->post('phone');
            $user->address    = $this->request->post('address');
            $password         = $this->request->post('password');
            
            $this->design->assign('name', $user->name);
            $this->design->assign('email', $user->email);
            $this->design->assign('phone', $user->phone);
            $this->design->assign('address', $user->address);
            
            $this->db->query('SELECT count(*) as count FROM __users WHERE email=? AND id!=?', $user->email, $this->user->id);
            $user_exists = $this->db->result('count');

            /*Валидация данных*/
            if($user_exists) {
                $this->design->assign('error', 'user_exists');
            } elseif(!$this->validate->is_name($user->name, true)) {
                $this->design->assign('error', 'empty_name');
            } elseif(!$this->validate->is_email($user->email, true)) {
                $this->design->assign('error', 'empty_email');
            } elseif(!$this->validate->is_phone($user->phone)) {
                $this->design->assign('error', 'empty_phone');
            } elseif(!$this->validate->is_address($user->address)) {
                $this->design->assign('error', 'empty_address');
            } elseif($user_id = $this->users->update_user($this->user->id, $user)) {
                $this->user = $this->users->get_user(intval($user_id));
                $this->design->assign('user', $this->user);
            } else {
                $this->design->assign('error', 'unknown error');
            }
            
            if(!empty($password)) {
                $this->users->update_user($this->user->id, array('password'=>$password));
            }
        } else {
            // Передаем в шаблон
            $this->design->assign('name', $this->user->name);
            $this->design->assign('email', $this->user->email);
            $this->design->assign('phone', $this->user->phone);
            $this->design->assign('address', $this->user->address);
        }

        /*Выборка истории заказов клиента*/
        $orders = $this->orders->get_orders(array('user_id'=>$this->user->id));
        $all_status = $this->orderstatus->get_status();
        if($all_status) {
            $orders_status = array();
            foreach ($all_status as $status_item) {
                $orders_status[$status_item->id] = $status_item;
            }
        }
        $this->design->assign('orders_status', $orders_status);
        $this->design->assign('orders', $orders);
        
        $this->design->assign('meta_title', $this->user->name);
        $body = $this->design->fetch('user.tpl');
        
        return $body;
    }
    
}
