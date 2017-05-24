<?php

require_once('Okay.php');

class Features extends Okay {

    /*Выборка всех свойств товаров*/
    public function get_features($filter = array()) {
        $category_id_filter = '';
        if(isset($filter['category_id'])) {
            $category_id_filter = $this->db->placehold('AND id in(SELECT feature_id FROM __categories_features AS cf WHERE cf.category_id in(?@))', (array)$filter['category_id']);
        }
        
        $in_filter_filter = '';
        if(isset($filter['in_filter'])) {
            $in_filter_filter = $this->db->placehold('AND f.in_filter=?', intval($filter['in_filter']));
        }
        
        $id_filter = '';
        if(!empty($filter['id'])) {
            $id_filter = $this->db->placehold('AND f.id in(?@)', (array)$filter['id']);
        }
        
        $lang_sql = $this->languages->get_query(array('object'=>'feature'));
        // Выбираем свойства
        $query = $this->db->placehold("SELECT 
                f.id, 
                f.position, 
                f.in_filter, 
                f.yandex, 
                f.auto_name_id, 
                f.auto_value_id, 
                f.url, 
                $lang_sql->fields 
            FROM __features AS f 
            $lang_sql->join
            WHERE 
                1 
                $category_id_filter 
                $in_filter_filter 
                $id_filter 
            ORDER BY f.position 
        ");
        $this->db->query($query);
        return $this->db->results();
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
                $this->db->query('select product_id from __options where feature_id=?', intval($id));
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
            $this->db->query('select product_id from __options where feature_id=?', intval($id));
            $p_ids = $this->db->results('product_id');
            if (!empty($p_ids)) {
                $this->db->query('update __products set last_modify=now() where id in(?@)', $p_ids);
            }
            
            $query = $this->db->placehold("DELETE FROM __features WHERE id=? LIMIT 1", intval($id));
            $this->db->query($query);
            $query = $this->db->placehold("DELETE FROM __options WHERE feature_id=?", intval($id));
            $this->db->query($query);
            $query = $this->db->placehold("DELETE FROM __categories_features WHERE feature_id=?", intval($id));
            $this->db->query($query);
            $this->db->query("DELETE FROM __lang_features WHERE feature_id=?", intval($id));
        }
    }

    /*Удаление значения свойства*/
    public function delete_option($product_id, $feature_id) {
        $lang_id  = $this->languages->lang_id();
        $lang_id_filter = '';
        if($lang_id) {
            $lang_id_filter = $this->db->placehold("AND lang_id=?", $lang_id);
        }
        
        $query = $this->db->placehold("DELETE FROM __options WHERE product_id=? AND feature_id=? $lang_id_filter LIMIT 1", intval($product_id), intval($feature_id));
        $this->db->query($query);
    }

    /*Обновление значения свойства*/
    public function update_option($product_id, $feature_id, $value, $translit = '') {
        $lang_id  = $this->languages->lang_id();
        $lang_id_filter = '';
        $into_lang = '';
        if($lang_id) {
            $lang_id_filter = $this->db->placehold("AND lang_id=?", $lang_id);
            $into_lang = $this->db->placehold("lang_id=?, ", $lang_id);
        }
        $translit = $this->db->placehold("translit=?, ", ($translit != '' ? $translit : $this->translit_alpha($value)));
        
        if($value != '') {
            $query = $this->db->placehold("REPLACE INTO __options SET $into_lang $translit value=?, product_id=?, feature_id=?", $value, intval($product_id), intval($feature_id));
            $this->db->query($query);
        } else {
            $query = $this->db->placehold("DELETE FROM __options WHERE feature_id=? AND product_id=? $lang_id_filter", intval($feature_id), intval($product_id));
            $this->db->query($query);
        }
        return true;
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
                $this->db->query('select o.product_id 
                    from __options o
                    inner join __products_categories pc on(pc.product_id=o.product_id)
                    where o.feature_id=? and pc.category_id in(?@) group by o.product_id', intval($id), $diff);
                $p_ids = $this->db->results('product_id');
                if (!empty($p_ids)) {
                    $this->db->query('update __products set last_modify=now() where id in(?@)', $p_ids);
                }
            }
        } else {
            $this->db->query('select product_id from __options where feature_id=?', intval($id));
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
            
            // Удалим значения из options
            $query = $this->db->placehold("DELETE o FROM __options o
                LEFT JOIN __products_categories pc ON pc.product_id=o.product_id
                WHERE 
                    o.feature_id=? 
                    AND pc.position=(SELECT MIN(pc2.position) FROM __products_categories pc2 WHERE pc.product_id=pc2.product_id) 
                    AND pc.category_id not in(?@)", $id, $categories);
            $this->db->query($query);
        } else {
            // Удалим значения из options
            $query = $this->db->placehold("DELETE o FROM __options o WHERE o.feature_id=?", $id);
            $this->db->query($query);
        }
    }

