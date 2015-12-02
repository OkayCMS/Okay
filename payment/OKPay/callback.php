<?php

// Работаем в корневой директории
chdir ('../../');
require_once('api/Okay.php');
$okay = new Okay();


// Read the post from OKPAY and add 'ok_verify' 
$req = 'ok_verify=true'; 

foreach ($_POST as $key => $value) {
	$value = urlencode(stripslashes($value));
	$req .= "&$key=$value";
}

// Post back to OKPAY to validate 
$header .= "POST /ipn-verify.html HTTP/1.0\r\n"; 
$header .= "Host: www.okpay.com\r\n"; 
$header .= "Content-Type: application/x-www-form-urlencoded\r\n"; 
$header .= "Content-Length: " . strlen($req) . "\r\n\r\n"; 
$fp = fsockopen ('www.okpay.com', 80, $errno, $errstr, 30); 
 
if (!$fp)
{
	my_exit('Error postback');
}

fputs ($fp, $header . $req); 
while (!feof($fp))
    $res = fgets ($fp, 1024); 
fclose ($fp);

if ($res != "VERIFIED")
{
	my_exit('Not verified');
}


// Проверяем данные
if($_POST['ok_txn_kind'] !== 'payment_link')
	my_exit('Invalid ok_txn_kind');

if($_POST['ok_txn_status'] !== 'completed')
	my_exit('Invalid ok_txn_status');

if(intval($_POST['ok_ipn_test']) !== 0)
	my_exit('Test ipn');

$order_id = intval($_POST['ok_invoice']);

////////////////////////////////////////////////
// Выберем заказ из базы
////////////////////////////////////////////////
$order = $okay->orders->get_order(intval($order_id));
if(empty($order))
	my_exit('Оплачиваемый заказ не найден');
 
////////////////////////////////////////////////
// Выбираем из базы соответствующий метод оплаты
////////////////////////////////////////////////
$method = $okay->payment->get_payment_method(intval($order->payment_method_id));
if(empty($method))
	my_exit("Неизвестный метод оплаты");
	
$settings = unserialize($method->settings);
$payment_currency = $okay->money->get_currency(intval($method->currency_id));

// Проверяем получателя платежа
if($_POST['ok_reciever'] != $settings['okpay_receiver'])
	my_exit("bad reciever");

// Проверяем валюту
if($_POST['ok_txn_currency'] != $payment_currency->code)
	my_exit("bad currency");

// Нельзя оплатить уже оплаченный заказ  
if($order->paid)
	my_exit('Этот заказ уже оплачен');

if($_POST['ok_item_1_price'] != round($okay->money->convert($order->total_price, $method->currency_id, false), 2) || $_POST['ok_item_1_price']<=0)
	my_exit("incorrect price");
	
	       
// Установим статус оплачен
$okay->orders->update_order(intval($order->id), array('paid'=>1));

// Отправим уведомление на email
$okay->notify->email_order_user(intval($order->id));
$okay->notify->email_order_admin(intval($order->id));

// Спишем товары  
$okay->orders->close(intval($order->id));

// Перенаправим пользователя на страницу заказа
header('Location: '.$okay->config->root_url.'/order/'.$order->url);

exit();

function my_exit($text)
{
	header('Location: '.$okay->request->root_url.'/order/');
	exit();
}
