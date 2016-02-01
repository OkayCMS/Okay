<?php

require_once('api/Okay.php');

class SpecialAdmin extends Okay {
    
    public function fetch() {
        if($this->request->method('post')) {
            // Сортировка
            $positions = $this->request->post('positions');
            if (!empty($positions)) {
                $ids = array_keys($positions);
                sort($positions);
                $positions = array_reverse($positions);
                foreach($positions as $i=>$position) {
                    $this->db->query("UPDATE __spec_img SET position=? WHERE id=?", $position, $ids[$i]);
                }
            }
            
            // Действия с выбранными
            $ids = $this->request->post('check');
            if(is_array($ids)) {
                switch($this->request->post('action')) {
                    case 'delete': {
                        foreach($ids as $id) {
                            $this->db->query("SELECT filename FROM __spec_img WHERE id=?", intval($id));
                            $filename = $this->db->result('filename');
                            @unlink($this->config->root_dir.$this->config->special_images_dir.$filename);
                            $this->db->query("DELETE FROM __spec_img WHERE id=? LIMIT 1", intval($id));
                            
                            $this->db->query("UPDATE __products set special=null where special=?", $filename);
                            $this->db->query("UPDATE __lang_products set special=null where special=?", $filename);
                        }
                        break;
                    }
                }
            }
            
            $specials = array();
            if($this->request->post('special')) {
                foreach($this->request->post('special') as $field_name=>$values) {
                    foreach($values as $id=>$value) {
                        if(empty($specials[$id])) {
                            $specials[$id] = new stdClass;
                        }
                        $specials[$id]->$field_name = $value;
                    }
                }
            }
            foreach ($specials as $sid=>$special) {
                $this->db->query("UPDATE __spec_img SET ?% WHERE id=?", $special, $sid);
            }
            
            $new_specials = $this->request->post('new_special');
            $new_files = $this->request->files('special_files');
            if (!empty($new_files)) {
                foreach ($new_files['tmp_name'] as $i=>$tmp_name) {
                    $name = $new_files['name'][$i];
                    if ($new_files['size'][$i] > 0 && !empty($name) && ($filename = $this->image->upload_image($tmp_name, $name, $this->config->special_images_dir))) {
                        $special = array('name'=>$new_specials['name'][$i], 'filename'=>$filename);
                        $this->db->query("INSERT INTO __spec_img SET ?%", $special);
                        $id = $this->db->insert_id();
                        $this->db->query("UPDATE __spec_img SET position=id WHERE id=?", $id);
                    }
                }
            }
        }
        
        $this->db->query("SELECT * FROM __spec_img ORDER BY position DESC");
        $special_images = $this->db->results();
        $this->design->assign('special_images', $special_images);
        return $this->design->fetch('special.tpl');
    }
    
}
