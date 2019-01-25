<?php

require_once('api/Okay.php');

class FeaturesAliasesAdmin extends Okay {

    public function fetch() {

        $this->design->set_templates_dir('backend/design/html');
        $this->design->set_compiled_dir('backend/design/compiled');

        if($this->request->post("ajax")){
            if($this->request->post("action") == "get") {
                $result = new stdClass();
                $result->success = false;

                $features_aliases = array();
                foreach ($this->features_aliases->get_features_aliases() as $f) {
                    $features_aliases[$f->id] = $f;
                }

                if ($feature_id = $this->request->post("feature_id", "integer")) {
                    $feature = $this->features->get_feature($feature_id);
                }

                if ($feature->id) {

                    $features_values = array();
                    foreach ($this->features_values->get_features_values(array('feature_id'=>$feature->id)) as $fv) {
                        $features_values[$fv->translit] = $fv;
                    }

                    foreach ($this->features_aliases->get_options_aliases_values(array('feature_id'=>$feature->id)) as $oa) {
                        $features_values[$oa->translit]->aliases[$oa->feature_alias_id] = $oa;
                    }
                    $this->design->assign('features_values', $features_values);

                    foreach ($this->features_aliases->get_feature_aliases_values(array('feature_id'=>$feature->id)) as $fv) {
                        $features_aliases[$fv->feature_alias_id]->value = $fv;
                    }
                    $result->success = true;
                }

                $this->design->assign('feature', $feature);
                $this->design->assign('features_aliases', $features_aliases);

                $result->feature_aliases_tpl = $this->design->fetch("features_aliases_ajax.tpl");
                $result->feature_aliases_values_tpl = $this->design->fetch("features_aliases_values_ajax.tpl");
                header("Content-type: application/json; charset=UTF-8");
                header("Cache-Control: must-revalidate");
                header("Pragma: no-cache");
                header("Expires: -1");
                print json_encode($result);
                die();

            }

            /*Обновление шаблона данных категории*/
            if($this->request->post("action") == "set") {

                $result = new stdClass();
                $result->success = false;

                if ($feature_id = $this->request->post("feature_id", "integer")) {
                    $feature = $this->features->get_feature($feature_id);
                }

                if ($feature) {
                    $result->success = true;
                    $features_aliases = array();
                    $features_aliases_values = array();
                    if($this->request->post('features_aliases')) {
                        foreach($this->request->post('features_aliases') as $n=>$fa) {
                            foreach($fa as $i=>$a) {
                                if(empty($features_aliases[$i])) {
                                    $features_aliases[$i] = new stdClass;
                                }
                                $features_aliases[$i]->$n = $a;
                            }
                        }
                    }

                    if($this->request->post('feature_aliases_value')) {
                        foreach($this->request->post('feature_aliases_value') as $n=>$fav) {
                            foreach($fav as $i=>$av) {
                                if(empty($features_aliases_values[$i])) {
                                    $features_aliases_values[$i] = new stdClass;
                                }
                                $features_aliases_values[$i]->$n = $av;
                            }
                        }
                    }

                    foreach($features_aliases as $k=>$features_alias) {
                        if ($features_alias->name) {
                            if (!empty($features_alias->id)) {
                                $this->features_aliases->update_feature_alias($features_alias->id, $features_alias);
                            } else {
                                unset($features_alias->id);
                                $features_alias->id = $this->features_aliases->add_feature_alias($features_alias);
                            }
                        }

                        // Добавим все значения для алиасов которые нам запостили
                        if (isset($features_aliases_values[$k]) && $features_alias->id) {
                            $alias_value = $features_aliases_values[$k];
                            $alias_value->feature_id = $feature->id;
                            $alias_value->feature_alias_id = $features_alias->id;

                            if (!empty($alias_value->id)) {
                                $this->features_aliases->update_feature_alias_value($alias_value->id, $alias_value);
                            } else {
                                unset($alias_value->id);
                                $this->features_aliases->add_feature_alias_value($alias_value);
                            }
                        }

                        $features_alias = $this->features_aliases->get_features_alias((int)$features_alias->id);
                        if(!empty($features_alias->id)) {
                            $features_aliases_ids[] = $features_alias->id;
                        }
                    }

                    $current_features_aliases = $this->features_aliases->get_features_aliases();
                    foreach($current_features_aliases as $current_features_alias) {
                        if(!in_array($current_features_alias->id, $features_aliases_ids)) {
                            $current_feature_alias_values = $this->features_aliases->get_feature_aliases_values(array('feature_alias_id'=>$current_features_alias->id));
                            foreach ($current_feature_alias_values as $cv) {
                                $this->features_aliases->delete_feature_alias_value($cv->id);
                            }
                            $this->features_aliases->delete_feature_alias($current_features_alias->id);
                        }
                    }

                    asort($features_aliases_ids);
                    $i = 0;
                    foreach($features_aliases_ids as $features_alias_id) {
                        $this->features_aliases->update_feature_alias($features_aliases_ids[$i], array('position'=>$features_alias_id));
                        $i++;
                    }

                    $features_aliases = array();
                    foreach ($this->features_aliases->get_features_aliases() as $f) {
                        $features_aliases[$f->id] = $f;
                    }
                    $this->design->assign('features_aliases', $features_aliases);

                    // Удалим все алиасы значений свойств для текущего языка
                    if(!empty($feature->id)) {
                        $this->db->query("DELETE FROM __options_aliases_values WHERE feature_id=? AND lang_id=?", $feature->id, $this->languages->lang_id());
                    }

                    $features_values = array();
                    foreach ($this->features_values->get_features_values(array('feature_id'=>$feature->id)) as $fv) {
                        $features_values[$fv->translit] = $fv;
                    }
                    $this->design->assign('features_values', $features_values);

                    if ($feature->id && $this->request->post('options_aliases')) {
                        foreach($this->request->post('options_aliases') as $o_translit=>$values) {
                            foreach($values as $feature_alias_id=>$value) {
                                if (!empty($value) && isset($features_aliases[$feature_alias_id]) && isset($features_values[$o_translit])) {
                                    $option_alias = new stdClass;
                                    $option_alias->translit = $o_translit;
                                    $option_alias->value    = $value;
                                    $option_alias->lang_id  = $this->languages->lang_id();
                                    $option_alias->feature_id       = $feature->id;
                                    $option_alias->feature_alias_id = $feature_alias_id;
                                    $this->features_aliases->add_option_alias_value($option_alias);
                                    $features_values[$o_translit]->aliases[$feature_alias_id] = $option_alias;
                                }
                            }
                        }
                    }
                    $this->design->assign('feature', $feature);
                }

                $result->feature_aliases_tpl = $this->design->fetch("features_aliases_ajax.tpl");
                $result->feature_aliases_values_tpl = $this->design->fetch("features_aliases_values_ajax.tpl");
                header("Content-type: application/json; charset=UTF-8");
                header("Cache-Control: must-revalidate");
                header("Pragma: no-cache");
                header("Expires: -1");
                print json_encode($result);
                die();

            }
        }

        $features_count = $this->features->count_features();
        $features = $this->features->get_features(array('limit'=>$features_count));

        $this->design->assign('features', $features);
        return $this->body = $this->design->fetch('features_aliases.tpl');
    }
}
