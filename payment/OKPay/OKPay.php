<?php

require_once('api/Okay.php');

class OKPay extends Okay
{	
	public function checkout_form($order_id)
	{
		$order = $this->orders->get_order((int)$order_id);
		$payment_method = $this->payment->get_payment_method($order->payment_method_id);
		$settings = $this->payment->get_payment_settings($payment_method->id);
		
		$price = round($this->money->convert($order->total_price, $payment_method->currency_id, false), 2);
		$currency = $this->money->get_currency(intval($payment_method->currency_id));
		
		// описание заказа
		// order description
		$desc = 'Оплата заказа №'.$order->id;

		$return_url = $this->config->root_url.'/payment/OKPay/callback.php';

        $res['settings_pay'] = $settings;
        $res['order'] = $order;
        $res['desc'] = $desc;
        $res['price'] = $price;
        $res['currency'] = $currency;
        $res['return_url'] = $return_url;
				
		return $res;
	}
}