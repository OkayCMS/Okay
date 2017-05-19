<?php

require_once('api/Okay.php');

class SettingsNotifyAdmin extends Okay {

    public function fetch() {
        if($this->request->method('POST')) {
            $this->settings->order_email = $this->request->post('order_email');
            $this->settings->comment_email = $this->request->post('comment_email');
            $this->settings->notify_from_email = $this->request->post('notify_from_email');
            $this->settings->notify_from_name = $this->request->post('notify_from_name');
            $this->settings->email_lang = $this->request->post('email_lang');
            $this->design->assign('message_success', 'saved');
        }
        $btr_languages = array();
        foreach ($this->languages->lang_list() as $label=>$l) {
            if (file_exists("backend/lang/".$label.".php")) {
                $btr_languages[$l->name] = $l->label;
            }
        }
        $this->design->assign('btr_languages', $btr_languages);

        return $this->design->fetch('settings_notify.tpl');
    }
}
