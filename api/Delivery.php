<?php

require_once('Okay.php');

class Delivery extends Okay {

    /*Выборка конкретного способа доставки*/
    public function get_delivery($id) {
        if (empty($id)) {
            return false;
        }
        $delivery_id_filter = $this->db->placehold('AND d.id=?', intval($id));
        $lang_sql = $this->languages->get_query(array('object'=>'delivery'));
        $query = $this->db->placehold("SELECT 
                d.id, 
                d.free_from, 
                d.price, 
                d.enabled, 
                d.position, 
                d.separate_payment,
                d.image,
                $lang_sql->fields
            FROM __delivery d
            $lang_sql->join
            WHERE 
                1 
                $delivery_id_filter 
            LIMIT 1 
        ");
        
        $this->db->query($query);
        return $this->db->result();
    }

    /*Выборка всех способов доставки*/
    public function get_deliveries($filter = array(), $count = false) {
        // По умолчанию
        $limit = 100;
        $page = 1;
        $joins = '';
        $where = '1';
        $group_by = '';
        $order = 'd.position';
        $lang_sql = $this->languages->get_query(array('object'=>'delivery'));
        $select = "d.id, 
                d.free_from, 
                d.price, 
                d.enabled, 
                d.position, 
                d.separate_payment,
                d.image,
                $lang_sql->fields";

        if ($count === true) {
            $select = "COUNT(DISTINCT c.id) as count";
        }

        if(isset($filter['limit'])) {
            $limit = max(1, intval($filter['limit']));
        }

        if(isset($filter['page'])) {
            $page = max(1, intval($filter['page']));
        }

        $sql_limit = $this->db->placehold(' LIMIT ?, ? ', ($page-1)*$limit, $limit);
        
        if(!empty($filter['enabled'])) {
            $where .= $this->db->placehold(' AND enabled=?', intval($filter['enabled']));
        }

        if (!empty($order)) {
            $order = "ORDER BY $order";
        }

        // При подсчете нам эти переменные не нужны
        if ($count === true) {
            $order      = '';
            $group_by   = '';
            $sql_limit  = '';
        }

        $query = $this->db->placehold("SELECT $select
            FROM __delivery d
            $lang_sql->join
            $joins
            WHERE 
                $where
                $group_by
                $order 
                $sql_limit
        ");
        $this->db->query($query);
        if ($count === true) {
            return $this->db->result('count');
        } else {
            return $this->db->results();
        }
    }

    /*Обновление способа доставки*/
    public function update_delivery($id, $delivery) {
        $delivery = (object)$delivery;
        // Проверяем есть ли мультиязычность и забираем описания для перевода
        $result = $this->languages->get_description($delivery, 'delivery');
        
        $query = $this->db->placehold("UPDATE __delivery SET ?% WHERE id in(?@)", $delivery, (array)$id);
        $this->db->query($query);
        
        // Если есть описание для перевода. Указываем язык для обновления
        if(!empty($result->description)) {
            $this->languages->action_description($id, $result->description, 'delivery', $this->languages->lang_id());
        }
        return $id;
    }

    /*Добавление способа доставки*/
    public function add_delivery($delivery) {
        $delivery = (object)$delivery;
        // Проверяем есть ли мультиязычность и забираем описания для перевода
        $result = $this->languages->get_description($delivery, 'delivery');
        
        $query = $this->db->placehold('INSERT INTO __delivery SET ?%', $delivery);
        if(!$this->db->query($query)) {
            return false;
        }
        
        $id = $this->db->insert_id();
        
        // Если есть описание для перевода. Указываем язык для обновления
        if(!empty($result->description)) {
            $this->languages->action_description($id, $result->description, 'delivery');
        }
        
        $this->db->query("UPDATE __delivery SET position=id WHERE id=?", intval($id));
        return $id;
    }

    /*Удаление способа доставки*/
    public function delete_delivery($id) {
        // Удаляем связь доставки с методоми оплаты
        $query = $this->db->placehold("DELETE FROM __delivery_payment WHERE delivery_id=?", intval($id));
        $this->db->query($query);
        
        if(!empty($id)) {
            $this->image->delete_image($id, 'image', 'delivery', $this->config->original_deliveries_dir, $this->config->resized_deliveries_dir);
            $query = $this->db->placehold("DELETE FROM __delivery WHERE id=? LIMIT 1", intval($id));
            $this->db->query($query);
            $this->db->query("DELETE FROM __lang_delivery WHERE delivery_id=?", intval($id));
        }
    }

    /*Выборка доступных способов оплаты для данного способа доставки*/
    public function get_delivery_payments($id) {
        $query = $this->db->placehold("SELECT payment_method_id FROM __delivery_payment WHERE delivery_id=?", intval($id));
        $this->db->query($query);
        return $this->db->results('payment_method_id');
    }

    /*Обновление способов оплаты у данного способа доставки*/
    public function update_delivery_payments($id, $payment_methods_ids) {
        $query = $this->db->placehold("DELETE FROM __delivery_payment WHERE delivery_id=?", intval($id));
        $this->db->query($query);
        if(is_array($payment_methods_ids)) {
            foreach($payment_methods_ids as $p_id) {
                $this->db->query("INSERT INTO __delivery_payment SET delivery_id=?, payment_method_id=?", $id, $p_id);
            }
        }
    }
    
}
