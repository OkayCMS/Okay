<?php

require_once('api/Okay.php');

class Payanyway extends Okay
{	
	public function checkout_form($order_id)
	{
		$order = $this->orders->get_order((int)$order_id);
		$payment_method = $this->payment->get_payment_method($order->payment_method_id);
		$payment_settings = $this->payment->get_payment_settings($payment_method->id);
		$payment_currency = $this->money->get_currency(intval($payment_method->currency_id));
		
		$price = number_format($this->money->convert($order->total_price, $payment_method->currency_id, false), 2, '.', '');
		
		$success_url = $this->config->root_url.'/order/'.$order->url;
		$fail_url = $this->config->root_url.'/order/'.$order->url;
				
		// метод оплаты - текущий
		$payment_system = explode('_', $payment_settings['payment_system']);

		// формирование подписи
		$currency_code = ($payment_currency->code == 'RUR')?'RUB':$payment_currency->code;
		$signature  = md5($payment_settings['MNT_ID'].$order->id.$price.$currency_code.$payment_settings['MNT_TEST_MODE'].$payment_settings['MNT_DATAINTEGRITY_CODE']);

		if ($payment_system[1]){
			$url = "https://".$payment_settings['payment_url']."/assistant.htm";
		} else {
			$url = $this->config->root_url.'/payment/Payanyway/callback.php?invoice=true';
		}

        $res['url'] = $url;
        $res['payment_system'] = $payment_system;
        $res['payment_settings'] = $payment_settings;
        $res['order'] = $order;
        $res['price'] = $price;
        $res['currency_code'] = $currency_code;
        $res['signature'] = $signature;
        $res['success_url'] = $success_url;
        $res['fail_url'] = $fail_url;

		return $res;
	}

}