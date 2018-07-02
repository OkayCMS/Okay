<?php
    if(!empty($_SERVER['HTTP_USER_AGENT'])){
        session_name(md5($_SERVER['HTTP_USER_AGENT']));
    }
    session_start();
    require_once('../api/Okay.php');
    $okay = new Okay();
    $result = false;
    
    if(($currency_id = $okay->request->get('currency_id', 'integer')) && $okay->money->get_currency($currency_id)) {
        $_SESSION['currency_id'] = $currency_id;
        $result = true;
    }

    header("Content-type: text/html; charset=UTF-8");
    header("Cache-Control: must-revalidate");
    header("Pragma: no-cache");
    header("Expires: -1");
    print $result;
