<?php

require_once('api/Okay.php');

class TopvisorProjectAdmin extends Okay {
    
    public function fetch() {
        //print_r($_POST);return false;
        $project_id = $this->request->get('id', 'integer');
        $project = $this->topvisor->get_project($project_id);
        if (is_string($project) && $project == 'Wrong API KEY' || empty($project)) {
            header('location: '.$this->config->root_url.'/backend/index.php?module=TopvisorProjectsAdmin');
            exit();
        }
        if ($project_id && !empty($project)) {
            //Поисковые системы и регионы
            if (isset($_POST['new_searcher'])) {
                // добавление поисковой системы
                if($this->request->post('add_searcher')) {
                    $searcher = $this->request->post('new_searcher');
                    $res = $this->topvisor->add_searcher($project->id, $searcher);
                    if ($res->error) {
                        $this->design->assign('message_error', $res->message);
                    } elseif (!$res) {
                        $this->design->assign('message_error', 'error_searcher_100500');
                    } else {
                        $project = $this->topvisor->get_project($project_id);
                        $this->design->assign('message_success', 'added_searcher');
                    }
                // добавления региона к поисковой системе
                } elseif ($searcher_id = $this->request->post('add_region')) {
                    $searcher_id = key($searcher_id);
                    $region = $_POST['new_region'][$searcher_id];
                    if ($region > 0) {
                        $res = $this->topvisor->add_region($region, $searcher_id);
                        if ($res->error) {
                            $this->design->assign('message_error', $res->message);
                        } elseif (!$res) {
                            $this->design->assign('message_error', 'error_region_100500');
                        } else {
                            $project = $this->topvisor->get_project($project_id);
                            $this->design->assign('message_success', 'added_region');
                        }
                    } else {
                        $this->design->assign('message_error', 'empty_region');
                    }
                } else {
                    $ids = $this->request->post('check');
                    if(is_array($ids) && !empty($ids)) {
                        switch($this->request->post('action')) {
                            case 'delete': {
                                $api_results = array();
                                foreach($ids as $id) {
                                    $a = $this->topvisor->delete_searcher($id);
                                    if (!$a->result) {
                                        $api_results[$id] = $a;
                                    }
                                }
                                if (!empty($api_results)) {
                                    $this->design->assign('message_error', 'delete_searcher');
                                    $this->design->assign('api_results', $api_results);
                                } else {
                                    $project = $this->topvisor->get_project($project_id);
                                    $this->design->assign('message_success', 'delete_searcher');
                                }
                                break;
                            }
                        }
                    }
                }
            // запросы и группы
            } elseif (isset($_POST['new_group'])) {
                // добавление группы запросов
                if($this->request->post('add_group')) {
                    $group_name = $this->request->post('new_group');
                    $res = $this->topvisor->add_group($project->id, $group_name);
                    if ($res->error) {
                        $this->design->assign('message_error', $res->message);
                    } elseif (!$res) {
                        $this->design->assign('message_error', 'error_group_100500');
                    } else {
                        $project = $this->topvisor->get_project($project_id);
                        $this->design->assign('message_success', 'added_group');
                    }
                } elseif ($group_id = $this->request->post('add_queries')) {
                    $group_id = key($group_id);
                    if (isset($_POST['new_queries'][$group_id])) {
                        $queries = array();
                        foreach ($_POST['new_queries'][$group_id] as $q) {
                            if ($q != '') {
                                $queries[] = $q;
                            }
                        }
                        if (!empty($queries)) {
                            $res = $this->topvisor->add_queries($project->id, $group_id, implode('|||', $queries));
                            if ($res->error) {
                                $this->design->assign('message_error', $res->message);
                            } elseif (!$res) {
                                $this->design->assign('message_error', 'error_query_100500');
                            } else {
                                $project = $this->topvisor->get_project($project_id);
                                $this->design->assign('message_success', 'added_query');
                            }
                        } else {
                            $this->design->assign('message_error', 'query_all_empty');
                        }
                    } else {
                        $this->design->assign('message_error', 'query_empty');
                    }
                    
                    
                    /*if ($region > 0) {
                        $res = $this->topvisor->add_region($region, $searcher_id);
                        if ($res->error) {
                            $this->design->assign('message_error', $res->message);
                        } elseif (!$res) {
                            $this->design->assign('message_error', 'error_region_100500');
                        } else {
                            $project = $this->topvisor->get_project($project_id);
                            $this->design->assign('message_success', 'added_region');
                        }
                    } else {
                        $this->design->assign('message_error', 'empty_region');
                    }*/
                }
            }
            $res = $this->topvisor->percent_of_parse($project->id);
            if (isset($res[0])) {
                $project->percent_of_parse = $res[0]->percent;
            }
            $this->design->assign('project', $project);
            $queries_groups = array();
            foreach ($project->groups as $g) {
                $g->queries = array();
                $queries_groups[$g->id] = $g;
            }
            foreach ($this->topvisor->get_queries($project->id) as $q) {
                $queries_groups[$q->group_id]->queries[] = $q;
            }
            $this->design->assign('queries_groups', $queries_groups);
        }
        
        $projects = array();
        foreach ($this->topvisor->get_projects() as $p) {
            $projects[$p->id] = $p;
        }
        $this->design->assign('projects', $projects);
        return  $this->design->fetch('topvisor_project.tpl');
    }
    
}
