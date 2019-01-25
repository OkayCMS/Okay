<?php

require_once('api/Okay.php');

class Webmoney extends Okay
{	
	public function checkout_form($order_id)
	{
		$order = $this->orders->get_order((int)$order_id);
		$payment_method = $this->payment->get_payment_method($order->payment_method_id);
		$payment_settings = $this->payment->get_payment_settings($payment_method->id);
		
		$amount = $this->money->convert($order->total_price, $payment_method->currency_id, false);
		
		$success_url = $this->config->root_url.'/order/'.$order->url;
		
		$fail_url = $this->config->root_url.'/order/'.$order->url;

        $res['order'] = $order;
        $res['payment_method'] = $payment_method;
        $res['payment_settings'] = $payment_settings;
        $res['amount'] = $amount;
        $res['success_url'] = $success_url;
        $res['fail_url'] = $fail_url;

		return $res;
	}

}