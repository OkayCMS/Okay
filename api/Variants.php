<?php

require_once('Okay.php');

class Variants extends Okay {

    /*Выборка вариантов*/
    public function get_variants($filter = array()) {
        $product_id_filter = '';
        $variant_id_filter = '';
        $instock_filter = '';
        
        if(!empty($filter['product_id'])) {
            $product_id_filter = $this->db->placehold('AND v.product_id in(?@)', (array)$filter['product_id']);
        }
        
        if(!empty($filter['id'])) {
            $variant_id_filter = $this->db->placehold('AND v.id in(?@)', (array)$filter['id']);
        }
        
        if(!empty($filter['in_stock']) && $filter['in_stock']) {
            $instock_filter = $this->db->placehold('AND (v.stock>0 OR v.stock IS NULL)');
        }
        
        if(!$product_id_filter && !$variant_id_filter) {
            return array();
        }
        $lang_sql = $this->languages->get_query(array('object'=>'variant'));
        $query = $this->db->placehold("SELECT 
                v.id, 
                v.product_id,
                v.weight,
                v.price, 
                NULLIF(v.compare_price, 0) as compare_price, 
                v.sku, 
                IFNULL(v.stock, ?) as stock, 
                (v.stock IS NULL) as infinity, 
                v.attachment, 
                v.position, 
                v.currency_id, 
                v.feed,
                c.rate_from, 
                c.rate_to, 
                $lang_sql->fields
            FROM __variants AS v
            $lang_sql->join
            left join __currencies as c on(c.id=v.currency_id)
            WHERE
                1
                $product_id_filter
                $variant_id_filter
                $instock_filter
            GROUP BY v.id
            ORDER BY v.position, v.id
        ", $this->settings->max_order_amount);
        
        $this->db->query($query);
        $variants = $this->db->results();
        if (defined('IS_CLIENT') && !empty($variants)) {
            foreach($variants as $row) {
                if ($row->rate_from != $row->rate_to && $row->currency_id) {
                    $row->price = $row->price*$row->rate_to/$row->rate_from;
                    $row->compare_price = $row->compare_price*$row->rate_to/$row->rate_from;
                }
            }
        }
        return $variants;
    }

    /*Выборка конкретного варианта*/
    public function get_variant($id) {
        if(empty($id)) {
            return false;
        }
        $variant_id_filter = $this->db->placehold('AND v.id=?', intval($id));
        
        $lang_sql = $this->languages->get_query(array('object'=>'variant'));
        $query = $this->db->placehold("SELECT 
                v.id, 
                v.product_id,
                v.weight,
                v.price, 
                NULLIF(v.compare_price, 0) as compare_price, 
                v.sku, 
                IFNULL(v.stock, ?) as stock, 
                (v.stock IS NULL) as infinity, 
                v.attachment, 
                v.currency_id, 
                v.feed,
                c.rate_from, 
                c.rate_to, 
                $lang_sql->fields
            FROM __variants v
            $lang_sql->join
            left join __currencies as c on(c.id=v.currency_id) 
            WHERE 
                1 
                $variant_id_filter 
            LIMIT 1
        ", $this->settings->max_order_amount);
        
        $this->db->query($query);
        $variant = $this->db->result();
        if (defined('IS_CLIENT') && $variant->id) {
            if ($variant->rate_from != $variant->rate_to && $variant->currency_id) {
                $variant->price = $variant->price*$variant->rate_to/$variant->rate_from;
                $variant->compare_price = $variant->compare_price*$variant->rate_to/$variant->rate_from;
            }
        }
        return $variant;
    }
    
    public function update_variant($id, $variant) {
        $variant = (object)$variant;
        $result = $this->languages->get_description($variant, 'variant');
        
        $v = (array)$variant;
        if (!empty($v)) {
            $query = $this->db->placehold("UPDATE __variants SET ?% WHERE id=? LIMIT 1", $variant, intval($id));
            $this->db->query($query);
        }
        
        if(!empty($result->description)) {
            $this->languages->action_description($id, $result->description, 'variant', $this->languages->lang_id());
        }
        
        return $id;
    }
    
    public function add_variant($variant) {
        $variant = (object)$variant;
        $result = $this->languages->get_description($variant, 'variant');
        
        $query = $this->db->placehold("INSERT INTO __variants SET ?%", $variant);
        $this->db->query($query);
        $variant_id = $this->db->insert_id();
        
        if(!empty($result->description)) {
            $this->languages->action_description($variant_id, $result->description, 'variant');
        }
        
        return $variant_id;
    }
    
    public function delete_variant($id) {
        if(!empty($id)) {
            $this->delete_attachment($id);
            $query = $this->db->placehold("DELETE FROM __variants WHERE id = ? LIMIT 1", intval($id));
            $this->db->query($query);
            $this->db->query('UPDATE __purchases SET variant_id=NULL WHERE variant_id=?', intval($id));
            $this->db->query("DELETE FROM __lang_variants WHERE variant_id = ?", intval($id));
        }
    }
    
    public function delete_attachment($id) {
        $query = $this->db->placehold("SELECT attachment FROM __variants WHERE id=?", $id);
        $this->db->query($query);
        $filename = $this->db->result('attachment');
        $query = $this->db->placehold("SELECT 1 FROM __variants WHERE attachment=? AND id!=?", $filename, $id);
        $this->db->query($query);
        $exists = $this->db->num_rows();
        if(!empty($filename) && $exists == 0) {
            @unlink($this->config->root_dir.'/'.$this->config->downloads_dir.$filename);
        }
        $this->update_variant($id, array('attachment'=>null));
    }
    
}
