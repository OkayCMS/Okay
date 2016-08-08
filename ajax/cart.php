<?php
    if(!empty($_SERVER['HTTP_USER_AGENT'])){
        session_name(md5($_SERVER['HTTP_USER_AGENT']));
    }
    session_start();
    require_once('../api/Okay.php');
    define('IS_CLIENT', true);
    $okay = new Okay();
    $okay->cart->add_item($okay->request->get('variant', 'integer'), $okay->request->get('amount', 'integer'));
    $cart = $okay->cart->get_cart();
    $okay->design->assign('cart', $cart);
    
	$currencies = $okay->money->get_currencies(array('enabled'=>1));
    if(isset($_SESSION['currency_id'])) {
        $currency = $okay->money->get_currency($_SESSION['currency_id']);
    } else {
        $currency = reset($currencies);
    }
    
    $okay->design->assign('currency',	$currency);
    
    $language = $okay->languages->languages(array('id'=>$_SESSION['lang_id']));
    $okay->design->assign('language', $language);
    
    $lang_link = '';
    $first_lang = $okay->languages->languages();
    if (!empty($first_lang)) {
        $first_lang = reset($first_lang);
        if($first_lang->id !== $language->id) {
            $lang_link = $language->label . '/';
        }
    }
    $okay->design->assign('lang_link', $lang_link);
    $okay->design->assign('lang', $okay->translations);
    
    $result = $okay->design->fetch('cart_informer.tpl');
    header("Content-type: application/json; charset=UTF-8");
    header("Cache-Control: must-revalidate");
    header("Pragma: no-cache");
    header("Expires: -1");
    print json_encode($result);
