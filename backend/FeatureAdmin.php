<?php

require_once('api/Okay.php');

class FeatureAdmin extends Okay {
    
    public function fetch() {
        $feature = new stdClass;
        if($this->request->method('post')) {
            $feature->id = $this->request->post('id', 'integer');
            $feature->name = $this->request->post('name');
            $feature->in_filter = intval($this->request->post('in_filter'));
            $feature->yandex = intval($this->request->post('yandex'));
            $feature_categories = $this->request->post('feature_categories');
            $feature->auto_name_id = $this->request->post('auto_name_id');
            $feature->auto_value_id = $this->request->post('auto_value_id');
            $feature->url = $this->request->post('url', 'string');
            
            $feature->url = preg_replace("/[\s]+/ui", '', $feature->url);
            $feature->url = strtolower(preg_replace("/[^0-9a-z]+/ui", '', $feature->url));
            if(empty($feature->url)) {
                $feature->url = $this->translit_alpha($feature->name);
            }
            
            // Не допустить одинаковые URL свойств.
            if(($c = $this->features->get_feature($feature->url)) && $c->id!=$feature->id) {
                $this->design->assign('message_error', 'Свойство с таким url уже существует');
            } elseif(empty($feature->name)) {
                $this->design->assign('message_error', 'empty_name');
            } else {
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
    
}
