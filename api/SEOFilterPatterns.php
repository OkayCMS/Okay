<?php

require_once('Okay.php');

class SEOFilterPatterns extends Okay {


    public function get_patterns($filter = array()) {
        $category_id_filter = '';
        $type_filter = '';
        $feature_id_filter = '';

        if(!empty($filter['category_id'])) {
            $category_id_filter = $this->db->placehold('AND p.category_id in (?@)', (array)$filter['category_id']);
        }

        if(!empty($filter['type'])) {
            $type_filter = $this->db->placehold('AND p.type = ?', $filter['type']);
        }

        if(!empty($filter['feature_id'])) {
            $feature_id_filter = $this->db->placehold('AND p.feature_id in (?@)', (array)$filter['feature_id']);
        }

        $lang_sql = $this->languages->get_query(array('object'=>'seo_filter_pattern', 'px'=>'p'));
        $query = $this->db->placehold("SELECT
                p.id,
                p.category_id,
                p.type,
                p.feature_id,
                $lang_sql->fields
            FROM __seo_filter_patterns p
            $lang_sql->join
            WHERE
                1
                $category_id_filter
                $type_filter
                $feature_id_filter
            ");

        $this->db->query($query);
        $patterns = $this->db->results();
        return $patterns;
    }

    public function get_pattern($id) {
        if(empty($id)) {
            return false;
        }
        $pattern_id_filter = $this->db->placehold('AND p.id=?', (int)$id);

        $lang_sql = $this->languages->get_query(array('object'=>'seo_filter_pattern', 'px'=>'p'));
        $query = $this->db->placehold("SELECT
                p.id,
                p.category_id,
                p.type,
                p.feature_id,
                $lang_sql->fields
            FROM __seo_filter_patterns p
            $lang_sql->join
            WHERE
                1
                $pattern_id_filter
            LIMIT 1
        ");

        $this->db->query($query);
        return $this->db->result();
    }

    public function update_pattern($id, $pattern) {
        $pattern = (object)$pattern;
        $result = $this->languages->get_description($pattern, 'seo_filter_pattern');

        $v = (array)$pattern;
        if (!empty($v)) {
            $query = $this->db->placehold("UPDATE __seo_filter_patterns SET ?% WHERE id=? LIMIT 1", $pattern, (int)$id);
            $this->db->query($query);
        }

        if(!empty($result->description)) {
            $this->languages->action_description($id, $result->description, 'seo_filter_pattern', $this->languages->lang_id());
        }

        return $id;
    }

    public function add_pattern($pattern) {

        // Проверяем есть ли мультиязычность и забираем описания для перевода
        $result = $this->languages->get_description($pattern, 'seo_filter_pattern');

        $query = $this->db->placehold("INSERT INTO __seo_filter_patterns SET ?%", $pattern);
        $this->db->query($query);
        $id = $this->db->insert_id();

        // Если есть описание для перевода. Указываем язык для обновления
        if(!empty($result->description)) {
            $this->languages->action_description($id, $result->description, 'seo_filter_pattern');
        }
        return $id;
    }

    public function delete_pattern($id) {
        if(!empty($id)) {
            $query = $this->db->placehold("DELETE FROM __seo_filter_patterns WHERE id = ? LIMIT 1", (int)$id);
            $this->db->query($query);
            $query = $this->db->placehold("DELETE FROM __lang_seo_filter_patterns WHERE seo_filter_pattern_id = ?", (int)$id);
            $this->db->query($query);
        }
    }
}
