<?php

require_once('api/Okay.php');

class SettingsGeneralAdmin extends Okay {

    private $allow_img = array('png','gif','jpg','jpeg');
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
            $this->settings->captcha_callback = $this->request->post('captcha_callback', 'boolean');
            $this->settings->public_recaptcha = $this->request->post('public_recaptcha');
            $this->settings->secret_recaptcha = $this->request->post('secret_recaptcha');
            $this->settings->public_recaptcha_invisible = $this->request->post('public_recaptcha_invisible');
            $this->settings->secret_recaptcha_invisible = $this->request->post('secret_recaptcha_invisible');
            $this->settings->captcha_type = $this->request->post('captcha_type');
            $this->settings->iframe_map_code = $this->request->post('iframe_map_code');
            $this->settings->gather_enabled = $this->request->post('gather_enabled', 'boolean');
            $this->settings->public_recaptcha_v3 = $this->request->post('public_recaptcha_v3');
            $this->settings->secret_recaptcha_v3 = $this->request->post('secret_recaptcha_v3');

            if ($recaptcha_scores = $this->request->post('recaptcha_scores')) {
                foreach ($recaptcha_scores as $k=>$score) {
                    $score = (float)str_replace(',', '.', $score);
                    $recaptcha_scores[$k] = round($score, 1);
                }
            }
            $this->settings->recaptcha_scores = $recaptcha_scores;
            
            if(is_null($this->request->post('site_logo'))) {
               if(file_exists($this->config->root_dir .'/design/'. $this->settings->theme . '/images/'.$this->settings->site_logo)) {
                   @unlink($this->config->root_dir .'/design/'. $this->settings->theme . '/images/'.$this->settings->site_logo);
                   $this->settings->site_logo = '';
               }
            } else {
                $this->settings->site_logo = $this->request->post('site_logo');
            }
            
            if(!empty($_FILES['site_logo']['tmp_name']) && !empty($_FILES['site_logo']['name'])) {
                $tmp_name = $_FILES['site_logo']['tmp_name'];
                $site_logo_name = $_FILES['site_logo']['name'];
                $ext = pathinfo($site_logo_name,PATHINFO_EXTENSION);
                if(in_array($ext,$this->allow_img)) {
                    if(move_uploaded_file($tmp_name, $this->config->root_dir .'/design/'. $this->settings->theme . '/images/' . $site_logo_name)) {
                        $this->settings->site_logo = $site_logo_name;
                    }
                } else {
                    $this->design->assign('message_error', 'wrong_ext');
                }
            }
            $this->design->assign('message_success', 'saved');
        }
        $this->design->assign('allow_ext', $this->allow_img);

        return $this->design->fetch('settings_general.tpl');
    }

}
