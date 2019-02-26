<?php

require_once('Okay.php');

class FeaturesAliases extends Okay {

    public function get_features_aliases($filter = array(), $count = false) {
        // По умолчанию
        $limit = 100;
        $page = 1;
        $joins = '';
        $where = '1';
        $group_by = '';
        $order = 'f.position';
        $lang_sql = $this->languages->get_query(array('object'=>'feature_alias'));
        $select = "f.id, 
                f.variable,
                f.position,
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
            FROM __features_aliases f
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

    public function get_features_alias($id) {

        if (empty($id)) {
            return false;
        }

        if(is_int($id)) {
            $id_filter = $this->db->placehold('AND f.id = ?', $id);
        } else {
            $id_filter = $this->db->placehold('AND f.variable = ?', $id);
        }

        $lang_sql = $this->languages->get_query(array('object'=>'feature_alias'));
        // Выбираем свойства
        $query = $this->db->placehold("SELECT
                f.id,
                f.variable,
                f.position,
                $lang_sql->fields
            FROM __features_aliases AS f
            $lang_sql->join
            WHERE
                1
                $id_filter
            LIMIT 1
        ");
        $this->db->query($query);
        return $this->db->result();
    }

    public function add_feature_alias($alias) {

        $alias = (array) $alias;
        if(empty($alias['variable'])) {
            $alias['variable'] = $this->translit($alias['name']);
            $alias['variable'] = strtolower(preg_replace("/[^0-9a-z]+/ui", '', $alias['variable']));
        }

        // Если есть склонение с такой переменной, добавляем к ней число
        while($this->get_features_alias((string)$alias['variable'])) {
            if(preg_match('/(.+)_([0-9]+)$/', $alias['variable'], $parts)) {
                $alias['variable'] = $parts[1].'_'.($parts[2]+1);
            } else {
                $alias['variable'] = $alias['variable'].'_2';
            }
        }

        $alias = (object)$alias;
        // Проверяем есть ли мультиязычность и забираем описания для перевода
        $result = $this->languages->get_description($alias, 'feature_alias');
        
        $query = $this->db->placehold("INSERT INTO __features_aliases SET ?%", $alias);
        $this->db->query($query);
        $id = $this->db->insert_id();
        $query = $this->db->placehold("UPDATE __features_aliases SET position=id WHERE id=? LIMIT 1", $id);
        $this->db->query($query);
        
        // Если есть описание для перевода. Указываем язык для обновления
        if(!empty($result->description)) {
            $this->languages->action_description($id, $result->description, 'feature_alias');
        }
        return $id;
    }

    public function update_feature_alias($id, $alias) {

        $alias = (object)$alias;
        // Проверяем есть ли мультиязычность и забираем описания для перевода
        $result = $this->languages->get_description($alias, 'feature_alias');
        
        $query = $this->db->placehold("UPDATE __features_aliases SET ?% WHERE id in(?@) LIMIT ?", $alias, (array)$id, count((array)$id));
        $this->db->query($query);
        
        // Если есть описание для перевода. Указываем язык для обновления
        if(!empty($result->description)) {
            $this->languages->action_description($id, $result->description, 'feature_alias', $this->languages->lang_id());
        }
        return $id;
    }

    public function delete_feature_alias($id = array()) {
        if(!empty($id)) {
            $query = $this->db->placehold("DELETE FROM __features_aliases WHERE id=? LIMIT 1", (int)$id);
            $this->db->query($query);
            $query = $this->db->placehold("DELETE FROM __lang_features_aliases WHERE feature_alias_id=?", (int)$id);
            $this->db->query($query);
            $query = $this->db->placehold("DELETE FROM __options_aliases_values WHERE feature_alias_id=?", (int)$id);
            $this->db->query($query);
        }
    }

    // метод возвращает значения алиасов для каждого свойства
    public function get_feature_aliases_values($filter = array()) {

        $feature_id_filter = '';
        $feature_alias_id_filter = '';

        if(!empty($filter['feature_id'])) {
            $feature_id_filter = $this->db->placehold('AND f.feature_id in(?@)', (array)$filter['feature_id']);
        }
        if(!empty($filter['feature_alias_id'])) {
            $feature_alias_id_filter = $this->db->placehold('AND f.feature_alias_id in(?@)', (array)$filter['feature_alias_id']);
        }

        $lang_sql = $this->languages->get_query(array('object'=>'feature_alias_value'));

        $query = $this->db->placehold("SELECT
                f.id,
                f.feature_alias_id,
                f.feature_id,
                fa.variable,
                $lang_sql->fields
            FROM __features_aliases_values AS f
            $lang_sql->join
            LEFT JOIN __features_aliases fa ON fa.id=f.feature_alias_id
            WHERE
                1
                $feature_alias_id_filter
                $feature_id_filter
        ");
        $this->db->query($query);
        return $this->db->results();
    }

    public function add_feature_alias_value($alias_value) {
        $alias_value = (object)$alias_value;
        // Проверяем есть ли мультиязычность и забираем описания для перевода
        $result = $this->languages->get_description($alias_value, 'feature_alias_value');

        $query = $this->db->placehold("INSERT INTO __features_aliases_values SET ?%", $alias_value);
        $this->db->query($query);
        $id = $this->db->insert_id();

        // Если есть описание для перевода. Указываем язык для обновления
        if(!empty($result->description)) {
            $this->languages->action_description($id, $result->description, 'feature_alias_value');
        }
        return $id;
    }

    public function update_feature_alias_value($id, $alias_value) {

        $alias_value = (object)$alias_value;
        // Проверяем есть ли мультиязычность и забираем описания для перевода
        $result = $this->languages->get_description($alias_value, 'feature_alias_value');

        $query = $this->db->placehold("UPDATE __features_aliases_values SET ?% WHERE id in(?@) LIMIT ?", $alias_value, (array)$id, count((array)$id));
        $this->db->query($query);

        // Если есть описание для перевода. Указываем язык для обновления
        if(!empty($result->description)) {
            $this->languages->action_description($id, $result->description, 'feature_alias_value', $this->languages->lang_id());
        }
        return $id;
    }

    public function delete_feature_alias_value($id = array()) {
        if(!empty($id)) {
            $query = $this->db->placehold("DELETE FROM __features_aliases_values WHERE id=? LIMIT 1", (int)$id);
            $this->db->query($query);
            $query = $this->db->placehold("DELETE FROM __lang_features_aliases_values WHERE feature_alias_value_id=?", (int)$id);
            $this->db->query($query);
        }
    }

    public function add_option_alias_value($option_alias) {
        $query = $this->db->placehold("INSERT INTO __options_aliases_values SET ?%", $option_alias);
        $this->db->query($query);
        return true;
    }

    // метод возвращает значения алиасов для каждого свойства
    public function get_options_aliases_values($filter = array()) {

        $feature_id_filter = '';
        $feature_alias_id_filter = '';
        $translit_filter = '';
        $lang_id_filter = $this->db->placehold("AND ov.lang_id=?", $this->languages->lang_id());

        if(!empty($filter['feature_id'])) {
            $feature_id_filter = $this->db->placehold('AND ov.feature_id in(?@)', (array)$filter['feature_id']);
        }
        if(!empty($filter['feature_alias_id'])) {
            $feature_alias_id_filter = $this->db->placehold('AND ov.feature_alias_id in(?@)', (array)$filter['feature_alias_id']);
        }
        if(!empty($filter['translit'])) {
            $translit_filter = $this->db->placehold('AND ov.translit in(?@)', (array)$filter['translit']);
        }

        $query = $this->db->placehold("SELECT
                ov.feature_alias_id,
                ov.translit,
                ov.value,
                ov.feature_id,
                ov.lang_id,
                fa.variable
            FROM __options_aliases_values AS ov
            LEFT JOIN __features_aliases fa ON fa.id=ov.feature_alias_id
            WHERE
                1
                $feature_alias_id_filter
                $feature_id_filter
                $lang_id_filter
                $translit_filter
        ");
        $this->db->query($query);
        return $this->db->results();
    }

}
