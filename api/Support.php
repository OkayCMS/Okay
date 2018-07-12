<?php

require_once('Okay.php');

class Support extends Okay {

    public function add_comment($params = array()) {
        $info = $this->supportinfo->get_info();
        if (empty($info->public_key) || empty($params)) {
            return false;
        }
        $params['key'] = $info->public_key;
        $params['action'] = 'add_comment';
        return $this->support_request($params);
    }

    public function close_topic($topic_id) {
        $info = $this->supportinfo->get_info();
        if (empty($info->public_key) || empty($topic_id)) {
            return false;
        }
        $params = array(
            'topic_id' => $topic_id,
            'key'      => $info->public_key,
            'action'   => 'close_topic'
        );
        return $this->support_request($params);
    }

    public function add_topic($params = array()) {
        $info = $this->supportinfo->get_info();
        if (empty($info->public_key) || empty($params)) {
            return false;
        }
        $params['key'] = $info->public_key;
        $params['action'] = 'add_topic';
        return $this->support_request($params);
    }

    public function get_topic($params = array('page'=>1)) {
        $info = $this->supportinfo->get_info();
        if (empty($info->public_key) || empty($params)) {
            return false;
        }
        $params['page'] = max(1, intval($params['page']));
        $params['key'] = $info->public_key;
        $params['action'] = 'get_topic';
        return $this->support_request($params);
    }

    public function get_topics($params = array('page'=>1)) {
        $info = $this->supportinfo->get_info();
        if (empty($info->public_key) || empty($params)) {
            return false;
        }
        $params['page'] = max(1, intval($params['page']));
        $params['key'] = $info->public_key;
        $params['action'] = 'get_topics';
        return $this->support_request($params);
    }

    public function get_new_keys() {
        $info = $this->supportinfo->get_info();
        $info->temp_time = strtotime($info->temp_time);
        if (!empty($info->temp_time) && $info->temp_time+300 < time()) {
            $this->supportinfo->update_info(array('temp_key'=>null, 'temp_time'=>null));
            $info->temp_key = null;
        }
        if (!empty($info->temp_key)) {
            return false;
        }
        $info->temp_time = date('Y-m-d H:i:s');
        $info->temp_key = md5(uniqid("temp_key", true));
        $this->supportinfo->update_info(array('temp_time'=>$info->temp_time, 'temp_key'=>$info->temp_key));
        $params = array(
            'action'        => 'new_keys',
            'temp_key'      => $info->temp_key,
            'version'       => $this->config->version,
            'version_type'  => (!empty($this->config->version_type) ? $this->config->version_type : null),
            'owner_email'   => $this->settings->admin_email,
            'owner_phone'   => $this->settings->admin_phone ? $this->settings->admin_phone : ''
        );
        return $this->support_request($params);
    }

    private function support_request($params = array()) {
        if (empty($params) || empty($params['action'])) {
            return false;
        }
        $info = $this->supportinfo->get_info();
        $params['domain'] = $_SERVER['HTTP_HOST'];
        $params['version'] = $this->config->version;
        $params['version_type'] = $this->config->version_type;
        openssl_public_encrypt($info->accesses, $params['accesses'], $info->public_key);
        $params['accesses'] = bin2hex($params['accesses']);
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, 'http://okay-cms.support/support/1.0/');
        curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-Type: application/json; charset=UTF-8'));
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($ch, CURLOPT_TIMEOUT, 20);
        //curl_setopt($ch, CURLOPT_HEADER, 0);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($params));
        curl_setopt($ch, CURLOPT_POST, 1);
        $response = curl_exec($ch);
        //$r = curl_getinfo($ch);
        curl_close($ch);
        $response = json_decode($response);
        if ($response && isset($response->balance) && $response->balance != $info->balance) {
            $this->supportinfo->update_info(array('balance'=>$response->balance));
        }
        return $response;
    }
}
