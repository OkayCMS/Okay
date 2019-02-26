<?php

require_once('Okay.php');

class Features extends Okay {

    /*Выборка всех свойств товаров*/
    public function get_features($filter = array(), $count = false) {
        // По умолчанию
        $limit = 100;
        $page = 1;
        $joins = '';
        $where = '1';
        $group_by = '';
        $order = 'f.position';
        $lang_sql = $this->languages->get_query(array('object'=>'feature'));
        $select = "f.id, 
                f.position, 
                f.in_filter, 
                f.yandex, 
                f.auto_name_id, 
                f.auto_value_id, 
                f.url, 
                f.url_in_product,
                f.to_index_new_value,
                $lang_sql->fields";

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

        if(isset($filter['category_id'])) {
            $where .= $this->db->placehold(' AND id in(SELECT feature_id FROM __categories_features AS cf WHERE cf.category_id in(?@))', (array)$filter['category_id']);
        }
        
        if(isset($filter['in_filter'])) {
            $where .= $this->db->placehold(' AND f.in_filter=?', intval($filter['in_filter']));
        }
        
        if(!empty($filter['id'])) {
            $where .= $this->db->placehold(' AND f.id in(?@)', (array)$filter['id']);
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
            FROM __features f
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

    public function count_features($filter = array()) {
        return $this->get_features($filter, true);
    }

    /*Выборка конкретного свойства товара*/
    public function get_feature($id) {
        if (empty($id)) {
            return false;
        }
        if (is_int($id)) {
            $feature_id_filter = $this->db->placehold('AND f.id=?', intval($id));
        } else {
            $feature_id_filter = $this->db->placehold('AND f.url=?', $id);
        }
        $lang_sql = $this->languages->get_query(array('object'=>'feature'));
        // Выбираем свойство
        $query = $this->db->placehold("SELECT 
                f.id, 
                f.position, 
                f.in_filter, 
                f.yandex, 
                f.auto_name_id, 
                f.auto_value_id, 
                f.url, 
                f.url_in_product,
                f.to_index_new_value,
                $lang_sql->fields
            FROM __features f 
            $lang_sql->join 
            WHERE 
                1 
                $feature_id_filter
            LIMIT 1 
        ");
        $this->db->query($query);
        return $this->db->result();
    }

    /*Выборка категорий, закрепленных за свойством*/
    public function get_feature_categories($id) {
        $query = $this->db->placehold("SELECT cf.category_id as category_id 
            FROM __categories_features cf
            WHERE cf.feature_id = ?", $id);
        $this->db->query($query);
        return $this->db->results('category_id');
    }

    /*Добавление свойства*/
    public function add_feature($feature) {
        $feature = (array)$feature;
        $feature['url'] = preg_replace("/[\s]+/ui", '', $feature['url']);
        $feature['url'] = strtolower(preg_replace("/[^0-9a-z]+/ui", '', $feature['url']));
        if(empty($feature['url'])) {
            $feature['url'] = $this->translit_alpha($feature['name']);
        }
        while($this->get_feature((string)$feature['url'])) {
            if(preg_match('/(.+)([0-9]+)$/', $feature['url'], $parts)) {
                $feature['url'] = $parts[1].''.($parts[2]+1);
            } else {
                $feature['url'] = $feature['url'].'2';
            }
        }
        
        $feature = (object)$feature;
        // Проверяем есть ли мультиязычность и забираем описания для перевода
        $result = $this->languages->get_description($feature, 'feature');
        
        $query = $this->db->placehold("INSERT INTO __features SET ?%", $feature);
        $this->db->query($query);
        $id = $this->db->insert_id();
        $query = $this->db->placehold("UPDATE __features SET position=id WHERE id=? LIMIT 1", $id);
        $this->db->query($query);
        
        // Если есть описание для перевода. Указываем язык для обновления
        if(!empty($result->description)) {
            $this->languages->action_description($id, $result->description, 'feature');
        }
        return $id;
    }

    /*Обновление свойства*/
    public function update_feature($id, $feature) {
        //lastModify
        $feature = (array)$feature;
        if (isset($feature['name']) && !empty($feature['name']) && !is_array($id)) {
            $old_feature = $this->get_feature($id);
            if ($old_feature->name != $feature['name']) {
                $this->db->query('SELECT `pv`.`product_id` 
                                  FROM `__products_features_values` AS `pv`
                                  INNER JOIN `__features_values` AS `fv` ON `pv`.`value_id`=`fv`.`id` AND `fv`.`feature_id`=?', intval($id));
                $p_ids = $this->db->results('product_id');
                if (!empty($p_ids)) {
                    $this->db->query('update __products set last_modify=now() where id in(?@)', $p_ids);
                }
            }
        }
        
        $feature = (object)$feature;
        // Проверяем есть ли мультиязычность и забираем описания для перевода
        $result = $this->languages->get_description($feature, 'feature');
        
        $query = $this->db->placehold("UPDATE __features SET ?% WHERE id in(?@) LIMIT ?", (array)$feature, (array)$id, count((array)$id));
        $this->db->query($query);
        
        // Если есть описание для перевода. Указываем язык для обновления
        if(!empty($result->description)) {
            $this->languages->action_description($id, $result->description, 'feature', $this->languages->lang_id());
        }
        return $id;
    }

    /*Удаление свойства*/
    public function delete_feature($id = array()) {
        if(!empty($id)) {
            //lastModify
            $this->db->query("SELECT `pv`.`product_id`
                              FROM `__products_features_values` AS `pf`
                              INNER JOIN `__features_values` AS `fv` ON `pf`.`value_id`=`fv`.`id` AND `fv`.`feature_id` = ?", intval($id));
            $p_ids = $this->db->results('product_id');
            if (!empty($p_ids)) {
                $this->db->query('update __products set last_modify=now() where id in(?@)', $p_ids);
            }

            /*Удаляем значения свойств*/
            $this->features_values->delete_product_value(null, null, $id);
            $this->features_values->delete_feature_value(null, $id);

            $query = $this->db->placehold("DELETE FROM __features WHERE id=? LIMIT 1", intval($id));
            $this->db->query($query);
            $query = $this->db->placehold("DELETE FROM __options_aliases_values WHERE feature_id=?", intval($id));
            $this->db->query($query);
            $query = $this->db->placehold("DELETE FROM __categories_features WHERE feature_id=?", intval($id));
            $this->db->query($query);
            $this->db->query("DELETE FROM __lang_features WHERE feature_id=?", intval($id));
        }
    }

    /*Добавление связки категории и свойства*/
    public function add_feature_category($id, $category_id) {
        $query = $this->db->placehold("INSERT IGNORE INTO __categories_features SET feature_id=?, category_id=?", $id, $category_id);
        $this->db->query($query);
    }

    /*Обновление связки категории и свойства*/
    public function update_feature_categories($id, $categories) {
        //lastModify
        if (is_array($categories)) {
            $this->db->query('select category_id from __categories_features where feature_id=?', $id);
            $c_ids = $this->db->results('category_id');
            $diff = array_diff($c_ids, $categories);
            if (!empty($diff)) {
                $this->db->query('SELECT `pv`.`product_id` 
                                  FROM `__products_features_values` AS `pv`
                                  INNER JOIN `__features_values` AS `fv` ON `pv`.`value_id`=`fv`.`id`
                                  INNER JOIN `__products_categories` AS `pc` ON `pc`.`product_id`=`pv`.`product_id`
                                  WHERE `fv`.`feature_id`=? AND `pc`.`category_id` IN (?@)', intval($id), $diff);
                $p_ids = $this->db->results('product_id');
                if (!empty($p_ids)) {
                    $this->db->query('update __products set last_modify=now() where id in(?@)', $p_ids);
                }
            }
        } else {
            $this->db->query("SELECT `pv`.`product_id`
                              FROM `__products_features_values` AS `pf`
                              INNER JOIN `__features_values` AS `fv` ON `pf`.`value_id`=`fv`.`id` AND `fv`.`feature_id` = ?", intval($id));
            $p_ids = $this->db->results('product_id');
            if (!empty($p_ids)) {
                $this->db->query('update __products set last_modify=now() where id in(?@)', $p_ids);
            }
        }
        
        $id = intval($id);
        $query = $this->db->placehold("DELETE FROM __categories_features WHERE feature_id=?", $id);
        $this->db->query($query);
        
        if(is_array($categories)) {
            $values = array();
            foreach($categories as $category) {
                $values[] = "($id , ".intval($category).")";
            }
            
            $query = $this->db->placehold("INSERT INTO __categories_features (feature_id, category_id) VALUES ".implode(', ', $values));
            $this->db->query($query);
            
            // Удаляем значения свойств из категорий которые не запостили (их могли отжать)
            $query = $this->db->placehold("DELETE `pv` FROM `__products_features_values` AS `pv`
                            INNER JOIN `__features_values` AS `fv` ON `pv`.`value_id`=`fv`.`id`
                            LEFT JOIN `__products_categories` AS `pc` ON `pc`.`product_id`=`pv`.`product_id`
                            WHERE 
                                `fv`.`feature_id`=? 
                                AND `pc`.`position`=(SELECT MIN(`pc2`.`position`) FROM `__products_categories` AS `pc2` WHERE `pc`.`product_id`=`pc2`.`product_id`) 
                                AND `pc`.`category_id` not in(?@)", $id, $categories);
            $this->db->query($query);
        } else {
            // Если не прислали категорий, тогда удаляем все значения этого свойства для товаров
            $query = $this->db->placehold("DELETE `pv` FROM `__products_features_values` AS `pf`
                              INNER JOIN `__features_values` AS `fv` ON `pf`.`value_id`=`fv`.`id` AND `fv`.`feature_id` = ?", $id);
            $this->db->query($query);
        }
    }

    public function check_auto_id($feature_id, $auto_id, $field = "auto_name_id") {
        if (empty($auto_id)) {
            return true;
        }
        $this->db->query("SELECT id FROM __features WHERE $field=?", $auto_id);
        $exist_id = $this->db->result('id');
        return (!$exist_id || $feature_id == $exist_id);
    }

}
