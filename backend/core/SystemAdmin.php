<?php

require_once('api/Okay.php');

class SystemAdmin extends Okay {

    /*Информация о системе*/
    public function fetch() {
        $php_version = phpversion();
        $all_extensions = get_loaded_extensions();
        $ini_params = array();
        $request_ini = array('display_errors',
                            'memory_limit',
                            'post_max_size',
                            'max_input_time',
                            'max_file_uploads',
                            'max_execution_time',
                            'upload_max_filesize',
                            'max_input_vars');

        foreach ($request_ini as $ini) {
            $ini_params[$ini] =  ini_get($ini);
        }
        $sql_info = $this->db->get_mysql_info();
        $server_ip = file_get_contents('http://ipinfo.io/ip');

        $this->design->assign('sql_info', $sql_info);
        $this->design->assign('php_version', $php_version);
        $this->design->assign('all_extensions', $all_extensions);
        $this->design->assign('ini_params',$ini_params);
        $this->design->assign('server_ip', $server_ip);

        return $this->design->fetch('settings_system.tpl');
    }
}