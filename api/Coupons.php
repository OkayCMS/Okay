<?php

require_once('Okay.php');

class Coupons extends Okay {

    /*Выборка конкретного купона*/
    public function get_coupon($id) {
        if (empty($id)) {
            return false;
        }
        if(gettype($id) == 'string') {
            $where = $this->db->placehold('AND c.code=? ', $id);
        } else {
            $where = $this->db->placehold('AND c.id=? ', $id);
        }
        
        $query = $this->db->placehold("SELECT 
                c.id, 
                c.code, 
                c.value, 
                c.type, 
                c.expire, 
                c.min_order_price, 
                c.single, 
                c.usages,
                ((DATE(NOW()) <= DATE(c.expire) OR c.expire IS NULL) AND (c.usages=0 OR NOT c.single)) AS valid
            FROM __coupons c 
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

    /*Выборка всех купонов*/
    public function get_coupons($filter = array(), $count = false) {
        // По умолчанию
        $limit = 1000;
        $page = 1;
        $joins = '';
        $where = '1';
        $group_by = '';
        $order = 'valid DESC, c.id DESC';
        $select = "c.id, 
                c.code, 
                c.value, 
                c.type, 
                c.expire, 
                c.min_order_price, 
                c.single, 
                c.usages, 
        		((DATE(NOW()) <= DATE(c.expire) OR c.expire IS NULL) AND (c.usages=0 OR NOT c.single)) AS valid";

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
        
        if(!empty($filter['id'])) {
            $where .= $this->db->placehold(' AND c.id in(?@)', (array)$filter['id']);
        }
        
        if(isset($filter['valid'])) {
            if($filter['valid']) {
                $where .= $this->db->placehold(' AND ((DATE(NOW()) <= DATE(c.expire) OR c.expire IS NULL) AND (c.usages=0 OR NOT c.single))');
            } else {
                $where .= $this->db->placehold(' AND NOT ((DATE(NOW()) <= DATE(c.expire) OR c.expire IS NULL) AND (c.usages=0 OR NOT c.single))');
            }
        }
        
        if(isset($filter['keyword'])) {
            $keywords = explode(' ', $filter['keyword']);
            $keyword_filter = ' ';
            foreach($keywords as $keyword) {
                $keyword_filter .= $this->db->placehold('AND (
                    c.code LIKE "%'.$this->db->escape(trim($keyword)).'%" 
                ) ');
            }
            $where .= $keyword_filter;
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
            FROM __coupons c 
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

    /*Подсчитываем количество купонов*/
    public function count_coupons($filter = array()) {
        return $this->get_coupons($filter, true);
    }

    /*Добавление купона*/
    public function add_coupon($coupon) {
        if(empty($coupon->single)) {
            $coupon->single = 0;
        }
        $query = $this->db->placehold("INSERT INTO __coupons SET ?%", $coupon);
        
        if(!$this->db->query($query)) {
            return false;
        } else {
            return $this->db->insert_id();
        }
    }

    /*Обновление купона*/
    public function update_coupon($id, $coupon) {
        $query = $this->db->placehold("UPDATE __coupons SET ?% WHERE id in(?@) LIMIT ?", $coupon, (array)$id, count((array)$id));
        $this->db->query($query);
        return $id;
    }

    /*Удаление купона*/
    public function delete_coupon($id) {
        if(!empty($id)) {
            $query = $this->db->placehold("DELETE FROM __coupons WHERE id=? LIMIT 1", intval($id));
            return $this->db->query($query);
        }
    }
    
}
