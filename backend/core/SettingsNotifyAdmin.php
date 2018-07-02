<?php

require_once('api/Okay.php');

class SettingsNotifyAdmin extends Okay {

    /*Настройки уведомлений*/
    public function fetch() {
        if($this->request->method('POST')) {
            $this->settings->order_email = $this->request->post('order_email');
            $this->settings->comment_email = $this->request->post('comment_email');
            $this->settings->notify_from_email = $this->request->post('notify_from_email');
            $this->settings->update('notify_from_name', $this->request->post('notify_from_name'));
            $this->settings->email_lang = $this->request->post('email_lang');
            $this->settings->auto_approved = $this->request->post('auto_approved');

            $this->settings->use_smtp = $this->request->post('use_smtp');
            $this->settings->smtp_server = $this->request->post('smtp_server');
            $this->settings->smtp_port = $this->request->post('smtp_port');
            $this->settings->smtp_user = $this->request->post('smtp_user');
            $this->settings->smtp_pass = $this->request->post('smtp_pass');
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
