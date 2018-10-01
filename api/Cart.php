<?php

require_once('Okay.php');

class Cart extends Okay {

    /*Выбираем содержимое корзины*/
    public function get_cart() {
        $cart = new stdClass();
        $cart->purchases = array();
        $cart->total_price = 0;
        $cart->total_products = 0;
        $cart->coupon = null;
        $cart->discount = 0;
        $cart->coupon_discount = 0;
        
        // Берем из сессии список variant_id=>amount
        if(!empty($_SESSION['shopping_cart'])) {
            $session_items = $_SESSION['shopping_cart'];
            
            $variants = $this->variants->get_variants(array('id'=>array_keys($session_items)));
            if(!empty($variants)) {
                foreach($variants as $variant) {
                    $items[$variant->id] = new stdClass();
                    $items[$variant->id]->variant = $variant;
                    $items[$variant->id]->amount = $session_items[$variant->id];
                    $products_ids[] = $variant->product_id;
                }
                
                $products = array();
                $images_ids = array();
                foreach($this->products->get_products(array('id'=>$products_ids, 'limit'=>count($products_ids))) as $p) {
                    $products[$p->id]=$p;
                    $images_ids[] = $p->main_image_id;
                }
                
                if (!empty($images_ids)) {
                    $images = $this->products->get_images(array('id'=>$images_ids));
                    foreach ($images as $image) {
                        $products[$image->product_id]->image = $image;
                    }
                }
                
                foreach($items as $variant_id=>$item) {
                    $purchase = null;
                    if(!empty($products[$item->variant->product_id])) {
                        $purchase = new stdClass();
                        $purchase->product = $products[$item->variant->product_id];
                        $purchase->variant = $item->variant;
                        $purchase->amount = $item->amount;
                        
                        $cart->purchases[] = $purchase;
                        $cart->total_price += $item->variant->price*$item->amount;
                        $cart->total_products += $item->amount;
                    }
                }
                
                // Пользовательская скидка
                $cart->discount = 0;
                if(isset($_SESSION['user_id']) && $user = $this->users->get_user(intval($_SESSION['user_id']))) {
                    $cart->discount = $user->discount;
                }
                
                $cart->total_price *= (100-$cart->discount)/100;
                
                // Скидка по купону
                if(isset($_SESSION['coupon_code'])) {
                    $cart->coupon = $this->coupons->get_coupon($_SESSION['coupon_code']);
                    if($cart->coupon && $cart->coupon->valid && $cart->total_price>=$cart->coupon->min_order_price) {
                        if($cart->coupon->type=='absolute') {
                            // Абсолютная скидка не более суммы заказа
                            $cart->coupon_discount = $cart->total_price>$cart->coupon->value?$cart->coupon->value:$cart->total_price;
                            $cart->total_price = max(0, $cart->total_price-$cart->coupon->value);
                            $cart->coupon->coupon_percent = round(100-($cart->total_price*100)/($cart->total_price+$cart->coupon->value),2);
                        } else {
                            $cart->coupon->coupon_percent = $cart->coupon->value;
                            $cart->coupon_discount = $cart->total_price * ($cart->coupon->value)/100;
                            $cart->total_price = $cart->total_price-$cart->coupon_discount;
                        }
                    } else {
                        unset($_SESSION['coupon_code']);
                    }
                }
            }
        }
        return $cart;
    }

    /*Добавление товара в корзину*/
    public function add_item($variant_id, $amount = 1) {
        // Выберем товар из базы, заодно убедившись в его существовании
        $variant = $this->variants->get_variant($variant_id);
        // Если товар существует, добавим его в корзину
        if(!empty($variant) && ($variant->stock>0 || $this->settings->is_preorder)) {
            $amount = max(1, $amount);
            if(isset($_SESSION['shopping_cart'][$variant_id])) {
                $amount = max(1, $amount+$_SESSION['shopping_cart'][$variant_id]);
            }
            // Не дадим больше чем на складе
            $amount = min($amount, ($variant->stock ? $variant->stock : min($this->settings->max_order_amount, $amount)));
            $_SESSION['shopping_cart'][$variant_id] = intval($amount);
        }
    }

    /*Обновление товара в корзине*/
    public function update_item($variant_id, $amount = 1) {
        // Выберем товар из базы, заодно убедившись в его существовании
        $variant = $this->variants->get_variant($variant_id);
        // Если товар существует, добавим его в корзину
        if(!empty($variant) && ($variant->stock>0 || $this->settings->is_preorder)) {
            $amount = max(1, $amount);
            // Не дадим больше чем на складе
            $amount = min($amount, ($variant->stock ? $variant->stock : min($this->settings->max_order_amount, $amount)));
            $_SESSION['shopping_cart'][$variant_id] = intval($amount);
        }
    }

    /*Удаление товара из корзины*/
    public function delete_item($variant_id) {
        unset($_SESSION['shopping_cart'][$variant_id]);
    }

    /*Очистка корзины*/
    public function empty_cart() {
        unset($_SESSION['shopping_cart']);
        unset($_SESSION['coupon_code']);
    }

    /*Применение купона в корзине*/
    public function apply_coupon($coupon_code) {
        $coupon = $this->coupons->get_coupon((string)$coupon_code);
        if($coupon && $coupon->valid) {
            $_SESSION['coupon_code'] = $coupon->code;
        } else {
            unset($_SESSION['coupon_code']);
        }
    }
    
}
