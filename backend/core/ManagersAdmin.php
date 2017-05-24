<?php

require_once('api/Okay.php');

class ManagersAdmin extends Okay {
    
    public function fetch() {
        if($this->request->method('post')) {
            // Действия с выбранными
            $ids = $this->request->post('check');
            if(is_array($ids)) {
                switch($this->request->post('action')) {
                    case 'delete': {
                        /*Удалить менеджера*/
                        foreach($ids as $id) {
                            $this->managers->delete_manager($id);
                        }
                        break;
                    }
                }
            }
        }
        
        $managers = $this->managers->get_managers();
        $managers_count = $this->managers->count_managers();
        $this->design->assign('managers', $managers);
        $this->design->assign('managers_count', $managers_count);
        return $this->body = $this->design->fetch('managers.tpl');
    }
    
}
