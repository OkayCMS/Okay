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
                        /*Удаление заявок на обратный звонок*/
                        foreach($ids as $id) {
                            $this->callbacks->delete_callback($id);
                        }
                        break;
                    }
                    case 'processed': {
                        /*Модерация заявок на обратный звонок*/
                        foreach ($ids as $id) {
                            $this->callbacks->update_callback($id, array('processed'=>1));
                        }
                        break;
                    }
                    case 'unprocessed': {
                        /*Модерация заявок на обратный звонок*/
                        foreach ($ids as $id) {
                            $this->callbacks->update_callback($id, array('processed'=>0));
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
        
        
        $callbacks_count = $this->callbacks->count_callbacks();
        // Показать все страницы сразу
        if($this->request->get('page') == 'all') {
            $filter['limit'] = $callbacks_count;
        }
        /*Выборка заявок на обратный звонок*/
        $callbacks = $this->callbacks->get_callbacks($filter, true);

        $this->design->assign('pages_count', ceil($callbacks_count/$filter['limit']));
        $this->design->assign('current_page', $filter['page']);

        $this->design->assign('callbacks', $callbacks);
        $this->design->assign('callbacks_count', $callbacks_count);
        
        return $this->design->fetch('callbacks.tpl');
    }
    
}

?>