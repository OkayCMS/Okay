<?php

require_once('api/Okay.php');

class Acquiropay extends Okay
{	
	public function checkout_form($order_id, $button_text = null)
	{
		if(empty($button_text))
			$button_text = 'Перейти к оплате';
		
		$order = $this->orders->get_order((int)$order_id);
		$payment_method = $this->payment->get_payment_method($order->payment_method_id);
		$payment_currency = $this->money->get_currency(intval($payment_method->currency_id));
		$settings = $this->payment->get_payment_settings($payment_method->id);
		$price = $order->total_price;
		
		// описание заказа
		$desc = 'Оплата заказа №'.$order->id;
		$cb_url = $this->config->root_url.'/payment/Acquiropay/callback.php';
		$ok_url = $this->config->root_url.'/order/'.$order->url;

		$token = md5($settings[acquiropay_mid].$settings[acquiropay_product].$price.$order_id.$settings[acquiropay_sw]);

        $res['order'] = $order;
        $res['payment_method'] = $payment_method;
        $res['payment_currency'] = $payment_currency;
        $res['settings_pay'] = $settings;
        $res['price'] = $price;
        $res['desc'] = $desc;
        $res['cb_url'] = $cb_url;
        $res['ok_url'] = $ok_url;
        $res['token'] = $token;

		$button =  "<form accept-charset='UTF-8' name='payment_form' method='POST' action='https://secure.acquiropay.com'>
					    <input type='hidden' name='product_id' value='$settings[acquiropay_product]'/> 
					    <input type='hidden' name='product_name' value='$desc' />
					    <input type='hidden' name='token' value='$token' />
					    <input type='hidden' name='amount' value='$price' />
					    <input type='hidden' name='cf' value='$order_id' />
					    <input type='hidden' name='cf2' value='' />
					    <input type='hidden' name='cf3' value='' />
					    <input type='hidden' name='first_name' value='$order->name' />
					    <input type='hidden' name='last_name' value='' />
					    <input type='hidden' name='email' value='$order->email' />
					    <input type='hidden' name='phone' value='$order->phone' />
					    <input type='hidden' name='cb_url' value='$cb_url'/>
					    <input type='hidden' name='ok_url' value='$ok_url'/>
	  				    <input type='hidden' name='ko_url' value='$settings[acquiropay_uerror]'/>
						<input type='submit' class='checkout_button' value='$button_text'>
  			</form>";
		return $res;
	}
}