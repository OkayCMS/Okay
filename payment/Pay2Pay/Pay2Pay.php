<?php

require_once('api/Okay.php');

class Pay2Pay extends Okay
{	
	public function checkout_form($order_id)
	{
		$order = $this->orders->get_order((int)$order_id);
		$payment_method = $this->payment->get_payment_method($order->payment_method_id);
		$payment_currency = $this->money->get_currency(intval($payment_method->currency_id));
		$settings = $this->payment->get_payment_settings($payment_method->id);
		
		$price = round($this->money->convert($order->total_price, $payment_method->currency_id, false), 2);
		
		// описание заказа
		// order description
		$desc = 'Оплата заказа №'.$order->id;
		
		$success_url = $this->config->root_url.'/order/';
		$result_url = $this->config->root_url.'/payment/Pay2Pay/callback.php';		
		
		$currency = $payment_currency->code;
		if ($currency == 'RUR')
		  $currency = 'RUB';
		  
		$xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
            <request>
              <version>1.2</version>
              <merchant_id>".$settings['pay2pay_merchantid']."</merchant_id>
              <language>ru</language>
              <order_id>$order->id</order_id>
              <amount>$price</amount>
              <currency>$currency</currency>
              <description>$desc</description>
              <result_url>$result_url</result_url>
              <success_url>$success_url</success_url>
              <fail_url>$success_url</fail_url>";
        if ($settings['pay2pay_testmode'] == '1') {
            $xml .= "<test_mode>1</test_mode>";
        }
        $xml .= "</request>";
    
		$xml_encoded = base64_encode($xml);
		
		$merc_sign = $settings['pay2pay_secret'];
		$sign_encoded = base64_encode(md5($merc_sign.$xml.$merc_sign));

        $res['xml_encoded'] = $xml_encoded;
        $res['sign_encoded'] = $sign_encoded;

		return $res;
	}
}