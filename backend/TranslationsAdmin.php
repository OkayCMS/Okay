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
        
        /*
        $languages    = $this->languages->get_languages();
        $translations = $this->languages->get_translations();
        
        if($translations) {
            foreach($translations as $t) {
                foreach($languages as $l) {
                    $lang[$l->label] = $t->
                }
            }
        }
        */
        
        $debug='';
        if($debug){
            print '<div style="background-color: #FFFFCC; position: absolute; z-index: 99" align="left"><pre>';
            print_r($category);
            print '</pre></div><br />';
        }
        
        $translations = $this->languages->get_translations();
        $this->design->assign('translations', $translations);
        return $this->design->fetch('translations.tpl');
    }
    
}
