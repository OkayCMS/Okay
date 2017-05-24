<?php

require_once('api/Okay.php');

class SettingsGeneralAdmin extends Okay {

    /*Настройки сайта*/
    public function fetch() {
        if($this->request->method('POST')) {
            $this->settings->update('site_name', $this->request->post('site_name'));
            $this->settings->date_format = $this->request->post('date_format');
            $this->settings->admin_email = $this->request->post('admin_email');
            $this->settings->site_work = $this->request->post('site_work');
            $this->settings->update('site_annotation', $this->request->post('site_annotation'));
            $this->settings->captcha_product = $this->request->post('captcha_product', 'boolean');
            $this->settings->captcha_post = $this->request->post('captcha_post', 'boolean');
            $this->settings->captcha_cart = $this->request->post('captcha_cart', 'boolean');
            $this->settings->captcha_register = $this->request->post('captcha_register', 'boolean');
            $this->settings->captcha_feedback = $this->request->post('captcha_feedback', 'boolean');
            $this->design->assign('message_success', 'saved');
        }

        return $this->design->fetch('settings_general.tpl');
    }

}
