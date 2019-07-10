<?php

require_once('Okay.php');

class Comments extends Okay {

    /*Выбираем конкретный комментарий*/
    public function get_comment($id) {
        if (empty($id)) {
            return false;
        }
        $comment_id_filter = $this->db->placehold('AND c.id=?', intval($id));
        $query = $this->db->placehold("SELECT 
                c.id,
                c.parent_id,
                c.object_id, 
                c.name,
                c.email,
                c.ip, 
                c.type, 
                c.text, 
                c.date, 
                c.approved,
                c.lang_id
            FROM __comments c 
            WHERE 
                1 
                $comment_id_filter 
            LIMIT 1
        ");
        
        if($this->db->query($query)) {
            return $this->db->result();
        } else {
            return false;
        }
    }

    /*Выбираем все комментарии*/
    public function get_comments($filter = array(), $count = false) {
        // По умолчанию
        $limit = 0;
        $page = 1;
        $joins = '';
        $where = '1';
        $group_by = '';
        $order = 'c.id DESC';
        $select = "c.id,
                c.parent_id,
                c.object_id, 
                c.ip, 
                c.name,
                c.email,
                c.text, 
                c.type, 
                c.date, 
                c.approved,
                c.lang_id";
        
        if ($count === true) {
            $select = "COUNT(DISTINCT c.id) as count";
        }
        
        if(isset($filter['limit'])) {
            $limit = max(1, intval($filter['limit']));
        }
        
        if(isset($filter['page'])) {
            $page = max(1, intval($filter['page']));
        }

        $sql_limit = ($limit ? $this->db->placehold(' LIMIT ?, ? ', ($page-1)*$limit, $limit) : '');
        
        if(isset($filter['approved'])) {
            $ip_filter = '';
            if(isset($filter['ip'])) {
                $ip_filter = $this->db->placehold(" OR c.ip=?", $filter['ip']);
            }
            $where .= $this->db->placehold(" AND (c.approved=? $ip_filter)", intval($filter['approved']));
        }
        
        if(!empty($filter['object_id'])) {
            $where .= $this->db->placehold(' AND c.object_id in(?@)', (array)$filter['object_id']);
        }
        
        if(!empty($filter['type'])) {
            $where .= $this->db->placehold(' AND c.type=?', $filter['type']);
        }

        if (isset($filter['has_parent'])) {
            $where .= ' AND c.parent_id'.($filter['has_parent'] ? '>0' : '=0');
        }

        if(!empty($filter['parent_id'])) {
            $where .= $this->db->placehold(' AND c.parent_id IN(?@)', (array)$filter['parent_id']);
        }
        
        if(!empty($filter['keyword'])) {
            $keywords = explode(' ', $filter['keyword']);
            $keyword_filter = ' ';
            foreach($keywords as $keyword) {
                $keyword_filter .= $this->db->placehold('AND (
                        c.name LIKE "%'.$this->db->escape(trim($keyword)).'%" 
                        OR c.text LIKE "%'.$this->db->escape(trim($keyword)).'%"
                        OR c.email LIKE "%'.$this->db->escape(trim($keyword)).'%"
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
            FROM __comments c 
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

    /*Подсчитываем количество комментариев*/
    public function count_comments($filter = array()) {    
        return $this->get_comments($filter, true);
    }

    /*Добавление комментария*/
    public function add_comment($comment) {
        
        // Автоматическое одобрение комментария
        if ($this->settings->auto_approved) {
            $comment->approved = 1;
        }
        $query = $this->db->placehold('INSERT INTO __comments SET ?%, date = NOW()', $comment);
        if(!$this->db->query($query)) {
            return false;
        }
        $id = $this->db->insert_id();
        
        $comment = (array)$comment;
        if ($comment['approved'] == 1 && $comment['object_id']) {
            if ($comment['type'] == 'blog') {
                $this->db->query('update __blog set last_modify=now() where id=?', intval($comment['object_id']));
            } elseif ($comment['type'] == 'product') {
                $this->db->query('update __products set last_modify=now() where id=?', intval($comment['object_id']));
            }
        }
        
        return $id;
    }

    /*Обновление комментария*/
    public function update_comment($id, $comment) {
        $date_query = '';
        if(isset($comment->date)) {
            $date = $comment->date;
            unset($comment->date);
            $date_query = $this->db->placehold(', date=STR_TO_DATE(?, ?)', $date, $this->settings->date_format);
        }
        $query = $this->db->placehold("UPDATE __comments SET ?% $date_query WHERE id in(?@) LIMIT 1", $comment, (array)$id);
        $this->db->query($query);
        
        $comment = (array)$comment;
        if ($comment['approved'] == 1) {
            $this->db->query('select object_id, type from __comments where id=?', intval($id));
            $c = $this->db->result();
            if ($c->type == 'blog') {
                $this->db->query('update __blog set last_modify=now() where id=?', intval($c->object_id));
            } elseif ($c->type == 'product') {
                $this->db->query('update __products set last_modify=now() where id=?', intval($c->object_id));
            }
        }
        
        return $id;
    }

    /*Удаление комментария*/
    public function delete_comment($id) {
        if(!empty($id)) {
            $this->db->query('select object_id, type, approved from __comments where id=?', intval($id));
            $c = $this->db->result();
            if ($c->approved == 1) {
                if ($c->type == 'blog') {
                    $this->db->query('update __blog set last_modify=now() where id=?', intval($c->object_id));
                } elseif ($c->type == 'product') {
                    $this->db->query('update __products set last_modify=now() where id=?', intval($c->object_id));
                }
            }

            $this->db->query('SELECT id from __comments where parent_id=?', intval($id));
            $children = $this->db->results('id');
            foreach($children as $child_id) {
                $this->delete_comment($child_id);
            }
            
            $query = $this->db->placehold("DELETE FROM __comments WHERE id=? LIMIT 1", intval($id));
            $this->db->query($query);
        }
    }
    
}
