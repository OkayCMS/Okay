<?php
    // Проверка сессии для защиты от xss
    if(!$okay->request->check_session()) {
        trigger_error('Session expired', E_USER_WARNING);
        exit();
    }
    $res = new stdClass();
    
    if($okay->managers->access('topvisor')) {
        $okay->design->set_templates_dir('backend/design/html');
        $okay->design->set_compiled_dir('backend/design/compiled');
        
        $project_id = $okay->request->post('project_id', 'integer');
        $searcher = $okay->request->post('searcher');
        $region_key = $okay->request->post('region_key');
        $region_lang = $okay->request->post('region_lang');
        $group_id = $okay->request->post('group_id', 'integer');
        $page = $okay->request->post('page', 'integer');
        $dates = $okay->request->post('dates');
        $dates = explode('---', $dates);
        $date1 = date('Y-m-d', strtotime($dates[0]));
        $date2 = date('Y-m-d', strtotime($dates[1]));
        
        $res = new stdClass();
        $queries_dynamics = $okay->topvisor->get_queries_dynamics($project_id, $searcher, $region_key, $region_lang, $group_id, $date1, $date2, $page);
        $queries_dynamics->scheme->dates = array_reverse($queries_dynamics->scheme->dates);
        foreach ($queries_dynamics->phrases as $phrase) {
            $phrase->dates = array_reverse($phrase->dates);
        }
        $okay->design->assign('queries_dynamics', $queries_dynamics);
        
        $dates = array();
        foreach ($queries_dynamics->scheme->dates as $d) {
            $dates[] = $d->date;
        }
        if (!empty($dates)) {
            $qd_summary = $okay->topvisor->get_queries_dynamics_summary($project_id, $searcher, $region_key, $region_lang, $group_id, min($dates), max($dates));
            $okay->design->assign('qd_summary', $qd_summary);
        }
        $res->content = $okay->design->fetch('topvisor_queries_dynamics.tpl');
        $res->data = $queries_dynamics;
    }
    
    header("Content-type: application/json; charset=UTF-8");
    header("Cache-Control: must-revalidate");
    header("Pragma: no-cache");
    header("Expires: -1");
    print json_encode($res);
