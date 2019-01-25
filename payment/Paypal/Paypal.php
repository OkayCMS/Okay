<?php

require_once('api/Okay.php');

class Paypal extends Okay
{	
	public function checkout_form($order_id)
	{
		
		$order = $this->orders->get_order((int)$order_id);
		$purchases = $this->orders->get_purchases(array('order_id'=>intval($order->id)));

		$payment_method = $this->payment->get_payment_method($order->payment_method_id);
		$currency = $this->money->get_currency(intval($payment_method->currency_id));
		$payment_settings = $this->payment->get_payment_settings($payment_method->id);
			
		if($payment_settings['mode'] == 'sandbox') $paypal_url = "https://www.sandbox.paypal.com/cgi-bin/webscr";
		else $paypal_url = "https://www.paypal.com/cgi-bin/webscr";
			
		$ipn_url = $this->config->root_url.'/payment/Paypal/callback.php';
		$success_url = $this->config->root_url.'/order/'.$order->url;
		$fail_url = $this->config->root_url.'/order/'.$order->url;

        $coupon_discount = 0;
		if($order->coupon_discount>0) {
			$coupon_discount = $this->money->convert($order->coupon_discount, $payment_method->currency_id, false);
		}

        $res['paypal_url'] = $paypal_url;
        $res['currency'] = $currency;
        $res['order'] = $order;
        $res['payment_settings'] = $payment_settings;
        $res['ipn_url'] = $ipn_url;
        $res['success_url'] = $success_url;
        $res['fail_url'] = $fail_url;
        if($coupon_discount > 0) {
            $res['coupon_discount'] = $coupon_discount;
        }
        $res['purchases'] = $purchases;
        $res['payment_method'] = $payment_method;

		return $res;
	}

}