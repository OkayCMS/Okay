<?php

class Recaptcha extends Okay {

    private $secret_key;
    private $url = 'https://www.google.com/recaptcha/api/siteverify';
    private $response;

    public function __construct() {
        
        switch ($this->settings->captcha_type) {
            case 'invisible':
                $this->secret_key = $this->settings->secret_recaptcha_invisible;
                break;
            case 'v2':
                $this->secret_key = $this->settings->secret_recaptcha;
                break;
            case 'v3':
                $this->secret_key = $this->settings->secret_recaptcha_v3;
                break;
        }
    }

    public function check() {
        
        $this->request();
        
        // В случае инвалидных ключей пропускаем пользователя
        if (isset($this->response['error-codes']) && reset($this->response['error-codes']) == 'invalid-input-secret') {
            return true; // TODO add to events list
        }
        
        if ($this->response['success'] == false) {
            return false;
        }
        
        // Для третей версии нужно дополнительно определить можно ли пропускать с таким уровнем "человечности"
        if ($this->settings->captcha_type == 'v3') {
            return $this->calc_is_human_v3();
        }
        
        return true;
    }
    
    private function calc_is_human_v3() {
        
        $action = $this->response['action'];
        $score = (float)$this->response['score'];
        switch ($action) {
            case 'cart':
                $min_score = (float)$this->settings->recaptcha_scores['cart'];
                break;
            case 'product':
                $min_score = (float)$this->settings->recaptcha_scores['product'];
                break;
            default:
                $min_score = (float)$this->settings->recaptcha_scores['other'];
        }

        return $min_score <= $score;
    }
    
    private function request() {
        $curl = curl_init($this->url);

        $params = http_build_query(array(
            'secret'   => $this->secret_key,
            'response' => $this->get_response_key(),
            'remoteip' => $_SERVER['REMOTE_ADDR']
        ));

        curl_setopt($curl, CURLOPT_POST, true);
        curl_setopt($curl, CURLOPT_POSTFIELDS, $params);
        curl_setopt($curl, CURLOPT_FOLLOWLOCATION, true);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
        $response = curl_exec($curl);
        curl_close($curl);
        
        $this->response = json_decode($response, true);
    }

    private function get_response_key() {
        if ($this->settings->captcha_type == 'v2' || $this->settings->captcha_type == 'invisible'){
            return $this->request->post('g-recaptcha-response');
        } elseif ($this->settings->captcha_type == 'v3'){
            return $this->request->post('recaptcha_token');
        }
    }
    
}
