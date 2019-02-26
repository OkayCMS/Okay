<?php

require_once('Okay.php');

class Feedbacks extends Okay {

    /*Выборка конкретной заявки с формы обратной связи*/
    public function get_feedback($id) {
        if (empty($id)) {
            return false;
        }
        $feedback_id_filter = $this->db->placehold('AND f.id=?', intval($id));
        $query = $this->db->placehold("SELECT 
                f.id, 
                f.name, 
                f.email, 
                f.ip, 
                f.message,
                f.is_admin,
                f.parent_id,
                f.processed,
                f.date,
                f.lang_id
            FROM __feedbacks f
            WHERE 
                1
                $feedback_id_filter 
            LIMIT 1
        ");
        if($this->db->query($query)) {
            return $this->db->result();
        } else {
            return false;
        }
    }

    /*Выборка всех заявок с формы обратной связи*/
    public function get_feedbacks($filter = array(), $count = false) {
        // По умолчанию
        $limit = 100;
        $page = 1;
        $joins = '';
        $where = '1';
        $group_by = '';
        $order = 'f.id ASC';
        $select = "f.id, 
                f.name, 
                f.email, 
                f.ip, 
                f.message,
                f.is_admin,
                f.parent_id,
                f.processed,
                f.date,
                f.lang_id";

        if ($count === true) {
            $select = "COUNT(DISTINCT f.id) as count";
        }
        
        if(isset($filter['limit'])) {
            $limit = max(1, intval($filter['limit']));
        }

        if(isset($filter['page'])) {
            $page = max(1, intval($filter['page']));
        }
        
        $sql_limit = $this->db->placehold(' LIMIT ?, ? ', ($page-1)*$limit, $limit);

        if(isset($filter['processed'])) {
            $where .= $this->db->placehold(' AND f.processed=?',$filter['processed']);
        }
        
        if(!empty($filter['keyword'])) {
            $keywords = explode(' ', $filter['keyword']);
            $keyword_filter = ' ';
            foreach($keywords as $keyword) {
                $keyword_filter .= $this->db->placehold('AND (
                    f.name LIKE "%'.$this->db->escape(trim($keyword)).'%" 
                    OR f.message LIKE "%'.$this->db->escape(trim($keyword)).'%" 
                    OR f.email LIKE "%'.$this->db->escape(trim($keyword)).'%" 
                ) ');
            }
            $where .= $keyword_filter;
        }
        
        if (isset($filter['has_parent'])) {
            $where .= ' AND f.parent_id'.($filter['has_parent'] ? '>0' : '=0');
        }
        
        if(!empty($filter['parent_id'])) {
            $where .= $this->db->placehold(' AND f.parent_id IN(?@)', (array)$filter['parent_id']);
        }

        if (!empty($filter['sort'])) {
            switch ($filter['sort']) {
                case 'new_first':
                    $order = 'f.id DESC';
                    break;
            }
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
            FROM __feedbacks f
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

    /*Подсчет количества заявок с формы обратной связи*/
    public function count_feedbacks($filter = array()) {
        return $this->get_feedbacks($filter, true);
    }

    /*Добавление заявки с формы обратной связи*/
    public function add_feedback($feedback) {
        $query = $this->db->placehold('INSERT INTO __feedbacks SET ?%, date = NOW()', $feedback);
        
        if(!$this->db->query($query)) {
            return false;
        }
        $id = $this->db->insert_id();
        return $id;
    }

    /*Обновление заявки с формы обратной связи*/
    public function update_feedback($id, $feedback) {
        $date_query = '';
        if(isset($feedback->date)) {
            $date = $feedback->date;
            unset($feedback->date);
            $date_query = $this->db->placehold(', date=STR_TO_DATE(?, ?)', $date, $this->settings->date_format);
        }
        $query = $this->db->placehold("UPDATE __feedbacks SET ?% $date_query WHERE id in(?@) LIMIT 1", $feedback, (array)$id);
        $this->db->query($query);
        return $id;
    }

    /*Удаление заявки с формы обратной связи*/
    public function delete_feedback($id) {
        if(!empty($id)) {
            $query = $this->db->placehold("DELETE FROM __feedbacks WHERE id=? LIMIT 1", intval($id));
            $this->db->query($query);

            $this->db->query('SELECT id from __feedbacks where parent_id=?', intval($id));
            $children = $this->db->results('id');
            foreach($children as $child_id) {
                $this->delete_feedback($child_id);
            }
        }
    }
    
}
