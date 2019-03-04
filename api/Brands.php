<?php

require_once('Okay.php');

class Brands extends Okay {

    /*Выбираем все бренды*/
    public function get_brands($filter = array(), $count = false) {
        $limit = 100;
        $page  = 1;
        $joins = '';
        $where = '1';
        $group_by = '';
        $order = 'b.position';
        $lang_sql = $this->languages->get_query(array('object'=>'brand'));
        $select = "DISTINCT b.id, 
                b.url, 
                b.image, 
                b.last_modify,
                b.visible,
                b.position,
                $lang_sql->fields";
        $visible = '';
        
        $joins .= $this->db->placehold(" LEFT JOIN __products p ON p.brand_id=b.id");

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

        if(isset($filter['visible'])) {
            $where .= $visible = $this->db->placehold(' AND p.visible=?', intval($filter['visible']));
        }

        if(isset($filter['visible_brand'])) {
            $where .= $this->db->placehold(' AND b.visible=?', intval($filter['visible_brand']));
        }

        if(isset($filter['product_id'])) {
            $where .= $this->db->placehold(' AND p.id in (?@)', (array)$filter['product_id']);
        }
        
        $first_currency = $this->money->get_currencies(array('enabled'=>1));
        $first_currency = reset($first_currency);
        $coef = 1;
        
        if(isset($_SESSION['currency_id']) && $first_currency->id != $_SESSION['currency_id']) {
            $currency = $this->money->get_currency(intval($_SESSION['currency_id']));
            $coef = $currency->rate_from / $currency->rate_to;
        }
        
        if(isset($filter['price'])) {
            if(isset($filter['price']['min'])) {
                $where .= $this->db->placehold(" AND floor(IF(pv.currency_id=0 OR c.id is null,pv.price, pv.price*c.rate_to/c.rate_from)*$coef)>= ? ", $this->db->escape(trim($filter['price']['min'])));
            }
            if(isset($filter['price']['max'])) {
                $where .= $this->db->placehold(" AND floor(IF(pv.currency_id=0 OR c.id is null,pv.price, pv.price*c.rate_to/c.rate_from)*$coef)<= ? ", $this->db->escape(trim($filter['price']['max'])));
            }
            $joins .= $this->db->placehold(" LEFT JOIN __variants pv ON pv.product_id = p.id");
            $joins .= $this->db->placehold(" LEFT JOIN __currencies c ON c.id=pv.currency_id");
        }
        
        if(!empty($filter['category_id'])) {
            $joins .= $this->db->placehold(" LEFT JOIN __products_categories pc ON p.id = pc.product_id");
            $where .= $this->db->placehold(" AND pc.category_id in(?@) $visible", (array)$filter['category_id']);
        }

        if(!empty($filter['features'])) {

            $lang_id_options_filter = '';
            $lang_options_join      = '';
            // Алиас для таблицы без языков
            $options_px = 'fv';
            if (!empty($lang_id)) {
                $lang_id_options_filter = $this->db->placehold("AND `lfv`.`lang_id`=?", $lang_id);
                $lang_options_join = $this->db->placehold("LEFT JOIN `__lang_features_values` AS `lfv` ON `pf`.`value_id`=`lfv`.`feature_value_id`");
                // Алиас для таблицы с языками
                $options_px = 'lfv';
            }

            foreach($filter['features'] as $feature_id=>$value) {
                $features_values[] = $this->db->placehold("(
                            `{$options_px}`.`translit` in(?@)
                            AND `{$options_px}`.`feature_id`=?)", (array)$value, $feature_id);
            }

            if (!empty($features_values)) {
                $features_values = implode(' OR ', $features_values);

                $features_values_products_join = '';
                if (!empty($visible)) {
                    $features_values_products_join = $this->db->placehold("LEFT JOIN `__products` AS `p` ON `p`.`id`=`pf`.`product_id`");
                }

                $where .= $this->db->placehold(" AND `p`.`id` in (SELECT 
                    `pf`.`product_id`
                FROM `__products_features_values` AS `pf`
                $lang_options_join
                $features_values_products_join
                LEFT JOIN `__features_values` AS `fv` ON `fv`.`id`=`pf`.`value_id`
                WHERE ($features_values) 
                $lang_id_options_filter
                $visible
                GROUP BY `pf`.`product_id` HAVING COUNT(*) >= ?)", count($filter['features']));
            }
        }

        if (!empty($filter['other_filter'])) {
            $other_filter = " AND (";
            if (in_array("featured", $filter['other_filter'])) {
                $other_filter .= "p.featured=1 OR ";
            }
            if (in_array("discounted", $filter['other_filter'])) {
                $other_filter .= "(SELECT 1 FROM __variants pv WHERE pv.product_id=p.id AND pv.compare_price>0 LIMIT 1) = 1 OR ";
            }
            $where .= substr($other_filter, 0, -4).")";
        }

        if(!empty($filter['selected_brands'])) {
            $where .= $this->db->placehold(' OR b.id in (?@)', (array)$filter['selected_brands']);
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
        
        // Выбираем все бренды
        $query = $this->db->placehold("SELECT $select
            FROM __brands b
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

    public function count_brands($filter = array()) {
        return $this->get_brands($filter, true);
    }

    /*Выбираем конкретный бренд*/
    public function get_brand($id) {
        if (empty($id)) {
            return false;
        }
        if(is_int($id)) {
            $filter = $this->db->placehold('AND b.id = ?', intval($id));
        } else {
            $filter = $this->db->placehold('AND b.url = ?', $id);
        }
        
        $lang_sql = $this->languages->get_query(array('object'=>'brand'));
        $query = "SELECT 
                b.id, 
                b.url, 
                b.image, 
                b.last_modify,
                b.visible,
                b.position,
                $lang_sql->fields                
            FROM __brands b
            $lang_sql->join
            WHERE 
                1 
                $filter
            LIMIT 1
        ";
        
        $this->db->query($query);
        return $this->db->result();
    }

    /*Добавление бренда*/
    public function add_brand($brand) {
        $brand = (object)$brand;
        $brand->url = preg_replace("/[\s]+/ui", '', $brand->url);
        $brand->url = strtolower(preg_replace("/[^0-9a-z]+/ui", '', $brand->url));
        if(empty($brand->url)) {
            $brand->url = $this->translit_alpha($brand->name);
        }
        while($this->get_brand((string)$brand->url)) {
            if(preg_match('/(.+)([0-9]+)$/', $brand->url, $parts)) {
                $brand->url = $parts[1].''.($parts[2]+1);
            } else {
                $brand->url = $brand->url.'2';
            }
        }
        
        // Проверяем есть ли мультиязычность и забираем описания для перевода
        $result = $this->languages->get_description($brand, 'brand');

        $this->db->query("INSERT INTO __brands SET ?%", $brand);
        $id = $this->db->insert_id();
        $this->db->query("UPDATE __brands SET position=id WHERE id=? LIMIT 1", $id);
        
        // Если есть описание для перевода. Указываем язык для обновления
        if(!empty($result->description)) {
            $this->languages->action_description($id, $result->description, 'brand');
        }
        return $id;
    }

    /*Обновление бренда*/
    public function update_brand($id, $brand) {
        $brand = (object)$brand;
        // Проверяем есть ли мультиязычность и забираем описания для перевода
        $result = $this->languages->get_description($brand, 'brand');

        $query = $this->db->placehold("UPDATE __brands SET ?% WHERE id=? LIMIT 1", $brand, intval($id));
        $this->db->query($query);
        
        // Если есть описание для перевода. Указываем язык для обновления
        if(!empty($result->description)) {
            $this->languages->action_description($id, $result->description, 'brand', $this->languages->lang_id());
        }
        
        return $id;
    }

    /*Удаление бренда*/
    public function delete_brand($id) {
        if(!empty($id)) {
            $this->image->delete_image($id, 'image', 'brands', $this->config->original_brands_dir, $this->config->resized_brands_dir);
            $query = $this->db->placehold("DELETE FROM __brands WHERE id=? LIMIT 1", $id);
            $this->db->query($query);
            $query = $this->db->placehold("UPDATE __products SET brand_id=NULL WHERE brand_id=?", $id);
            $this->db->query($query);
            $this->db->query("DELETE FROM __lang_brands WHERE brand_id=?", $id);
        }
    }
    
}
