<?php

require_once('api/Okay.php');

class TranslationsAdmin extends Okay {
    
    public function fetch() {

        $admin_theme = $this->settings->admin_theme;
        if ($admin_theme) {
            $locked_theme = is_file('design/' . $admin_theme . '/locked');
        } else {
            $locked_theme = is_file('design/' . $this->settings->theme . '/locked');
        }
        $this->design->assign('locked_theme', $locked_theme);

        // Обработка действий
        if(!$locked_theme && $this->request->method('post')) {
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
