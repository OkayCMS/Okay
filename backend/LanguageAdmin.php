<?php

require_once('api/Okay.php');

class LanguageAdmin extends Okay {
    
    public function fetch() {
        $lang_list = $this->languages->lang_list();
        $language = new stdClass();
        if($this->request->method('post')) {
            $lang = $lang_list[$this->request->post('lang')];
            
            $language->id      = $this->request->post('id', 'intgeger');
            $language->name    = $lang->name;
            $language->label   = $lang->label;
            $language->enabled = $this->request->post('enabled', 'boolean');
            
            /*
            $language->name  = $this->request->post('name');
            $language->label = trim($this->request->post('label'));
            */
            
            $this->db->query("SELECT * FROM __languages WHERE label=? LIMIT 1", $language->label);
            $exist_label = $this->db->result();
            
            if(!$language->label) {
                $this->design->assign('message_error', 'label_empty');
            } elseif($exist_label && $exist_label->id!=$language->id) {
                $this->design->assign('message_error', 'label_exists');
            } else {
                if(empty($language->id)) {
                    $language->id = $this->languages->add_language($language);
                    $this->design->assign('message_success', 'added');
                } else {
                    $this->languages->update_language($language->id, $language);
                    $this->design->assign('message_success', 'updated');
                }
            }
        } else {
            $language->id = $this->request->get('id', 'integer');
            if(!empty($language->id)) {
                $language = $this->languages->get_language($language->id);
            }
        }
        
        $this->design->assign('lang_list', $lang_list);
        
        $this->design->assign('language', $language);
        return $this->design->fetch('language.tpl');
    }
    
}
