<?php

require_once('api/Okay.php');

class SettingsCounterAdmin extends Okay {

    /*Настройки счетчиков*/
    public function fetch() {
        if($this->request->method('POST')) {
            $this->settings->g_analytics = $this->request->post('g_analytics');
            $this->settings->g_webmaster = $this->request->post('g_webmaster');
            $this->settings->y_webmaster = $this->request->post('y_webmaster');
            $this->settings->yandex_metrika_counter_id = $this->request->post('yandex_metrika_counter_id');
            $this->settings->head_custom_script = $this->request->post('head_custom_script');
            $this->settings->body_custom_script = $this->request->post('body_custom_script');
            $this->design->assign('message_success', 'saved');
        }

        return $this->design->fetch('settings_counter.tpl');
    }

}
