<?php
    if(!empty($_SERVER['HTTP_USER_AGENT'])){
        session_name(md5($_SERVER['HTTP_USER_AGENT']));
    }
    session_start();
    require_once('../api/Okay.php');
    define('IS_CLIENT', true);
    $okay = new Okay();
    /*Определяем пользователя*/
    if(isset($_SESSION['user_id']) && $user = $okay->users->get_user(intval($_SESSION['user_id']))) {
        $okay->design->assign('user', $user);
    }
    
    $action = $okay->request->get('action');
    $variant_id = $okay->request->get('variant_id', 'integer');
    $amount = $okay->request->get('amount', 'integer');
    /*Действия над товарами в корзине*/
    switch($action) {
        case 'update_citem':
            $okay->cart->update_item($variant_id, $amount);
            break;
        case 'remove_citem':
            $okay->cart->delete_item($variant_id);
            break;
        case 'add_citem':
            $okay->cart->add_item($variant_id, $amount);
            break;
        default:
            break;
    }

    /*Определяем язык*/
    $language = $okay->languages->get_language($okay->languages->lang_id());
    $okay->design->assign('language', $language);
    $okay->design->assign('lang_link', $okay->languages->get_lang_link());
    $okay->translations->debug = (bool)$okay->config->debug_translation;
    $okay->design->assign('lang', $okay->translations->get_translations(array('lang'=>$language->label)));

    $cart = $okay->cart->get_cart();
    $okay->design->assign('cart', $cart);
    /*Определяем валюту*/
    $currencies = $okay->money->get_currencies(array('enabled'=>1));
    if(isset($_SESSION['currency_id'])) {
        $currency = $okay->money->get_currency($_SESSION['currency_id']);
    } else {
        $currency = reset($currencies);
    }
    $okay->design->assign('currency',    $currency);

    /*Выбираем доступные способы доставки и оплаты*/
    $deliveries = $okay->delivery->get_deliveries(array('enabled'=>1));
    $okay->design->assign('deliveries', $deliveries);
    foreach($deliveries as $delivery) {
        $delivery->payment_methods = $okay->payment->get_payment_methods(array('delivery_id'=>$delivery->id, 'enabled'=>1));
    }
    $okay->design->assign('all_currencies', $okay->money->get_currencies());

    /*Рабтаем с товарами в корзине*/
    if (count($cart->purchases) > 0) {
        $coupon_code = trim($okay->request->get('coupon_code', 'string'));
        if(empty($coupon_code)) {
            $okay->cart->apply_coupon('');                
        } else {
            $coupon = $okay->coupons->get_coupon((string)$coupon_code);
            if(empty($coupon) || !$coupon->valid) {
                $okay->cart->apply_coupon($coupon_code);
                $okay->design->assign('coupon_error', 'invalid');
            } else {
                $okay->cart->apply_coupon($coupon_code);
            }
        }
        if($okay->coupons->count_coupons(array('valid'=>1))>0) {
            $okay->design->assign('coupon_request', true);
        }
        $cart = $okay->cart->get_cart();
        $okay->design->assign('cart', $cart);
        $result = array('result'=>1);
        $result['cart_informer'] = $okay->design->fetch('cart_informer.tpl');
        $result['cart_purchases'] = $okay->design->fetch('cart_purchases.tpl');
        $result['cart_deliveries'] = $okay->design->fetch('cart_deliveries.tpl');
        $result['currency_sign'] = $currency->sign;
        $result['total_price'] = $okay->money->convert($cart->total_price, $currency->id);
        $result['total_products'] = $cart->total_products;
    } else {
        $result = array('result'=>0);
        $result['cart_informer'] = $okay->design->fetch('cart_informer.tpl');
        $result['content'] = $okay->design->fetch('cart.tpl');
    }
    header("Content-type: application/json; charset=UTF-8");
    header("Cache-Control: must-revalidate");
    header("Pragma: no-cache");
    header("Expires: -1");        
    print json_encode($result);
