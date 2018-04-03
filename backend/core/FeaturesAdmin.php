<?php

require_once('api/Okay.php');

class FeaturesAdmin extends Okay {
    
    public function fetch() {

        $filter = array();
        $filter['page'] = max(1, $this->request->get('page', 'integer'));

        if ($filter['limit'] = $this->request->get('limit', 'integer')) {
            $filter['limit'] = max(5, $filter['limit']);
            $filter['limit'] = min(100, $filter['limit']);
            $_SESSION['features_num_admin'] = $filter['limit'];
        } elseif (!empty($_SESSION['features_num_admin'])) {
            $filter['limit'] = $_SESSION['features_num_admin'];
        } else {
            $filter['limit'] = 25;
        }
        $this->design->assign('current_limit', $filter['limit']);

        if($this->request->method('post')) {
            // Действия с выбранными
            $ids = $this->request->post('check');
            if(is_array($ids)) {
                switch($this->request->post('action')) {
                    case 'set_in_filter': {
                        /*Отображать в фильтре*/
                        $this->features->update_feature($ids, array('in_filter'=>1));
                        break;
                    }
                    case 'unset_in_filter': {
                        /*Не отображать в фильтре*/
                        $this->features->update_feature($ids, array('in_filter'=>0));
                        break;
                    }
                    case 'to_yandex': {
                        /*Выгружать с яндекс*/
                        $this->features->update_feature($ids, array('yandex'=>1));    
                        break;
                    }
                    case 'from_yandex': {
                        /*Не выгружать в яндекс*/
                        $this->features->update_feature($ids, array('yandex'=>0));    
                        break;
                    }
                    case 'delete': {
                        /*Удалить свойство*/
                        $current_cat = $this->request->get('category_id', 'integer');
                        foreach($ids as $id) {
                            // текущие категории
                            $cats = $this->features->get_feature_categories($id);
                            
                            // В каких категориях оставлять
                            $diff = array_diff($cats, (array)$current_cat);
                            if(!empty($current_cat) && !empty($diff)) {
                                $this->features->update_feature_categories($id, $diff);
                            } else {
                                $this->features->delete_feature($id);
                            }
                        }
                        break;
                    }
                }
            }
            
            // Сортировка
            $positions = $this->request->post('positions');
            $ids = array_keys($positions);
            sort($positions);
            foreach($positions as $i=>$position) {
                $this->features->update_feature($ids[$i], array('position'=>$position));
            }
        }
        
        $categories = $this->categories->get_categories();
        $category = null;

        $category_id = $this->request->get('category_id', 'integer');
        if($category_id) {
            $category = $this->categories->get_category($category_id);
            $filter['category_id'] = $category->id;
        }

        $features_count = $this->features->count_features($filter);
        // Показать все страницы сразу
        if($this->request->get('page') == 'all') {
            $filter['limit'] = $features_count;
        }

        if($filter['limit']>0) {
            $pages_count = ceil($features_count/$filter['limit']);
        } else {
            $pages_count = 0;
        }
        $filter['page'] = min($filter['page'], $pages_count);
        $this->design->assign('features_count', $features_count);
        $this->design->assign('pages_count', $pages_count);
        $this->design->assign('current_page', $filter['page']);

        $features = $this->features->get_features($filter);
        foreach ($features as $f){
            $f->features_categories = $this->features->get_feature_categories($f->id);
        }
        $this->design->assign('categories', $categories);
        $this->design->assign('categories_tree', $this->categories->get_categories_tree());
        $this->design->assign('category', $category);
        $this->design->assign('features', $features);
        return $this->body = $this->design->fetch('features.tpl');
    }
    
}
