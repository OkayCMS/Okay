<?php

require_once('api/Okay.php');

class Interkassa extends Okay
{	
	public function checkout_form($order_id)
	{
		$order = $this->orders->get_order((int)$order_id);
		$payment_method = $this->payment->get_payment_method($order->payment_method_id);
		$payment_currency = $this->money->get_currency(intval($payment_method->currency_id));
		$settings = $this->payment->get_payment_settings($payment_method->id);
		
		$price = round($this->money->convert($order->total_price, $payment_method->currency_id, false), 2);
		
		
		// описание заказа
		$desc = 'Оплата заказа №'.$order->id;
		
		$success_url = $this->config->root_url.'/order/'.$order->url;
		$callback_url = $this->config->root_url.'/payment/Interkassa2/callback.php';


        $res['settings_pay'] = $settings;
        $res['order'] = $order;
        $res['settings_pay'] = $settings;
        $res['payment_currency'] = $payment_currency;
        $res['price'] = $price;
        $res['desc'] = $desc;
        $res['success_url'] = $success_url;
        $res['callback_url'] = $callback_url;

		return $res;
	}
}