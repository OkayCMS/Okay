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

        if ($filter['limit'] = $this->request->get('limit', 'integer')) {
            $filter['limit'] = max(5, $filter['limit']);
            $filter['limit'] = min(100, $filter['limit']);
            $_SESSION['callback_num_admin'] = $filter['limit'];
        } elseif (!empty($_SESSION['callback_num_admin'])) {
            $filter['limit'] = $_SESSION['callback_num_admin'];
        } else {
            $filter['limit'] = 25;
        }
        $this->design->assign('current_limit', $filter['limit']);
        
        // Сортировка по статусу
        $status = $this->request->get('status', 'string');
        if($status == 'processed') {
            $filter['processed'] = 1;
        } elseif ($status == 'unprocessed') {
            $filter['processed'] = 0;
        }
        $this->design->assign('status', $status);

        // Поиск
        $keyword = $this->request->get('keyword');
        if(!empty($keyword)) {
            $filter['keyword'] = $keyword;
            $this->design->assign('keyword', $keyword);
        }
        
        $callbacks_count = $this->callbacks->count_callbacks($filter);
        // Показать все страницы сразу
        if($this->request->get('page') == 'all') {
            $filter['limit'] = $callbacks_count;
        }
        /*Выборка заявок на обратный звонок*/
        $callbacks = $this->callbacks->get_callbacks($filter);

        $this->design->assign('pages_count', ceil($callbacks_count/$filter['limit']));
        $this->design->assign('current_page', $filter['page']);

        $this->design->assign('callbacks', $callbacks);
        $this->design->assign('callbacks_count', $callbacks_count);
        
        return $this->design->fetch('callbacks.tpl');
    }
    
}
