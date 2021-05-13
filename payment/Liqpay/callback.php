<?php

// Работаем в корневой директории
chdir ('../../');
require_once('api/Okay.php');
$okay = new Okay();

// Выбираем из xml нужные данные
$public_key		 	= $okay->request->post('public_key');
$amount				= $okay->request->post('amount');
$currency			= $okay->request->post('currency');
$description		= $okay->request->post('description');
$liqpay_order_id	= $okay->request->post('order_id');
$order_id			= intval(substr($liqpay_order_id, 0, strpos($liqpay_order_id, '-')));
$type				= $okay->request->post('type');
$signature			= $okay->request->post('signature');
$status				= $okay->request->post('status');
$transaction_id		= $okay->request->post('transaction_id');
$sender_phone		= $okay->request->post('sender_phone');

if($status !== 'success')
	die("bad status");

if($type !== 'buy')
	die("bad type");

////////////////////////////////////////////////
// Выберем заказ из базы
////////////////////////////////////////////////
$order = $okay->orders->get_order(intval($order_id));
if(empty($order))
	die('Оплачиваемый заказ не найден');
 
////////////////////////////////////////////////
// Выбираем из базы соответствующий метод оплаты
////////////////////////////////////////////////
$method = $okay->payment->get_payment_method(intval($order->payment_method_id));
if(empty($method))
	die("Неизвестный метод оплаты");
	
$settings = unserialize($method->settings);
$payment_currency = $okay->money->get_currency(intval($method->currency_id));

// Валюта должна совпадать
if($currency !== $payment_currency->code)
	die("bad currency");

// Проверяем контрольную подпись
$mysignature = base64_encode(sha1($settings['liqpay_private_key'].$amount.$currency.$public_key.$liqpay_order_id.$type.$description.$status.$transaction_id.$sender_phone, 1));
if($mysignature !== $signature)
	die("bad sign".$signature);

// Нельзя оплатить уже оплаченный заказ  
if($order->paid)
	die('order already paid');

if($amount != round($okay->money->convert($order->total_price, $method->currency_id, false), 2) || $amount<=0)
	die("incorrect price");
	       
// Установим статус оплачен
$okay->orders->update_order(intval($order->id), array('paid'=>1));

// Отправим уведомление на email
$okay->notify->email_order_user(intval($order->id));
$okay->notify->email_order_admin(intval($order->id));

// Спишем товары  
$okay->orders->close(intval($order->id));

// Перенаправим пользователя на страницу заказа
// header('Location: '.$okay->config->root_url.'/order/'.$order->url);

exit();