<?php

require_once('api/Okay.php');

class Qiwi extends Okay
{	
	public function checkout_form($order_id)
	{
		$order = $this->orders->get_order((int)$order_id);
		$payment_method = $this->payment->get_payment_method($order->payment_method_id);
		$payment_currency = $this->money->get_currency(intval($payment_method->currency_id));
		$payment_settings = $this->payment->get_payment_settings($payment_method->id);
		
		$price = $this->money->convert($order->total_price, $payment_method->currency_id, false);
		
		$success_url = $this->config->root_url.'/order/'.$order->url;
				
		// регистрационная информация (логин, пароль #1)
		// registration info (login, password #1)
		$login = $payment_settings['qiwi_login'];
		
		// номер заказа
		// number of order
		$inv_id = $order->id;
		
		// описание заказа
		// order description
		$inv_desc = 'Оплата заказа №'.$inv_id;
		
		$message = "Введите логин Qiwi-кошелька или номер телефона (10 последних цифр):";
		$phone = preg_replace('/[^\d]/', '', $order->phone);
		$phone = substr($phone, -min(10, strlen($phone)), 10);

        $res['login'] = $login;
        $res['price'] = $price;
        $res['inv_id'] = $inv_id;
        $res['payment_currency'] = $payment_currency;
        $res['inv_desc'] = $inv_desc;
        $res['success_url'] = $success_url;
        $res['fail_url'] = $success_url;
        $res['message'] = $message;
        $res['phone'] = $phone;

		return $res;
	}
}