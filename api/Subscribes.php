<?php

require_once('Okay.php');

class Subscribes extends Okay {

    /*Выборка всех подписчиков*/
    public function get_subscribes($filter = array(), $count = false) {
        // По умолчанию
        $limit = 100;
        $page = 1;
        $joins = '';
        $where = '1';
        $group_by = '';
        $order = '';
        $select = "s.id, 
                s.email";

        if ($count === true) {
            $select = "COUNT(DISTINCT s.id) as count";
        }

        if(isset($filter['limit'])) {
            $limit = max(1, intval($filter['limit']));
        }

        if(isset($filter['page'])) {
            $page = max(1, intval($filter['page']));
        }

        $sql_limit = $this->db->placehold(' LIMIT ?, ? ', ($page-1)*$limit, $limit);
        
        if (isset($filter['keyword'])) {
            $where .= ' AND s.email like "%'.$this->db->escape(trim($filter['keyword'])).'%"';
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
            FROM __subscribe_mailing s
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

    /*Подсчет количества подписчиков*/
    public function count_subscribes($filter = array()) {
        return $this->get_subscribes($filter, true);
    }

    /*Выборка конкретного подписчика*/
    public function get_subscribe($id) {
        $filter = $this->db->placehold('AND id = ?', $id);
        $query = "SELECT 
                id, 
                email
            FROM __subscribe_mailing 
            WHERE 
                1 
                $filter 
            LIMIT 1";
        $this->db->query($query);
        return $this->db->result();
    }

    /*Добавление подписчика*/
    public function add_subscribe($subscribe) {
        $subscribe = (array)$subscribe;
        $this->db->query("INSERT INTO __subscribe_mailing SET ?%", $subscribe);
        return $this->db->insert_id();
    }

    /*Обновления подписчика*/
    public function update_subscribe($id, $subscribe) {
        $query = $this->db->placehold("UPDATE __subscribe_mailing SET ?% WHERE id=? LIMIT 1", $subscribe, intval($id));
        $this->db->query($query);
        return $id;
    }

    /*Удаление подписчка*/
    public function delete_subscribe($ids) {
        if(!empty($ids)) {
        	$this->db->query('delete from __subscribe_mailing where id in(?@)', $ids);
        }
    }
    
}
