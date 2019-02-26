<?php

require_once('api/Okay.php');

class FeatureAdmin extends Okay {

    private $forbidden_names = array();
    
    public function fetch() {
        $feature = new stdClass;
        if ($this->request->method('post')) {
            $feature->id = $this->request->post('id', 'integer');
            $feature->name = $this->request->post('name');
            $feature->in_filter = intval($this->request->post('in_filter'));
            $feature->yandex = intval($this->request->post('yandex'));
            $feature->auto_name_id = $this->request->post('auto_name_id');
            $feature->auto_value_id = $this->request->post('auto_value_id');
            $feature->url = $this->request->post('url', 'string');
            $feature->url_in_product = $this->request->post('url_in_product');
            $feature->to_index_new_value = $this->request->post('to_index_new_value');

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

            // Если отметили "Индексировать все значения"
            if (isset($_POST['to_index_all_values']) && $feature->id) {
                $this->db->query("UPDATE `__features_values` SET `to_index`=? WHERE `feature_id`=?", $this->request->post('to_index_all_values', 'integer'), $feature->id);
            }

            $features_values = array();
            if($this->request->post('feature_values')) {
                foreach($this->request->post('feature_values') as $n=>$fv) {
                    foreach($fv as $i=>$v) {
                        if(empty($features_values[$i])) {
                            $features_values[$i] = new stdClass;
                        }
                        $features_values[$i]->$n = $v;
                    }
                }
            }

            if ($values_to_delete = $this->request->post('values_to_delete')) {
                foreach ($features_values  as $k=>$fv) {
                    if (in_array($fv->id, $values_to_delete)) {
                        unset($features_values[$k]);
                        $this->features_values->delete_feature_value($fv->id);
                    }
                }
            }

            $feature_values_ids = array();
            foreach($features_values as $fv) {
                if (!$fv->to_index) {
                    $fv->to_index = 0;
                }
                // TODO Обработка ошибок не уникального тринслита или генерить уникальный
                if ($fv->value) {
                    $fv->feature_id = $feature->id;
                    if (!empty($fv->id)) {
                        $this->features_values->update_feature_value($fv->id, $fv);
                    } else {
                        unset($fv->id);
                        $fv->id = $this->features_values->add_feature_value($fv);
                    }
                    $feature_values_ids[] = $fv->id;
                }
            }

            asort($feature_values_ids);
            $i = 0;
            foreach($feature_values_ids as $features_value_id) {
                $this->features_values->update_feature_value($feature_values_ids[$i], array('position'=>$features_value_id));
                $i++;
            }

            // Если прислали значения для объединения
            if (($union_main_value_id = $this->request->post('union_main_value_id', 'integer'))
                && ($union_second_value_id = $this->request->post('union_second_value_id', 'integer'))) {

                $union_main_value   = $this->features_values->get_feature_value($union_main_value_id);
                $union_second_value = $this->features_values->get_feature_value($union_second_value_id);

                if ($union_main_value && $union_second_value && $union_main_value->id != $union_second_value->id) {

                    // Получим id товаров для которых уже есть занчение которое мы объединяем
                    $this->db->query("SELECT `product_id` FROM `__products_features_values` WHERE `value_id`=?", $union_main_value->id);
                    $products_ids = $this->db->results('product_id');

                    // Добавляем значение с которым объединяли всем товарам у которых было старое значение
                    foreach ($products_ids as $product_id) {
                        $this->db->query("REPLACE INTO `__products_features_values` SET `product_id`=?, `value_id`=?", $product_id, $union_second_value->id);
                    }

                    // Удаляем занчение которое мы объединяли
                    $this->features_values->delete_feature_value($union_main_value->id);
                }
            }

        } else {
            $feature->id = $this->request->get('id', 'integer');
            $feature = $this->features->get_feature($feature->id);
        }

        if ($feature->id) {

            $features_values = array();
            $features_values_filter = array('feature_id'=>$feature->id);

            if ($features_values_filter['limit'] = $this->request->get('limit', 'integer')) {
                $features_values_filter['limit'] = max(5, $features_values_filter['limit']);
                $features_values_filter['limit'] = min(100, $features_values_filter['limit']);
                $_SESSION['features_values_num_admin'] = $features_values_filter['limit'];
            } elseif (!empty($_SESSION['features_values_num_admin'])) {
                $features_values_filter['limit'] = $_SESSION['features_values_num_admin'];
            } else {
                $features_values_filter['limit'] = 25;
            }
            $this->design->assign('current_limit', $features_values_filter['limit']);

            $features_values_filter['page'] = max(1, $this->request->get('page', 'integer'));

            $feature_values_count = $this->features_values->get_features_values($features_values_filter, true);

            // Показать все страницы сразу
            if($this->request->get('page') == 'all') {
                $features_values_filter['limit'] = $feature_values_count;
            }

            if($features_values_filter['limit'] > 0) {
                $pages_count = ceil($feature_values_count/$features_values_filter['limit']);
            } else {
                $pages_count = 0;
            }

            if ($this->request->post('action') == 'move_to_page' && $this->request->post('check')) {
                /*Переместить на страницу*/
                $target_page = $this->request->post('target_page', 'integer');

                // Сразу потом откроем эту страницу
                $features_values_filter['page'] = $target_page;

                $check = $this->request->post('check');
                $query = $this->db->placehold("SELECT id FROM __features_values WHERE feature_id=? AND id not in (?@) ORDER BY position ASC", $feature->id, (array)$check);
                $this->db->query($query);

                $ids = $this->db->results('id');

                // вычисляем после какого значения вставить то, которое меремещали
                $offset = $features_values_filter['limit'] * ($target_page)-1;
                $feature_values_ids = array();
                
                // Собираем общий массив id значений, и в нужное место добавим значение которое перемещали
                // По сути иммитация если выбрали page=all и мереместили приблизительно в нужное место значение
                foreach ($ids as $k=>$id) {
                    if ($k == $offset) {
                        $feature_values_ids = array_merge($feature_values_ids, $check);
                        unset($check);
                    }
                    $feature_values_ids[] = $id;
                }
                
                if (!empty($check)) {
                    $feature_values_ids = array_merge($feature_values_ids, $check);
                }

                asort($feature_values_ids);
                $i = 0;
                
                foreach($feature_values_ids as $features_value_id) {
                    $this->features_values->update_feature_value($feature_values_ids[$i], array('position'=>$features_value_id));
                    $i++;
                }
            }

            $features_values_filter['page'] = min($features_values_filter['page'], $pages_count);
            $this->design->assign('feature_values_count', $feature_values_count);
            $this->design->assign('pages_count', $pages_count);
            $this->design->assign('current_page', $features_values_filter['page']);

            foreach ($this->features_values->get_features_values($features_values_filter) as $fv) {
                $features_values[$fv->translit] = $fv;
            }

            $this->design->assign('features_values', $features_values);
        }

        $feature_categories = array();
        if($feature) {
            $feature_categories = $this->features->get_feature_categories($feature->id);
        } elseif ($category_id = $this->request->get('category_id')) {
            $feature_categories[] = $category_id;
        }

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
