<?php

require_once('Okay.php');

class Banners extends Okay {

    /*Выбираем все слайды*/
    public function get_banners_images($filter = array(), $count = false) {
        $limit = 100;  // По умолчанию
        $page = 1;
        $joins = '';
        $where = '1';
        $group_by = '';
        $order = 'bi.position DESC';
        $lang_sql = $this->languages->get_query(array('object'=>'banner_image', 'px'=>'bi'));
        $select = "bi.id, 
                bi.banner_id, 
                bi.image, 
                bi.position, 
                bi.visible, 
                $lang_sql->fields ";

        if ($count === true) {
            $select = "COUNT(DISTINCT bi.id) as count";
        }
        
        if(isset($filter['limit'])) {
            $limit = max(1, intval($filter['limit']));
        }
        
        if(isset($filter['page'])) {
            $page = max(1, intval($filter['page']));
        }
        
        $sql_limit = $this->db->placehold(' LIMIT ?, ? ', ($page-1)*$limit, $limit);
        
        if(!empty($filter['id'])) {
            $where .= $this->db->placehold(' AND bi.id in(?@)', (array)$filter['id']);
        }
        
        if(!empty($filter['banner_id'])) {
            $where .= $this->db->placehold(' AND bi.banner_id in(?@)', (array)$filter['banner_id']);
        }
        
        if(isset($filter['visible'])) {
            $where .= $this->db->placehold(' AND bi.visible=?', intval($filter['visible']));
        }
        
        if(!empty($filter['sort'])) {
            switch ($filter['sort']) {
                case 'position':
                    $order = 'bi.position DESC';
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
            FROM __banners_images bi
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

    /*Подсчитываем количество найденных слайдов*/
    public function count_banners_images($filter = array()) {
        return $this->get_banners_images($filter, true);
    }

    /*Выбираем конкретный слайд*/
    public function get_banners_image($id) {
        if(!is_int($id)) {
           return false;
        }
        $banner_id_filter = $this->db->placehold("AND bi.id=?", intval($id));
        
        $lang_sql = $this->languages->get_query(array('object'=>'banner_image', 'px'=>'bi'));
        $query = $this->db->placehold("SELECT 
                bi.id, 
                bi.banner_id, 
                bi.image, 
                bi.position, 
                bi.visible, 
                $lang_sql->fields 
            FROM __banners_images bi 
            $lang_sql->join
            WHERE 
                1 
                $banner_id_filter
            LIMIT 1
        ", $id);
        $this->db->query($query);
        $banners_image = $this->db->result();
        return $banners_image;
    }

    /*Добавление слайда*/
    public function add_banners_image($banners_image) {
        $banners_image = (object)$banners_image;
        // Проверяем есть ли мультиязычность и забираем описания для перевода
        $result = $this->languages->get_description($banners_image, 'banner_image');
        
        if($this->db->query("INSERT INTO __banners_images SET ?%", $banners_image)) {
            $id = $this->db->insert_id();
            $this->db->query("UPDATE __banners_images SET position=id WHERE id=?", $id);
            
            // Если есть описание для перевода. Указываем язык для обновления
            if(!empty($result->description)) {
                $this->languages->action_description($id, $result->description, 'banner_image');
            }
            return $id;
        } else {
            return false;
        }
    }

    /*Обновление слайда*/
    public function update_banners_image($id, $banners_image) {
        $banners_image = (object)$banners_image;
        // Проверяем есть ли мультиязычность и забираем описания для перевода
        $result = $this->languages->get_description($banners_image, 'banner_image');
        
        $query = $this->db->placehold("UPDATE __banners_images SET ?% WHERE id in (?@) LIMIT ?", $banners_image, (array)$id, count((array)$id));
        if($this->db->query($query)) {
            // Если есть описание для перевода. Указываем язык для обновления
            if(!empty($result->description)) {
                $this->languages->action_description($id, $result->description, 'banner_image', $this->languages->lang_id());
            }
            return $id;
        } else {
            return false;
        }
    }

    /*Удаление слайда*/
    public function delete_banners_image($id) {
        if(!empty($id)) {
            $this->image->delete_image((int)$id, 'image', 'banners_images', $this->config->banners_images_dir, $this->config->resized_banners_images_dir);
            $query = $this->db->placehold("DELETE FROM __banners_images WHERE id=? LIMIT 1", intval($id));
            if($this->db->query($query)) {
                $this->db->query("DELETE FROM __lang_banners_images where banner_image_id=?", intval($id));
                return true;
            }
        }
        return false;
    }

    /*Выбираем все группы баннеров*/
    public function get_banners($filter = array(), $count = false) {
        $limit = 100;  // По умолчанию
        $page = 1;
        $joins = '';
        $where = '1';
        $group_by = '';
        $order = 'b.position DESC';
        $select = "b.*";
        if ($count === true) {
            $select = "COUNT(DISTINCT b.id) as count";
        }

        if(isset($filter['limit'])) {
            $limit = max(1, intval($filter['limit']));
        }

        if(isset($filter['page'])) {
            $page = max(1, intval($filter['page']));
        }

        $sql_limit = $this->db->placehold(' LIMIT ?, ? ', ($page-1)*$limit, $limit);
        
        if (isset($filter['visible'])) {
            $where .= $this->db->placehold(' AND visible = ?', intval($filter['visible']));
        }

        // При подсчете нам эти переменные не нужны
        if ($count === true) {
            $order      = '';
            $group_by   = '';
            $sql_limit  = '';
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
            FROM __banners b
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
            $banners = array();
            foreach($this->db->results() as $banner) {
                $banners[$banner->id] = $banner;
            }
            return $banners;
        }
    }

    public function count_banners($filter = array()) {
        return $this->get_banners($filter, true);
    }
    
    /*Выбираем определенную группу баннеров*/
    public function get_banner($id, $visible = false, $show_filter_array = array()) {
        if (empty($id)) {
            return false;
        }
        
        $is_visible = '';
        $show_filter = '';
        
        if($visible) {
            $is_visible = 'AND visible=1';
        }

        if(is_int($id)) {
            $banner_id_filter = $this->db->placehold('AND id=? ', intval($id));
        } else {
            $banner_id_filter = $this->db->placehold('AND group_id=? ', $id);
        }
        
        if(!empty($show_filter_array)) {
            foreach($show_filter_array as $k=>$sfa) {
                if(empty($sfa)) {
                    unset($show_filter_array[$k]);
                    continue;
                }
                $show_filter_array[$k] = $this->db->placehold($k." regexp '[[:<:]](?)[[:>:]]'", intval($show_filter_array[$k]));
            }
            $show_filter_array[] = "show_all_pages=1";
            $show_filter = 'AND (' . implode(' OR ',$show_filter_array) . ')';
        }
        
        $query = $this->db->placehold("SELECT * FROM __banners WHERE 1 $banner_id_filter $is_visible $show_filter LIMIT 1");
        $this->db->query($query);
        $banner = $this->db->result();
        return $banner;
    }

    /*Обновляем группу баннеров*/
    public function update_banner($id, $banner) {
        $query = $this->db->placehold("UPDATE __banners SET ?% WHERE id in (?@) LIMIT ?", $banner, (array)$id, count((array)$id));
        if($this->db->query($query)) {
            return $id;
        } else {
            return false;
        }
    }

    /*Добавляем группу баннеров*/
    public function add_banner($banner) {
        $banner = (array) $banner;
        
        if($this->db->query("INSERT INTO __banners SET ?%", $banner)) {
            $id = $this->db->insert_id();
            $this->db->query("UPDATE __banners SET position=id WHERE id=?", $id);
            return $id;
        } else {
            return false;
        }
    }

    /*Удаляем группу баннеров*/
    public function delete_banner($id) {
        if(!empty($id)) {
            $this->db->query("SELECT id FROM __banners_images where banner_id=?", intval($id));
            $banners_images_ids = $this->db->results('id');
            if (!empty($banners_images_ids)) {
                foreach ($banners_images_ids as $bi_id) {
                    $this->delete_banners_image($bi_id);
                }
            }
            
            $query = $this->db->placehold("DELETE FROM __banners WHERE id=? LIMIT 1", intval($id));
            if($this->db->query($query)) {
                return true;
            }
        }
        return false;
    }
    
}
