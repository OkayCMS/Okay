<?php

require_once('api/Okay.php');

class CallbacksAdmin extends Okay {
    
    public function fetch() {
        // Обработка действий
        if($this->request->method('post')) {
            // Действия с выбранными
            $ids = $this->request->post('check');
            if(!empty($ids)) {
                switch($this->request->post('action')) {
                    case 'delete': {
                        foreach($ids as $id) {
                            $this->callbacks->delete_callback($id);
                        }
                        break;
                    }
                    case 'processed': {
                        foreach ($ids as $id) {
                            $this->callbacks->update_callback($id, array('processed'=>1));
                        }
                        break;
                    }
                }
            }
        }
        
        // Отображение
        $filter = array();
        $filter['page'] = max(1, $this->request->get('page', 'integer'));
        $filter['limit'] = 40;
        
        
        //$callbacks_count = $this->callbacks->count_callbacks($filter);
        // Показать все страницы сразу
        if($this->request->get('page') == 'all') {
            $filter['limit'] = $callbacks_count;
        }
        
        $callbacks = $this->callbacks->get_callbacks($filter, true);
        
        $this->design->assign('pages_count', ceil($callbacks_count/$filter['limit']));
        $this->design->assign('current_page', $filter['page']);
        
        $this->design->assign('callbacks', $callbacks);
        $this->design->assign('callbacks_count', $callbacks_count);
        
        return $this->design->fetch('callbacks.tpl');
    }
    
}

?>