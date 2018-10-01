<?php

require_once('api/Okay.php');

class ImportLogAdmin extends Okay {

    /*Лог импорта товаров*/
    public function fetch() {
        $filter = array();
        $filter['page'] = max(1, $this->request->get('page', 'integer'));

        if ($filter['limit'] = $this->request->get('limit', 'integer')) {
            $filter['limit'] = max(25, $filter['limit']);
            $filter['limit'] = min(500, $filter['limit']);
            $_SESSION['import_log_num'] = $filter['limit'];
        } elseif (!empty($_SESSION['import_log_num'])) {
            $filter['limit'] = $_SESSION['import_log_num'];
        } else {
            $filter['limit'] = 100;
        }
        $this->design->assign('current_limit', $filter['limit']);

        // Текущий фильтр
        if($f = $this->request->get('filter', 'string')) {
            $filter['status'] = $f;
            $this->design->assign('filter', $f);
        }

        // Поиск
        $keyword = $this->request->get('keyword');
        if(!empty($keyword)) {
            $filter['keyword'] = $keyword;
            $this->design->assign('keyword', $keyword);
        }

        $logs_count = $this->get_logs($filter);
        // Показать все страницы сразу
        if($this->request->get('page') == 'all') {
            $filter['limit'] = $logs_count;
        }

        if($filter['limit']>0) {
            $pages_count = ceil($logs_count/$filter['limit']);
        } else {
            $pages_count = 0;
        }
        $filter['page'] = min($filter['page'], $pages_count);
        $this->design->assign('logs_count', $logs_count);
        $this->design->assign('pages_count', $pages_count);
        $this->design->assign('current_page', $filter['page']);

        $logs = $this->get_logs($filter, false);
        if(!empty($logs)) {
            $products_ids = array();
            foreach($logs as $l) {
                $products_ids[] = $l->product_id;
            }

            $products = array();
            $images_ids = array();
            foreach($this->products->get_products(array('id'=>array_unique($products_ids))) as $p) {
                $products[$p->id] = $p;
                $images_ids[] = $p->main_image_id;
            }

            if (!empty($images_ids)) {
                $images = $this->products->get_images(array('id'=>$images_ids));
                foreach ($images as $image) {
                    if (isset($products[$image->product_id])) {
                        $products[$image->product_id]->image = $image;
                    }
                }
            }

            foreach ($logs as $l) {
                if (isset($products[$l->product_id])) {
                    $l->product = $products[$l->product_id];
                }
            }
        }
        $this->design->assign('logs', $logs);

        return $this->design->fetch('import_log.tpl');
    }

    /*Выборка лога последнего успешного импорта*/
    private function get_logs($filter = array(), $is_count = true) {
        $keyword_filter = '';
        $status_filter = '';
        $sql_limit = '';

        if (isset($filter['keyword'])) {
            $keywords = explode(' ', $filter['keyword']);
            foreach ($keywords as $keyword) {
                $kw = $this->db->escape(trim($keyword));
                if ($kw !== '') {
                    $keyword_filter .= $this->db->placehold("AND (
                        il.product_name LIKE '%$kw%'
                        OR il.variant_name LIKE '%$kw%'
                    ) ");
                }
            }
        }
        if (isset($filter['status'])) {
            $status_filter = $this->db->placehold('AND il.status=?', $filter['status']);
        }

        if ($is_count) {
            $select = 'count(il.id) as cnt';
        } else {
            $select = 'il.*';
            $limit = 100;
            if(isset($filter['limit'])) {
                $limit = max(1, intval($filter['limit']));
            }
            if(isset($filter['page'])) {
                $page = max(1, intval($filter['page']));
            }
            $sql_limit = $this->db->placehold(' LIMIT ?, ? ', ($page-1)*$limit, $limit);
        }
        $query = "SELECT $select
            FROM __import_log AS il
            WHERE
                1
                $keyword_filter
                $status_filter
            ORDER BY id DESC
            $sql_limit
        ";
        $this->db->query($query);
        if ($is_count) {
            return $this->db->result('cnt');
        } else {
            return $this->db->results();
        }
    }

}
