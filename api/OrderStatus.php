<?php

require_once('Okay.php');

class OrderStatus extends Okay {

    /**
     * get all status
     * @return array of objects
     */
    /*Выборка всех статусов заказов*/
    public function get_status($filter = array()) {
        $status_id_filter = '';

        if(isset($filter['status'])){
            $status_id_filter = $this->db->placehold("AND os.id = ?",intval($filter['status']));
        }
        $lang_sql = $this->languages->get_query(array('object'=>'order_status', 'px'=>'os'));
        $query = $this->db->placehold("SELECT os.* ,
                $lang_sql->fields 
                FROM __orders_status os
                $lang_sql->join 
                WHERE 1
                $status_id_filter
                ORDER BY os.position ASC");
        $this->db->query($query);
        $results = $this->db->results();
        if(!empty($results)){
            return $results;
        } else {
            return false;
        }
    }

    /*
     * function add new status
     * @status - array or object with data
     * @return id of new status
     * */
    /*Добавление статуса заказа*/
    public function add_status($status) {
        $status = (object)$status;
        // Проверяем есть ли мультиязычность и забираем описания для перевода
        $result = $this->languages->get_description($status, 'order_status');

        $query = $this->db->placehold('INSERT INTO __orders_status SET ?%', $status);
        if(!$this->db->query($query)) {
            return false;
        }
        $id = $this->db->insert_id();
        $this->db->query("UPDATE __orders_status SET position=id WHERE id=?", $id);

        // Если есть описание для перевода. Указываем язык для обновления
        if(!empty($result->description)) {
            $this->languages->action_description($id, $result->description, 'order_status');
        }
        return $id;
    }

    /*
     * function of update current status
     * @id - id current status
     * @status - array of object of data
     * @return id of updated status
     * */
    /*Обновления статуса заказа*/
    public function update_status($id, $status) {
        $status = (object)$status;
        // Проверяем есть ли мультиязычность и забираем описания для перевода
        $result = $this->languages->get_description($status, 'order_status');

        $query = $this->db->placehold("UPDATE __orders_status SET ?% WHERE id = ? LIMIT 1", $status ,$id);
        $this->db->query($query);
        // Если есть описание для перевода. Указываем язык для обновления
        if(!empty($result->description)) {
            $this->languages->action_description($id, $result->description, 'order_status', $this->languages->lang_id());
        }

        return $id;
    }

    /*
     * function is delete a status
     * @id - id of removed status
     * @return boolean
     *
     * */
    /*Удаления статуса заказа*/
    public function delete_status($id) {
        if(!empty($id)) {
            $order_query = $this->db->placehold("SELECT COUNT(id) as count FROM __orders WHERE status_id = ?", intval($id));
            $this->db->query($order_query);
            $check_cnt = $this->db->result("count");

            if($check_cnt == 0){
                $query = $this->db->placehold("DELETE FROM __orders_status WHERE id=?", intval($id));
                if($this->db->query($query)) {
                    $query = $this->db->placehold("DELETE FROM __labels WHERE id=? LIMIT 1", intval($id));
                    $this->db->query($query);
                    $query = $this->db->placehold("DELETE FROM __lang_orders_status WHERE order_status_id=?", intval($id));
                    $this->db->query($query);
                    return true;
                }
            }
        }
        return false;
    }

}
