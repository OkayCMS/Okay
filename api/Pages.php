<?php

require_once('Okay.php');

class Pages extends Okay {

    // Системные url
    public $system_pages = array('catalog', 'products', 'all-products', 'discounted', 'bestsellers', 'brands', 'blog', 'news', 'wishlist', 'comparison', 'cart', 'order', 'contact', 'user', '404', '');
    
    /*Выборка конкрентной страницы*/
    public function get_page($id) {
        if(gettype($id) == 'string') {
            $where = $this->db->placehold('AND p.url=? ', $id);
        } else {
            $where = $this->db->placehold('AND p.id=? ', intval($id));
        }
        
        $lang_sql = $this->languages->get_query(array('object'=>'page'));
        
        $query = "SELECT 
                p.id, 
                p.url, 
                p.position, 
                p.visible, 
                p.last_modify, 
                $lang_sql->fields
            FROM __pages p 
            $lang_sql->join 
            WHERE 
                1 
                $where 
            LIMIT 1
        ";
        
        $this->db->query($query);
        return $this->db->result();
    }

    /*Выборка всех страниц*/
    public function get_pages($filter = array()) {
        $visible_filter = '';
        $pages = array();
        
        if(isset($filter['visible'])) {
            $visible_filter = $this->db->placehold('AND p.visible = ?', intval($filter['visible']));
        }
        
        $lang_sql = $this->languages->get_query(array('object'=>'page'));
        $query = "SELECT 
                p.id, 
                p.url, 
                p.position, 
                p.visible, 
                p.last_modify, 
                $lang_sql->fields
            FROM __pages p 
            $lang_sql->join 
            WHERE 
                1 
                $visible_filter 
            ORDER BY p.position
        ";
        $this->db->query($query);
        foreach($this->db->results() as $page) {
            $pages[$page->id] = $page;
        }
        return $pages;
    }

    /*Добавление страницы*/
    public function add_page($page) {
        $page = (object)$page;
        // Проверяем есть ли мультиязычность и забираем описания для перевода
        $result = $this->languages->get_description($page, 'page');
        
        $page->last_modify = date("Y-m-d H:i:s");
        $query = $this->db->placehold('INSERT INTO __pages SET ?%', $page);
        if(!$this->db->query($query)) {
            return false;
        }
        
        $id = $this->db->insert_id();
        
        // Если есть описание для перевода. Указываем язык для обновления
        if(!empty($result->description)) {
            $this->languages->action_description($id, $result->description, 'page');
        }
        
        $this->db->query("UPDATE __pages SET position=id WHERE id=?", $id);
        return $id;
    }

    /*Обновление страницы*/
    public function update_page($id, $page) {
        $page = (object)$page;
        // Проверяем есть ли мультиязычность и забираем описания для перевода
        $result = $this->languages->get_description($page, 'page');
        
        $page->last_modify = date("Y-m-d H:i:s");
        $query = $this->db->placehold('UPDATE __pages SET ?% WHERE id in (?@)', $page, (array)$id);
        if(!$this->db->query($query)) {
            return false;
        }
        
        // Если есть описание для перевода. Указываем язык для обновления
        if(!empty($result->description)) {
            $this->languages->action_description($id, $result->description, 'page', $this->languages->lang_id());
        }
        
        return $id;
    }

    /*Удаление страницы*/
    public function delete_page($id) {
        if(!empty($id)) {
            // Запретим удаление системных ссылок
            $page = $this->get_page(intval($id));
            if (in_array($page->url, $this->system_pages)) {
                return false;
            }
            $query = $this->db->placehold("DELETE FROM __pages WHERE id=? LIMIT 1", intval($id));
            if($this->db->query($query)) {
                $this->db->query("DELETE FROM __lang_pages WHERE page_id=?", intval($id));
                return true;
            }
        }
        return false;
    }

}
