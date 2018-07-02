<?php

require_once('View.php');

class RegisterView extends View {
    
    public function fetch() {
        /*Прием данных для регистрации*/
        if($this->request->method('post') && $this->request->post('register')) {
            $user = new stdClass();
            $user->last_ip  = $_SERVER['REMOTE_ADDR'];
            $user->name     = $this->request->post('name');
            $user->email    = $this->request->post('email');
            $user->phone    = $this->request->post('phone');
            $user->address  = $this->request->post('address');
            $user->password = $this->request->post('password');
            $captcha_code   = $this->request->post('captcha_code');
            
            $this->design->assign('name', $user->name);
            $this->design->assign('email', $user->email);
            $this->design->assign('phone', $user->phone);
            $this->design->assign('address', $user->address);
            
            $this->db->query('SELECT count(*) as count FROM __users WHERE email=?', $user->email);
            $user_exists = $this->db->result('count');

            /*Валидация данных клиента*/
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
            } elseif(empty($user->password)) {
                $this->design->assign('error', 'empty_password');
            } elseif($this->settings->captcha_register && !$this->validate->verify_captcha('captcha_register', $captcha_code)) {
                $this->design->assign('error', 'captcha');
            } elseif($user_id = $this->users->add_user($user)) {
                $_SESSION['user_id'] = $user_id;
                header('Location: '.$this->config->root_url.'/'.$this->lang_link.'user');
            } else {
                $this->design->assign('error', 'unknown error');
            }
        }
        return $this->design->fetch('register.tpl');
    }
    
}
