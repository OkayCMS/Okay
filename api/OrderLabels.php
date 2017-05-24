<?php

require_once('Okay.php');

class OrderLabels extends Okay {

    /*Выборка конкретной метки*/
    public function get_label($id) {
        $lang_sql = $this->languages->get_query(array('object'=>'order_labels', 'px'=>'lb'));
        $query = $this->db->placehold("SELECT lb.* ,
                            $lang_sql->fields 
                            FROM __labels lb
                            $lang_sql->join 
                            WHERE lb.id=? LIMIT 1", intval($id));
        $this->db->query($query);
        return $this->db->result();
    }

    /*Выборка всех меток*/
    public function get_labels() {
        $lang_sql = $this->languages->get_query(array('object'=>'order_labels', 'px'=>'lb'));
        $query = $this->db->placehold("SELECT lb.* ,
                $lang_sql->fields 
                FROM __labels lb
                $lang_sql->join 
                ORDER BY lb.position");
        $this->db->query($query);
        return $this->db->results();
    }

    /*Добавление метки*/
    public function add_label($label) {
        $label = (object)$label;
        // Проверяем есть ли мультиязычность и забираем описания для перевода
        $result = $this->languages->get_description($label, 'order_labels');

        $query = $this->db->placehold('INSERT INTO __labels SET ?%', $label);
        if(!$this->db->query($query)) {
            return false;
        }
        $id = $this->db->insert_id();
        $this->db->query("UPDATE __labels SET position=id WHERE id=?", $id);
        // Если есть описание для перевода. Указываем язык для обновления
        if(!empty($result->description)) {
            $this->languages->action_description($id, $result->description, 'order_labels');
        }
        return $id;
    }

    /*Обновление метки*/
    public function update_label($id, $label) {
        $label = (object)$label;
        // Проверяем есть ли мультиязычность и забираем описания для перевода
        $result = $this->languages->get_description($label, 'order_labels');

        $query = $this->db->placehold("UPDATE __labels SET ?% WHERE id = ? LIMIT 1", $label ,$id);
        $this->db->query($query);
        // Если есть описание для перевода. Указываем язык для обновления
        if(!empty($result->description)) {
            $this->languages->action_description($id, $result->description, 'order_labels', $this->languages->lang_id());
        }

        return $id;
    }

    /*Удаление метки*/
    public function delete_label($id) {
        if(!empty($id)) {
            $query = $this->db->placehold("DELETE FROM __orders_labels WHERE label_id=?", intval($id));
            if($this->db->query($query)) {
                $query = $this->db->placehold("DELETE FROM __labels WHERE id=? LIMIT 1", intval($id));
                $this->db->query($query);
                $query = $this->db->placehold("DELETE FROM __lang_orders_labels WHERE order_labels_id=?", intval($id));
                $this->db->query($query);
                return true;
            } else {
                return false;
            }
        }
    }

    /*Выборка меток конкретного заказа*/
    public function get_order_labels($order_id = array()) {
        if(empty($order_id)) {
            return array();
        }

        $label_id_filter = $this->db->placehold('AND ol.order_id in(?@)', (array)$order_id);
        $lang_sql = $this->languages->get_query(array('object'=>'order_labels', 'px'=>'lb'));
        $query = $this->db->placehold("SELECT
                    ol.order_id,
                    lb.id,
                    lb.color,
                    lb.position,
                    $lang_sql->fields
                    FROM __labels lb
                    LEFT JOIN __orders_labels ol ON ol.label_id = lb.id
                    $lang_sql->join 
                    WHERE 1
                    $label_id_filter
                    ORDER BY position
                    ");

        $this->db->query($query);

        $res = $this->db->results();
        if(!empty($res)){
            return $res;
        } else {
            return array();
        }
    }

    /*Обновление меток заказа*/
    public function update_order_labels($id, $labels_ids) {
        $labels_ids = (array)$labels_ids;
        $query = $this->db->placehold("DELETE FROM __orders_labels WHERE order_id=?", intval($id));
        $this->db->query($query);
        if(is_array($labels_ids)) {
            foreach($labels_ids as $l_id) {
                $this->db->query("INSERT INTO __orders_labels SET order_id=?, label_id=?", $id, $l_id);
            }
        }
    }

    /*Добавление меток к заказу*/
    public function add_order_labels($id, $labels_ids) {
        $labels_ids = (array)$labels_ids;
        if(is_array($labels_ids))
            foreach($labels_ids as $l_id) {
                $this->db->query("INSERT IGNORE INTO __orders_labels SET order_id=?, label_id=?", $id, $l_id);
            }
    }

    /*Удаление меток с заказа*/
    public function delete_order_labels($id, $labels_ids)
    {
        $labels_ids = (array)$labels_ids;
        if (is_array($labels_ids)) {
            foreach ($labels_ids as $l_id) {
                $this->db->query("DELETE FROM __orders_labels WHERE order_id=? AND label_id=?", $id, $l_id);
            }
        }
    }

}
