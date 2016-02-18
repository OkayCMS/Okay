<?php

require_once('Okay.php');

class Callbacks extends Okay {

    public function email_callback_admin($callback_id) {
        if(!($callback = $this->callbacks->get_callback(intval($callback_id)))) {
            return false;
        }
        $this->design->assign('callback', $callback);
        // Отправляем письмо
        $email_template = $this->design->fetch($this->config->root_dir.'backend/design/html/email_callback_admin.tpl');
        $subject = $this->design->get_var('subject');
        $this->notify->email($this->settings->comment_email, $subject, $email_template, "$callback->name <$callback->phone>", "$callback->name <$callback->phone>");
    }
    
    public function get_callback($id) {
        $query = $this->db->placehold("SELECT 
                c.id, 
                c.name, 
                c.phone, 
                c.message, 
                c.date, 
                c.processed,
                c.url
            FROM __callbacks c 
            WHERE id=? 
            LIMIT 1
        ", intval($id));
        
        if($this->db->query($query)) {
            return $this->db->result();
        } else {
            return false;
        }
    }
    
    public function get_callbacks($filter = array(), $new_on_top = false) {
        // По умолчанию
        $limit = 1000;
        $page = 1;
        $processed = '';
        
        if(isset($filter['limit'])) {
            $limit = max(1, intval($filter['limit']));
        }
        
        if(isset($filter['page'])) {
            $page = max(1, intval($filter['page']));
        }
        
        if(isset($filter['processed'])) {
            $processed = $this->db->placehold('AND processed=?',$filter['processed']);
        }
        
        $sql_limit = $this->db->placehold(' LIMIT ?, ? ', ($page-1)*$limit, $limit);
        
        if($new_on_top) {
            $sort='DESC';
        } else {
            $sort='ASC';
        }
        
        $query = $this->db->placehold("SELECT 
                c.id, 
                c.name, 
                c.phone, 
                c.date, 
                c.message, 
                c.processed,
                c.url
            FROM __callbacks c 
            WHERE 
                1 
                $processed 
            ORDER BY c.id 
            $sort 
            $sql_limit
        ");
        
        $this->db->query($query);
        return $this->db->results();
    }
    
    public function add_callback($callback) {
        $query = $this->db->placehold('INSERT INTO __callbacks SET ?%, date = NOW()', $callback);
        
        if(!$this->db->query($query)) {
            return false;
        }
        
        $id = $this->db->insert_id();
        return $id;
    }
    
    public function update_callback($id, $callback) {
        $date_query = '';
        /*if(isset($fedback->date)) {
            $date = $callback->date;
            unset($callback->date);
            $date_query = $this->db->placehold(', date=STR_TO_DATE(?, ?)', $date, $this->settings->date_format);
        }*/
        $query = $this->db->placehold("UPDATE __callbacks SET ?% $date_query WHERE id in(?@) LIMIT 1", $callback, (array)$id);
        $this->db->query($query);
        return $id;
    }
    
    public function delete_callback($id) {
        if(!empty($id)) {
            $query = $this->db->placehold("DELETE FROM __callbacks WHERE id=? LIMIT 1", intval($id));
            $this->db->query($query);
        }
    }
    
}
