<?php

require_once('Okay.php');

class Categories extends Okay {
    
    // Список указателей на категории в дереве категорий (ключ = id категории)
    private $all_categories;
    // Дерево категорий
    private $categories_tree;

    /*Выбираем все категории*/
    public function get_categories($filter = array()) {

        $parent_filter = '';
        $date_from_filter = '';
        $level_depth_filter = '';

        if(!isset($this->categories_tree)) {
            $this->init_categories();
        }

        if (!empty($filter['id'])) {
            $result = array();
            foreach ((array)$filter['id'] as $id) {
                if (isset($this->all_categories[$id])) {
                    $result[$id] = $this->all_categories[$id];
                }
            }
            return $result;
        }

        if(!empty($filter['product_id'])) {
            $query = $this->db->placehold("SELECT category_id FROM __products_categories WHERE product_id in(?@) ORDER BY position", (array)$filter['product_id']);
            $this->db->query($query);
            $categories_ids = $this->db->results('category_id');
            $result = array();
            foreach($categories_ids as $id) {
                if(isset($this->all_categories[$id])) {
                    $result[$id] = $this->all_categories[$id];
                }
            }
            return $result;
        }

        if(!empty($filter['brand_id'])) {
            $category_visible_filter = '';
            
            if (isset($filter['category_visible'])) {
                $category_visible_filter = $this->db->placehold(" AND c.visible=?", (int)$filter['category_visible']);
            }
            
            $query = $this->db->placehold("SELECT pc.category_id FROM __products_categories pc 
                      INNER JOIN __products p ON p.id=pc.product_id AND p.brand_id in (?@) AND p.visible=1
                      LEFT JOIN __categories c ON c.id=pc.category_id
                      WHERE 1
                      $category_visible_filter
                      GROUP BY pc.category_id ORDER BY c.parent_id, c.position", (array)$filter['brand_id']);
            $this->db->query($query);
            $categories_ids = $this->db->results('category_id');
            $result = array();
            foreach($categories_ids as $id) {
                if(isset($this->all_categories[$id])) {
                    $result[$id] = $this->all_categories[$id];
                }
            }
            return $result;
        }
        
        $parent = null;
        if (!empty($filter['parent_id']) && isset($this->all_categories[intval($filter['parent_id'])])) {
            $parent = $this->all_categories[intval($filter['parent_id'])];
        }
        
        if (!empty($filter['level_depth'])) {
            if ($parent) {
                $parent_filter = $this->db->placehold('AND c.id in(?@)', (array)$parent->children);
            }
            $level_depth_filter = $this->db->placehold("AND c.level_depth = ?", (int)$filter['level_depth']);
        }

        if (!empty($filter['date_from'])) {
            $from = date('Y-m-d H:i:s', strtotime($filter['date_from']));
            $date_from_filter = $this->db->placehold("AND c.created >= ?", $from);
        }

        if (!empty($filter['level_depth']) || !empty($filter['date'])) {
            $this->db->query("SELECT c.id
                FROM __categories c
                WHERE 1
                $level_depth_filter
                $parent_filter
                $date_from_filter
                ORDER BY c.position");

            $categories_ids = $this->db->results('id');

            $result = array();
            foreach ($categories_ids as $cid) {
                if (isset($this->all_categories[$cid])) {
                    $result[$cid] = $this->all_categories[$cid];
                }
            }
            return $result;
        } elseif ($parent) {
            return $parent->subcategories;
        }
        
        return $this->all_categories;
    }

    /*Выбираем категории определенного товара*/
    public function get_product_categories($product_id) {
        $query = $this->db->placehold("SELECT product_id, category_id, position FROM __products_categories WHERE product_id in(?@) ORDER BY position", (array)$product_id);
        $this->db->query($query);
        return $this->db->results();
    }

    /*Выбираем связку товаров и их категорий*/
    public function get_products_categories() {
        $query = $this->db->placehold("SELECT product_id, category_id, position FROM __products_categories ORDER BY position");
        $this->db->query($query);
        return $this->db->results();
    }

    /*Выбираем дерево категорий*/
    public function get_categories_tree() {
        if(!isset($this->categories_tree)) {
            $this->init_categories();
        }
        return $this->categories_tree;
    }

    /*Выбираем конкретную категорию*/
    public function get_category($id) {
        if(!isset($this->all_categories)) {
            $this->init_categories();
        }
        if(is_int($id) && array_key_exists(intval($id), $this->all_categories)) {
            return $category = $this->all_categories[intval($id)];
        } elseif(is_string($id)) {
            foreach ($this->all_categories as $category) {
                if ($category->url == $id) {
                    return $this->get_category((int)$category->id);
                }
            }
        }
        return false;
    }

    /*Добавление категории*/
    public function add_category($category) {
        $created = '';
        $category = (array)$category;
        if(empty($category['url'])) {
            $category['url'] = preg_replace("/[\s]+/ui", '_', $category['name']);
            $category['url'] = strtolower(preg_replace("/[^0-9a-zа-я_]+/ui", '', $category['url']));
        }
        
        // Если есть категория с таким URL, добавляем к нему число
        while($this->get_category((string)$category['url'])) {
            if(preg_match('/(.+)_([0-9]+)$/', $category['url'], $parts)) {
                $category['url'] = $parts[1].'_'.($parts[2]+1);
            } else {
                $category['url'] = $category['url'].'_2';
            }
        }
        
        $category = (object)$category;
        if ($category->parent_id) {
            if (isset($this->all_categories[$category->parent_id])) {
                $category->level_depth = $this->all_categories[$category->parent_id]->level_depth + 1;
            }
        } else {
            $category->level_depth = 1;
        }

        if (empty($category->created)) {
            $created = $this->db->placehold(", created=NOW()");
        }

        $result = $this->languages->get_description($category, 'category');
        
        $this->db->query("INSERT INTO __categories SET ?% $created", $category);
        $id = $this->db->insert_id();
        $this->db->query("UPDATE __categories SET position=id WHERE id=?", $id);
        
        if(!empty($result->description)) {
            $this->languages->action_description($id, $result->description, 'category');
        }
        
        unset($this->categories_tree);
        unset($this->all_categories);
        return $id;
    }

    /*Обновление уровня вложенности категории*/
    private function update_level_depth($id, $prev_level = 1) {
        if ($this->all_categories[$id]->subcategories) {
            foreach ($this->all_categories[$id]->subcategories as $sub_cat) {
                $this->db->query("UPDATE __categories SET level_depth=? WHERE id=? LIMIT 1", $prev_level+1, intval($sub_cat->id));
                $this->update_level_depth($sub_cat->id, $prev_level+1);
            }
        }
    }

    /*Обновление категории*/
    public function update_category($id, $category) {
        if (is_object($category)) {
            if ($category->parent_id) {
                if (isset($this->all_categories[$category->parent_id])) {
                    $category->level_depth = $this->all_categories[$category->parent_id]->level_depth + 1;
                }
            } else {
                $category->level_depth = 1;
            }
            $this->update_level_depth($id, $category->level_depth);
        }
        
        $category = (array)$category;
        unset($category['path']);
        unset($category['level']);
        unset($category['subcategories']);
        unset($category['children']);
        $category = (object)$category;
        $result = $this->languages->get_description($category, 'category');
        
        $query = $this->db->placehold("UPDATE __categories SET ?%, last_modify=NOW() WHERE id=? LIMIT 1", $category, intval($id));
        $this->db->query($query);
        
        if(!empty($result->description)) {
            $this->languages->action_description($id, $result->description, 'category', $this->languages->lang_id());
        }
        
        unset($this->categories_tree);
        unset($this->all_categories);
        return intval($id);
    }

    /*Удаление категории*/
    public function delete_category($ids) {
        $ids = (array) $ids;
        foreach($ids as $id) {
            if($category = $this->get_category(intval($id))) {
                if(!empty($category->children)) {
                    foreach ($category->children as $cid) {
                        $this->image->delete_image($cid, 'image', 'categories', $this->config->original_categories_dir, $this->config->resized_categories_dir);
                    }
                    $query = $this->db->placehold("DELETE FROM __categories WHERE id in(?@)", $category->children);
                    $this->db->query($query);
                    $this->db->query("SELECT product_id FROM __products_categories WHERE category_id in(?@)", $category->children);
                    //Получим товары для которых нужно будет обновить информацию о главных категориях
                    $product_ids = $this->db->results('product_id');
                    $query = $this->db->placehold("DELETE FROM __products_categories WHERE category_id in(?@)", $category->children);
                    $this->db->query($query);
                    //Обновим информацию о главной категории
                    $this->update_main_product_category($product_ids);
                    $this->db->query("DELETE FROM __lang_categories WHERE category_id in(?@)", $category->children);

                    if ($patterns = $this->seo_filter_patterns->get_patterns(array('category_id'=>$category->children))) {
                        foreach ($patterns as $p) {
                            $this->seo_filter_patterns->delete_pattern($p->id);
                        }
                    }
                }
            }
        }
        unset($this->categories_tree);
        unset($this->all_categories);
        return $id;
    }

    /*Добавление категории к товару*/
    public function add_product_category($product_id, $category_id, $position=0) {
        $this->db->query("update __categories set last_modify=now() where id=?", intval($category_id));
        $query = $this->db->placehold("INSERT IGNORE INTO __products_categories SET product_id=?, category_id=?, position=?", $product_id, $category_id, $position);
        $this->db->query($query);
    }

    //Обновление информацию о главной категории товара
    public function update_main_product_category($product_ids) {
        if (!empty($product_ids)) {
            $this->db->query("UPDATE __products p
                              LEFT JOIN __products_categories pc ON p.id = pc.product_id AND pc.position=(SELECT MIN(position) FROM __products_categories WHERE product_id=p.id LIMIT 1)
                              SET p.main_category_id = pc.category_id
                              WHERE p.id in (?@)", (array)$product_ids);
        }
    }

    /*Удаление категории из товара*/
    public function delete_product_category($products_ids, $categories_ids = array()) {

        $products_ids = (array)$products_ids;
        $categories_ids = (array)$categories_ids;
        $category_id_filter = '';
        if (empty($category_id)) {
            foreach ($this->get_categories(array('product_id'=>$products_ids)) as $c) {
                $categories_ids[] = $c->id;
            }
        }
        if (!empty($categories_ids)) {
            $this->db->query("UPDATE __categories SET last_modify=NOW() WHERE id IN (?@)", $categories_ids);
            $category_id_filter = $this->db->placehold("AND category_id IN (?@)", $categories_ids);
        }
        $query = $this->db->placehold("DELETE FROM __products_categories WHERE product_id IN (?@) $category_id_filter", $products_ids);
        $this->db->query($query);
    }

    /*Выборка категорий из БД и рекурсивное построение дерева категорий*/
    private function init_categories() {
        // Дерево категорий
        $tree = new stdClass();
        $tree->subcategories = array();
        
        // Указатели на узлы дерева
        $pointers = array();
        $pointers[0] = &$tree;
        $pointers[0]->path = array();
        $pointers[0]->level = 0;
        
        $lang_sql = $this->languages->get_query(array('object'=>'category'));
        
        // Выбираем все категории
        $query = $this->db->placehold("SELECT 
                c.id, 
                c.parent_id,  
                c.url, 
                c.image, 
                c.visible, 
                c.position, 
                c.level_depth, 
                c.yandex_name, 
                c.last_modify, 
                c.created,
                $lang_sql->fields
            FROM __categories c 
            $lang_sql->join 
            ORDER BY c.parent_id, c.position
        ");

        $this->db->query($query);
        $categories = $this->db->results();
        
        $finish = false;
        // Не кончаем, пока не кончатся категории, или пока ниодну из оставшихся некуда приткнуть
        while(!empty($categories)  && !$finish) {
            $flag = false;
            // Проходим все выбранные категории
            foreach($categories as $k=>$category) {
                if(isset($pointers[$category->parent_id])) {
                    // В дерево категорий (через указатель) добавляем текущую категорию
                    $pointers[$category->id] = $pointers[$category->parent_id]->subcategories[] = $category;
                    
                    // Путь к текущей категории
                    $curr = $pointers[$category->id];
                    $pointers[$category->id]->path = array_merge((array)$pointers[$category->parent_id]->path, array($curr));
                    
                    // Уровень вложенности категории
                    $pointers[$category->id]->level = 1+$pointers[$category->parent_id]->level;
                    
                    // Убираем использованную категорию из массива категорий
                    unset($categories[$k]);
                    $flag = true;
                }
            }
            if(!$flag) $finish = true;
        }
        
        // Для каждой категории id всех ее деток узнаем
        $ids = array_reverse(array_keys($pointers));
        foreach($ids as $id) {
            if($id>0) {
                $pointers[$id]->children[] = $id;
                
                if(isset($pointers[$pointers[$id]->parent_id]->children)) {
                    $pointers[$pointers[$id]->parent_id]->children = array_merge($pointers[$id]->children, $pointers[$pointers[$id]->parent_id]->children);
                } else {
                    $pointers[$pointers[$id]->parent_id]->children = $pointers[$id]->children;
                }
            }
        }
        unset($pointers[0]);
        unset($ids);
        
        $this->categories_tree = $tree->subcategories;
        $this->all_categories = $pointers;
    }

    /*Выборка категорий яндекс маркета*/
    public function get_market($query = '') {
        $query = mb_strtolower($query);
        $market_cats = array();
        $file = 'files/downloads/market_categories.csv';
        if (file_exists($file)) {
            $f = fopen($file, 'r');
            fgetcsv($f, 0, '^');
            while (!feof($f)) {
                $line = fgetcsv($f, 0, '^');
                if (empty($query) || strpos(mb_strtolower($line[0]), $query) !== false) {
                    $market_cats[] = $line[0];
                }
            }
            fclose($f);
        }
        return $market_cats;
    }
    
}
