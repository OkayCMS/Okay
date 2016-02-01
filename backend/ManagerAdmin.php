<?php

require_once('api/Okay.php');

class ManagerAdmin extends Okay {
    
    public function fetch() {
        $manager = new stdClass();
        if($this->request->method('post')) {
            $manager->id = $this->request->post('id', 'integer');
            if ($this->request->post('unlock_manager')) {
                $this->managers->update_manager($manager->id, array('cnt_try'=>0));
                $id = $this->request->get('id', 'integer');
                if(!empty($id)) {
                    $manager = $this->managers->get_manager($id);
                }
            } else {
                $manager->login = $this->request->post('login');

                if(empty($manager->login)) {
                    $this->design->assign('message_error', 'empty_login');
                } elseif(($m = $this->managers->get_manager($manager->login)) && $m->id!=$manager->id) {
                    $manager->permissions = (array)$this->request->post('permissions');
                    $this->design->assign('message_error', 'login_exists');
                } else {
                    if($this->request->post('password') != "") {
                        $manager->password = $this->request->post('password');
                    }

                    // Обновляем права только другим менеджерам
                    $current_manager = $this->managers->get_manager();
                    if($manager->id != $current_manager->id) {
                        $manager->permissions = (array)$this->request->post('permissions');
                    }

                    if(empty($manager->id)) {
                        $manager->id = $this->managers->add_manager($manager);
                        $this->design->assign('message_success', 'added');
                    } else {
                        $this->managers->update_manager($manager->id, $manager);
                        $this->design->assign('message_success', 'updated');
                    }
                    $manager = $this->managers->get_manager($manager->login);
                }
            }
        } else {
            $id = $this->request->get('id', 'integer');
            if(!empty($id)) {
                $manager = $this->managers->get_manager($id);
            }
        }

        $this->design->assign('m', $manager);
        
        return $this->design->fetch('manager.tpl');
    }
    
}
