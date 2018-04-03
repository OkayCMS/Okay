<?php

require_once('api/Okay.php');

class LanguageAdmin extends Okay {
    
    public function fetch() {
        $languages = $this->languages->get_languages();
        $lang_list = $this->languages->lang_list();
        $language = new stdClass();
        /*Принимаем информацию о языке сайта*/
        if($this->request->method('post')) {
            $language->id      = $this->request->post('id', 'integer');
            $language->enabled = $this->request->post('enabled', 'boolean');
            if (empty($language->id)) {
                $lang = $lang_list[$this->request->post('lang')];
                $language->name    = $lang->name;
                $language->label   = $lang->label;
                $language->href_lang = $lang->href_lang;

                $this->db->query("SELECT * FROM __languages WHERE label=? LIMIT 1", $language->label);
                $exist_label = $this->db->result();

                if(!$language->label) {
                    $this->design->assign('message_error', 'label_empty');
                } elseif($exist_label && $exist_label->id!=$language->id) {
                    $this->design->assign('message_error', 'label_exists');
                } else {
                    /*Добавление/Обновление языка*/
                    $language->id = $this->languages->add_language($language);
                    $languages = $this->languages->get_languages();
                    foreach($languages as $l) {
                        $language->{'name_'.$l->label} = $language->name;
                    }
                    $this->languages->update_language($language->id, $language);
                    $this->design->assign('message_success', 'added');
                }
            } elseif (!empty($languages)) {
                foreach($languages as $l) {
                    $field = 'name_'.$l->label;
                    $language->$field = $this->request->post($field);
                }
                $this->languages->update_language($language->id, $language);
                $this->design->assign('message_success', 'updated');
            }
        } else {
            $language->id = $this->request->get('id', 'integer');
        }

        if(!empty($language->id)) {
            $language = $this->languages->get_language($language->id);
        }
        $this->design->assign('lang_list', $lang_list);
        
        $this->design->assign('language', $language);
        $this->design->assign('languages', $languages);
        return $this->design->fetch('language.tpl');
    }
    
}
