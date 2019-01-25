<?php

require_once('api/Okay.php');

class Receipt extends Okay
{

	public function checkout_form($order_id)
	{
		$order = $this->orders->get_order((int)$order_id);
		$payment_method = $this->payment->get_payment_method($order->payment_method_id);
		$payment_settings = $this->payment->get_payment_settings($payment_method->id);
		
		$amount = $this->money->convert($order->total_price, $payment_method->currency_id, false);

        $res['payment_settings'] = $payment_settings;
        $res['order'] = $order;
        $res['amount'] = $amount;

		return $res;
	}
}