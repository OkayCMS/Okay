<?php

require_once('api/Okay.php');

class UserGroupAdmin extends Okay {
    
    public function fetch() {
        $group = new stdClass;
        /*Прием данных о группе пользователей*/
        if($this->request->method('post')) {
            $group->id = $this->request->post('id', 'integer');
            $group->name = $this->request->post('name');
            $group->discount = $this->request->post('discount');
            
            if (empty($group->name)) {
                $this->design->assign('message_error', 'empty_name');
            } else {
                /*Добавление/Обновление групы пользователей*/
                if(empty($group->id)) {
                    $group->id = $this->users->add_group($group);
                    $this->design->assign('message_success', 'added');
                } else {
                    $group->id = $this->users->update_group($group->id, $group);
                    $this->design->assign('message_success', 'updated');
                }
                $group = $this->users->get_group(intval($group->id));
            }
        } else {
            $id = $this->request->get('id', 'integer');
            if(!empty($id)) {
                $group = $this->users->get_group(intval($id));
            }
        }
        
        if(!empty($group)) {
            $this->design->assign('group', $group);
        }
        
        return $this->design->fetch('user_group.tpl');
    }
    
}
