<?php

require_once('api/Okay.php');

class CategoriesAdmin extends Okay {
    
    public function fetch() {
        if($this->request->method('post')) {
            // Действия с выбранными
            $ids = $this->request->post('check');
            if(is_array($ids)) {
                switch($this->request->post('action')) {
                    case 'disable': {
                        foreach($ids as $id) {
                            $this->categories->update_category($id, array('visible'=>0));
                        }
                        break;
                    }
                    case 'enable': {
                        foreach($ids as $id) {
                            $this->categories->update_category($id, array('visible'=>1));
                        }
                        break;
                    }
                    case 'delete': {
                        $this->categories->delete_category($ids);
                        break;
                    }
                    case 'in_feed': {
                        foreach($ids as $id) {
                            $category = $this->categories->get_category(intval($id));
                            $q = $this->db->placehold("SELECT v.id FROM __categories c RIGHT JOIN __products_categories pc ON c.id=pc.category_id
                                  RIGHT JOIN __variants v ON v.product_id=pc.product_id
                                  WHERE c.id in(?@)", $category->children);
                            $this->db->query($q);
                            $v_ids = $this->db->results('id');
                            if (count($v_ids) > 0) {
                                $q = $this->db->placehold("UPDATE __variants SET feed=1 WHERE id IN(?@)", $v_ids);
                                $this->db->query($q);
                            }

                        }
                        break;
                    }
                    case 'out_feed': {
                        foreach($ids as $id) {
                            $category = $this->categories->get_category(intval($id));
                            $q = $this->db->placehold("SELECT v.id FROM __categories c
                                 RIGHT JOIN __products_categories pc ON c.id=pc.category_id
                                 RIGHT JOIN __variants v ON v.product_id=pc.product_id
                                 WHERE c.id in(?@)", $category->children);
                            $this->db->query($q);
                            $v_ids = $this->db->results('id');
                            if (count($v_ids) > 0) {
                                $q = $this->db->placehold("UPDATE __variants SET feed=0 WHERE id IN(?@)", $v_ids);
                                $this->db->query($q);
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
                $this->categories->update_category($ids[$i], array('position'=>$position));
            }
        }
        
        $categories = $this->categories->get_categories_tree();
        
        $this->design->assign('categories', $categories);
        return $this->design->fetch('categories.tpl');
    }
    
}
