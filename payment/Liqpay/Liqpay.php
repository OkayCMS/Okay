<?php

require_once('api/Okay.php');

class Liqpay extends Okay
{	
	public function checkout_form($order_id)
	{
		
		$order = $this->orders->get_order((int)$order_id);
		$liqpay_order_id = $order->id."-".rand(100000, 999999);
		$payment_method = $this->payment->get_payment_method($order->payment_method_id);
		$payment_currency = $this->money->get_currency(intval($payment_method->currency_id));
		$settings = $this->payment->get_payment_settings($payment_method->id);
		
		$price = round($this->money->convert($order->total_price, $payment_method->currency_id, false), 2);	

		// описание заказа
		// order description
		$desc = 'Оплата заказа №'.$order->id;

		$result_url = $this->config->root_url.'/order/'.$order->url;
		$server_url = $this->config->root_url.'/payment/Liqpay/callback.php';		
		
		
		$private_key = $settings['liqpay_private_key'];
		$public_key = $settings['liqpay_public_key'];
		$sign = base64_encode(sha1($private_key.$price.$payment_currency->code.$public_key.$liqpay_order_id.'buy'.$desc.$result_url.$server_url, 1));

        $res['public_key'] = $public_key;
        $res['price'] = $price;
        $res['payment_currency'] = $payment_currency;
        $res['desc'] = $desc;
        $res['liqpay_order_id'] = $liqpay_order_id;
        $res['result_url'] = $result_url;
        $res['server_url'] = $server_url;
        $res['sign'] = $sign;

		return $res;
	}
}