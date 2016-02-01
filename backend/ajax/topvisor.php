<?php
    // Проверка сессии для защиты от xss
    if(!$okay->request->check_session()) {
        trigger_error('Session expired', E_USER_WARNING);
        exit();
    }
    
    $res = new stdClass();
    if($okay->managers->access('topvisor')) {
        $module = $okay->request->post('module');
        $module = (!$module ? $okay->request->get('module') : $module);
        switch ($module) {
            case 'apometr': {
                $searcher = $okay->request->post('searcher');
                $region_key = $okay->request->post('region_key');
                $region_lang = $okay->request->post('region_lang');
                $date_month = date('Y-m-01', strtotime($okay->request->post('date_month')));
                
                $apometr = array();
                foreach ($okay->topvisor->get_apometr($searcher, $region_key, $region_lang, $date_month) as $a) {
                    $apometr[$a->date] = $a;
                }
                $res->res = $apometr;
                break;
            }
            case 'check_positions': {
                $id = $okay->request->post('id', 'integer');
                $res = $okay->topvisor->check_positions($id);
                break;
            }
            case 'delete_query': {
                $id = $okay->request->post('id', 'integer');
                $res = $okay->topvisor->delete_query($id);
                break;
            }
            case 'delete_region': {
                $id = $okay->request->post('id', 'integer');
                $res = $okay->topvisor->delete_region($id);
                break;
            }
            case 'search_regions': {
                $keyword = $okay->request->get('query');
                $keywords = explode(' ', $keyword);
                $regions = $okay->topvisor->get_regions($keyword);
                
                $suggestions = array();
                foreach ($regions as $key=>$region) {
                    $suggestion = new stdClass();
                    $suggestion->value = $region;
                    $suggestion->data = $key;
                    $suggestions[] = $suggestion;
                }
                $res->query = $keyword;
                $res->suggestions = $suggestions;
                break;
            }
            case 'check_percent_of_parse': {
                $id = $okay->request->post('id', 'integer');
                $res = $okay->topvisor->percent_of_parse($id);
                if (isset($res[0])) {
                    $res = $res[0];
                }
                break;
            }
        }
    }
    
    header("Content-type: application/json; charset=UTF-8");
    header("Cache-Control: must-revalidate");
    header("Pragma: no-cache");
    header("Expires: -1");
    print json_encode($res);
