<?php

require_once('Okay.php');

class Blog extends Okay {

    /*Выбираем определенную запись*/
    public function get_post($id,$type_post = null) {
        if (empty($id) && empty($type_post)) {
            return false;
        }
        $type = '';
        if($type_post) {
            $type = $this->db->placehold('AND b.type_post=? ', $type_post);
        }
        if(is_int($id)) {
            $where = $this->db->placehold('AND b.id=? ', intval($id));
        } else {
            $where = $this->db->placehold('AND b.url=? ', $id);
        }
        
        $lang_sql = $this->languages->get_query(array('object'=>'blog'));
        $query = $this->db->placehold("SELECT 
                b.id, 
                b.url, 
                b.visible, 
                b.date, 
                b.image,
                b.type_post,
                b.last_modify, 
                $lang_sql->fields 
            FROM __blog b 
            $lang_sql->join 
            WHERE
                1 
                $where 
                $type
            LIMIT 1
        ");
        if($this->db->query($query)) {
            return $this->db->result();
        } else {
            return false;
        }
    }

    /*Выбираем все записи*/
    public function get_posts($filter = array(), $count = false) {
        $limit = 1000; // По умолчанию
        $page = 1;
        $where = '1';
        $order = 'b.date DESC, b.id DESC ';
        $lang_sql = $this->languages->get_query(array('object'=>'blog'));
        $select = "b.id, 
                b.url, 
                b.visible, 
                b.date, 
                b.image, 
                b.type_post,
                b.last_modify, 
                $lang_sql->fields";

        if ($count === true) {
            $select = "COUNT(DISTINCT b.id) as count";
        }
        
        $lang_id  = $this->languages->lang_id();
        $px = ($lang_id ? 'l' : 'b');
        
        if(isset($filter['limit'])) {
            $limit = max(1, intval($filter['limit']));
        }
        if(isset($filter['page'])) {
            $page = max(1, intval($filter['page']));
        }

        $sql_limit = $this->db->placehold(' LIMIT ?, ? ', ($page-1)*$limit, $limit);
        
        if(!empty($filter['id'])) {
            $where .= $this->db->placehold(' AND b.id in(?@)', (array)$filter['id']);
        }

        if(!empty($filter['type_post'])) {
            $where .= $this->db->placehold(' AND b.type_post = ?', $filter['type_post']);
        }
        
        if(isset($filter['visible'])) {
            $where .= $this->db->placehold(' AND b.visible = ?', intval($filter['visible']));
        }
        if(isset($filter['keyword'])) {
            $keyword_filter = ' ';
            $keywords = explode(' ', $filter['keyword']);
            foreach($keywords as $keyword) {
                $keyword_filter .= $this->db->placehold('AND ('.$px.'.name LIKE "%'.$this->db->escape(trim($keyword)).'%" OR '.$px.'.meta_keywords LIKE "%'.$this->db->escape(trim($keyword)).'%") ');
            }
            $where .= $keyword_filter;
        }

        if (!empty($order)) {
            $order = "ORDER BY $order";
        }

        // При подсчете нам эти переменные не нужны
        if ($count === true) {
            $order      = '';
            $sql_limit  = '';
        }
        
        $query = $this->db->placehold("SELECT $select
            FROM __blog b 
            $lang_sql->join 
            WHERE 
                $where
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

    /*Подсчитываем количество найденных записей*/
    public function count_posts($filter = array()) {
        return $this->get_posts($filter, true);
    }

    /*Добавляем запись*/
    public function add_post($post) {
        $post = (object)$post;
        // Проверяем есть ли мультиязычность и забираем описания для перевода
        $result = $this->languages->get_description($post, 'blog');

        $query = $this->db->placehold("INSERT INTO __blog SET ?%", $post);
        if(!$this->db->query($query)) {
            return false;
        }
        
        $id = $this->db->insert_id();
        
        // Если есть описание для перевода. Указываем язык для обновления
        if(!empty($result->description)) {
            $this->languages->action_description($id, $result->description, 'blog');
        }
        
        return $id;
    }

    /*Обновляем запись*/
    public function update_post($id, $post) {
        $post = (object)$post;
        // Проверяем есть ли мультиязычность и забираем описания для перевода
        $result = $this->languages->get_description($post, 'blog');

        $query = $this->db->placehold("UPDATE __blog SET ?% WHERE id in(?@) LIMIT ?", $post, (array)$id, count((array)$id));
        $this->db->query($query);
        
        // Если есть описание для перевода. Указываем язык для обновления
        if(!empty($result->description)) {
            $this->languages->action_description($id, $result->description, 'blog', $this->languages->lang_id());
        }
        return $id;
    }

    /*Удаляем запись*/
    public function delete_post($id) {
        if(!empty($id)) {
            $this->image->delete_image($id, 'image', 'blog', $this->config->original_blog_dir, $this->config->resized_blog_dir);
            $this->db->query("SELECT type_post FROM __blog WHERE id=? LIMIT 1", (int)$id);
            $type_post = $this->db->result("type_post");
            $query = $this->db->placehold("DELETE FROM __blog WHERE id=? LIMIT 1", intval($id));
            if($this->db->query($query)) {
                if ($type_post == "news") {
                    $this->settings->lastModifyNews = date("Y-m-d H:i:s");
                } else {
                    $this->settings->lastModifyPosts = date("Y-m-d H:i:s");
                }
                $this->db->query("DELETE FROM __lang_blog WHERE blog_id=?", intval($id));
                $query = $this->db->placehold("DELETE FROM __comments WHERE type='blog' AND object_id=?", intval($id));
                if($this->db->query($query)) {
                    return true;
                }
            }                            
        }
        return false;
    }

    /*Выбираем следующию запись от текущей*/
    public function get_next_post($id) {
        $this->db->query("SELECT date,type_post FROM __blog WHERE id=? LIMIT 1", $id);
        $res = $this->db->results();
        $this->db->query("(SELECT id, type_post FROM __blog WHERE date=? AND id>? AND visible AND type_post = ?  ORDER BY id limit 1)
                           UNION
                          (SELECT id, type_post FROM __blog WHERE date>? AND visible AND type_post = ? ORDER BY date, id limit 1)",
            reset($res)->date, $id, reset($res)->type_post,reset($res)->date, reset($res)->type_post);
        $next = $this->db->results();
        if($next) {
            return $this->get_post(intval(reset($next)->id), reset($next)->type_post);
        } else {
            return false;
        }
    }

    /*Выбираем предыдущую запись от текущей*/
    public function get_prev_post($id) {
        $this->db->query("SELECT date,type_post FROM __blog WHERE id=? LIMIT 1", $id);
        $res = $this->db->results();
        
        $this->db->query("(SELECT id,type_post FROM __blog WHERE date=? AND id<? AND visible AND type_post = ? ORDER BY id DESC limit 1)
                           UNION
                          (SELECT id,type_post FROM __blog WHERE date<? AND visible AND type_post = ? ORDER BY date DESC, id DESC limit 1)",
            reset($res)->date, $id, reset($res)->type_post,reset($res)->date, reset($res)->type_post );
        $prev = $this->db->results();
        if($prev) {
            return $this->get_post(intval(reset($prev)->id), reset($prev)->type_post);
        } else {
            return false;
        }
    }

    /*Выбираем связанные товары к записи*/
    public function get_related_products($filter = array()) {
        $product_id_filter = '';
        $post_id_filter = '';
        if(!empty($filter['post_id'])) {
            $post_id_filter = $this->db->placehold('AND post_id in(?@)', (array)$filter['post_id']);
        }
        if(!empty($filter['product_id'])) {
            $product_id_filter = $this->db->placehold('AND related_id in(?@)', (array)$filter['product_id']);
        }
        $query = $this->db->placehold("SELECT
                post_id,
                related_id,
                position
            FROM __related_blogs
            WHERE
                1
                $post_id_filter
                $product_id_filter
            ORDER BY position
        ");
        $this->db->query($query);
        return $this->db->results();
    }

    /*Добавление связанного товара к записи*/
    public function add_related_product($post_id, $related_id, $position=0) {
        $query = $this->db->placehold("INSERT IGNORE INTO __related_blogs SET post_id=?, related_id=?, position=?", $post_id, $related_id, $position);
        $this->db->query($query);
        return $related_id;
    }
    
}
