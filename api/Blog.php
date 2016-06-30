<?php

require_once('Okay.php');

class Blog extends Okay {
    
    public function get_post($id) {
        if (empty($id)) {
            return false;
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
                b.last_modify, 
                $lang_sql->fields 
            FROM __blog b 
            $lang_sql->join 
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
    
    public function get_posts($filter = array()) {
    	// По умолчанию
    	$limit = 1000;
    	$page = 1;
    	$post_id_filter = '';
    	$visible_filter = '';
    	$keyword_filter = '';
    	$posts = array();
        $lang_id  = $this->languages->lang_id();
        $px = ($lang_id ? 'l' : 'b');
        
        if(isset($filter['limit'])) {
            $limit = max(1, intval($filter['limit']));
        }
        if(isset($filter['page'])) {
            $page = max(1, intval($filter['page']));
        }
        
        if(!empty($filter['id'])) {
            $post_id_filter = $this->db->placehold('AND b.id in(?@)', (array)$filter['id']);
        }
        
        if(isset($filter['visible'])) {
            $visible_filter = $this->db->placehold('AND b.visible = ?', intval($filter['visible']));
        }
        if(isset($filter['keyword'])) {
    		$keywords = explode(' ', $filter['keyword']);
            foreach($keywords as $keyword) {
                $keyword_filter .= $this->db->placehold('AND ('.$px.'.name LIKE "%'.$this->db->escape(trim($keyword)).'%" OR '.$px.'.meta_keywords LIKE "%'.$this->db->escape(trim($keyword)).'%") ');
            }
    	}
        
    	$sql_limit = $this->db->placehold(' LIMIT ?, ? ', ($page-1)*$limit, $limit);
        $lang_sql = $this->languages->get_query(array('object'=>'blog'));
    	$query = $this->db->placehold("SELECT 
                b.id, 
                b.url, 
                b.visible, 
                b.date, 
                b.image, 
                b.last_modify, 
                $lang_sql->fields
            FROM __blog b 
            $lang_sql->join 
            WHERE 
                1 
                $post_id_filter 
                $visible_filter 
                $keyword_filter
            ORDER BY date DESC, id DESC 
            $sql_limit
        ");
    	$this->db->query($query);
    	return $this->db->results();
    }
    
    public function count_posts($filter = array()) {	
    	$post_id_filter = '';
    	$visible_filter = '';
    	$keyword_filter = '';
        $lang_id  = $this->languages->lang_id();
        $px = ($lang_id ? 'l' : 'b');

        if(!empty($filter['id'])) {
            $post_id_filter = $this->db->placehold('AND b.id in(?@)', (array)$filter['id']);
        }
    		
        if(isset($filter['visible'])) {
            $visible_filter = $this->db->placehold('AND b.visible = ?', intval($filter['visible']));
        }		
        
        if(isset($filter['keyword'])) {
    		$keywords = explode(' ', $filter['keyword']);
            foreach($keywords as $keyword) {
                $keyword_filter .= $this->db->placehold('AND ('.$px.'.name LIKE "%'.$this->db->escape(trim($keyword)).'%" OR '.$px.'.meta_keywords LIKE "%'.$this->db->escape(trim($keyword)).'%") ');
            }
    	}
        $lang_sql = $this->languages->get_query(array('object'=>'blog'));
    	$query = "SELECT COUNT(distinct b.id) as count
            FROM __blog b
            $lang_sql->join
            WHERE 1 
                $post_id_filter 
                $visible_filter 
                $keyword_filter
        ";
        
        if($this->db->query($query)) {
            return $this->db->result('count');
        } else {
            return false;
        }
    }
    
    public function add_post($post) {
        $date_query = (!isset($post->date) ? ', date=NOW()' : '');
        
        $post = (object)$post;
        // Проверяем есть ли мультиязычность и забираем описания для перевода
        $result = $this->languages->get_description($post, 'blog');
        
        $post->last_modify = date("Y-m-d H:i:s");
    	$query = $this->db->placehold("INSERT INTO __blog SET ?% $date_query", $post);
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
    
    public function update_post($id, $post) {
        $post = (object)$post;
        // Проверяем есть ли мультиязычность и забираем описания для перевода
        $result = $this->languages->get_description($post, 'blog');
        
        $post->last_modify = date("Y-m-d H:i:s");
    	$query = $this->db->placehold("UPDATE __blog SET ?% WHERE id in(?@) LIMIT ?", $post, (array)$id, count((array)$id));
    	$this->db->query($query);
        
        // Если есть описание для перевода. Указываем язык для обновления
        if(!empty($result->description)) {
            $this->languages->action_description($id, $result->description, 'blog', $this->languages->lang_id());
        }
    	return $id;
    }
    
    public function delete_post($id) {
        if(!empty($id)) {
            $this->image->delete_image($id, 'image', 'blog', $this->config->original_blog_dir, $this->config->resized_blog_dir);
    		$query = $this->db->placehold("DELETE FROM __blog WHERE id=? LIMIT 1", intval($id));
            if($this->db->query($query)) {
                $this->settings->lastModifyPosts = date("Y-m-d H:i:s");
    		    $this->db->query("DELETE FROM __lang_blog WHERE blog_id=?", intval($id));
    			$query = $this->db->placehold("DELETE FROM __comments WHERE type='blog' AND object_id=?", intval($id));
                if($this->db->query($query)) {
                    return true;
                }
    		}							
    	}
    	return false;
    }	
    
    public function get_next_post($id) {
    	$this->db->query("SELECT date FROM __blog WHERE id=? LIMIT 1", $id);
    	$date = $this->db->result('date');
        
    	$this->db->query("(SELECT id FROM __blog WHERE date=? AND id>? AND visible  ORDER BY id limit 1)
    	                   UNION
    	                  (SELECT id FROM __blog WHERE date>? AND visible ORDER BY date, id limit 1)",
    	                  $date, $id, $date);
    	$next_id = $this->db->result('id');
        if($next_id) {
            return $this->get_post(intval($next_id));
        } else {
            return false;
        }
    }
    
    public function get_prev_post($id) {
    	$this->db->query("SELECT date FROM __blog WHERE id=? LIMIT 1", $id);
    	$date = $this->db->result('date');
        
    	$this->db->query("(SELECT id FROM __blog WHERE date=? AND id<? AND visible ORDER BY id DESC limit 1)
    	                   UNION
    	                  (SELECT id FROM __blog WHERE date<? AND visible ORDER BY date DESC, id DESC limit 1)",
    	                  $date, $id, $date);
    	$prev_id = $this->db->result('id');
        if($prev_id) {
            return $this->get_post(intval($prev_id));
        } else {
            return false;
        }
    }

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

    public function add_related_product($post_id, $related_id, $position=0) {
        $query = $this->db->placehold("INSERT IGNORE INTO __related_blogs SET post_id=?, related_id=?, position=?", $post_id, $related_id, $position);
        $this->db->query($query);
        return $related_id;
    }
    
}
