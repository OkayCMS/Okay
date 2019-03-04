<?php

require_once('api/Okay.php');

class ProductsAdmin extends Okay {
    
    public function fetch() {
        $filter = array();
        $filter['page'] = max(1, $this->request->get('page', 'integer'));

        if ($filter['limit'] = $this->request->get('limit', 'integer')) {
            $filter['limit'] = max(5, $filter['limit']);
            $filter['limit'] = min(100, $filter['limit']);
            $_SESSION['products_num_admin'] = $filter['limit'];
        } elseif (!empty($_SESSION['products_num_admin'])) {
            $filter['limit'] = $_SESSION['products_num_admin'];
        } else {
            $filter['limit'] = 25;
        }
        $this->design->assign('current_limit', $filter['limit']);
        
        // Категории
        $categories = $this->categories->get_categories_tree();
        $this->design->assign('categories', $categories);
        
        // Текущая категория
        $category_id = $this->request->get('category_id', 'integer');
        if($category_id && $category = $this->categories->get_category($category_id)) {
            $filter['category_id'] = $category->children;
        } elseif ($category_id==-1) {
            $filter['without_category'] = 1;
        }
        $this->design->assign('category_id', $category_id);
        
        // Бренды категории
        $brands_count = $this->brands->count_brands(array('category_id'=>$filter['category_id']));
        $brands = $this->brands->get_brands(array('category_id'=>$filter['category_id'], 'limit'=>$brands_count));
        $this->design->assign('brands', $brands);
        
        // Все бренды
        $brands_count = $this->brands->count_brands();
        $all_brands = array();
        foreach ($this->brands->get_brands(array('limit'=>$brands_count)) as $b) {
            $all_brands[$b->id] = $b;
        }
        $this->design->assign('all_brands', $all_brands);
        
        // Текущий бренд
        $brand_id = $this->request->get('brand_id', 'integer');
        if($brand_id && $brand = $this->brands->get_brand($brand_id)) {
            $filter['brand_id'] = $brand->id;
        } elseif ($brand_id==-1) {
            $filter['brand_id'] = array(0);
        }
        $this->design->assign('brand_id', $brand_id);

        $filter['features'] = $this->request->get('features');
        
        /*Фильтр по товарам*/
        if($f = $this->request->get('filter', 'string')) {
            if($f == 'featured') {
                $filter['featured'] = 1;
            } elseif($f == 'discounted') {
                $filter['discounted'] = 1;
            } elseif($f == 'visible') {
                $filter['visible'] = 1;
            } elseif($f == 'hidden') {
                $filter['visible'] = 0;
            } elseif($f == 'outofstock') {
                $filter['in_stock'] = 0;
            } elseif($f == 'in_feed') {
                $filter['feed'] = 1;
            } elseif($f == 'out_feed') {
                $filter['feed'] = 0;
            } elseif($f == 'without_images') {
                $filter['has_images'] = 0;
            }
            $this->design->assign('filter', $f);
        }
        
        // Поиск
        $keyword = $this->request->get('keyword');
        if(!empty($keyword)) {
            $filter['keyword'] = $keyword;
            $this->design->assign('keyword', $keyword);
        }
        
        // Обработка действий
        if($this->request->method('post')) {
            // Сохранение цен и наличия
            $prices = $this->request->post('price');
            $stocks = $this->request->post('stock');

            foreach($prices as $id=>$price) {
                $stock = $stocks[$id];
                if($stock == '∞' || $stock == '') {
                    $stock = null;
                }
                $this->variants->update_variant($id, array('price'=>str_replace(',', '.', $price), 'stock'=>$stock));
            }
            
            // Сортировка
            $positions = $this->request->post('positions');
            $ids = array_keys($positions);
            sort($positions);
            $positions = array_reverse($positions);
            foreach($positions as $i=>$position) {
                $this->products->update_product($ids[$i], array('position'=>$position));
            }
            
            // Действия с выбранными
            $ids = $this->request->post('check');
            if(!empty($ids)) {
                switch($this->request->post('action')) {
                    case 'disable': {
                        /*Выключить товар*/
                        $this->products->update_product($ids, array('visible'=>0));
                        break;
                    }
                    case 'enable': {
                        /*Включить товар*/
                        $this->products->update_product($ids, array('visible'=>1));
                        break;
                    }
                    case 'set_featured': {
                        /*Включить "хит продаж"*/
                        $this->products->update_product($ids, array('featured'=>1));
                        break;
                    }
                    case 'unset_featured': {
                        /*Выключить "хит продаж"*/
                        $this->products->update_product($ids, array('featured'=>0));
                        break;
                    }
                    case 'set_feed': {
                        /*Выгружать в фид*/
                        $this->db->query("UPDATE __variants set feed=1 where product_id in(?@)", $ids);
                        break;
                    }
                    case 'unset_feed': {
                        /*Не выгружать в фид*/
                        $this->db->query("UPDATE __variants set feed=0 where product_id in(?@)", $ids);
                        break;
                    }
                    case 'delete': {
                        /*Удалить товар*/
                        $this->products->delete_product($ids);
                        break;
                    }
                    case 'duplicate': {
                        /*Сделать копию товара*/
                        foreach($ids as $id) {
                            $this->products->duplicate_product(intval($id));
                        }
                        break;
                    }
                    case 'move_to_page': {
                        /*Переместить на страницу*/
                        $target_page = $this->request->post('target_page', 'integer');
                        
                        // Сразу потом откроем эту страницу
                        $filter['page'] = $target_page;
                        
                        // До какого товара перемещать
                        $limit = $filter['limit']*($target_page-1);
                        if($target_page > $this->request->get('page', 'integer')) {
                            $limit += count($ids)-1;
                        } else {
                            $ids = array_reverse($ids, true);
                        }
                        
                        
                        $temp_filter = $filter;
                        $temp_filter['page'] = $limit+1;
                        $temp_filter['limit'] = 1;
                        $tmp = $this->products->get_products($temp_filter);
                        $target_product = array_pop($tmp);
                        $target_position = $target_product->position;
                        
                        // Если вылезли за последний товар - берем позицию последнего товара в качестве цели перемещения
                        if($target_page > $this->request->get('page', 'integer') && !$target_position) {
                            $query = $this->db->placehold("SELECT distinct p.position AS target FROM __products p LEFT JOIN __products_categories AS pc ON pc.product_id = p.id WHERE 1 $category_id_filter $brand_id_filter ORDER BY p.position DESC LIMIT 1", count($ids));
                            $this->db->query($query);
                            $target_position = $this->db->result('target');
                        }
                        
                        foreach($ids as $id) {
                            $query = $this->db->placehold("SELECT position FROM __products WHERE id=? LIMIT 1", $id);
                            $this->db->query($query);
                            $initial_position = $this->db->result('position');
                            
                            if($target_position > $initial_position) {
                                $query = $this->db->placehold("	UPDATE __products set position=position-1 WHERE position>? AND position<=?", $initial_position, $target_position);
                            } else {
                                $query = $this->db->placehold("	UPDATE __products set position=position+1 WHERE position<? AND position>=?", $initial_position, $target_position);
                            }
                            
                            $this->db->query($query);
                            $query = $this->db->placehold("UPDATE __products SET __products.position = ? WHERE __products.id = ?", $target_position, $id);
                            $this->db->query($query);
                        }
                        break;
                    }
                    case 'move_to_category': {
                        /*Переместить в категорию*/
                        $category_id = $this->request->post('target_category', 'integer');
                        $filter['page'] = 1;
                        $category = $this->categories->get_category($category_id);
                        $filter['category_id'] = $category->children;
                        
                        foreach($ids as $id) {
                            $query = $this->db->placehold("DELETE FROM __products_categories WHERE category_id=? AND product_id=? LIMIT 1", $category_id, $id);
                            $this->db->query($query);
                            $query = $this->db->placehold("UPDATE IGNORE __products_categories set category_id=? WHERE product_id=? ORDER BY position DESC LIMIT 1", $category_id, $id);
                            $this->db->query($query);
                            if($this->db->affected_rows() == 0) {
                                $query = $this->db->query("INSERT IGNORE INTO __products_categories set category_id=?, product_id=?", $category_id, $id);
                            }
                        }
                        break;
                    }
                    case 'move_to_brand': {
                        /*Переместить в бренд*/
                        $brand_id = $this->request->post('target_brand', 'integer');
                        $brand = $this->brands->get_brand($brand_id);
                        $filter['page'] = 1;
                        $filter['brand_id'] = $brand_id;
                        $query = $this->db->placehold("UPDATE __products set brand_id=? WHERE id in (?@)", $brand_id, $ids);
                        $this->db->query($query);
                        
                        // Заново выберем бренды категории
                        $brands_count = $this->brands->count_brands(array('category_id'=>$category_id));
                        $brands = $this->brands->get_brands(array('category_id'=>$category_id, 'limit'=>$brands_count));
                        $this->design->assign('brands', $brands);
                        
                        break;
                    }
                }
            }
        }
        
        // Отображение
        if(isset($brand)) {
            $this->design->assign('brand', $brand);
        }
        if(isset($category)) {
            $this->design->assign('category', $category);
        }
        
        $products_count = $this->products->count_products($filter);
        // Показать все страницы сразу
        if($this->request->get('page') == 'all') {
            $filter['limit'] = $products_count;
        }
        
        if($filter['limit']>0) {
            $pages_count = ceil($products_count/$filter['limit']);
        } else {
            $pages_count = 0;
        }
        $filter['page'] = min($filter['page'], $pages_count);
        $this->design->assign('products_count', $products_count);
        $this->design->assign('pages_count', $pages_count);
        $this->design->assign('current_page', $filter['page']);
        
        $products = array();
        $images_ids = array();
        foreach($this->products->get_products($filter) as $p) {
            $products[$p->id] = $p;
            $images_ids[] = $p->main_image_id;
        }
        
        
        if(!empty($products)) {
            // Товары
            $products_ids = array_keys($products);
            foreach($products as $product) {
                $product->variants = array();
                $product->properties = array();
            }
            
            $variants = $this->variants->get_variants(array('product_id'=>$products_ids));
            
            foreach($variants as $variant) {
                $products[$variant->product_id]->variants[] = $variant;
            }

            if (!empty($images_ids)) {
                $images = $this->products->get_images(array('id'=>$images_ids));
                foreach ($images as $image) {
                    if (isset($products[$image->product_id])) {
                        $products[$image->product_id]->image = $image;
                    }
                }
            }
        }
        
        $this->design->assign('currencies', $this->money->get_currencies());
        $this->design->assign('products', $products);

        return $this->design->fetch('products.tpl');
    }

}
