<?php
    if(!empty($_SERVER['HTTP_USER_AGENT'])){
        session_name(md5($_SERVER['HTTP_USER_AGENT']));
    }
    session_start();
    require_once('../api/Okay.php');
    define('IS_CLIENT', true);
    $okay = new Okay();
    /*Действия над товаром в сравнении*/
    $product_id = $okay->request->get('product', 'integer');
    $action = $okay->request->get('action');
    if($action == 'add') {
        $okay->comparison->add_item(intval($product_id));
    } elseif($action == 'delete') {
        $okay->comparison->delete_item(intval($product_id));
    }
    
    $comparison = $okay->comparison->get_comparison();
    $okay->design->assign('comparison', $comparison);

    /*Определяем язык*/
    $language = $okay->languages->get_language($okay->languages->lang_id());
    $okay->design->assign('language', $language);
    $okay->design->assign('lang_link', $okay->languages->get_lang_link());
    $okay->translations->debug = (bool)$okay->config->debug_translation;
    $okay->design->assign('lang', $okay->translations->get_translations(array('lang'=>$language->label)));
    
    $result = $okay->design->fetch('comparison_informer.tpl');
    header("Content-type: application/json; charset=UTF-8");
    header("Cache-Control: must-revalidate");
    header("Pragma: no-cache");
    header("Expires: -1");
    print json_encode($result);
