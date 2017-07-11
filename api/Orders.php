<?php

require_once('Okay.php');

class Orders extends Okay {

    /*Выборка конкретного заказа*/
    public function get_order($id) {
        if (empty($id)) {
            return false;
        }
        if(is_int($id)) {
            $where = $this->db->placehold('AND o.id=? ', intval($id));
        } else {
            $where = $this->db->placehold('AND  o.url=? ', $id);
        }
        
        $query = $this->db->placehold("SELECT  
                o.id, 
                o.delivery_id, 
                o.delivery_price, 
                o.separate_delivery, 
                o.payment_method_id, 
                o.paid, 
                o.payment_date, 
                o.closed, 
                o.discount, 
                o.coupon_code, 
                o.coupon_discount, 
                o.date, 
                o.user_id, 
                o.name, 
                o.address, 
                o.phone, 
                o.email, 
                o.comment, 
                o.status_id, 
                o.url, 
                o.total_price, 
                o.note, 
                o.ip, 
                o.lang_id
            FROM __orders o 
            WHERE 
                1 
                $where 
            LIMIT 1
        ");
        
        if($this->db->query($query)) {
            return $this->db->result();
        } else {
            return false;
        }
    }

    /*Выборка всех заказов*/
    public function get_orders($filter = array()) {
        // По умолчанию
        $limit = 100;
        $page = 1;
        $keyword_filter = '';
        $label_filter = '';
        $status_filter = '';
        $user_filter = '';
        $modified_since_filter = '';
        $id_filter = '';
        $date_filter = '';
        
        if(isset($filter['limit'])) {
            $limit = max(1, intval($filter['limit']));
        }
        
        if(isset($filter['page'])) {
            $page = max(1, intval($filter['page']));
        }
        
        $sql_limit = $this->db->placehold(' LIMIT ?, ? ', ($page-1)*$limit, $limit);
        
        if(!empty($filter['status'])) {
            $status_filter = $this->db->placehold('AND o.status_id = ?', intval($filter['status']));
        }
        
        if(isset($filter['id'])) {
            $id_filter = $this->db->placehold('AND o.id in(?@)', (array)$filter['id']);
        }
        
        if(isset($filter['user_id'])) {
            $user_filter = $this->db->placehold('AND o.user_id = ?', intval($filter['user_id']));
        }
        
        if(isset($filter['modified_since'])) {
            $modified_since_filter = $this->db->placehold('AND o.modified > ?', $filter['modified_since']);
        }
        
        if(isset($filter['label'])) {
            $label_filter = $this->db->placehold('AND ol.label_id = ?', $filter['label']);
        }
        
        if(!empty($filter['keyword'])) {
            $keywords = explode(' ', $filter['keyword']);
            foreach($keywords as $keyword) {
                $keyword_filter .= $this->db->placehold('AND (
                    o.id = "'.$this->db->escape(trim($keyword)).'" 
                    OR o.name LIKE "%'.$this->db->escape(trim($keyword)).'%" 
                    OR REPLACE(o.phone, "-", "")  LIKE "%'.$this->db->escape(str_replace('-', '', trim($keyword))).'%" 
                    OR o.address LIKE "%'.$this->db->escape(trim($keyword)).'%" 
                    OR o.email LIKE "%'.$this->db->escape(trim($keyword)).'%"
                    OR o.id in (SELECT order_id FROM __purchases WHERE product_name LIKE "%'.$this->db->escape(trim($keyword)).'%" OR variant_name LIKE "%'.$this->db->escape(trim($keyword)).'%")
                ) ');
            }
        }

        if(!empty($filter['from_date']) || !empty($filter['to_date'])){
                if(!empty($filter['from_date'])){
                    $from = date('Y-m-d',strtotime($filter['from_date']));
                }else{
                    $from = '1970-01-01'; /*если стартовой даты нет, берем время с эпохи UNIX*/
                }
                if(!empty($filter['to_date'])){
                    $to = date('Y-m-d',strtotime($filter['to_date']));
                }else{
                    $to = date('Y-m-d'); /*если конечной даты нет, берем за дату "сегодня"*/
                }
                $date_filter = $this->db->placehold("AND (o.date BETWEEN ? AND ?)",$from,$to);
        }
        
        // Выбираем заказы
        $query = $this->db->placehold("SELECT 
                o.id, 
                o.delivery_id, 
                o.delivery_price, 
                o.separate_delivery, 
                o.payment_method_id, 
                o.paid, 
                o.payment_date, 
                o.closed, 
                o.discount, 
                o.coupon_code, 
                o.coupon_discount, 
                o.date, 
                o.user_id, 
                o.name, 
                o.address, 
                o.phone, 
                o.email, 
                o.comment, 
                o.status_id, 
                o.url, 
                o.total_price, 
                o.note, 
                o.lang_id
            FROM __orders AS o
            LEFT JOIN __orders_labels AS ol ON o.id=ol.order_id
            WHERE 
                1
                $id_filter 
                $status_filter 
                $user_filter 
                $keyword_filter 
                $label_filter 
                $modified_since_filter
                $date_filter
            GROUP BY o.id 
            ORDER BY o.id DESC
            $sql_limit
        ", "%Y-%m-%d");
        $this->db->query($query);
        $orders = array();
        foreach($this->db->results() as $order) {
            $orders[$order->id] = $order;
        }
        return $orders;
    }

    /*Подсчет количества заказов*/
    public function count_orders($filter = array()) {
        $keyword_filter = '';
        $label_filter = '';
        $status_filter = '';
        $user_filter = '';
        $date_filter = '';
        
        if(!empty($filter['status'])) {
            $status_filter = $this->db->placehold('AND o.status_id = ?', intval($filter['status']));
        }
        
        if(isset($filter['user_id'])) {
            $user_filter = $this->db->placehold('AND o.user_id = ?', intval($filter['user_id']));
        }
        
        if(isset($filter['label'])) {
            $label_filter = $this->db->placehold('AND ol.label_id = ?', $filter['label']);
        }
        
        if(!empty($filter['keyword'])) {
            $keywords = explode(' ', $filter['keyword']);
            foreach($keywords as $keyword) {
                $keyword_filter .= $this->db->placehold('AND (
                    o.id = "'.$this->db->escape(trim($keyword)).'" 
                    OR o.name LIKE "%'.$this->db->escape(trim($keyword)).'%" 
                    OR REPLACE(o.phone, "-", "")  LIKE "%'.$this->db->escape(str_replace('-', '', trim($keyword))).'%" 
                    OR o.address LIKE "%'.$this->db->escape(trim($keyword)).'%" 
                    OR o.email LIKE "%'.$this->db->escape(trim($keyword)).'%"
                    OR o.id in (SELECT order_id FROM __purchases WHERE product_name LIKE "%'.$this->db->escape(trim($keyword)).'%" OR variant_name LIKE "%'.$this->db->escape(trim($keyword)).'%")
                ) ');
            }
        }

        if(!empty($filter['from_date']) || !empty($filter['to_date'])){
            if(!empty($filter['from_date'])){
                $from = $filter['from_date'];
            }else{
                $from = '1970-01-01'; /*если стартовой даты нет, берем время с эпохи UNIX*/
            }
            if(!empty($filter['to_date'])){
                $to = $filter['to_date'];
            }else{
                $to = date('Y-m-d'); /*если конечной даты нет, берем за дату "сегодня"*/
            }
            $date_filter = $this->db->placehold("AND (o.date BETWEEN ? AND ?)",$from,$to);
        }
        
        // Выбираем заказы
        $query = $this->db->placehold("SELECT COUNT(DISTINCT id) as count
            FROM __orders AS o
            LEFT JOIN __orders_labels AS ol ON o.id=ol.order_id
            WHERE 
                1
                $status_filter 
                $user_filter 
                $label_filter 
                $keyword_filter
                $date_filter
        ");
        $this->db->query($query);
        return $this->db->result('count');
    }

    /*Обновление заказа*/
    public function update_order($id, $order) {
        $order = (object)$order;

        $query = $this->db->placehold("UPDATE __orders SET ?%, modified=now() WHERE id=? LIMIT 1", $order, intval($id));
        $this->db->query($query);
        $this->update_total_price(intval($id));
        return $id;
    }

    /*Удаление заказа*/
    public function delete_order($id) {
        if(!empty($id)) {
            $query = $this->db->placehold("DELETE FROM __purchases WHERE order_id=?", $id);
            $this->db->query($query);
            
            $query = $this->db->placehold("DELETE FROM __orders_labels WHERE order_id=?", $id);
            $this->db->query($query);
            
            $query = $this->db->placehold("DELETE FROM __orders WHERE id=? LIMIT 1", $id);
            $this->db->query($query);
        }
    }

    /*Добавления заказа*/
    public function add_order($order) {
        $order = (object)$order;
        $order->url = md5(uniqid($this->config->salt, true));
        $set_curr_date = '';
        if(empty($order->date)) {
            $set_curr_date = ', date=now()';
        }
        $all_status = $this->orderstatus->get_status();
        $order->status_id = reset($all_status)->id;
        $query = $this->db->placehold("INSERT INTO __orders SET ?%$set_curr_date", $order);
        $this->db->query($query);
        $id = $this->db->insert_id();
        if(reset($all_status)->is_close == 1){
            $this->orders->close(intval($id));
        } else {
            $this->orders->open(intval($id));
        }

        return $id;
    }

    /*Выборка покупки по его ID*/
    public function get_purchase($id) {
        $query = $this->db->placehold("SELECT * FROM __purchases WHERE id=? LIMIT 1", intval($id));
        $this->db->query($query);
        return $this->db->result();
    }

    /*Выборка списка покупок с заказов*/
    public function get_purchases($filter = array()) {
        $order_id_filter = '';
        if(!empty($filter['order_id'])) {
            $order_id_filter = $this->db->placehold('AND order_id in(?@)', (array)$filter['order_id']);
        }
        
        $query = $this->db->placehold("SELECT * FROM __purchases WHERE 1 $order_id_filter ORDER BY id");
        $this->db->query($query);
        return $this->db->results();
    }

    /*Обновление покупки(товара)*/
    public function update_purchase($id, $purchase) {
        $purchase = (object)$purchase;
        $old_purchase = $this->get_purchase($id);
        if(!$old_purchase) {
            return false;
        }
        
        $order = $this->get_order(intval($old_purchase->order_id));
        if(!$order) {
            return false;
        }
        
        // Не допустить нехватки на складе
        $variant = $this->variants->get_variant($purchase->variant_id);
        if($order->closed && !empty($purchase->amount) && !empty($variant) && !$variant->infinity && $variant->stock<($purchase->amount-$old_purchase->amount)) {
            return false;
        }
        
        // Если заказ закрыт, нужно обновить склад при изменении покупки
        if($order->closed && !empty($purchase->amount)) {
            if($old_purchase->variant_id != $purchase->variant_id) {
                if(!empty($old_purchase->variant_id)) {
                    $query = $this->db->placehold("UPDATE __variants SET stock=stock+? WHERE id=? AND stock IS NOT NULL LIMIT 1", $old_purchase->amount, $old_purchase->variant_id);
                    $this->db->query($query);
                }
                if(!empty($purchase->variant_id)) {
                    $query = $this->db->placehold("UPDATE __variants SET stock=stock-? WHERE id=? AND stock IS NOT NULL LIMIT 1", $purchase->amount, $purchase->variant_id);
                    $this->db->query($query);
                }
            } elseif(!empty($purchase->variant_id)) {
                $query = $this->db->placehold("UPDATE __variants SET stock=stock+(?) WHERE id=? AND stock IS NOT NULL LIMIT 1", $old_purchase->amount - $purchase->amount, $purchase->variant_id);
                $this->db->query($query);
            }
        }
        
        $query = $this->db->placehold("UPDATE __purchases SET ?% WHERE id=? LIMIT 1", $purchase, intval($id));
        $this->db->query($query);
        $this->update_total_price($order->id);
        return $id;
    }

    /*Добавление покупки(товара в заказе)*/
    public function add_purchase($purchase) {
        $purchase = (object)$purchase;
        if(!empty($purchase->variant_id)) {
            $variant = $this->variants->get_variant($purchase->variant_id);
            if(empty($variant)) {
                return false;
            }
            $product = $this->products->get_product(intval($variant->product_id));
            if(empty($product)) {
                return false;
            }
        }
        
        $order = $this->get_order(intval($purchase->order_id));
        if(empty($order)) {
            return false;
        }
        
        // Не допустить нехватки на складе
        if($order->closed && !empty($purchase->amount) && !$variant->infinity && $variant->stock<$purchase->amount) {
            return false;
        }
        
        if(!isset($purchase->product_id) && isset($variant)) {
            $purchase->product_id = $variant->product_id;
        }
        
        if(!isset($purchase->product_name)  && !empty($product)) {
            $purchase->product_name = $product->name;
        }
        
        if(!isset($purchase->sku) && !empty($variant)) {
            $purchase->sku = $variant->sku;
        }
        
        if(!isset($purchase->variant_name) && !empty($variant)) {
            $purchase->variant_name = $variant->name;
        }
        
        if(!isset($purchase->price) && !empty($variant)) {
            $purchase->price = $variant->price;
        }
        
        if(!isset($purchase->amount)) {
            $purchase->amount = 1;
        }

        if(!isset($purchase->units) && !empty($variant)) {
            $purchase->units = $variant->units;
        }
        
        // Если заказ закрыт, нужно обновить склад при добавлении покупки
        if($order->closed && !empty($purchase->amount) && !empty($variant->id)) {
            $stock_diff = $purchase->amount;
            $query = $this->db->placehold("UPDATE __variants SET stock=stock-? WHERE id=? AND stock IS NOT NULL LIMIT 1", $stock_diff, $variant->id);
            $this->db->query($query);
        }
        
        $query = $this->db->placehold("INSERT INTO __purchases SET ?%", $purchase);
        $this->db->query($query);
        $purchase_id = $this->db->insert_id();
        
        $this->update_total_price($order->id);
        return $purchase_id;
    }

    /*Удаление покупки*/
    public function delete_purchase($id) {
        $purchase = $this->get_purchase($id);
        if(!$purchase) {
            return false;
        }
        
        $order = $this->get_order(intval($purchase->order_id));
        if(!$order) {
            return false;
        }
        
        // Если заказ закрыт, нужно обновить склад при изменении покупки
        if($order->closed && !empty($purchase->amount)) {
            $stock_diff = $purchase->amount;
            $query = $this->db->placehold("UPDATE __variants SET stock=stock+? WHERE id=? AND stock IS NOT NULL LIMIT 1", $stock_diff, $purchase->variant_id);
            $this->db->query($query);
        }
        
        $query = $this->db->placehold("DELETE FROM __purchases WHERE id=? LIMIT 1", intval($id));
        $this->db->query($query);
        $this->update_total_price($order->id);
        return true;
    }

    /*Закрытие заказа(списание количества)*/
    public function close($order_id) {
        $order = $this->get_order(intval($order_id));
        if(empty($order)) {
            return false;
        }
        
        if(!$order->closed) {
            $variants_amounts = array();
            $purchases = $this->get_purchases(array('order_id'=>$order->id));
            foreach($purchases as $purchase) {
                if(isset($variants_amounts[$purchase->variant_id])) {
                    $variants_amounts[$purchase->variant_id] += $purchase->amount;
                } else {
                    $variants_amounts[$purchase->variant_id] = $purchase->amount;
                }
            }
            
            foreach($variants_amounts as $id=>$amount) {
                $variant = $this->variants->get_variant($id);
                if(empty($variant) || ($variant->stock<$amount)) {
                    return false;
                }
            }
            foreach($purchases as $purchase) {
                $variant = $this->variants->get_variant($purchase->variant_id);
                if(!$variant->infinity) {
                    $new_stock = $variant->stock-$purchase->amount;
                    $this->variants->update_variant($variant->id, array('stock'=>$new_stock));
                }
            }
            $query = $this->db->placehold("UPDATE __orders SET closed=1, modified=NOW() WHERE id=? LIMIT 1", $order->id);
            $this->db->query($query);
        }
        return $order->id;
    }

    /*Открытие заказа (возвращение количества)*/
    public function open($order_id) {
        $order = $this->get_order(intval($order_id));
        if(empty($order)) {
            return false;
        }
        
        if($order->closed) {
            $purchases = $this->get_purchases(array('order_id'=>$order->id));
            foreach($purchases as $purchase) {
                $variant = $this->variants->get_variant($purchase->variant_id);
                if($variant && !$variant->infinity) {
                    $new_stock = $variant->stock+$purchase->amount;
                    $this->variants->update_variant($variant->id, array('stock'=>$new_stock));
                }
            }
            $query = $this->db->placehold("UPDATE __orders SET closed=0, modified=NOW() WHERE id=? LIMIT 1", $order->id);
            $this->db->query($query);
        }
        return $order->id;
    }

    /*Обновление итого заказа*/
    private function update_total_price($order_id) {
        $order = $this->get_order(intval($order_id));
        if(empty($order)) {
            return false;
        }
        
        $query = $this->db->placehold("UPDATE __orders o SET o.total_price=IFNULL((SELECT SUM(p.price*p.amount)*(100-o.discount)/100 FROM __purchases p WHERE p.order_id=o.id), 0)+o.delivery_price*(1-o.separate_delivery)-o.coupon_discount, modified=NOW() WHERE o.id=? LIMIT 1", $order->id);
        $this->db->query($query);
        return $order->id;
    }

}
