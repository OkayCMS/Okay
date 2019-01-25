<?php

require_once('api/Okay.php');

class Yandex extends Okay
{

	// Комиссия Яндекса, %
	private $fee = 0.5;

	public function checkout_form($order_id)
	{
		$order = $this->orders->get_order((int)$order_id);
		$payment_method = $this->payment->get_payment_method($order->payment_method_id);
		$settings = $this->payment->get_payment_settings($payment_method->id);
		
		$price = round($this->money->convert($order->total_price, $payment_method->currency_id, false), 2);
		
		// Учесть комиссию Яндекса
		$price = $price+max(0.01, $price*$this->fee/100);

		// описание заказа
		$desc = 'Оплата заказа №'.$order->id.' на сайте '.$this->settings->site_name;

        $res['settings_pay'] = $settings;
        $res['desc'] = $desc;
        $res['price'] = $price;
        $res['order'] = $order;

		return $res;
	}
}