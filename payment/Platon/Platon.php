<?php

require_once('api/Okay.php');

class Platon extends Okay
{	
	public function checkout_form($order_id)
	{
		$order = $this->orders->get_order((int)$order_id);
		$payment_method = $this->payment->get_payment_method($order->payment_method_id);
		$payment_currency = $this->money->get_currency(intval($payment_method->currency_id));
		$settings = $this->payment->get_payment_settings($payment_method->id);
		
		$price = round($this->money->convert($order->total_price, $payment_method->currency_id, false), 2);
		$price = number_format($price, 2, '.', '');
		// описание заказа
		// order description
		$data = base64_encode( serialize( array('amount'=>$price, 'currency'=>$payment_currency->code, 'name'=>'Оплата заказа №'.$order->id)));
		
		$return_url = $this->config->root_url.'/order/'.$order->url;
		
		$sign = md5(strtoupper(strrev($_SERVER["REMOTE_ADDR"]).strrev($settings['platon_key']).strrev($data).strrev($return_url).strrev($settings['platon_password'])));
		$res['settings_pay'] = $settings;
        $res['order'] = $order;
        $res['data'] = $data;
        $res['return_url'] = $return_url;
        $res['sign'] = $sign;

		return $res;
	}
}