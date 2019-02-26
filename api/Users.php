<?php

require_once('Okay.php');

class Users extends Okay {
    
    // осторожно, при изменении соли испортятся текущие пароли пользователей
    private $salt = '8e86a279d6e182b3c811c559e6b15484';

    /*Выборка пользователей*/
    public function get_users($filter = array(), $count = false) {
        // По умолчанию
        $limit = 1000;
        $page = 1;
        $joins = '';
        $where = '1';
        $group_by = '';
        $order = 'u.name';
        $select = "u.id, 
                u.email, 
                u.password, 
                u.name,
                u.phone,
                u.address,
                u.group_id, 
                u.last_ip, 
                u.created, 
                g.discount, 
                g.name as group_name";

        if ($count === true) {
            $select = "COUNT(DISTINCT u.id) as count";
        }

        if(isset($filter['limit'])) {
            $limit = max(1, intval($filter['limit']));
        }

        if(isset($filter['page'])) {
            $page = max(1, intval($filter['page']));
        }
        
        $sql_limit = $this->db->placehold(' LIMIT ?, ? ', ($page-1)*$limit, $limit);

        $joins .= "LEFT JOIN __groups g ON u.group_id=g.id";
        
        if (isset($filter['group_id'])) {
            $where .= $this->db->placehold(' AND u.group_id in(?@)', (array)$filter['group_id']);
        }
        
        if (isset($filter['keyword'])) {
            $keywords = explode(' ', $filter['keyword']);
            $keyword_filter = ' ';
            foreach ($keywords as $keyword) {
                $keyword_filter .= $this->db->placehold('AND (
                    u.name LIKE "%'.$this->db->escape(trim($keyword)).'%" 
                    OR u.email LIKE "%'.$this->db->escape(trim($keyword)).'%" 
                    OR u.last_ip LIKE "%'.$this->db->escape(trim($keyword)).'%" 
                ) ');
            }
            $where .= $keyword_filter;
        }
        
        if(!empty($filter['sort'])) {
            switch ($filter['sort']) {
                case 'date':
                    $order = 'u.created DESC';
                    break;
                case 'name':
                    $order = 'u.name';
                    break;
                case 'email':
                    $order = 'u.email';
                    break;
                case 'cnt_order':
                    $order = "(select count(o.id) as count from __orders o where o.user_id = u.id) DESC";
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
            FROM __users u
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

    /*Подсчет пользователей*/
    public function count_users($filter = array()) {
        return $this->get_users($filter, true);
    }

    /*Выборка конкретного пользователя*/
    public function get_user($id) {
        if (empty($id)) {
            return false;
        }
        if(gettype($id) == 'string') {
            $where = $this->db->placehold('AND u.email=? ', $id);
        } else {
            $where = $this->db->placehold('AND u.id=? ', intval($id));
        }
        
        // Выбираем пользователя
        $query = $this->db->placehold("SELECT 
                u.id, 
                u.email, 
                u.password, 
                u.name,
                u.phone,
                u.address,
                u.group_id, 
                u.last_ip, 
                u.created, 
                g.discount, 
                g.name as group_name 
            FROM __users u 
            LEFT JOIN __groups g ON u.group_id=g.id 
            WHERE
                1 
                $where 
            LIMIT 1
        ", $id);
        $this->db->query($query);
        $user = $this->db->result();
        if(empty($user)) {
            return false;
        }
        $user->discount *= 1; // Убираем лишние нули, чтобы было 5 вместо 5.00
        return $user;
    }

    /*Добавление пользователя*/
    public function add_user($user) {
        $user = (array)$user;
        if(isset($user['password'])) {
            $user['password'] = md5($this->salt.$user['password'].md5($user['password']));
        }
        
        $query = $this->db->placehold("SELECT count(*) as count FROM __users WHERE email=?", $user['email']);
        $this->db->query($query);
        
        if($this->db->result('count') > 0) {
            return false;
        }
        
        $query = $this->db->placehold("INSERT INTO __users SET ?%", $user);
        $this->db->query($query);
        return $this->db->insert_id();
    }

    /*Обновление пользователя*/
    public function update_user($id, $user) {
        $user = (array)$user;
        if(isset($user['password'])) {
            $user['password'] = md5($this->salt.$user['password'].md5($user['password']));
        }
        $query = $this->db->placehold("UPDATE __users SET ?% WHERE id=? LIMIT 1", $user, intval($id));
        $this->db->query($query);
        return $id;
    }

    /*Удаление пользователя*/
    public function delete_user($id) {
        if(!empty($id)) {
            $query = $this->db->placehold("UPDATE __orders SET user_id=0 WHERE user_id=?", intval($id));
            $this->db->query($query);
            
            $query = $this->db->placehold("DELETE FROM __users WHERE id=? LIMIT 1", intval($id));
            if($this->db->query($query)) {
                return true;
            }
        }
        return false;
    }

    /*Выборка групп пользователей*/
    public function get_groups() {
        // Выбираем группы
        $query = $this->db->placehold("SELECT g.id, g.name, g.discount FROM __groups AS g ORDER BY g.discount");
        $this->db->query($query);
        return $this->db->results();
    }

    /*Выборка группы пользователей */
    public function get_group($id) {
        // Выбираем группу
        $query = $this->db->placehold("SELECT * FROM __groups WHERE id=? LIMIT 1", $id);
        $this->db->query($query);
        $group = $this->db->result();
        
        return $group;
    }

    /*Добавление группы пользователей*/
    public function add_group($group) {
        $query = $this->db->placehold("INSERT INTO __groups SET ?%", $group);
        $this->db->query($query);
        return $this->db->insert_id();
    }

    /*Обновление группы пользователей*/
    public function update_group($id, $group) {
        $query = $this->db->placehold("UPDATE __groups SET ?% WHERE id=? LIMIT 1", $group, intval($id));
        $this->db->query($query);
        return $id;
    }

    /*Удаление группы пользователей*/
    public function delete_group($id) {
        if(!empty($id)) {
            $query = $this->db->placehold("UPDATE __users SET group_id=NULL WHERE group_id=? LIMIT 1", intval($id));
            $this->db->query($query);
            
            $query = $this->db->placehold("DELETE FROM __groups WHERE id=? LIMIT 1", intval($id));
            if($this->db->query($query)) {
                return true;
            }
        }
        return false;
    }

    /*Проверка пароля*/
    public function check_password($email, $password) {
        $encpassword = md5($this->salt.$password.md5($password));
        $query = $this->db->placehold("SELECT id FROM __users WHERE email=? AND password=? LIMIT 1", $email, $encpassword);
        $this->db->query($query);
        if($id = $this->db->result('id')) {
            return $id;
        }
        return false;
    }
    
}
