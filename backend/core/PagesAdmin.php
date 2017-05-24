<?php

require_once('api/Okay.php');

########################################
class PagesAdmin extends Okay {
    
    public function fetch() {
        // Меню
        $menus = $this->pages->get_menus();
        $this->design->assign('menus', $menus);
        
        // Текущее меню
        $menu_id = $this->request->get('menu_id', 'integer');
        if(!$menu_id || !$menu = $this->pages->get_menu($menu_id)) {
            $menu = reset($menus);
        }
        $this->design->assign('menu', $menu);
        
        // Обработка действий
        if($this->request->method('post')) {
            // Сортировка
            $positions = $this->request->post('positions');
            $ids = array_keys($positions);
            sort($positions);
            foreach($positions as $i=>$position) {
                $this->pages->update_page($ids[$i], array('position'=>$position));
            }
            foreach ($this->request->post("menu_id") as $page_id=>$menu_id) {
                $this->pages->update_page($page_id, array('menu_id'=>$menu_id));
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
                            $this->pages->delete_page($id);
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

?>