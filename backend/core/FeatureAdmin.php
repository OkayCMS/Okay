<?php

require_once('api/Okay.php');

class FeatureAdmin extends Okay {

    private $forbidden_names = array();
    
    public function fetch() {
        $feature = new stdClass;
        if($this->request->method('post')) {
            $feature->id = $this->request->post('id', 'integer');
            $feature->name = $this->request->post('name');
            $feature->in_filter = intval($this->request->post('in_filter'));
            $feature->yandex = intval($this->request->post('yandex'));
            $feature->auto_name_id = $this->request->post('auto_name_id');
            $feature->auto_value_id = $this->request->post('auto_value_id');
            $feature->url = $this->request->post('url', 'string');
            $feature->url_in_product = $this->request->post('url_in_product');

            $feature->url = preg_replace("/[\s]+/ui", '', $feature->url);
            $feature->url = strtolower(preg_replace("/[^0-9a-z]+/ui", '', $feature->url));
            if(empty($feature->url)) {
                $feature->url = $this->translit_alpha($feature->name);
            }
            $feature_categories = $this->request->post('feature_categories');

            // Не допустить одинаковые URL свойств.
            if(($c = $this->features->get_feature($feature->url)) && $c->id!=$feature->id) {
                $this->design->assign('message_error', 'duplicate_url');
            } elseif(empty($feature->name)) {
                $this->design->assign('message_error', 'empty_name');
            } elseif (!$this->features->check_auto_id($feature->id, $feature->auto_name_id)) {
                $this->design->assign('message_error', 'auto_name_id_exists');
            } elseif (!$this->features->check_auto_id($feature->id, $feature->auto_value_id, "auto_value_id")) {
                $this->design->assign('message_error', 'auto_value_id_exists');
            } elseif ($this->is_name_forbidden($feature->name)) {
                $this->design->assign('forbidden_names', $this->forbidden_names);
                $this->design->assign('message_error', 'forbidden_name');
            } else {
                /*Добавление/Обновление свойства*/
                if(empty($feature->id)) {
                    $feature->id = $this->features->add_feature($feature);
                    $feature = $this->features->get_feature($feature->id);
                    $this->design->assign('message_success', 'added');
                } else {
                    $this->features->update_feature($feature->id, $feature);
                    $feature = $this->features->get_feature($feature->id);
                    $this->design->assign('message_success', 'updated');
                }
                $this->features->update_feature_categories($feature->id, $feature_categories);
            }

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

            // Удалим все алиасы значений свойств для текущего языка
            if(!empty($feature->id)) {
                $this->db->query("DELETE FROM __options_aliases_values WHERE feature_id=? AND lang_id=?", $feature->id, $this->languages->lang_id());
            }

            foreach ($this->features->get_options(array('feature_id'=>$feature->id)) as $o) {
                $options[$o->translit] = $o;
            }
            $this->design->assign('options', $options);

            if ($feature->id && $this->request->post('options_aliases')) {
                foreach($this->request->post('options_aliases') as $o_translit=>$values) {
                    foreach($values as $feature_alias_id=>$value) {
                        if (!empty($value) && isset($features_aliases[$feature_alias_id]) && isset($options[$o_translit])) {
                            $option_alias = new stdClass;
                            $option_alias->translit = $o_translit;
                            $option_alias->value    = $value;
                            $option_alias->lang_id  = $this->languages->lang_id();
                            $option_alias->feature_id       = $feature->id;
                            $option_alias->feature_alias_id = $feature_alias_id;
                            $this->features_aliases->add_option_alias_value($option_alias);
                            $options[$o_translit]->aliases[$feature_alias_id] = $option_alias;
                        }
                    }
                }
            }

        } else {
            $feature->id = $this->request->get('id', 'integer');
            $feature = $this->features->get_feature($feature->id);
            if ($feature->id) {
                foreach ($this->features->get_options(array('feature_id'=>$feature->id)) as $o) {
                    $options[$o->translit] = $o;
                }

                foreach ($this->features_aliases->get_options_aliases_values(array('feature_id'=>$feature->id)) as $oa) {
                    $options[$oa->translit]->aliases[$oa->feature_alias_id] = $oa;
                }
                $this->design->assign('options', $options);
            }

            $features_aliases = array();
            foreach ($this->features_aliases->get_features_aliases() as $f) {
                $features_aliases[$f->id] = $f;
            }
        }

        $feature_categories = array();
        if($feature) {
            $feature_categories = $this->features->get_feature_categories($feature->id);
        } elseif ($category_id = $this->request->get('category_id')) {
            $feature_categories[] = $category_id;
        }

        if ($feature->id) {
            foreach ($this->features_aliases->get_feature_aliases_values(array('feature_id'=>$feature->id)) as $fv) {
                $features_aliases[$fv->feature_alias_id]->value = $fv;
            }
        }

        $this->design->assign('features_aliases', $features_aliases);
        $categories = $this->categories->get_categories_tree();
        $this->design->assign('categories', $categories);
        $this->design->assign('feature', $feature);
        $this->design->assign('feature_categories', $feature_categories);
        return $this->body = $this->design->fetch('feature.tpl');
    }

    private function is_name_forbidden($name) {
        $result = false;
        foreach($this->import->columns_names as $i=>$names) {
            $this->forbidden_names = array_merge($this->forbidden_names, $names);
            foreach($names as $n) {
                if(preg_match("~^".preg_quote($name)."$~ui", $n)) {
                    $result = true;
                }
            }
        }
        return $result;
    }
    
}
