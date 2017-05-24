<?php

require_once('View.php');

class LoginView extends View {
    
    public function fetch() {
        // Выход
        if($this->request->get('action') == 'logout') {
            unset($_SESSION['user_id']);
            header('Location: '.$this->config->root_url.'/'.$this->lang_link);
            exit();
        }
        // Вспомнить пароль
        elseif($this->request->get('action') == 'password_remind') {
            // Если запостили email
            if($this->request->method('post') && $this->request->post('email')) {
                $email = $this->request->post('email');
                $this->design->assign('email', $email);
                
                // Выбираем пользователя из базы
                $user = $this->users->get_user($email);
                if(!empty($user)) {
                    // Генерируем секретный код и запишем в базу с датой до которой он будет активен (+5 минут от текущей)
                    $code = md5(uniqid($this->config->salt, true));
                    $this->users->update_user($user->id, array('remind_code'=>$code, 'remind_expire'=>date('Y-m-d H:i:s', time()+300)));

                    // Отправляем письмо пользователю для восстановления пароля
                    $this->notify->email_password_remind($user->id, $code);
                    $this->design->assign('email_sent', true);
                } else {
                    $this->design->assign('error', 'user_not_found');
                }
            }
            // Если к нам перешли по ссылке для восстановления пароля
            elseif($this->request->get('code')) {
                $this->db->query("update __users set remind_code=null, remind_expire=null where remind_expire<?", date('Y-m-d H:i:s'));
                // Выбераем пользователя из базы
                $this->db->query("select id from __users where remind_code=? limit 1", $this->request->get('code'));
                $user = $this->db->result();
                if(empty($user)) {
                    return false;
                }

                $this->users->update_user($user->id, array('remind_code'=>null, 'remind_expire'=>null));
                
                // Залогиниваемся под пользователем и переходим в кабинет для изменения пароля
                $_SESSION['user_id'] = $user->id;
                header('Location: '.$this->config->root_url.'/'.$this->lang_link.'user');
            }
            return $this->design->fetch('password_remind.tpl');
        }
        // Вход
        elseif($this->request->method('post') && $this->request->post('login')) {
            $email           = $this->request->post('email');
            $password        = $this->request->post('password');
            
            $this->design->assign('email', $email);
            
            if($user_id = $this->users->check_password($email, $password)) {
                $user = $this->users->get_user($email);
                $_SESSION['user_id'] = $user_id;
                $this->users->update_user($user_id, array('last_ip'=>$_SERVER['REMOTE_ADDR']));

                // Перенаправляем пользователя в личный кабинет
                header('Location: '.$this->config->root_url.'/'.$this->lang_link.'user');
            } else {
                $this->design->assign('error', 'login_incorrect');
            }
        }
        return $this->design->fetch('login.tpl');
    }
    
}
