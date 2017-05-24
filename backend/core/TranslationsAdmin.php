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
                        /*Удалить перевод*/
                        foreach($ids as $id) {
                            $this->translations->delete_translation($id);
                        }
                        break;
                    }
                }
            }
        }
        $language = $this->languages->get_language($this->languages->lang_id());

        $filter = array();
        $filter['lang'] = $language->label;
        $filter['sort'] = $this->request->get('sort', 'string');
        if (empty($filter['sort'])) {
            $filter['sort'] = 'label';
        }
        $this->design->assign('sort', $filter['sort']);

        $translations = $this->translations->get_translations($filter);
        $this->design->assign('translations', $translations);
        return $this->design->fetch('translations.tpl');
    }
    
}
