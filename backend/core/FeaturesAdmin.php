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

            // Сортировка
            $positions = $this->request->post('positions');
            $ids = array_keys($positions);
            sort($positions);
            foreach($positions as $i=>$position) {
                $this->features->update_feature($ids[$i], array('position'=>$position));
            }
            
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
                    case 'move_to_page': {
                        /*Переместить на страницу*/
                        $target_page = $this->request->post('target_page', 'integer');
    
                        // Сразу потом откроем эту страницу
                        $filter['page'] = $target_page;
    
                        // До какого свойства перемещать
                        $limit = $filter['limit']*($target_page-1);
                        if($target_page > $this->request->get('page', 'integer')) {
                            $limit += count($ids)-1;
                        } else {
                            $ids = array_reverse($ids, true);
                        }
    
                        $temp_filter = $filter;
                        $temp_filter['page'] = $limit+1;
                        $temp_filter['limit'] = 1;
                        $tmp = $this->features->get_features($temp_filter);
                        $target_feature = array_pop($tmp);
                        $target_position = $target_feature->position;
    
                        // Если вылезли за последнее свойство - берем позицию последнего свойства в качестве цели перемещения
                        if($target_page > $this->request->get('page', 'integer') && !$target_position) {
                            $query = $this->db->placehold("SELECT distinct position AS target FROM __features ORDER BY position DESC LIMIT 1");
                            $this->db->query($query);
                            $target_position = $this->db->result('target');
                        }
    
                        foreach($ids as $id) {
                            $query = $this->db->placehold("SELECT position FROM __features WHERE id=? LIMIT 1", $id);
                            $this->db->query($query);
                            $initial_position = $this->db->result('position');
    
                            if($target_position > $initial_position) {
                                $query = $this->db->placehold("	UPDATE __features set position=position-1 WHERE position>? AND position<=?", $initial_position, $target_position);
                            } else {
                                $query = $this->db->placehold("	UPDATE __features set position=position+1 WHERE position<? AND position>=?", $initial_position, $target_position);
                            }
    
                            $this->db->query($query);
                            $query = $this->db->placehold("UPDATE __features SET position = ? WHERE id = ?", $target_position, $id);
                            $this->db->query($query);
                        }
                        break;
                    }
                }
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
