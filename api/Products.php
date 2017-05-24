<?php

require_once('Okay.php');

class Products extends Okay {
    
    private $all_brands = array();

    /*Выборка всех товаров*/
    public function get_products($filter = array()) {
        // По умолчанию
        $limit = 100;
        $page = 1;
        $category_id_filter = '';
        $brand_id_filter = '';
        $product_id_filter = '';
        $features_filter = '';
        $keyword_filter = '';
        $visible_filter = '';
        $is_featured_filter = '';
        $discounted_filter = '';
        $in_stock_filter = '';
        $has_images_filter = '';
        $feed_filter = '';
        $group_by = '';
        $order = 'p.position DESC';
        
        $lang_id  = $this->languages->lang_id();
        $px = ($lang_id ? 'l' : 'p');
        
        if(isset($filter['limit'])) {
            $limit = max(1, intval($filter['limit']));
        }
        
        if(isset($filter['page'])) {
            $page = max(1, intval($filter['page']));
        }
        
        $sql_limit = $this->db->placehold(' LIMIT ?, ? ', ($page-1)*$limit, $limit);
        
        if(!empty($filter['id'])) {
            $product_id_filter = $this->db->placehold('AND p.id in(?@)', (array)$filter['id']);
        }
        
        if(!empty($filter['category_id'])) {
            $category_id_filter = $this->db->placehold('INNER JOIN __products_categories pc ON pc.product_id = p.id AND pc.category_id in(?@)', (array)$filter['category_id']);
            $group_by = "GROUP BY p.id";
        }
        
        if(!empty($filter['brand_id'])) {
            $brand_id_filter = $this->db->placehold('AND p.brand_id in(?@)', (array)$filter['brand_id']);
        }
        
        if(isset($filter['featured'])) {
            $is_featured_filter = $this->db->placehold('AND p.featured=?', intval($filter['featured']));
        }
        
        if(isset($filter['discounted'])) {
            $discounted_filter = $this->db->placehold('AND (SELECT 1 FROM __variants pv WHERE pv.product_id=p.id AND pv.compare_price>0 LIMIT 1) = ?', intval($filter['discounted']));
        }
        
        if(isset($filter['in_stock'])) {
            $in_stock_filter = $this->db->placehold('AND (SELECT count(*)>0 FROM __variants pv WHERE pv.product_id=p.id AND (pv.stock IS NULL OR pv.stock>0) LIMIT 1) = ?', intval($filter['in_stock']));
        }

        if(isset($filter['has_images'])) {
            $has_images_filter = $this->db->placehold('AND (SELECT count(*)>0 FROM __images pi WHERE pi.product_id=p.id LIMIT 1) = ?', intval($filter['has_images']));
        }
        
        if(isset($filter['feed'])) {
            $feed_filter = $this->db->placehold('inner join __variants v on v.product_id=p.id and v.feed=?', intval($filter['feed']));
        }
        $price_filter = '';
        $variant_join = '';
        $currency_join = '';
        
        $first_currency = $this->money->get_currencies(array('enabled'=>1));
        $first_currency = reset($first_currency);
        $coef = 1;
        if(isset($_SESSION['currency_id']) && $first_currency->id != $_SESSION['currency_id']) {
            $currency = $this->money->get_currency(intval($_SESSION['currency_id']));
            $coef = $currency->rate_from / $currency->rate_to;
        }
        if(isset($filter['price'])) {
            if(isset($filter['price']['min'])) {
                $price_filter .= $this->db->placehold(" AND floor(IF(pv.currency_id=0 OR c.id is null,pv.price, pv.price*c.rate_to/c.rate_from)*$coef)>= ? ", $this->db->escape(trim($filter['price']['min'])));
            }
            if(isset($filter['price']['max'])) {
                $price_filter .= $this->db->placehold(" AND floor(IF(pv.currency_id=0 OR c.id is null,pv.price, pv.price*c.rate_to/c.rate_from)*$coef)<= ? ", $this->db->escape(trim($filter['price']['max'])));
            }
            $variant_join = 'LEFT JOIN __variants pv ON pv.product_id = p.id';
            $currency_join = 'LEFT JOIN __currencies c ON c.id=pv.currency_id';
        }
        
        if(isset($filter['visible'])) {
            $visible_filter = $this->db->placehold('AND p.visible=?', intval($filter['visible']));
        }
        
        if(!empty($filter['sort'])) {
            switch ($filter['sort']) {
                case 'position':
                    $order = 'p.position DESC';
                    break;
                case 'name':
                    $order = 'p.name ASC';
                    break;
                case 'name_desc':
                    $order = 'p.name DESC';
                    break;
                case 'rating':
                    $order = 'p.rating ASC';
                    break;
                case 'rating_desc':
                    $order = 'p.rating DESC';
                    break;
                case 'created':
                    $order = 'p.created DESC';
                    break;
                case 'price':
                    $order = "(SELECT -floor(IF(pv.currency_id=0 OR c.id is null,pv.price, pv.price*c.rate_to/c.rate_from)*$coef) 
                        FROM __variants pv 
                        LEFT JOIN __currencies c on c.id=pv.currency_id
                        WHERE 
                            p.id = pv.product_id 
                            AND pv.position=(SELECT MIN(position) 
                                FROM __variants 
                                WHERE 
                                    product_id=p.id LIMIT 1
                            ) 
                        LIMIT 1) DESC";
                    break;
                case 'price_desc':
                    $order = "(SELECT -floor(IF(pv.currency_id=0 OR c.id is null,pv.price, pv.price*c.rate_to/c.rate_from)*$coef)
                        FROM __variants pv
                        LEFT JOIN __currencies c on c.id=pv.currency_id
                        WHERE
                            p.id = pv.product_id
                            AND pv.position=(SELECT MIN(position)
                                FROM __variants
                                WHERE
                                    product_id=p.id LIMIT 1
                            )
                        LIMIT 1) ASC";
                    break;
            }
        }
        
        if(!empty($filter['keyword'])) {
            $keywords = explode(' ', $filter['keyword']);
            foreach($keywords as $keyword) {
                $kw = $this->db->escape(trim($keyword));
                if($kw!=='') {
                    $keyword_filter .= $this->db->placehold("AND (
                        $px.name LIKE '%$kw%' 
                        OR $px.meta_keywords LIKE '%$kw%' 
                        OR p.id in (SELECT product_id FROM __variants WHERE sku LIKE '%$kw%') 
                    ) ");
                }
            }
        }
        
        if(!empty($filter['features']) && !empty($filter['features'])) {
            foreach($filter['features'] as $feature=>$value) {
                $features_filter .= $this->db->placehold('AND p.id in (SELECT product_id FROM __options WHERE feature_id=? AND translit in(?@) ) ', $feature, (array)$value);
            }
        }
        
        $lang_sql = $this->languages->get_query(array('object'=>'product'));
        $query = "SELECT DISTINCT
                p.id,
                p.url,
                p.brand_id,
                p.position,
                p.created as created,
                p.visible,
                p.featured,
                p.rating,
                p.votes,
                p.last_modify,
                $lang_sql->fields
            FROM __products p
            $lang_sql->join
            $category_id_filter
            $variant_join
            $currency_join
            $feed_filter
            WHERE
                1
                $product_id_filter
                $brand_id_filter
                $features_filter
                $keyword_filter
                $is_featured_filter
                $discounted_filter
                $in_stock_filter
                $has_images_filter
                $visible_filter
                $price_filter
                $group_by
            ORDER BY $order
            $sql_limit
        ";
        $this->db->query($query);
        $products = $this->db->results();
        
        // field brand translation
        /*if (empty($this->all_brands)) {
            foreach ($this->brands->get_brands() as $b) {
                $this->all_brands[$b->id] = $b;
            }
        }
        if (!empty($this->all_brands)) {
            foreach ($products as $p) {
                if (isset($this->all_brands[$p->brand_id])) {
                    $p->brand = $this->all_brands[$p->brand_id]->name;
                    $p->brand_url = $this->all_brands[$p->brand_id]->url;
                }
            }
        }*/
        return $products;
    }

    /*Подсчет количества товаров*/
    public function count_products($filter = array()) {
        $category_id_filter = '';
        $brand_id_filter = '';
        $product_id_filter = '';
        $keyword_filter = '';
        $visible_filter = '';
        $is_featured_filter = '';
        $in_stock_filter = '';
        $has_images_filter = '';
        $feed_filter = '';
        $discounted_filter = '';
        $features_filter = '';
        
        $lang_id  = $this->languages->lang_id();
        $px = ($lang_id ? 'l' : 'p');
        
        if(!empty($filter['category_id'])) {
            $category_id_filter = $this->db->placehold('INNER JOIN __products_categories pc ON pc.product_id = p.id AND pc.category_id in(?@)', (array)$filter['category_id']);
        }
        
        if(!empty($filter['brand_id'])) {
            $brand_id_filter = $this->db->placehold('AND p.brand_id in(?@)', (array)$filter['brand_id']);
        }
        
        if(!empty($filter['id'])) {
            $product_id_filter = $this->db->placehold('AND p.id in(?@)', (array)$filter['id']);
        }
        
        if(isset($filter['keyword'])) {
            $keywords = explode(' ', $filter['keyword']);
            foreach($keywords as $keyword) {
                $kw = $this->db->escape(trim($keyword));
                if($kw!=='') {
                    $keyword_filter .= $this->db->placehold("AND (
                        $px.name LIKE '%$kw%' 
                        OR $px.meta_keywords LIKE '%$kw%' 
                        OR p.id in (SELECT product_id FROM __variants WHERE sku LIKE '%$kw%') 
                    ) ");
                }
            }
        }
        
        if(isset($filter['featured'])) {
            $is_featured_filter = $this->db->placehold('AND p.featured=?', intval($filter['featured']));
        }
        
        if(isset($filter['in_stock'])) {
            $in_stock_filter = $this->db->placehold('AND (SELECT count(*)>0 FROM __variants pv WHERE pv.product_id=p.id AND (pv.stock IS NULL OR pv.stock>0) LIMIT 1) = ?', intval($filter['in_stock']));
        }

        if(isset($filter['has_images'])) {
            $has_images_filter = $this->db->placehold('AND (SELECT count(*)>0 FROM __images pi WHERE pi.product_id=p.id LIMIT 1) = ?', intval($filter['has_images']));
        }
        
        if(isset($filter['feed'])) {
            $feed_filter = $this->db->placehold('inner join __variants v on v.product_id=p.id and v.feed=?', intval($filter['feed']));
        }
        $price_filter = '';
        $variant_join = '';
        $select = 'count(distinct p.id) as count';
        $currency_join = '';
        
        $first_currency = $this->money->get_currencies(array('enabled'=>1));
        $first_currency = reset($first_currency);
        $coef = 1;
        if(isset($_SESSION['currency_id']) && $first_currency->id != $_SESSION['currency_id']) {
            $currency = $this->money->get_currency(intval($_SESSION['currency_id']));
            $coef = $currency->rate_from / $currency->rate_to;
        }
        if(isset($filter['get_price'])) {
            $variant_join = 'LEFT JOIN __variants pv ON pv.product_id = p.id';
            $currency_join = 'LEFT JOIN __currencies c ON c.id=pv.currency_id';
            $select = "
                floor(min(IF(pv.currency_id=0 OR c.id is null,pv.price, pv.price*c.rate_to/c.rate_from)*$coef)) as min,
                floor(max(IF(pv.currency_id=0 OR c.id is null,pv.price, pv.price*c.rate_to/c.rate_from)*$coef)) as max
            ";
        } elseif(isset($filter['price'])) {
            if(isset($filter['price']['min'])) {
                $price_filter .= $this->db->placehold(" AND floor(IF(pv.currency_id=0 OR c.id is null,pv.price, pv.price*c.rate_to/c.rate_from)*$coef)>= ? ", $this->db->escape(trim($filter['price']['min'])));
            }
            if(isset($filter['price']['max'])) {
                $price_filter .= $this->db->placehold(" AND floor(IF(pv.currency_id=0 OR c.id is null,pv.price, pv.price*c.rate_to/c.rate_from)*$coef)<= ? ", $this->db->escape(trim($filter['price']['max'])));
            }
            $variant_join = 'LEFT JOIN __variants pv ON pv.product_id = p.id';
            $currency_join = 'LEFT JOIN __currencies c ON c.id=pv.currency_id';
        }
        
        if(isset($filter['discounted'])) {
            $discounted_filter = $this->db->placehold('AND (SELECT 1 FROM __variants pv WHERE pv.product_id=p.id AND pv.compare_price>0 LIMIT 1) = ?', intval($filter['discounted']));
        }
        
        if(isset($filter['visible'])) {
            $visible_filter = $this->db->placehold('AND p.visible=?', intval($filter['visible']));
        }
        
        if(!empty($filter['features']) && !empty($filter['features'])) {
            foreach($filter['features'] as $feature=>$value) {
                $features_filter .= $this->db->placehold('AND p.id in (SELECT product_id FROM __options WHERE feature_id=? AND translit in(?@) ) ', $feature, (array)$value);
            }
        }
        
        $lang_sql = $this->languages->get_query(array('object'=>'product'));
        $query = "SELECT $select
            FROM __products AS p
            $lang_sql->join
            $category_id_filter
            $feed_filter
            $variant_join
            $currency_join
            WHERE 
                1
                $brand_id_filter
                $product_id_filter
                $keyword_filter
                $is_featured_filter
                $in_stock_filter
                $has_images_filter
                $discounted_filter
                $visible_filter
                $features_filter
                $price_filter
        ";
        $this->db->query($query);
        if(isset($filter['get_price'])) {
            return $this->db->result();
        } else {
            return $this->db->result('count');
        }
    }

    /*Выборка конкретного товара*/
    public function get_product($id) {
        if (empty($id)) {
            return false;
        }
        if(is_int($id)) {
            $filter = $this->db->placehold('AND p.id = ?', $id);
        } else {
            $filter = $this->db->placehold('AND p.url = ?', $id);
        }
        
        $lang_sql = $this->languages->get_query(array('object'=>'product'));
        $query = "SELECT DISTINCT
                p.id,
                p.url,
                p.brand_id,
                p.position,
                p.created as created,
                p.visible,
                p.featured,
                p.rating,
                p.votes,
                p.last_modify,
                $lang_sql->fields
            FROM __products AS p
            $lang_sql->join
            WHERE 
                1 
                $filter
            GROUP BY p.id
            LIMIT 1
        ";
        $this->db->query($query);
        $product = $this->db->result();
        return $product;
    }

    /*Обновление товара*/
    public function update_product($id, $product) {
        $product = (object)$product;
        $result = $this->languages->get_description($product, 'product');
        
        $product->last_modify = date("Y-m-d H:i:s");
        $query = $this->db->placehold("UPDATE __products SET ?% WHERE id in (?@) LIMIT ?", $product, (array)$id, count((array)$id));
        if($this->db->query($query)) {
            if(!empty($result->description)) {
                $this->languages->action_description($id, $result->description, 'product', $this->languages->lang_id());
            }
            return $id;
        } else {
            return false;
        }
    }

    /*Добавление товара*/
    public function add_product($product) {
        $product = (array) $product;
        if(empty($product['url'])) {
            $product['url'] = preg_replace("/[\s]+/ui", '-', $product['name']);
            $product['url'] = strtolower(preg_replace("/[^0-9a-zа-я\-]+/ui", '', $product['url']));
        }
        
        // Если есть товар с таким URL, добавляем к нему число
        while($this->get_product((string)$product['url'])) {
            if(preg_match('/(.+)_([0-9]+)$/', $product['url'], $parts)) {
                $product['url'] = $parts[1].'_'.($parts[2]+1);
            } else {
                $product['url'] = $product['url'].'_2';
            }
        }
        
        $product = (object)$product;
        $result = $this->languages->get_description($product, 'product');
        
        $product->last_modify = date("Y-m-d H:i:s");
        if($this->db->query("INSERT INTO __products SET ?%", $product)) {
            $id = $this->db->insert_id();
            $this->db->query("UPDATE __products SET position=id WHERE id=?", $id);
            
            if(!empty($result->description)) {
                $this->languages->action_description($id, $result->description, 'product');
            }
            return $id;
        } else {
            return false;
        }
    }

    /*Удаление товара*/
    public function delete_product($id) {
        if(!empty($id)) {
            // Удаляем варианты
            $variants = $this->variants->get_variants(array('product_id'=>$id));
            foreach($variants as $v) {
                $this->variants->delete_variant($v->id);
            }
            
            // Удаляем изображения
            $images = $this->get_images(array('product_id'=>$id));
            foreach($images as $i) {
                $this->delete_image($i->id);
            }
            
            // Удаляем категории
            $categories = $this->categories->get_categories(array('product_id'=>$id));
            foreach($categories as $c) {
                $this->categories->delete_product_category($id, $c->id);
            }
            
            // Удаляем свойства
            $options = $this->features->get_options(array('product_id'=>$id));
            foreach($options as $o) {
                $this->features->delete_option($id, $o->feature_id);
            }
            
            // Удаляем связанные товары
            $related = $this->get_related_products($id);
            foreach($related as $r) {
                $this->delete_related_product($id, $r->related_id);
            }
            
            // Удаляем товар из связанных с другими
            $query = $this->db->placehold("DELETE FROM __related_products WHERE related_id=?", intval($id));
            $this->db->query($query);
            
            // Удаляем отзывы
            $comments = $this->comments->get_comments(array('object_id'=>$id, 'type'=>'product'));
            foreach($comments as $c) {
                $this->comments->delete_comment($c->id);
            }
            
            // Удаляем из покупок
            $this->db->query('UPDATE __purchases SET product_id=NULL WHERE product_id=?', intval($id));
            
            //lastModify
            $this->db->query('select brand_id from __products where id=?', intval($id));
            $bid = (int)$this->db->result('brand_id');
            if ($bid) {
                $this->db->query('update __brands set last_modify=now() where id=?', $bid);
            }
            
            // Удаляем языки
            $query = $this->db->placehold("DELETE FROM __lang_products WHERE product_id=?", intval($id));
            $this->db->query($query);
            
            // Удаляем товар
            $query = $this->db->placehold("DELETE FROM __products WHERE id=? LIMIT 1", intval($id));
            if($this->db->query($query)) {
                return true;
            }
        }
        return false;
    }

    /*Дублирование товара*/
    public function duplicate_product($id) {
        $product = $this->get_product($id);
        $product->id = null;
        $product->external_id = '';
        unset($product->created);
        
        // Сдвигаем товары вперед и вставляем копию на соседнюю позицию
        $this->db->query('UPDATE __products SET position=position+1 WHERE position>?', $product->position);
        $new_id = $this->products->add_product($product);
        $this->db->query('UPDATE __products SET position=? WHERE id=?', $product->position+1, $new_id);
        
        //lastModify
        if ($product->brand_id > 0) {
            $this->db->query('update __brands set last_modify=now() where id=?', intval($product->brand_id));
        }
        
        // Очищаем url
        $this->db->query('UPDATE __products SET url="" WHERE id=?', $new_id);
        
        // Дублируем категории
        $categories = $this->categories->get_product_categories($id);
        foreach($categories as $i=>$c) {
            $this->categories->add_product_category($new_id, $c->category_id, $i);
        }
        
        // Дублируем изображения
        $images = $this->get_images(array('product_id'=>$id));
        foreach($images as $image) {
            $this->add_image($new_id, $image->filename);
        }
        
        // Дублируем варианты
        $variants = $this->variants->get_variants(array('product_id'=>$id));
        foreach($variants as $variant) {
            $variant->product_id = $new_id;
            unset($variant->id);
            if($variant->infinity) {
                $variant->stock = null;
            }
            unset($variant->infinity);
            unset($variant->rate_from);unset($variant->rate_to);
            $variant->external_id = '';
            $this->variants->add_variant($variant);
        }
        
        // Дублируем свойства
        $options = $this->features->get_options(array('product_id'=>$id));
        foreach($options as $o) {
            $this->features->update_option($new_id, $o->feature_id, $o->value);
        }
        
        // Дублируем связанные товары
        $related = $this->get_related_products($id);
        foreach($related as $r) {
            $this->add_related_product($new_id, $r->related_id);
        }
        
        $this->multi_duplicate_product($id, $new_id);
        return $new_id;
    }

    /*Выборка связанных товаров*/
    public function get_related_products($product_id = array()) {
        if(empty($product_id)) {
            return array();
        }
        
        $product_id_filter = $this->db->placehold('AND product_id in(?@)', (array)$product_id);
        
        $query = $this->db->placehold("SELECT 
                product_id, 
                related_id, 
                position
            FROM __related_products
            WHERE
                1
                $product_id_filter
            ORDER BY position
        ");
        $this->db->query($query);
        return $this->db->results();
    }

    /*Добавление связанных товаров*/
    public function add_related_product($product_id, $related_id, $position=0) {
        $query = $this->db->placehold("INSERT IGNORE INTO __related_products SET product_id=?, related_id=?, position=?", $product_id, $related_id, $position);
        $this->db->query($query);
        return $related_id;
    }

    /*Удаление связанных товаров*/
    public function delete_related_product($product_id, $related_id) {
        $query = $this->db->placehold("DELETE FROM __related_products WHERE product_id=? AND related_id=? LIMIT 1", intval($product_id), intval($related_id));
        $this->db->query($query);
    }

    /*Выборка изображений товаров*/
    public function get_images($filter = array()) {
        $product_id_filter = '';
        if(!empty($filter['product_id'])) {
            $product_id_filter = $this->db->placehold('AND i.product_id in(?@)', (array)$filter['product_id']);
        }
        
        // images
        $query = $this->db->placehold("SELECT 
                i.id, 
                i.product_id, 
                i.name, 
                i.filename, 
                i.position
            FROM __images AS i 
            WHERE 
                1 
                $product_id_filter 
            ORDER BY i.product_id, i.position
        ");
        $this->db->query($query);
        return $this->db->results();
    }

    /*Добавление изображений товаров*/
    public function add_image($product_id, $filename, $name = '') {
        $query = $this->db->placehold("SELECT id FROM __images WHERE product_id=? AND filename=?", $product_id, $filename);
        $this->db->query($query);
        $id = $this->db->result('id');
        if(empty($id)) {
            $query = $this->db->placehold("INSERT INTO __images SET product_id=?, filename=?", $product_id, $filename);
            $this->db->query($query);
            $id = $this->db->insert_id();
            $query = $this->db->placehold("UPDATE __images SET position=id WHERE id=?", $id);
            $this->db->query($query);
        }
        return($id);
    }

    /*Обновление изображений*/
    public function update_image($id, $image) {
        $query = $this->db->placehold("UPDATE __images SET ?% WHERE id=?", $image, $id);
        $this->db->query($query);
        return($id);
    }

    /*Удаление изображений*/
    public function delete_image($id) {
        $query = $this->db->placehold("SELECT filename FROM __images WHERE id=?", $id);
        $this->db->query($query);
        $filename = $this->db->result('filename');
        $query = $this->db->placehold("DELETE FROM __images WHERE id=? LIMIT 1", $id);
        $this->db->query($query);
        $query = $this->db->placehold("SELECT count(*) as count FROM __images WHERE filename=? LIMIT 1", $filename);
        $this->db->query($query);
        $count = $this->db->result('count');
        if($count == 0) {
            $file = pathinfo($filename, PATHINFO_FILENAME);
            $ext = pathinfo($filename, PATHINFO_EXTENSION);
            
            // Удалить все ресайзы
            $rezised_images = glob($this->config->root_dir.$this->config->resized_images_dir.$file.".*x*.".$ext);
            if(is_array($rezised_images)) {
                foreach ($rezised_images as $f) {
                    @unlink($f);
                }
            }
            
            @unlink($this->config->root_dir.$this->config->original_images_dir.$filename);
        }
    }

    /*Выборка "соседних" товаров*/
    public function get_neighbors_products($category_id, $position) {
        $pids = array();
        // следующий товар
        $query = $this->db->placehold("SELECT id FROM __products p, __products_categories pc
            WHERE
                pc.product_id=p.id AND p.position>?
                AND pc.position=(SELECT MIN(pc2.position) FROM __products_categories pc2 WHERE pc.product_id=pc2.product_id)
                AND pc.category_id=?
                AND p.visible
            ORDER BY p.position
            limit 1
        ", $position, $category_id);
        $this->db->query($query);
        $pid = $this->db->result('id');
        if ($pid) {
            $pids[$pid] = 'prev';
        }
        // предыдущий товар
        $query = $this->db->placehold("SELECT id FROM __products p, __products_categories pc
            WHERE
                pc.product_id=p.id AND p.position<?
                AND pc.position=(SELECT MIN(pc2.position) FROM __products_categories pc2 WHERE pc.product_id=pc2.product_id)
                AND pc.category_id=?
                AND p.visible
            ORDER BY p.position DESC
            limit 1
        ", $position, $category_id);
        $this->db->query($query);
        $pid = $this->db->result('id');
        if ($pid) {
            $pids[$pid] = 'next';
        }

        $result = array('next'=>'', 'prev'=>'');
        if (!empty($pids)) {
            foreach ($this->get_products(array('id'=>array_keys($pids))) as $p) {
                $result[$pids[$p->id]] = $p;
            }
        }
        return $result;
    }

    /*Дублирование мультиязычного контента товара*/
    public function multi_duplicate_product($id, $new_id) {
        $lang_id = $this->languages->lang_id();
        if (!empty($lang_id)) {
            $languages = $this->languages->get_languages();
            $prd_fields = $this->languages->get_fields('products');
            $variant_fields = $this->languages->get_fields('variants');
            foreach ($languages as $language) {
                if ($language->id != $lang_id) {
                    $this->languages->set_lang_id($language->id);
                    //Product
                    if (!empty($prd_fields)) {
                        $old_prd = $this->get_product($id);
                        $upd_prd = new stdClass();
                        foreach($prd_fields as $field) {
                            $upd_prd->{$field} = $old_prd->{$field};
                        }
                        $this->update_product($new_id, $upd_prd);
                    }
                    
                    // Дублируем варианты
                    if (!empty($variant_fields)) {
                        $variants = $this->variants->get_variants(array('product_id'=>$new_id));
                        $old_variants = $this->variants->get_variants(array('product_id'=>$id));
                        foreach($old_variants as $i=>$old_variant) {
                            $upd_variant = new stdClass();
                            foreach ($variant_fields as $field) {
                                $upd_variant->{$field} = $old_variant->{$field};
                            }
                            $this->variants->update_variant($variants[$i]->id, $upd_variant);
                        }
                    }
                    
                    // Дублируем свойства
                    $options = $this->features->get_options(array('product_id'=>$id));
                    foreach($options as $o) {
                        $this->features->update_option($new_id, $o->feature_id, $o->value);
                    }
                    
                    $this->languages->set_lang_id($lang_id);
                }
            }
        }
    }

    /*Выборка промо-изображений*/
    public function get_spec_images() {
        $query = $this->db->placehold("SELECT id, filename, position FROM __spec_img ORDER BY position ASC");
        $this->db->query($query);
        $res = $this->db->results();
        if(!empty($res)){
            return $res;
        } else {
            return array();
        }
    }

    /*Удаление промо-изображений*/
    public function delete_spec_image($image_id) {
        if(empty($image_id)){
            return false;
        }
        $query = $this->db->placehold("SELECT filename FROM __spec_img WHERE id =?", intval($image_id));
        $this->db->query($query);
        $filename = $this->db->result('filename');
        unlink($this->config->root_dir.$this->config->special_images_dir.$filename);
        $this->db->query("DELETE FROM __spec_img WHERE id=? LIMIT 1", intval($image_id));
        $this->db->query("UPDATE __products SET special=NULL WHERE special=?", $filename);
        $this->db->query("UPDATE __lang_products SET special=NULL WHERE special=?", $filename);
        return true;
    }

    /*Обновление промо-изображений*/
    public function update_spec_images($id, $spec_image){
        if(empty($id) || empty($spec_image)){
            return false;
        }
        $spec_image = (array)$spec_image;
        $query = $this->db->placehold("UPDATE __spec_img SET ?% WHERE id=?", $spec_image, $id);
        $this->db->query($query);
        return $id;
    }

    /*Добавление промо-изображений*/
    public function add_spec_image($image) {
        if(empty($image)){
            return false;
        }
        $query = $this->db->query("INSERT INTO __spec_img SET filename = ?", $image);
        $this->db->query($query);
        $id = $this->db->insert_id();
        $this->db->query("UPDATE __spec_img SET position=id WHERE id=?", $id);
        return $id;
    }

}
