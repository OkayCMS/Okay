<?php

require_once('Okay.php');

class FeaturesValues extends Okay {

    /**
     * Выборка значений свойств
     * Применяя фильтр по product_id вернутся все уникальные значения свойств, но не для каждого товара,
     * чтобы получить связку товара и id значения используйте метод get_product_value_id($product_id)
     */
    public function get_features_values($filter = array(), $count = false) {
        $id_filter          = '';
        $feature_id_filter  = '';
        $product_id_filter  = '';
        $category_id_filter = '';
        $visible_filter     = '';
        $brand_id_filter    = '';
        $features_filter    = '';
        $other_filter       = '';
        $yandex_filter      = '';
        $value_filter       = '';
        $translit_filter    = '';
        $keyword_filter     = '';
        $price_filter       = '';
        
        $order_by           = '';
        $group_by           = '';
        $page               = 1;
        $limit              = 0;
        $sql_limit          = '';

        $product_join       = '';
        $variant_join       = '';
        $currency_join      = '';

        $lang_id  = $this->languages->lang_id();
        $px  = ($lang_id ? 'l' : 'fv');
        $fpx = ($lang_id ? 'lf' : 'f');

        if(isset($filter['limit'])) {
            $limit = max(1, intval($filter['limit']));
        }

        if(isset($filter['page'])) {
            $page = max(1, intval($filter['page']));
        }

        if ($limit > 0) {
            $sql_limit = $this->db->placehold(' LIMIT ?, ? ', ($page - 1) * $limit, $limit);
        }

        if (isset($filter['yandex'])) {
            $yandex_filter = $this->db->placehold("AND `f`.`yandex`=? AND `pf`.`product_id` IN (
                SELECT 
                    distinct(p.id)
                FROM ok_variants v 
                LEFT JOIN ok_products p ON v.product_id=p.id
                WHERE 
                    p.visible 
                    AND v.feed = 1 
                    AND (v.stock >0 OR v.stock is NULL) 
                    AND v.price >0 
            )", (int)$filter['yandex']);
        }

        if(isset($filter['id'])) {
            $id_filter = $this->db->placehold('AND `fv`.`id` in(?@)', (array)$filter['id']);
        }

        if(isset($filter['feature_id'])) {
            $feature_id_filter = $this->db->placehold('AND `fv`.`feature_id` in(?@)', (array)$filter['feature_id']);
        }

        if(isset($filter['product_id'])) {
            $product_id_filter = $this->db->placehold('AND `pf`.`product_id` in(?@)', (array)$filter['product_id']);
        }

        if(isset($filter['category_id'])) {
            $category_id_filter = $this->db->placehold('INNER JOIN `__products_categories` `pc` ON `pc`.`product_id`=`pf`.`product_id` AND `pc`.`category_id` in(?@)', (array)$filter['category_id']);
        }

        if(isset($filter['visible'])) {
            $product_join = $this->db->placehold("LEFT JOIN `__products` AS `p` ON `p`.`id`=`pf`.`product_id`");
            $visible_filter = $this->db->placehold('AND `visible`=?', (int)$filter['visible']);
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
                $price_filter .= $this->db->placehold("AND floor(IF(`pv`.`currency_id`=0 OR `c`.`id` is null,`pv`.`price`, `pv`.`price`*`c`.`rate_to`/`c`.`rate_from`)*$coef)>= ? ", $this->db->escape(trim($filter['price']['min'])));
            }
            if(isset($filter['price']['max'])) {
                $price_filter .= $this->db->placehold("AND floor(IF(`pv`.`currency_id`=0 OR `c`.`id` is null,`pv`.`price`, `pv`.`price`*`c`.`rate_to`/`c`.`rate_from`)*$coef)<= ? ", $this->db->escape(trim($filter['price']['max'])));
            }
            $product_join = $this->db->placehold("LEFT JOIN `__products` AS `p` ON `p`.`id`=`pf`.`product_id`");
            $variant_join = 'LEFT JOIN `__variants` AS `pv` ON `pv`.`product_id` = `p`.`id`';
            $currency_join = 'LEFT JOIN `__currencies` AS `c` ON `c`.`id`=`pv`.`currency_id`';
        }
        
