<?php

require_once('Okay.php');

class Callbacks extends Okay {

    /*Выбираем конкретную заявку на обратный звонок*/
    public function get_callback($id) {
        $query = $this->db->placehold("SELECT 
                c.id, 
                c.name, 
                c.phone, 
                c.message, 
                c.date, 
                c.processed,
                c.url,
                c.admin_notes
            FROM __callbacks c 
            WHERE id=? 
            LIMIT 1
        ", intval($id));
        
        if($this->db->query($query)) {
            return $this->db->result();
        } else {
            return false;
        }
    }

    /*Выбираем заявки на обратный звонок*/
    public function get_callbacks($filter = array(), $count = false) {
        // По умолчанию
        $limit = 1000;
        $page = 1;
        $joins = '';
        $where = '1';
        $group_by = '';
        $order = 'c.date DESC ';
        $select = "c.id, 
                c.name, 
                c.phone, 
                c.date, 
                c.message, 
                c.processed,
                c.url,
                c.admin_notes";

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
        
        if(isset($filter['processed'])) {
            $where .= $this->db->placehold(' AND c.processed=?',$filter['processed']);
        }
        
        if(!empty($filter['keyword'])) {
            $keywords = explode(' ', $filter['keyword']);
            $keyword_filter = ' ';
            foreach($keywords as $keyword) {
                $keyword_filter .= $this->db->placehold('AND (
                    c.name LIKE "%'.$this->db->escape(trim($keyword)).'%" 
                    OR c.message LIKE "%'.$this->db->escape(trim($keyword)).'%" 
                    OR c.phone LIKE "%'.$this->db->escape(trim($keyword)).'%" 
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
            FROM __callbacks c 
            $joins
            WHERE 
                $where
                $group_by
                $order
                $sql_limit
        ");
        
        $this->db->query($query);
        $this->db->query($query);
        if ($count === true) {
            return $this->db->result('count');
        } else {
            return $this->db->results();
        }
    }

    /*Подсчитываем количество заявок на обратный звонок*/
    public function count_callbacks($filter = array()) {
        return $this->get_callbacks($filter, true);
    }

    /*Добавление заявки на обратный звонок*/
    public function add_callback($callback) {
        $query = $this->db->placehold('INSERT INTO __callbacks SET ?%, date = NOW()', $callback);
        
        if(!$this->db->query($query)) {
            return false;
        }
        
        $id = $this->db->insert_id();
        return $id;
    }

    /*Обновление заявки на обратный звонок*/
    public function update_callback($id, $callback) {
        $query = $this->db->placehold("UPDATE __callbacks SET ?% WHERE id in(?@) LIMIT 1", $callback, (array)$id);
        $this->db->query($query);
        return $id;
    }

    /*Удаление заявки на обратный звонок*/
    public function delete_callback($id) {
        if(!empty($id)) {
            $query = $this->db->placehold("DELETE FROM __callbacks WHERE id=? LIMIT 1", intval($id));
            $this->db->query($query);
        }
    }
    
}
