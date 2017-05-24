<?php

require_once('api/Okay.php');

class TranslationAdmin extends Okay {

    /*Работа с переводом*/
    public function fetch() {
        $languages = $this->languages->get_languages();
        
        $translation = new stdClass();
        if($this->request->method('post')) {
            // id - предыдущий label
            $translation->id    = $this->request->post('id');
            $translation->label = trim($this->request->post('label'));
            $translation->label = str_replace(" ", '_', $translation->label);
            
            if($languages){
                foreach($languages as $lang) {
                    $field = 'lang_'.$lang->label;
                    $translation->$field = $this->request->post($field);
                }
            }
            $exist = $this->translations->get_translation($translation->label);
            
            $okay_object = $this->{$translation->label};
            if(!$translation->label) {
                $this->design->assign('message_error', 'label_empty');
            } elseif($exist && $exist->id!=$translation->id) {
                $this->design->assign('message_error', 'label_exists');
            } elseif(!empty($okay_object)) {
                $this->design->assign('message_error', 'label_is_class');
            } else {
                /*Добавление/Удаление перевода*/
                if(empty($translation->id)) {
                    $this->design->assign('message_success', 'added');
                } else {
                    $this->design->assign('message_success', 'updated');
                }
                $translation->id = $this->translations->update_translation($translation->id, $translation);
            }
        } else {
            $translation->id = $this->request->get('id');
            if(!empty($translation->id)) {
                $translation = $this->translations->get_translation($translation->id);
            }
        }
        
        $this->design->assign('languages', $languages);
        
        $this->design->assign('translation', $translation);
        return $this->design->fetch('translation.tpl');
    }
    
}
