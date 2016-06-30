<?php

require_once('View.php');

class UserView extends View {
    
    public function fetch() {
        if(empty($this->user)) {
            header('Location: '.$this->config->root_url.'/'.$this->lang_link.'user/login');
            exit();
        }

        if($this->request->method('post') && $this->request->post('name')) {
            $user = new stdClass();
            $user->name	    = $this->request->post('name');
            $user->email	= $this->request->post('email');
            $user->phone    = $this->request->post('phone');
            $user->address  = $this->request->post('address');
            $password		= $this->request->post('password');
            
            $this->design->assign('name', $user->name);
            $this->design->assign('email', $user->email);
            $this->design->assign('phone', $user->phone);
            $this->design->assign('address', $user->address);
            
            $this->db->query('SELECT count(*) as count FROM __users WHERE email=? AND id!=?', $user->email, $this->user->id);
            $user_exists = $this->db->result('count');
            
            if($user_exists) {
                $this->design->assign('error', 'user_exists');
            } elseif(empty($user->name)) {
                $this->design->assign('error', 'empty_name');
            } elseif(empty($user->email)) {
                $this->design->assign('error', 'empty_email');
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
        
        $orders = $this->orders->get_orders(array('user_id'=>$this->user->id));
        $this->design->assign('orders', $orders);
        
        $this->design->assign('meta_title', $this->user->name);
        $body = $this->design->fetch('user.tpl');
        
        return $body;
    }
    
}
