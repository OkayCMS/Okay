<?php

    if(!$okay->managers->access('orders')) {
        exit();
    }
    $limit = 100;
    
    $keyword = $okay->request->get('keyword', 'string');
    if($okay->request->get('limit', 'integer')) {
        $limit = $okay->request->get('limit', 'integer');
    }
    
    $orders = array_values($okay->orders->get_orders(array('keyword'=>$keyword, 'limit'=>$limit)));
    
    header("Content-type: application/json; charset=UTF-8");
    header("Cache-Control: must-revalidate");
    header("Pragma: no-cache");
    header("Expires: -1");
    print json_encode($orders);