        if(isset($filter['brand_id'])) {
            $brand_id_filter = $this->db->placehold('AND `pf`.`product_id` in(SELECT `id` FROM `__products` WHERE `brand_id` in(?@))', (array)$filter['brand_id']);
        }

        if(isset($filter['features'])) {
            $lang_id_options_filter = '';
            $lang_options_join      = '';
            // Алиас для таблицы без языков
            $options_px = 'fv';
            if (!empty($lang_id)) {
                $lang_id_options_filter = $this->db->placehold("AND `lfv`.`lang_id`=?", $lang_id);
                $lang_options_join = $this->db->placehold("LEFT JOIN `__lang_features_values` AS `lfv` ON `lfv`.`feature_value_id`=`fv`.`id`");
                // Алиас для таблицы с языками
                $options_px = 'lfv';
            }

            $features_filter_array = array();
            foreach($filter['features'] as $feature_id=>$value) {
                $features_filter_array[] = $this->db->placehold("(`fv`.`feature_id`=? OR `pf`.`product_id` in (SELECT `pf`.`product_id` FROM `__products_features_values` AS `pf`
                            LEFT JOIN `__features_values` AS `fv` ON `fv`.`id`=`pf`.`value_id`
                            {$lang_options_join}
                            WHERE
                                `{$options_px}`.`translit` in(?@)
                                AND `{$options_px}`.`feature_id`=?
                                $lang_id_options_filter)) ", $feature_id, (array)$value, $feature_id);
            }

