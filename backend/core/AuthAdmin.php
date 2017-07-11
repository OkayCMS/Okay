<?php

require_once('api/Okay.php');

class AuthAdmin extends Okay {

    public function fetch() {
        /*Восстановление пароля администратора*/
        $recovery_email = $this->request->get('recovery_email');
        if($this->request->get("ajax_recovery") && !empty($recovery_email)){
            if($recovery_email == $this->settings->admin_email){
                $code = $this->config->token(mt_rand(1, mt_getrandmax()) . mt_rand(1, mt_getrandmax()) . mt_rand(1, mt_getrandmax()));
                $_SESSION['admin_password_recovery_code'] = $code;
                $this->notify->password_recovery_admin($this->settings->admin_email, $code);
                $result = new stdClass();
                $result->send = true;
                print json_encode($result);
                die;
            }
        }

        if(isset($_SESSION['admin_password_recovery_code']) && $_SESSION['admin_password_recovery_code'] == $this->request->get('code')){
            $this->design->assign("recovery_mod",true);
            if($this->request->method('post')){
                $new_login = $this->request->post('new_login');
                $new_password = $this->request->post('new_password');
                $new_password_check = $this->request->post('new_password_check');

                if($new_password == $new_password_check) {
                    $manager = $this->managers->get_manager($new_login);
                    if (!$this->managers->update_manager($manager->id, array('password' => $new_password, 'cnt_try' => 0, 'last_try' => null))) {
                        $this->managers->add_manager(array('login' => $new_login, 'password' => $new_password));
                        $manager = $this->managers->get_manager($new_login);
                    }
                    unset($_SESSION['admin_password_recovery_code']);
                    $_SESSION['admin'] = $manager->login;
                    header('location: '.$this->config->root_url.'/backend/index.php');
                }
            }

        } elseif ($this->request->method('post')) {
            /*Авторизация в админ.панель*/
            $login = $this->request->post('login');
            $pass = $this->request->post('password');
            $manager = $this->managers->get_manager((string)$login);


            if ($manager) {
                /*Подсчитываем количество неправильны попыток входа*/
                $limit = 10;
                $now = date('Y-m-d');
                $last = (isset($manager->last_try) ? $manager->last_try : $now);
                if ($last != $now) {
                    $last = $now;
                    $manager->cnt_try = 1;
                } else {
                    $manager->cnt_try++;
                }

                if ($manager->cnt_try > $limit) {
                    $this->design->assign('error_message', 'limit_try');
                } elseif ($this->managers->check_password($pass, $manager->password)) {
                    /*Входим в админку*/
                    $_SESSION['admin'] = $manager->login;
                    $this->managers->update_manager((int)$manager->id, array('cnt_try'=>0, 'last_try'=>null));
                    $url = $_SESSION['before_auth_url'];
                    unset($_SESSION['before_auth_url']);
                    header('location: ' . ($url ? $url : $this->config->root_url . '/backend/index.php'));
                    exit();
                } else {
                    /*неверный пароль менеджера*/
                    $this->design->assign('login', $login);
                    $this->design->assign('error_message', 'auth_wrong');
                    $this->design->assign('limit_cnt', $limit-$manager->cnt_try);
                    $this->managers->update_manager((int)$manager->id, array('cnt_try'=>$manager->cnt_try, 'last_try'=>$last));
                }
            } else {
                /*менеджер не найден*/
                $this->design->assign('login', $login);
                $this->design->assign('error_message', 'auth_wrong');
            }
        }
        return $this->design->fetch('auth.tpl');
    }

}
