<?php

require_once('api/Okay.php');

class TopvisorProjectsAdmin extends Okay {
    
    public function fetch() {
        if ($this->request->post('api_settings')) {
            $this->settings->topvisor_key = trim($this->request->post('topvisor_key'));
        } elseif ($this->request->method('post') && !$this->request->post('add_project')) {
            $ids = $this->request->post('check');
            if(is_array($ids)) {
                switch($this->request->post('action')) {
                    case 'delete': {
                        $api_results = array();
                        foreach($ids as $id) {
                            $a = $this->topvisor->delete_project($id);
                            if (!$a->result) {
                                $api_results[$id] = $a;
                            }
                        }
                        if (!empty($api_results)) {
                            $this->design->assign('message_error', 'delete');
                            $this->design->assign('api_results', $api_results);
                        } else {
                            $this->design->assign('message_success', 'delete');
                        }
                        break;
                    }
                }
            }
        } elseif ($this->request->post('add_project')) {
            $site = $this->request->post('new_site');
            //$name = $this->request->post('new_name');
            if (!$site) {
                $this->design->assign('message_error', 'empty_site');
            } else {
                $res = $this->topvisor->add_project($site/*, $name*/);
                if ($res->error) {
                    $this->design->assign('message_error', $res->message);
                } else {
                    $this->design->assign('message_success', 'added');
                }
            }
        }
        
        $projects = array();
        $balance = '';
        $tm = $this->topvisor->get_projects();
        if ($tm && (!isset($tm->error) || !$tm->error)) {
            foreach ($tm as $p) {
                $projects[$p->id] = $p;
            }
            if (!empty($projects)) {
                foreach ($this->topvisor->percent_of_parse(array_keys($projects)) as $item) {
                    $projects[$item->id]->percent_of_parse = $item->percent;
                }
            }
            $balance = $this->topvisor->get_balance();
        } else {
            if (isset($tm->message) && $tm->message) {
                $this->design->assign('message_error', $tm->message);
            } elseif(!is_array($tm)) {
                $this->design->assign('message_error', 'unknown_error');
            }
        }

        $this->design->assign('projects', $projects);
        $this->design->assign('balance', (isset($balance[0]) ? $balance[0] : 0));
        return  $this->design->fetch('topvisor_projects.tpl');
    }
    
}
