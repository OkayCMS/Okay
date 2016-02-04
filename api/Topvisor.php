<?php

require_once('Okay.php');

class Topvisor extends Okay {
    
    public $request_count = 0;
    
    public function get_projects() {
        return $this->request(array('oper'=>'get', 'module'=>'mod_projects'));
    }
    
    public function get_project($id) {
        if (empty($id)) {
            return false;
        }
        $filter = json_encode(array('id'=>$id));
        $project = $this->request(array('oper'=>'get', 'module'=>'mod_projects', 'func'=>'full', 'filter'=>$filter));
        return reset($project);
    }
    
    public function add_project($site = '', $name = '') {
        if (!$site) {
            return false;
        }
        return $this->request(array('oper'=>'add', 'module'=>'mod_projects', 'post'=>array('site'=>$site/*, 'on'=>$name*/)));
    }
    
    public function delete_project($id) {
        if (empty($id)) {
            return false;
        }
        return $this->request(array('oper'=>'del', 'module'=>'mod_projects', 'post'=>array('id'=>$id)));
    }
    
    // статус проверки позиций проекта
    public function percent_of_parse($ids) {
        if (empty($ids)) {
            return false;
        }
        return $this->request(array('oper'=>'get', 'module'=>'mod_keywords', 'func'=>'percent_of_parse', 'post'=>array('project_ids'=>(array)$ids)));
    }
    
    public function check_positions($id) {
        if (empty($id)) {
            return false;
        }
        return $this->request(array('oper'=>'edit', 'module'=>'mod_keywords', 'func'=>'parse_task', 'post'=>array('id'=>$id)));
    }
    
    public function add_searcher($project_id, $searcher) {
        if (empty($project_id)) {
            return false;
        }
        return $this->request(array('oper'=>'add', 'module'=>'mod_projects', 'func'=>'searcher', 'post'=>array('project_id'=>$project_id, 'searcher'=>$searcher)));
    }
    
    public function delete_searcher($id) {
        if (empty($id)) {
            return false;
        }
        return $this->request(array('oper'=>'del', 'module'=>'mod_projects', 'func'=>'searcher', 'post'=>array('id'=>$id)));
    }
    
    public function get_regions($query = '') {
        $query = mb_strtolower($query);
        $regions = array();
        $file = 'files/downloads/topvisor_regions.csv';
        if (file_exists($file)) {
            $f = fopen($file, 'r');
            fgetcsv($f, 0, ';');//без региона.
            while (!feof($f)) {
                $line = fgetcsv($f, 0, ';');
                if (empty($query) || strpos(mb_strtolower($line[0]), $query) !== false) {
                    $regions[$line[1]] = $line[0];
                }
            }
            fclose($f);
        }
        return $regions;
        //return $this->request(array('oper'=>'get', 'module'=>'mod_projects', 'func'=>'regions'));
    }
    
    public function add_region($region_id, $searcher_id) {
        if (empty($region_id) || empty($searcher_id)) {
            return false;
        }
        return $this->request(array('oper'=>'add', 'module'=>'mod_projects', 'func'=>'searcher_region', 'post'=>array('searcher_id'=>$searcher_id, 'region'=>$region_id)));
    }
    
    public function delete_region($id) {
        if (empty($id)) {
            return false;
        }
        return $this->request(array('oper'=>'del', 'module'=>'mod_projects', 'func'=>'searcher_region', 'post'=>array('id'=>$id)));
    }
    
    public function add_group($project_id, $name) {
        if (empty($project_id) || empty($name)) {
            return false;
        }
        return $this->request(array('oper'=>'add', 'module'=>'mod_keywords', 'func'=>'group', 'post'=>array('project_id'=>$project_id, 'name'=>$name, 'on'=>1)));
    }
    
    public function get_queries($project_id) {
        if (empty($project_id)) {
            return false;
        }
        return $this->request(array('oper'=>'get', 'module'=>'mod_keywords', 'post'=>array('project_id'=>$project_id)));
    }
    
    public function get_queries_dynamics($project_id, $searcher_key, $region_key, $region_lang = 'ru', $group_id = -1, $date1 = '', $date2 = '', $page = 1) {
        if (empty($project_id)) {
            return false;
        }
        $page = max(1, $page);
        if (empty($date1)) {
            $date1 = date('Y-m-d', time()-2419200);//-28days from current
        }
        if (empty($date2)) {
            $date2 = date('Y-m-d', time()+86400);//+1days from current
        }
        $post = array(
            'project_id'    => $project_id,
            'page'          => $page,
            'rows'          => 100,
            'searcher'      => $searcher_key,
            'region_key'    => $region_key,
            'region_lang'   => $region_lang,// по умолчанию "ru"
            'group_id'      => $group_id,// -1 все группы
            'date1'         => $date1,
            'date2'         => $date2,
            'type_range'    => 2 // по умолчанию 3... 1 – только дни апдейтов Yandex; 2 – весь период (не более 30 дней); 3 – две даты.
        );
        return $this->request(array('oper'=>'get', 'module'=>'mod_keywords', 'func'=>'history', 'post'=>$post));
    }
    
    public function get_queries_dynamics_summary($project_id, $searcher_key, $region_key, $region_lang = 'ru', $group_id = -1, $date1 = '', $date2 = '') {
        if (empty($project_id)) {
            return false;
        }
        if (empty($date1)) {
            $date1 = date('Y-m-d', time()-2419200);
        }
        if (empty($date2)) {
            $date2 = date('Y-m-d', time()+86400);
        }
        $post = array(
            'project_id'    => $project_id,
            'searcher'      => $searcher_key,
            'region_key'    => $region_key,
            'region_lang'   => $region_lang,
            'group_id'      => $group_id,
            'date1'         => $date1,
            'date2'         => $date2
        );
        return $this->request(array('oper'=>'get', 'module'=>'mod_keywords', 'func'=>'history_summary', 'post'=>$post));
    }
    
    public function add_queries($project_id, $group_id, $queries) {
        if (empty($project_id) || empty($group_id) || empty($queries)) {
            return false;
        }
        return $this->request(array('oper'=>'add', 'module'=>'mod_keywords', 'func'=>'import', 'post'=>array('project_id'=>$project_id, 'group_id'=>$group_id, 'phrases'=>$queries)));
    }
    
    public function delete_query($id) {
        if (empty($id)) {
            return false;
        }
        return $this->request(array('oper'=>'del', 'module'=>'mod_keywords', 'post'=>array('id'=>$id)));
    }
    
    public function get_balance() {
        return $this->request(array('oper'=>'get', 'module'=>'bank', 'func'=>'balance'));
    }
    
    public function get_apometr($searcher_key, $region_key, $region_lang, $date_month, $action = 1) {
        // для гугла и бинга 0, для остальных (яндекс и го.майл) - 1
        if ($searcher_key == 1 || $searcher_key == 5) {
            $action = 0;
        }
        return $this->request(array('oper'=>'get', 'module'=>'mod_common', 'func'=>'apometr_calendar', 'post'=>array('searcher'=>$searcher_key, 'region_key'=>$region_key, 'region_lang'=>$region_lang, 'date_month'=>$date_month, 'action'=>$action)));
    }
    
    private function request($params) {
        if (empty($params)) {
            return false;
        }
        $this->request_count++;
        $params['api_key'] = $this->settings->topvisor_key;
        $url = http_build_query($params);
        $response = @file_get_contents('https://api.topvisor.ru/?'.$url);
        return json_decode($response);
    }
    
}
