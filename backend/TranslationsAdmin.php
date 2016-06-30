<?php

require_once('api/Okay.php');

class TranslationsAdmin extends Okay {
    
    public function fetch() {
        // Обработка действий
        if($this->request->method('post')) {
            // Действия с выбранными
            $ids = $this->request->post('check');
            if(is_array($ids)) {
                switch($this->request->post('action')) {
                    case 'delete': {
                        foreach($ids as $id) {
                            $this->languages->delete_translation($id);
                        }
                        break;
                    }
                }
            }
        }

        $filter = array();
        $filter['lang'] = $this->design->get_var('lang_label');
        $filter['sort'] = $this->request->get('sort', 'string');
        $this->design->assign('sort', $filter['sort']);

        $translations = $this->languages->get_translations($filter);
        $this->design->assign('translations', $translations);
        return $this->design->fetch('translations.tpl');
    }
    
}
