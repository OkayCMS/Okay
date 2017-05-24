<?php

require_once('api/Okay.php');

class UserGroupsAdmin extends Okay {
    
    public function fetch() {
        if($this->request->method('post')) {
            // Действия с выбранными
            $ids = $this->request->post('check');
            if(is_array($ids)) {
                switch($this->request->post('action')){
                    case 'delete': {
                        /*Удаление группы пользователей*/
                        foreach($ids as $id) {
                            $this->users->delete_group($id);
                        }
                        break;
                    }
                }
            }
        }
        
        $groups = $this->users->get_groups();
        foreach ($groups as $group){
            $group->cnt_users = $this->users->count_users(array("group_id"=>$group->id));
        }
        
        $this->design->assign('groups', $groups);
        return $this->body = $this->design->fetch('user_groups.tpl');
    }
    
}
