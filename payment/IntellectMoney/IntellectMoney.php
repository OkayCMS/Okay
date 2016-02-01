<?php

require_once('api/Okay.php');

class IntellectMoney extends Okay
{	
	public function checkout_form($order_id, $button_text = null)
	{
		if(empty($button_text))
			$button_text = 'Перейти к оплате';
		
		$order = $this->orders->get_order((int)$order_id);
		$payment_method = $this->payment->get_payment_method($order->payment_method_id);
		$payment_settings = $this->payment->get_payment_settings($payment_method->id);
		$payment_currency = $this->money->get_currency(intval($payment_method->currency_id));
		
			
		$shop_id = $payment_settings['im_eshop_id'];
		
		// номер заказа
		// number of order
		$order_id = $order->id;
		
		// описание заказа
		// order description
		//$order_description = 'Оплата заказа №'.$order->id;
		$description = 'Оплата заказа '.$order->id;
		$order_description = preg_replace('/[^0-9A-Za-zА-Яа-я\.\,\<\>\s]/', '', $description);
		
		// сумма заказа
		// sum of order
		$amount = $this->money->convert($order->total_price, $payment_method->currency_id, false);
		
		$currency_code = $payment_currency->code;
		
		// адрес, на который попадет пользователь по окончанию продажи в случае успеха
		$redirect_url_ok = $this->config->root_url.'/order/'.$order->url;
		
		// адрес, на который попадет пользователь по окончанию продажи в случае неудачи
		$redirect_url_failed = $this->config->root_url.'/order/'.$order->url;

		// Email покупателя
		$user_email = $order->email;

		$pre_hash = md5(join('::', array($shop_id,$order_id,$order_description,$amount,$currency_code,$payment_settings['im_secret_key'])));

        $res['shop_id'] = $shop_id;
        $res['order_id'] = $order_id;
        $res['order_description'] = $order_description;
        $res['amount'] = $amount;
        $res['currency_code'] = $currency_code;
        $res['redirect_url_ok'] = $redirect_url_ok;
        $res['redirect_url_failed'] = $redirect_url_failed;
        $res['user_email'] = $user_email;
        $res['pre_hash'] = $pre_hash;

		$button =	"<form action='https://merchant.intellectmoney.ru' method=POST>".
					"<input type=hidden name=eshopId value='$shop_id'>".
					"<input type=hidden name=orderId value='$order_id'>".
					"<input type=hidden name=serviceName value='$order_description'>".
					"<input type=hidden name=recipientAmount value='$amount'>".
					"<input type=hidden name=recipientCurrency value='$currency_code'>".
					"<input type=hidden name=successUrl value='$redirect_url_ok'>".
					"<input type=hidden name=failUrl value='$redirect_url_failed'>".
					"<input type=hidden name=user_email value='$user_email'>".
					"<input type=hidden name=hash value='$pre_hash'>".
					"<input type=submit class=payment_button value='$button_text'>".
					"</form>";
		return $res;
	}
	private function checksymbol(){
	
	}
}