<?php

require_once('api/Okay.php');

class Robokassa extends Okay {
    
    public function checkout_form($order_id) 
    {
        $order = $this->orders->get_order((int)$order_id);
        $payment_method = $this->payment->get_payment_method($order->payment_method_id);
        $payment_settings = $this->payment->get_payment_settings($payment_method->id);

        $price = $this->money->convert($order->total_price, $payment_method->currency_id, false);
        
        // регистрационная информация (логин, пароль #1)
        // registration info (login, password #1)
        $mrh_login = $payment_settings['login'];
        $mrh_pass1 = $payment_settings['password1'];

        // номер заказа
        // number of order
        $inv_id = $order->id;

        // описание заказа
        // order description
        $inv_desc = 'Оплата заказа №' . $inv_id;
        
        // предлагаемая валюта платежа
        // default payment e-currency
        $in_curr = "PCR";

        // язык
        // language
        $culture = $payment_settings['language'];

        // список товаров
        // products list
        $total_price = (float)$order->total_price;

        $total_price -= (float)$order->delivery_price; //цена доставки не учитывается

        $purchases = $this->orders->get_purchases(array('order_id' => (int)$order->id));

        $full_total_price = 0;

        foreach ($purchases as $p) {
            $full_total_price += (float)$p->price * (int)$p->amount;
        }

        $discount = $total_price / $full_total_price;

        $receipt = array('sno' => 'osn');

        $receipt['items'] = array();

        foreach ($purchases as $key => $p) {
            $one_product = array();
            $one_product['name'] = mb_substr(htmlentities($p->product_name . ($p->variant_name ? ' ' . $p->variant_name : '')), 0, 64);
            if ($key == end($purchases)) {
                $one_product['sum'] = $total_price;
            } else {
                $total_price -= floor((float)$p->price * (float)$p->amount * $discount);
                $one_product['sum'] = floor((float)$p->price * (float)$p->amount * $discount);
            }
            $one_product['quantity'] = (float)$p->amount;
            $one_product['tax'] = 'none';
            $receipt['items'][] = $one_product;
        }


        $url_json_receipt = urlencode(json_encode($receipt));

        // формирование подписи
        // generate signature
        $crc = md5("$mrh_login:$price:$inv_id:$url_json_receipt:$mrh_pass1");

        $res['mrh_login'] = $mrh_login;
        $res['price'] = $price;
        $res['inv_id'] = $inv_id;
        $res['receipt'] = $url_json_receipt;
        $res['inv_desc'] = $inv_desc;
        $res['crc'] = $crc;
        $res['in_curr'] = $in_curr;
        $res['culture'] = $culture;

        return $res;
    }

}