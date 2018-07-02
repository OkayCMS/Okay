<?php

require_once('api/Okay.php');

class MenusAdmin extends Okay {

    public function fetch() {
        /*Принимаем выбранные меню*/
        if($this->request->method('post')) {
            $ids = $this->request->post('check');
            if(is_array($ids)) {
                switch($this->request->post('action')) {
                    case 'disable': {
                        /*Выключаем меню*/
                        foreach($ids as $id) {
                            $this->menu->update_menu($id, array('visible'=>0));
                        }
                        break;
                    }
                    case 'enable': {
                        /*Включаем меню*/
                        foreach($ids as $id) {
                            $this->menu->update_menu($id, array('visible'=>1));
                        }
                        break;
                    }
                    case 'delete': {
                        /*Удаляем меню*/
                        foreach ($ids as $id) {
                            $this->menu->delete_menu($id);
                        }
                        break;
                    }
                }
            }

            // Сортировка
            $positions = $this->request->post('positions');
            $ids = array_keys($positions);
            sort($positions);
            foreach($positions as $i=>$position) {
                $this->menu->update_menu($ids[$i], array('position'=>$position));
            }
        }

        $menus = $this->menu->get_menus();
        $this->design->assign('menus', $menus);
        return $this->design->fetch('menus.tpl');
    }

}
