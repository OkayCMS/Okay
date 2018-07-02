<?php

require_once('api/Okay.php');

########################################
class PagesAdmin extends Okay {
    
    public function fetch() {
        // Обработка действий
        if($this->request->method('post')) {
            // Сортировка
            $positions = $this->request->post('positions');
            $ids = array_keys($positions);
            sort($positions);
            foreach($positions as $i=>$position) {
                $this->pages->update_page($ids[$i], array('position'=>$position));
            }

            // Действия с выбранными
            $ids = $this->request->post('check');
            if(is_array($ids)) {
                switch($this->request->post('action')) {
                    case 'disable': {
                        /*Выключить страницу*/
                        $this->pages->update_page($ids, array('visible'=>0));
                        break;
                    }
                    case 'enable': {
                        /*Включить страницу*/
                        $this->pages->update_page($ids, array('visible'=>1));
                        break;
                    }
                    case 'delete': {
                        /*Удалить страницу*/
                        foreach($ids as $id) {
                            if (!$this->pages->delete_page($id)) {
                                $this->design->assign('message_error', 'url_system');
                            }
                        }
                        break;
                    }
                }
            }
        }
        
        // Отображение
        $pages = $this->pages->get_pages();
        
        $this->design->assign('pages', $pages);
        return $this->design->fetch('pages.tpl');
    }
    
}
