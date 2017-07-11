<?php

require_once('api/Okay.php');

class Platon extends Okay
{	
	public function checkout_form($order_id, $button_text = null)
	{
		if(empty($button_text))
			$button_text = 'Перейти к оплате';
		
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

        $button =	'<form action="https://secure.platononline.com/webpaygw/pcc.php?a=auth" method="POST"/>'.
					'<input type="hidden" name="key" value="'.$settings['platon_key'].'" />'.
					'<input type="hidden" name="order" value="'.$order->id.'" />'.
					'<input type="hidden" name="data" value="'.$data.'" />'.
					'<input type="hidden" name="url" value="'.$return_url.'" />'.
					'<input type="hidden" name="sign" value="'.$sign.'" />'.
					'<input type=submit class=checkout_button value="'.$button_text.'">'.
					'</form>';
		return $res;
	}
}