    /*Выборка значений свойств*/
    public function get_options($filter = array()) {
        $feature_id_filter = '';
        $product_id_filter = '';
        $category_id_filter = '';
        $visible_filter = '';
        $brand_id_filter = '';
        $features_filter = '';
        
        if(empty($filter['feature_id']) && empty($filter['product_id'])) {
            return array();
        }
        
        $group_by = '';
        if(isset($filter['feature_id'])) {
            $group_by = 'GROUP BY feature_id, value';
        }
        
        if(isset($filter['feature_id'])) {
            $feature_id_filter = $this->db->placehold('AND po.feature_id in(?@)', (array)$filter['feature_id']);
        }
        
        if(isset($filter['product_id'])) {
            $product_id_filter = $this->db->placehold('AND po.product_id in(?@)', (array)$filter['product_id']);
        }
        
        if(isset($filter['category_id'])) {
            $category_id_filter = $this->db->placehold('INNER JOIN __products_categories pc ON pc.product_id=po.product_id AND pc.category_id in(?@)', (array)$filter['category_id']);
        }
        
        if(isset($filter['visible'])) {
            $visible_filter = $this->db->placehold('INNER JOIN __products p ON p.id=po.product_id AND visible=?', intval($filter['visible']));
        }
        
        if(isset($filter['brand_id'])) {
            $brand_id_filter = $this->db->placehold('AND po.product_id in(SELECT id FROM __products WHERE brand_id in(?@))', (array)$filter['brand_id']);
        }
        
        if(isset($filter['features'])) {
            foreach($filter['features'] as $feature=>$value) {
                $features_filter .= $this->db->placehold('AND (po.feature_id=? OR po.product_id in (SELECT product_id FROM __options WHERE feature_id=? AND translit in(?@) )) ', $feature, $feature, $value);
            }
        }
        
        $lang_id  = $this->languages->lang_id();
        $lang_id_filter = '';
        if($lang_id) {
            $lang_id_filter = $this->db->placehold("AND po.lang_id=?", $lang_id);
        }
        
        $query = $this->db->placehold("SELECT 
                po.product_id, 
                po.feature_id, 
                po.value, 
                po.translit, 
                count(po.product_id) as count
            FROM __options po
            $visible_filter
            $category_id_filter
            WHERE 
                1 
                $lang_id_filter 
                $feature_id_filter 
                $product_id_filter 
                $brand_id_filter 
                $features_filter 
            GROUP BY po.feature_id, po.value 
            ORDER BY po.value=0, -po.value DESC, po.value
        ");
        
        $this->db->query($query);
        return $this->db->results();
    }

    /*Выборка значений свойств товара(ов)*/
    public function get_product_options($filter = array()) {
        $product_id_filter = '';
        if (!empty($filter['product_id'])) {
            $product_id_filter = $this->db->placehold("AND po.product_id in(?@)", (array)$filter['product_id']);
        }
        $yandex_filter = '';
        if (isset($filter['yandex'])) {
            $yandex_filter = $this->db->placehold("AND f.yandex=?", intval($filter['yandex']));
        }
        
        $lang_id  = $this->languages->lang_id();
        $lang_id_filter = '';
        if($lang_id) {
            $lang_id_filter = $this->db->placehold("AND po.lang_id=?", $lang_id);
        }
        
        $lang_sql = $this->languages->get_query(array('object'=>'feature', 'px'=>'f'));
        $query = $this->db->placehold("SELECT 
                f.id as feature_id, 
                f.auto_name_id, 
                f.auto_value_id, 
                f.url, 
                po.value, 
                po.product_id, 
                po.translit, 
                $lang_sql->fields 
            FROM __options po
            LEFT JOIN __features f ON f.id=po.feature_id
            $lang_sql->join
            WHERE 
                1 
                $product_id_filter 
                $yandex_filter 
                $lang_id_filter 
            ORDER BY f.position
        ");

        $this->db->query($query);
        return $this->db->results();
    }

    /*Выборка свойств для товаров из списка сравнения*/
    public function get_comparison_options($products_ids = array()) {
        if(empty($products_ids)) {
            return array();
        }
        
        $lang_id  = $this->languages->lang_id();
        $lang_id_filter = '';
        if($lang_id) {
            $lang_id_filter = $this->db->placehold("AND po.lang_id=?", $lang_id);
        }
        
        $query = $this->db->placehold("SELECT 
                po.product_id, 
                po.feature_id, 
                po.value 
            FROM __options po
            WHERE 
                1 
                AND po.product_id in(?@) 
                $lang_id_filter
            ORDER BY po.feature_id, po.value=0, -po.value DESC, po.value
        ", (array)$products_ids);
        
        $this->db->query($query);
        $res = $this->db->results();
        
        return $res;
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
