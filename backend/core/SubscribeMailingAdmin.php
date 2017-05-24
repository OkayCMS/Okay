<?php

require_once('api/Okay.php');

class SubscribeMailingAdmin extends Okay {
    
    private $export_files_dir = 'backend/files/export_users/';

    /*Отображение подписчиков сайта*/
    public function fetch() {
        /*Экспорт подписчиков*/
        if ($this->request->post('is_export')) {
            $this->design->assign('export_files_dir', $this->export_files_dir);
            $this->design->assign('sort', $this->request->get('sort'));
            $this->design->assign('keyword', $this->request->get('keyword'));
            $this->design->assign('export_files_dir', $this->export_files_dir);
            if(!is_writable($this->export_files_dir)) {
                $this->design->assign('message_error', 'no_permission');
            }
            return $this->design->fetch('export_subscribes.tpl');
        }
        if($this->request->method('post')) {
            $ids = $this->request->post('check');
            
            if(is_array($ids)) {
                switch($this->request->post('action')) {
                    case 'delete': {
                        /*Удалить подписчика*/
                        $this->subscribes->delete_subscribe($ids);
                        break;
                    }
                }
            }
        }
        
        $filter = array();
        $filter['page'] = max(1, $this->request->get('page', 'integer'));
        $filter['limit'] = 20;
        // Поиск
        $keyword = $this->request->get('keyword');
        if(!empty($keyword)) {
            $filter['keyword'] = $keyword;
            $this->design->assign('keyword', $keyword);
        }
        $subscribes_count = $this->subscribes->count_subscribes($filter);
        // Показать все страницы сразу
        if($this->request->get('page') == 'all') {
            $filter['limit'] = $subscribes_count;
        }
        
        if($filter['limit']>0) {
            $pages_count = ceil($subscribes_count/$filter['limit']);
        } else {
            $pages_count = 0;
        }
        $filter['page'] = min($filter['page'], $pages_count);
        $this->design->assign('pages_count', $pages_count);
        $this->design->assign('current_page', $filter['page']);
        
        $subscribes = $this->subscribes->get_subscribes($filter);
        
        $this->design->assign('subscribes', $subscribes);
        $this->design->assign('subscribes_count', $subscribes_count);
        return $this->body = $this->design->fetch('subscribe_mailing.tpl');
    }
    
}
