<?php
    if(!empty($_SERVER['HTTP_USER_AGENT'])){
        session_name(md5($_SERVER['HTTP_USER_AGENT']));
    }
    session_start();
    require_once('../api/Okay.php');
    define('IS_CLIENT', true);
    $okay = new Okay();
    /*Добавляем товары в корзину*/
    $okay->cart->add_item($okay->request->get('variant', 'integer'), $okay->request->get('amount', 'integer'));
    $cart = $okay->cart->get_cart();
    $okay->design->assign('cart', $cart);

    /*Определяем валюту*/
	$currencies = $okay->money->get_currencies(array('enabled'=>1));
    if(isset($_SESSION['currency_id'])) {
        $currency = $okay->money->get_currency($_SESSION['currency_id']);
    } else {
        $currency = reset($currencies);
    }
    $okay->design->assign('currency',	$currency);

    /*Определяем язык*/
    $language = $okay->languages->get_language($okay->languages->lang_id());
    $okay->design->assign('language', $language);
    $okay->design->assign('lang_link', $okay->languages->get_lang_link());
    $okay->translations->debug = (bool)$okay->config->debug_translation;
    $okay->design->assign('lang', $okay->translations->get_translations(array('lang'=>$language->label)));
    
    $result = $okay->design->fetch('cart_informer.tpl');
    header("Content-type: application/json; charset=UTF-8");
    header("Cache-Control: must-revalidate");
    header("Pragma: no-cache");
    header("Expires: -1");
    print json_encode($result);