            $features_filter = "AND (" . implode(" AND ", $features_filter_array) . ")";
        }

        /**
         * Т.к. иногда нужно доставать только выбранные значения, выносим это в отдельный фильтр.
         * можно применять в паре с $filter['features'] тогда результат от $filter['features'] будет дополняться результатом из $filter['selected_features']
         * таким образом на странице https://demookay.com/catalog/gadzhety/seriya-redminote4_redmi3s/razreshenieekrana-1080x1920piks
         * "Redmi 3S" больше не будет пропадать
         */
        if(isset($filter['selected_features'])) {
            $selected_features_array = array();
            foreach($filter['selected_features'] as $feature_id=>$value) {
                // Собираем еще фильтр по всем выбранным значениям, чтобы они из фильтра не пропадали, и их можно было отменить
                $selected_features_array[] = $this->db->placehold("({$px}.`translit` in(?@) AND `fv`.`feature_id`=?)", (array)$value, $feature_id);
            }
            
            if (!empty($selected_features_array)) {
                // Если применялся фильтр по $filter['features'], тогда нужно объединить запросы
                // Забираем сюда фильтры по цене и бренду
                if (!empty($features_filter_array)) {
                    $features_filter = "AND (" . implode(" AND ", $features_filter_array) . $price_filter . $brand_id_filter . " OR " . implode(" OR ", $selected_features_array) . ")";
                } else {
                    $features_filter = "AND (" . implode(" OR ", $selected_features_array) . $price_filter . $brand_id_filter . ")";
                }
                $price_filter = '';
                $brand_id_filter = '';
            }
        }

        if (!empty($filter['other_filter'])) {
            $other_filter = "AND (";
            if (in_array("featured", $filter['other_filter'])) {
                $other_filter .= "`pf`.`product_id` IN(SELECT `id` FROM `__products` WHERE `featured`=1) OR ";
            }
            if (in_array("discounted", $filter['other_filter'])) {
                $other_filter .= "(SELECT 1 FROM `__variants` `pv` WHERE `pv`.`product_id`=`pf`.`product_id` AND `pv`.`compare_price`>0 LIMIT 1) = 1 OR ";
            }
            $other_filter = substr($other_filter, 0, -4).")";
        }

        $lang_options_sql = $this->languages->get_query(array('object'=>'feature_value', 'px_lang'=>$px, 'px'=>'fv'));
        $lang_features_sql = $this->languages->get_query(array('object'=>'feature', 'px_lang'=>$fpx, 'px'=>'f'));

        $lang_options_sql->fields  = $this->replace_lang_fields($lang_options_sql->fields, $px);
        $lang_features_sql->fields = $this->replace_lang_fields($lang_features_sql->fields, $fpx);

        if(isset($filter['value'])) {
            $value = $this->db->escape(trim($filter['value']));
            if(!empty($value)) {
                $value_filter = $this->db->placehold("AND $px.`value` = ? ", $value);
            }
        }

        if(isset($filter['translit'])) {
            $translit_filter = $this->db->placehold("AND $px.`translit` IN (?@) ", (array)$filter['translit']);
        }

        if(isset($filter['keyword'])) {
            $keyword = $this->db->escape(trim($filter['keyword']));
            if(!empty($keyword)) {
                $keyword_filter = $this->db->placehold("AND $px.`value` LIKE '$keyword%' ");
            }
        }

        if ($count) {
            $select = $this->db->placehold("COUNT(DISTINCT `fv`.`id`) AS `count`");
            $sql_limit = "";
        } else {
            $select = $this->db->placehold("
                `fv`.`id`,
                `fv`.`feature_id`,
                `fv`.`position`,
                count(`pf`.`product_id`)  AS `count`,
                MAX(`f`.`auto_name_id`)   AS `auto_name_id`, 
                MAX(`f`.`auto_value_id`)  AS `auto_value_id`, 
                MAX(`f`.`url`)            AS `url`, 
                MAX(`f`.`in_filter`)      AS `in_filter`, 
                MAX(`f`.`yandex`)         AS `yandex`, 
                MAX(`f`.`url_in_product`) AS `url_in_product`,
                MAX(`fv`.`to_index`)      AS `to_index`,
                $lang_options_sql->fields,
                $lang_features_sql->fields");
            $group_by = $this->db->placehold("GROUP BY `fv`.`id`");
            $order_by = $this->db->placehold("ORDER BY `f`.`position` ASC, `fv`.`position` ASC, `value` ASC");
        }

        $query = $this->db->placehold("SELECT 
                $select
            FROM `__features_values` AS `fv`
            LEFT JOIN `__features` AS `f` ON `f`.`id`=`fv`.`feature_id`
            LEFT JOIN `__products_features_values` AS `pf` ON `pf`.`value_id`=`fv`.`id`
            $lang_options_sql->join
            $lang_features_sql->join
            $product_join
            $category_id_filter
            $variant_join
            $currency_join
            WHERE 
                1 
                $feature_id_filter 
                $product_id_filter 
                $visible_filter
                $brand_id_filter 
                $features_filter 
                $yandex_filter
                $other_filter
                $value_filter
                $translit_filter
                $id_filter
                $keyword_filter
                $price_filter
            $group_by
            $order_by
            $sql_limit
        ");

        $this->db->query($query);
        if ($count) {
            return $this->db->result('count');
        } else {
            return $this->db->results();
        }
    }
    
    /**
     * @param array $features
     * example $features[feature_id] = [value1_id, value2_id ...]
     * Метод возвращает только мультиязычные поля значений свойств, используется для построения alternate на странице фильтра
     * @return array
     * result [
     *  lang_id => [
     *          feature1_id => [
     *              value1_id => $value1,
     *              value2_id => $value2
     *          ],
     *          feature2_id => [
     *              value3_id => $value3,
     *              value4_id => $value4
     *          ]
     *      ]
     *  ]
     */
    public function get_features_values_all_lang($features = array()) {
        
        if (empty($features)) {
            return array();
        }

        $values_filter = array();
        foreach ($features as $feature_id=>$values_ids) {
            if (!empty($values_ids)) {
                $values_filter[] = $this->db->placehold("(`feature_id`=? AND `feature_value_id` IN (?@))", (int)$feature_id, $values_ids);
            }
        }
        
        $result = array();
        if (!empty($values_filter)) {
            $values_filter = implode(' OR ', $values_filter);
            $query = $this->db->placehold("SELECT `lang_id`, `feature_value_id`, `feature_id`, `value`, `translit` FROM `__lang_features_values` WHERE $values_filter");
            $this->db->query($query);
            
            foreach ($this->db->results() as $res) {
                $result[$res->lang_id][$res->feature_id][$res->feature_value_id] = $res;
            }
            
        }
        
        return $result;
    }

    public function get_feature_value($id) {

        if(empty($id)) {
            return false;
        }

        $lang_id  = $this->languages->lang_id();
        $px  = ($lang_id ? 'l' : 'fv');

        $lang_sql = $this->languages->get_query(array('object'=>'feature_value', 'px_lang'=>$px, 'px'=>'fv'));

        $query = $this->db->placehold("SELECT 
                `fv`.`id`,
                `fv`.`feature_id`,
                `fv`.`to_index`,
                $lang_sql->fields
            FROM `__features_values` AS `fv`
            $lang_sql->join
            WHERE 
                `fv`.`id`=?
            LIMIT 1", (int)$id);

        $this->db->query($query);
        return $this->db->result();
    }

    /**
     * Для применения MAX() получаем мультиязычные поля, и строим запрос вида
     * MAX(l.value) AS value, MAX(l.translit) AS translit
     * MAX() Применяем для совместимости с ONLY_FULL_GROUP_BY
     */
    private function replace_lang_fields($fields, $px) {
        if ($fields) {
            $lang_sql_fields = [];
            $lang_fields = (array)explode(',', $fields);

            foreach ($lang_fields as $lf) {
                $lf = trim($lf);
                /*Вырезаем алиас таблицы*/
                $lf_clear = preg_replace("~`?$px`?\.~", "", $lf);
                $lang_sql_fields[] = "MAX($lf) AS $lf_clear";
            }

            if (!empty($lang_sql_fields)) {
                $lang_sql_fields = implode(", ", $lang_sql_fields);
            }
            return $lang_sql_fields;
        }
        return null;
    }

    /*Удаление значения свойства*/
    public function delete_feature_value($value_id = null, $feature_id = null) {

        $features_filter = array();
        if (null !== $value_id) {
            $features_filter['id'] = $value_id;
        }

        if (null !== $feature_id) {
            $features_filter['feature_id'] = $feature_id;
        }

        // TODO удалять с алиасов
        $this->delete_product_value(null, $value_id);

        if ($values = $this->get_features_values($features_filter)) {
            $values_ids = array();
            foreach ($values as $f) {
                $values_ids[] = $f->id;
            }

            $query = $this->db->placehold("DELETE FROM `__lang_features_values` WHERE `feature_value_id` in (?@)", $values_ids);
            $this->db->query($query);

            $query = $this->db->placehold("DELETE FROM `__features_values` WHERE `id` in (?@)", $values_ids);
            if($this->db->query($query)) {
                return true;
            }
        }
        return false;
    }

    /*добавление значения свойства*/
    public function add_feature_value($feature_value) {

        $feature_value = (object)$feature_value;

        if (empty($feature_value->value) || empty($feature_value->feature_id)) {
            return false;
        }

        $feature_value->value = trim($feature_value->value);

        if (empty($feature_value->translit)) {
            $feature_value->translit = $this->translit_alpha($feature_value->value);
        }
        $feature_value->translit = strtr(strtolower(trim($feature_value->translit)), $this->spec_pairs);

        $result = $this->languages->get_description($feature_value, 'feature_value', false);

        if ($this->db->query("INSERT INTO `__features_values` SET ?%", $feature_value)) {
            $id = $this->db->insert_id();
            if (empty($feature_value->position)) {
                $this->db->query("UPDATE `__features_values` SET `position`=`id` WHERE `id`=?", $id);
            }

            if (!empty($result->description)) {
                
                if (!empty($feature_value->feature_id)) {
                    $result->description->feature_id = $feature_value->feature_id;
                }
                
                $this->languages->action_description($id, $result->description, 'feature_value');
            }
            return $id;
        } else {
            return false;
        }
    }

    /*Обновление значения свойства*/
    public function update_feature_value($id, $feature_value) {
        $feature_value = (object)$feature_value;

        if (!empty($feature_value->value)) {
            $feature_value->value = trim($feature_value->value);
        }

        if (empty($feature_value->translit) && !empty($feature_value->value)) {
            $feature_value->translit = $this->translit_alpha($feature_value->value);
        }

        if (!empty($feature_value->translit)) {
            $feature_value->translit = strtr(strtolower(trim($feature_value->translit)), $this->spec_pairs);
        }

        $result = $this->languages->get_description($feature_value, 'feature_value');

        if (!empty((array)$feature_value)) {
            $query = $this->db->placehold("UPDATE `__features_values` SET ?% WHERE `id`=? LIMIT 1", $feature_value, (int)$id);
            $this->db->query($query);
        }
        
        if (!empty($result->description)) {

            if (!empty($feature_value->feature_id)) {
                $result->description->feature_id = $feature_value->feature_id;
            }
            
            $this->languages->action_description($id, $result->description, 'feature_value', $this->languages->lang_id());
        }
        return $id;
    }

    /*добавление значения свойства товара*/
    public function add_product_value($product_id, $value_id) {

        if (empty($product_id) || empty($value_id)) {
            return false;
        }

        $query = $this->db->placehold("INSERT IGNORE INTO `__products_features_values` SET `product_id`=?, `value_id`=?", $product_id, $value_id);

        if ($this->db->query($query)) {
            return true;
        }
        return false;
    }

    /*Метод возвращает ID всех значений свойств товаров*/
    public function get_product_value_id($product_id) {

        if (empty($product_id)) {
            return false;
        }

        $query = $this->db->placehold("SELECT `product_id`, `value_id`
                FROM `__products_features_values`
                WHERE `product_id` IN (?@)", (array)$product_id);

        if ($this->db->query($query)) {
            return $this->db->results();
        }
        return false;
    }

    /*удаление связки значения свойства и товара*/
    public function delete_product_value($product_id, $value_id = null, $feature_id = null) {

        $product_id_filter  = '';
        $value_id_filter    = '';
        $feature_id_filter  = '';
        $feature_id_join    = '';

        /*Удаляем только если передали хотябы один аргумент*/
        if (empty($product_id) && empty($value_id) && empty($feature_id)) {
            return false;
        }

        if (!empty($product_id)) {
            $product_id_filter = $this->db->placehold("AND `pf`.`product_id` in (?@)", (array)$product_id);
        }

        if (!empty($value_id)) {
            $value_id_filter = $this->db->placehold("AND `pf`.`value_id` in (?@)", (array)$value_id);
        }

        if (!empty($feature_id)) {
            $feature_id_filter = $this->db->placehold("AND `fv`.`feature_id` in (?@)", (array)$feature_id);
            $feature_id_join   = $this->db->placehold("INNER JOIN `__features_values` as `fv` ON `pf`.`value_id`=`fv`.`id`");
        }

        $query = $this->db->placehold("DELETE `pf`
                                FROM `__products_features_values` as `pf`
                                    $feature_id_join 
                                WHERE 1 
                                    $product_id_filter
                                    $value_id_filter
                                    $feature_id_filter
                                    ");

        if ($this->db->query($query)) {
            return true;
        }
        return false;
    }

}
