<?php

require_once('Okay.php');

class Categories extends Okay {
    
    // Список указателей на категории в дереве категорий (ключ = id категории)
    private $all_categories;
    // Дерево категорий
    private $categories_tree;
    
    public function get_categories($filter = array()) {
        if(!isset($this->categories_tree)) {
            $this->init_categories();
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
        
        $parent = null;
        if (!empty($filter['parent_id']) && isset($this->all_categories[intval($filter['parent_id'])])) {
            $parent = $this->all_categories[intval($filter['parent_id'])];
        }
        
        if (!empty($filter['level_depth'])) {
            $parent_filter = '';
            if ($parent) {
                $parent_filter = $this->db->placehold('AND c.id in(?@)', (array)$parent->children);
            }
            
            $this->db->query("select c.id 
                from __categories c 
                where c.level_depth=? 
                $parent_filter 
                order by c.name", intval($filter['level_depth']));
            $result = array();
            foreach ($this->db->results('id') as $cid) {
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
    
    public function get_product_categories($product_id) {
        $query = $this->db->placehold("SELECT product_id, category_id, position FROM __products_categories WHERE product_id in(?@) ORDER BY position", (array)$product_id);
        $this->db->query($query);
        return $this->db->results();
    }
    
    public function get_products_categories() {
        $query = $this->db->placehold("SELECT product_id, category_id, position FROM __products_categories ORDER BY position");
        $this->db->query($query);
        return $this->db->results();
    }
    
    public function get_categories_tree() {
        if(!isset($this->categories_tree)) {
            $this->init_categories();
        }
        return $this->categories_tree;
    }
    
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
    
    public function add_category($category) {
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
        
        $result = $this->languages->get_description($category, 'category');
        
        $category->last_modify = date("Y-m-d H:i:s");
        $this->db->query("INSERT INTO __categories SET ?%", $category);
        $id = $this->db->insert_id();
        $this->db->query("UPDATE __categories SET position=id WHERE id=?", $id);
        
        if(!empty($result->description)) {
            $this->languages->action_description($id, $result->description, 'category');
        }
        
        unset($this->categories_tree);
        unset($this->all_categories);
        return $id;
    }
    
    private function update_level_depth($id, $prev_level = 1) {
        if ($this->all_categories[$id]->subcategories) {
            foreach ($this->all_categories[$id]->subcategories as $sub_cat) {
                $this->db->query("UPDATE __categories SET level_depth=? WHERE id=? LIMIT 1", $prev_level+1, intval($sub_cat->id));
                $this->update_level_depth($sub_cat->id, $prev_level+1);
            }
        }
    }
    
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
        
        $category = (object)$category;
        $result = $this->languages->get_description($category, 'category');
        
        $category->last_modify = date("Y-m-d H:i:s");
        $query = $this->db->placehold("UPDATE __categories SET ?% WHERE id=? LIMIT 1", $category, intval($id));
        $this->db->query($query);
        
        if(!empty($result->description)) {
            $this->languages->action_description($id, $result->description, 'category', $this->languages->lang_id());
        }
        
        unset($this->categories_tree);
        unset($this->all_categories);
        return intval($id);
    }
    
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
                    $query = $this->db->placehold("DELETE FROM __products_categories WHERE category_id in(?@)", $category->children);
                    $this->db->query($query);
                    $this->db->query("DELETE FROM __lang_categories WHERE category_id in(?@)", $category->children);
                }
            }
        }
        unset($this->categories_tree);
        unset($this->all_categories);
        return $id;
    }
    
    public function add_product_category($product_id, $category_id, $position=0) {
        $this->db->query("update __categories set last_modify=now() where id=?", intval($category_id));
        $query = $this->db->placehold("INSERT IGNORE INTO __products_categories SET product_id=?, category_id=?, position=?", $product_id, $category_id, $position);
        $this->db->query($query);
    }
    
    public function delete_product_category($product_id, $category_id) {
        $this->db->query("update __categories set last_modify=now() where id=?", intval($category_id));
        $query = $this->db->placehold("DELETE FROM __products_categories WHERE product_id=? AND category_id=? LIMIT 1", intval($product_id), intval($category_id));
        $this->db->query($query);
    }
    
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
                $lang_sql->fields
            FROM __categories c 
            $lang_sql->join 
            ORDER BY c.parent_id, c.position
        ");
        
        // Выбор категорий с подсчетом количества товаров для каждой. Может тормозить при большом количестве товаров.
        // $query = $this->db->placehold("SELECT c.id, c.parent_id, c.name, c.description, c.url, c.meta_title, c.meta_keywords, c.meta_description, c.image, c.visible, c.position, COUNT(p.id) as products_count
        //                               FROM __categories c LEFT JOIN __products_categories pc ON pc.category_id=c.id LEFT JOIN __products p ON p.id=pc.product_id AND p.visible GROUP BY c.id ORDER BY c.parent_id, c.position");
        
        
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
                
                // Добавляем количество товаров к родительской категории, если текущая видима
                // if(isset($pointers[$pointers[$id]->parent_id]) && $pointers[$id]->visible)
                //		$pointers[$pointers[$id]->parent_id]->products_count += $pointers[$id]->products_count;
            }
        }
        unset($pointers[0]);
        unset($ids);
        
        $this->categories_tree = $tree->subcategories;
        $this->all_categories = $pointers;
    }

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
