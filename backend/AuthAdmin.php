<?php

require_once('api/Okay.php');

class AuthAdmin extends Okay {

    public function fetch() {
        if ($this->request->method('post')) {
            $login = $this->request->post('login');
            $pass = $this->request->post('password');
            $manager = $this->managers->get_manager((string)$login);
            if ($manager) {
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
                    // Установим переменную сессии, чтоб сервер знал что админ авторизован.
                    $_SESSION['admin'] = $manager->login;
                    $this->managers->update_manager((int)$manager->id, array('cnt_try'=>0, 'last_try'=>null));
                    header('location: '.$this->config->root_url.'/backend/index.php');
                    exit();
                } else {
                    // не верный пароль менеджера
                    $this->design->assign('login', $login);
                    $this->design->assign('error_message', 'auth_wrong');
                    $this->design->assign('limit_cnt', $limit-$manager->cnt_try);
                    $this->managers->update_manager((int)$manager->id, array('cnt_try'=>$manager->cnt_try, 'last_try'=>$last));
                }
            } else {
                // менеджер не найден
                $this->design->assign('login', $login);
                $this->design->assign('error_message', 'auth_wrong');
            }
        }
        return $this->design->fetch('auth.tpl');
    }

}
