<?php

require_once('Okay.php');

class SupportInfo extends Okay {

    private $info;

    public function get_info() {
        if (isset($this->info)) {
            return $this->info;
        }
        $query = $this->db->placehold("SELECT si.* FROM __support_info si LIMIT 1");
        if($this->db->query($query)) {
            $this->info = $this->db->result();
            if (!$this->info) {
                $this->clear_info();
                $this->info = (object) array(
                    'private_key'=>null,
                    'public_key'=>null,
                    'new_messages'=>0,
                    'balance'=>0,
                    'temp_key'=>null,
                    'temp_time'=>null,
                    'is_auto'=>1
                );
                $this->add_info($this->info);
            }
            return $this->info;
        } else {
            return false;
        }
    }

    public function update_info($info) {
        $query = $this->db->placehold("UPDATE __support_info SET ?% LIMIT 1", $info);
        if (!$this->db->query($query)) {
            return false;
        }
        unset($this->info);
        return true;
    }

    private function add_info($info) {
        /*if ($this->get_info()) {
            return false;
        }*/
        $query = $this->db->placehold("INSERT INTO __support_info SET ?%", $info);
        if(!$this->db->query($query)) {
            return false;
        }
        return true;
    }

    private function clear_info() {
        $query = $this->db->placehold("TRUNCATE __support_info");
        if (!$this->db->query($query)) {
            return false;
        }
        return true;
    }

}
