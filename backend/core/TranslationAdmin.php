<?php

require_once('api/Okay.php');

class TranslationAdmin extends Okay {

    /*Работа с переводом*/
    public function fetch() {
        $languages = $this->languages->get_languages();

        $admin_theme = $this->settings->admin_theme;
        if ($admin_theme) {
            $locked_theme = is_file('design/' . $admin_theme . '/locked');
        } else {
            $locked_theme = is_file('design/' . $this->settings->theme . '/locked');
        }
        $this->design->assign('locked_theme', $locked_theme);

        $translation = new stdClass();
        if(!$locked_theme && $this->request->method('post')) {
            // id - предыдущий label
            $translation->id    = $this->request->post('id');
            $translation->label = trim($this->request->post('label'));
            $translation->label = str_replace(" ", '_', $translation->label);
            $translation->label = preg_replace("/[^a-z0-9\-_]/i", "", $translation->label);
            
            if($languages){
                foreach($languages as $lang) {
                    $field = 'lang_'.$lang->label;
                    $translation->$field = $this->request->post($field);
                    $translation->values[$lang->id] = $translation->$field;
                }
            }
            $exist = $this->translations->get_translation($translation->label, true);
            
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
        }

        if(!empty($translation->id)) {
            $translation = $this->translations->get_translation($translation->id);
        }
        
        $this->design->assign('languages', $languages);
        
        $this->design->assign('translation', $translation);
        return $this->design->fetch('translation.tpl');
    }
    
}
