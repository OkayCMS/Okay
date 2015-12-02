<?php

require_once('api/Okay.php');

class SpecialAdmin extends Okay {
    
    public function fetch() {
        $submit = $this->request->post('submit', '');
        
        if($submit=="Сохранить") {
            $name = $this->request->post('name', '');
            $dir_n="files/special/";
            @mkdir( $dir_n , 0777 );
            if (move_uploaded_file($_FILES["spec_img"]['tmp_name'], $dir_n.$_FILES["spec_img"]['name'])) {
                $foto_t= $_FILES["spec_img"]['name'];
                $query = $this->db->placehold("INSERT INTO __spec_img (name,filename) VALUES(\"$name\" ,\"$foto_t\")");
                $this->db->query($query);
            }
            
            // Действия с выбранными
            $ids = $this->request->post('check');
            if(!empty($ids)) {
                foreach($ids as $id) {
                    $delimg = $this->db->placehold("SELECT filename FROM __spec_img WHERE id=?", $id);
                    $this->db->query($delimg);
                    $filename = $this->db->result('filename');
                    @unlink($this->config->root_dir.$dir_n.$filename);
                    $delall = $this->db->placehold("DELETE FROM __spec_img WHERE id=? LIMIT 1", intval($id));
                    $this->db->query($delall);
                    
                    $this->db->query("UPDATE __products set special=null where special=?", $filename);
                }
            }
        }
        
        $query1 = $this->db->placehold("SELECT * FROM __spec_img order by id");
        $res=$this->db->query($query1);
        $kartinki = $this->db->results();
        
        $this->design->assign('kartinki', $kartinki);
        return $this->design->fetch('special.tpl');
    }
    
}

?>