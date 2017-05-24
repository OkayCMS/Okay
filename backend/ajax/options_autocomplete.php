<?php

    if(!$okay->managers->access('products')) {
        exit();
    }
    $limit = 100;

    /*Принимаем строку запроса*/
    $keyword = $okay->request->get('query', 'string');
    $feature_id = $okay->request->get('feature_id', 'string');

    /*Выбираем значение свойства*/
    $query = $okay->db->placehold('SELECT DISTINCT po.value 
        FROM __options po
        WHERE 
            value LIKE "'.$okay->db->escape($keyword).'%" 
            AND feature_id=? 
        ORDER BY po.value 
        LIMIT ?
    ', $feature_id, $limit);
    
    $okay->db->query($query);
    
    $options = $okay->db->results('value');
    
    $res = new stdClass;
    $res->query = $keyword;
    $res->suggestions = $options;
    header("Content-type: application/json; charset=UTF-8");
    header("Cache-Control: must-revalidate");
    header("Pragma: no-cache");
    header("Expires: -1");
    print json_encode($res);
