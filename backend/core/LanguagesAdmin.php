<?php

require_once('api/Okay.php');

class LanguagesAdmin extends Okay {
    
    public function fetch() {
        // Обработка действий
        if($this->request->method('post')) {
            // Действия с выбранными
            $ids = $this->request->post('check');
            if(is_array($ids)) {
                switch($this->request->post('action')) {
                    case 'delete': {
                        /*Удаление языка*/
                        $languages = $this->languages->get_languages();
                        if (count($languages) == count($ids)) {
                            $first = $this->languages->get_first_language();
                        }
                        foreach($ids as $id) {
                            $this->languages->delete_language($id, (isset($first) && $id == $first->id));
                        }
                        break;
                    }
                    case 'disable': {
                        /*Выключение языка*/
                        $this->languages->update_language($ids, array('enabled'=>0));
                        break;
                    }
                    case 'enable': {
                        /*Включение языка*/
                        $this->languages->update_language($ids, array('enabled'=>1));
                        break;
                    }
                }
            }
            
            // Сортировка
            $positions = $this->request->post('positions');
            foreach($positions as $position=>$id) {
                $this->languages->update_language($id, array('position'=>$position+1));
            }
        }
        
        $languages = $this->languages->get_languages();
        $this->design->assign('languages', $languages);

        return $this->design->fetch('languages.tpl');
    }
    
}
