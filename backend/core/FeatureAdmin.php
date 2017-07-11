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
        } else {
            $feature->id = $this->request->get('id', 'integer');
            $feature = $this->features->get_feature($feature->id);
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
