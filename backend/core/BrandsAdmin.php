<?php

require_once('api/Okay.php');

class BrandsAdmin extends Okay {
    
    public function fetch() {

        $filter = array();
        $filter['page'] = max(1, $this->request->get('page', 'integer'));

        if ($filter['limit'] = $this->request->get('limit', 'integer')) {
            $filter['limit'] = max(5, $filter['limit']);
            $filter['limit'] = min(100, $filter['limit']);
            $_SESSION['brands_num_admin'] = $filter['limit'];
        } elseif (!empty($_SESSION['brands_num_admin'])) {
            $filter['limit'] = $_SESSION['brands_num_admin'];
        } else {
            $filter['limit'] = 25;
        }
        $this->design->assign('current_limit', $filter['limit']);

        // Обработка действий
        if($this->request->method('post')) {
            // Действия с выбранными
            $ids = $this->request->post('check');
            
            if(is_array($ids)) {
                switch($this->request->post('action')) {
                    case 'delete': {
                        /*Удаление брендов*/
                        foreach($ids as $id) {
                            $this->brands->delete_brand($id);
                        }
                        break;
                    }
                    case 'in_feed': {
                        /*Выгрузка товаров бренда в файл feed.xml*/
                        foreach($ids as $id) {
                            $q = $this->db->placehold("SELECT v.id FROM __products p LEFT JOIN __variants v ON v.product_id=p.id WHERE p.brand_id =?", $id);
                            $this->db->query($q);
                            $v_ids = $this->db->results('id');
                            if (count($v_ids) > 0) {
                                $q = $this->db->placehold("UPDATE __variants SET feed=1 WHERE id in(?@)", $v_ids);
                                $this->db->query($q);
                            }
                        }
                        break;
                    }
                    case 'out_feed': {
                        /*Снятие товаров бренда с выгрузки файла feed.xml*/
                        foreach($ids as $id) {
                            $q = $this->db->placehold("SELECT v.id FROM __products p LEFT JOIN __variants v ON v.product_id=p.id WHERE p.brand_id =?", $id);
                            $this->db->query($q);
                            $v_ids = $this->db->results('id');
                            if (count($v_ids) > 0) {
                                $q = $this->db->placehold("UPDATE __variants SET feed=0 WHERE id in(?@)", $v_ids);
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
                $this->brands->update_brand($ids[$i], array('position'=>$position));
            }
        }

        $brands_count = $this->brands->count_brands($filter);
        // Показать все страницы сразу
        if($this->request->get('page') == 'all') {
            $filter['limit'] = $brands_count;
        }

        if($filter['limit']>0) {
            $pages_count = ceil($brands_count/$filter['limit']);
        } else {
            $pages_count = 0;
        }
        $filter['page'] = min($filter['page'], $pages_count);
        $this->design->assign('brands_count', $brands_count);
        $this->design->assign('pages_count', $pages_count);
        $this->design->assign('current_page', $filter['page']);

        $brands = $this->brands->get_brands($filter);
        
        $this->design->assign('brands', $brands);
        return $this->body = $this->design->fetch('brands.tpl');
    }
    
}
