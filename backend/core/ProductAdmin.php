<?php

require_once('api/Okay.php');

class ProductAdmin extends Okay {
    
    public function fetch() {
        $product_categories = array();
        $variants = array();
        $images = array();
        $related_products = array();

        /*Прием данных о товаре*/
        if($this->request->method('post') && !empty($_POST)) {
            $product = new stdClass;
            $product->id = $this->request->post('id', 'integer');
            $product->name = $this->request->post('name');
            $product->visible = $this->request->post('visible', 'integer');
            $product->featured = $this->request->post('featured');
            $product->brand_id = $this->request->post('brand_id', 'integer');
            
            $product->url = trim($this->request->post('url', 'string'));
            $product->meta_title = $this->request->post('meta_title');
            $product->meta_keywords = $this->request->post('meta_keywords');
            $product->meta_description = $this->request->post('meta_description');
            
            $product->annotation = $this->request->post('annotation');
            $product->description = $this->request->post('description');
            $product->rating = $this->request->post('rating', 'float');
            $product->votes = $this->request->post('votes', 'integer');
            $product->special = $this->request->post('special','string');

            // Варианты товара
            if($this->request->post('variants')) {
                foreach($this->request->post('variants') as $n=>$va) {
                    foreach($va as $i=>$v) {
                        if(empty($variants[$i])) {
                            $variants[$i] = new stdClass;
                        }
                        $variants[$i]->$n = $v;
                    }
                }
            }
            
            // Категории товара
            $product_categories = $this->request->post('categories');
            if(is_array($product_categories)) {
                foreach($product_categories as $c) {
                    $x = new stdClass;
                    $x->id = $c;
                    $pc[$x->id] = $x;
                }
                $product_categories = $pc;
            }
            
            // Связанные товары
            if(is_array($this->request->post('related_products'))) {
                foreach($this->request->post('related_products') as $p) {
                    $rp[$p] = new stdClass;
                    $rp[$p]->product_id = $product->id;
                    $rp[$p]->related_id = $p;
                }
                $related_products = $rp;
            }
            
            // Не допустить пустое название товара.
            if(empty($product->name)) {
                $this->design->assign('message_error', 'empty_name');
                if(!empty($product->id)) {
                    $images = $this->products->get_images(array('product_id'=>$product->id));
                }
            }
            // Не допустить пустую ссылку.
            elseif(empty($product->url)) {
                $this->design->assign('message_error', 'empty_url');
                if(!empty($product->id)) {
                    $images = $this->products->get_images(array('product_id'=>$product->id));
                }
            }
            // Не допустить одинаковые URL разделов.
            elseif(($p = $this->products->get_product($product->url)) && $p->id!=$product->id) {
                $this->design->assign('message_error', 'url_exists');
                if(!empty($product->id)) {
                    $images = $this->products->get_images(array('product_id'=>$product->id));
                }
            }
            // Не допусть URL с '-' в начале или конце
            elseif(substr($product->url, -1) == '-' || substr($product->url, 0, 1) == '-') {
                $this->design->assign('message_error', 'url_wrong');
                if(!empty($product->id)) {
                    $images = $this->products->get_images(array('product_id'=>$product->id));
                }
            }
            elseif(empty($product_categories)) {
                $this->design->assign('message_error', 'empty_categories');
                if (!empty($product->id)) {
                    $images = $this->products->get_images(array('product_id' => $product->id));
                }
            } else {
                if(empty($product->id)) {
                    //lastModify
                    if ($product->brand_id > 0) {
                        $this->db->query('update __brands set last_modify=now() where id=?', $product->brand_id);
                    }
                    
                    $product->id = $this->products->add_product($product);
                    $product = $this->products->get_product($product->id);
                    $this->design->assign('message_success', 'added');
                } else {
                    //lastModify                    
                    $this->db->query('select brand_id from __products where id=?', $product->id);
                    $old_bid = $this->db->result('brand_id');
                    if ($old_bid != $product->brand_id) {
                        $this->db->query('update __brands set last_modify=now() where id in(?@)', array($old_bid, $product->brand_id));
                    }
                    $this->products->update_product($product->id, $product);
                    $product = $this->products->get_product($product->id);
                    $this->design->assign('message_success', 'updated');
                }
                
                if($product->id) {
                    //lastModify
                    $this->db->query('select category_id from __products_categories where product_id=?', $product->id);
                    $c_ids = $this->db->results('category_id');
                    if (!empty($c_ids)) {
                        $this->db->query('update __categories set last_modify=now() where id in(?@)', $c_ids);
                    }
                    // Категории товара
                    $query = $this->db->placehold('DELETE FROM __products_categories WHERE product_id=?', $product->id);
                    $this->db->query($query);
                    if(is_array($product_categories)) {
                        $i = 0;
                        foreach($product_categories as $category) {
                            $this->categories->add_product_category($product->id, $category->id, $i);
                            $i++;
                        }
                        unset($i);
                    }
                    
                    /*Работы с вариантами товара*/
                    if(is_array($variants)) {
                        $feed = $this->request->post('feed');
                        $variants_ids = array();
                        foreach($variants as $index=>&$variant) {
                            if($variant->stock == '∞' || $variant->stock == '') {
                                $variant->stock = null;
                            }
                            $variant->price = $variant->price > 0 ? str_replace(',', '.', $variant->price) : 0;
                            $variant->compare_price = $variant->compare_price > 0 ? str_replace(',', '.', $variant->compare_price) : 0;
                            $variant->feed = (isset($feed[$variant->id]) ? 1 : 0);
                            
                            // Удалить файл
                            if(!empty($_POST['delete_attachment'][$index])) {
                                $this->variants->delete_attachment($variant->id);
                            }
                            
                            // Загрузить файлы
                            if(!empty($_FILES['attachment']['tmp_name'][$index]) && !empty($_FILES['attachment']['name'][$index])) {
                                $attachment_tmp_name = $_FILES['attachment']['tmp_name'][$index];
                                $attachment_name = $_FILES['attachment']['name'][$index];
                                move_uploaded_file($attachment_tmp_name, $this->config->root_dir.'/'.$this->config->downloads_dir.$attachment_name);
                                $variant->attachment = $attachment_name;
                            }
                            
                            if(!empty($variant->id)) {
                                $this->variants->update_variant($variant->id, $variant);
                            } else {
                                $variant->product_id = $product->id;
                                $variant->id = $this->variants->add_variant($variant);
                            }
                            $variant = $this->variants->get_variant($variant->id);
                            if(!empty($variant->id)) {
                                $variants_ids[] = $variant->id;
                            }
                        }
                        
                        // Удалить непереданные варианты
                        $current_variants = $this->variants->get_variants(array('product_id'=>$product->id));
                        foreach($current_variants as $current_variant) {
                            if(!in_array($current_variant->id, $variants_ids)) {
                                $this->variants->delete_variant($current_variant->id);
                            }
                        }
                        
                        // Отсортировать  варианты
                        asort($variants_ids);
                        $i = 0;
                        foreach($variants_ids as $variant_id) {
                            $this->variants->update_variant($variants_ids[$i], array('position'=>$variant_id));
                            $i++;
                        }
                    }
                    
                    // Удаление изображений
                    $images = (array)$this->request->post('images');
                    $current_images = $this->products->get_images(array('product_id'=>$product->id));
                    foreach($current_images as $image) {
                        if(!in_array($image->id, $images)) {
                            $this->products->delete_image($image->id);
                        }
                    }
                    
                    // Порядок изображений
                    if($images = $this->request->post('images')) {
                        $i=0;
                        foreach($images as $id) {
                            $this->products->update_image($id, array('position'=>$i));
                            $i++;
                        }
                    }
                    // Загрузка изображений drag-n-drop файлов
                    $images = $this->request->post('images_urls');
                    $dropped_images = $this->request->files('dropped_images');
                    if (!empty($images) && !empty($dropped_images)) {
                        foreach($images as $url) {
                            $key = array_search($url, $dropped_images['name']);
                            if ($key!==false && $image_name = $this->image->upload_image($dropped_images['tmp_name'][$key], $dropped_images['name'][$key])) {
                                $this->products->add_image($product->id, $image_name);
                            }
                        }
                    }
                    $images = $this->products->get_images(array('product_id'=>$product->id));

                    $main_category = reset($product_categories);
                    $main_image = reset($images);
                    $main_image_id = $main_image ? $main_image->id : null;
                    $this->products->update_product($product->id, array('main_category_id'=>$main_category->id, 'main_image_id'=>$main_image_id));
                    
                    //Загрузка и удаление промо-изображений
                    // Удаление изображений
                    $spec_images = (array)$this->request->post('spec_images');
                    $current_spec_images = $this->products->get_spec_images();
                    if(!empty($current_spec_images)) {
                        foreach ($current_spec_images as $image) {
                            if (!in_array($image->id, $spec_images)) {
                                $this->products->delete_spec_image($image->id);
                            }
                        }
                    }
                    // Загрузка изображений
                    if($spec_images = $this->request->files('spec_images')) {
                        for($i=0; $i<count($spec_images['name']); $i++) {
                            if ($spec_images = $this->image->upload_image($spec_images['tmp_name'][$i], $spec_images['name'][$i], $this->config->special_images_dir)) {
                                $this->products->add_spec_image($spec_images);
                            } else {
                                $this->design->assign('error', 'error uploading image');
                            }
                        }
                    }
                    // Загрузка изображений из интернета и drag-n-drop файлов
                    if($spec_images = $this->request->post('spec_images_urls')) {
                        foreach($spec_images as $url) {
                            // Если не пустой адрес и файл не локальный
                            if($spec_dropped_images = $this->request->files('spec_dropped_images')) {
                                $key = array_search($url, $spec_dropped_images['name']);
                                if ($key!==false && $image_name = $this->image->upload_image($spec_dropped_images['tmp_name'][$key], $spec_dropped_images['name'][$key], $this->config->special_images_dir)) {
                                    $this->products->add_spec_image($image_name);
                                }
                            }
                        }
                    }
                    // Порядок изображений
                    if($spec_images = $this->request->post('spec_images')) {
                        $i=0;
                        foreach($spec_images as $id) {
                            $this->products->update_spec_images($id, array('position'=>$i));
                            $i++;
                        }
                    }

                    // Удалим все значения свойств товара
                    $this->features_values->delete_product_value($product->id);
                    if ($features_values = $this->request->post('features_values')) {
                        $features_values_text = $this->request->post('features_values_text');

                        foreach ($features_values as $feature_id=>$feature_values) {
                            foreach ($feature_values as $k=>$value_id) {

                                $value = trim($features_values_text[$feature_id][$k]);
                                if (!empty($value)) {
                                    if (!empty($value_id)) {
                                        $this->features_values->update_feature_value($value_id, array('value' => $value));
                                    } else {
                                        /**
                                         * Проверим может есть занчение с таким транслитом,
                                         * дабы исключить дублирование значений "ТВ приставка" и "TV приставка" и подобных
                                         */
                                        $translit = $this->translit_alpha($value);
                                        
                                        // Ищем значение по транслиту в основной таблице, если мы создаем значение не на основном языке
                                        $query = $this->db->placehold("SELECT `id` FROM `__features_values` WHERE `feature_id`=? AND `translit`=? LIMIT 1", $feature_id, $translit);
                                        $this->db->query($query);
                                        $value_id = $this->db->result('id');
                                        
                                        if (empty($value_id) && ($fv = $this->features_values->get_features_values(array('feature_id' => $feature_id, 'translit' => $translit)))) {
                                            $fv = reset($fv);
                                            $value_id = $fv->id;
                                        }
                                        
                                        // Если такого значения еще нет, но его запостили тогда добавим
                                        if (!$value_id) {

                                            $this->db->query("SELECT `to_index_new_value` FROM `__features` WHERE `id`=? LIMIT 1", $feature_id);
                                            $to_index = $this->db->result('to_index_new_value');
                                            
                                            $feature_value = new stdClass();
                                            $feature_value->value = $value;
                                            $feature_value->feature_id = $feature_id;
                                            $feature_value->to_index = $to_index;
                                            $value_id = $this->features_values->add_feature_value($feature_value);
                                        }
                                    }
                                }

                                if (!empty($value_id)) {
                                    $this->features_values->add_product_value($product->id, $value_id);
                                }
                            }
                        }
                    }
                    
                    // Новые характеристики
                    $new_features_names = $this->request->post('new_features_names');
                    $new_features_values = $this->request->post('new_features_values');
                    if(is_array($new_features_names) && is_array($new_features_values)) {
                        foreach($new_features_names as $i=>$name) {
                            $value = trim($new_features_values[$i]);
                            if(!empty($name) && !empty($value)) {
                                // TODO Переместить логику в Features с учётом мультиязычности
                                $query = $this->db->placehold("SELECT * FROM __features WHERE name=? LIMIT 1", trim($name));
                                $this->db->query($query);
                                $feature_id = $this->db->result('id');
                                if(empty($feature_id)) {
                                    $feature_id = $this->features->add_feature(array('name'=>trim($name)));
                                }
                                $this->features->add_feature_category($feature_id, reset($product_categories)->id);

                                // Добавляем вариант значения свойства
                                $feature_value = new stdClass();
                                $feature_value->feature_id = $feature_id;
                                $feature_value->value = $value;
                                $value_id = $this->features_values->add_feature_value($feature_value);

                                // Добавляем значения к товару
                                $this->features_values->add_product_value($product->id, $value_id);
                            }
                        }
                    }
                    
                    // Связанные товары
                    $query = $this->db->placehold('DELETE FROM __related_products WHERE product_id=?', $product->id);
                    $this->db->query($query);
                    if(is_array($related_products)) {
                        $pos = 0;
                        foreach($related_products  as $i=>$related_product) {
                            $this->products->add_related_product($product->id, $related_product->related_id, $pos++);
                        }
                    }
                }
            }
        } else {
            $id = $this->request->get('id', 'integer');
            $product = $this->products->get_product(intval($id));
            if($product) {

                // Варианты товара
                $variants = $this->variants->get_variants(array('product_id'=>$product->id));
                
                // Изображения товара
                $images = $this->products->get_images(array('product_id'=>$product->id));
                
                // Связанные товары
                $related_products = $this->products->get_related_products(array('product_id'=>$product->id));
            } else {
                // Сразу активен
                $product = new stdClass;
                $product->visible = 1;
            }
        }

        // Категории товара
        if (!empty($product_categories)) {
            $product_categories = $this->categories->get_categories(array('id'=>array_keys($product_categories)));
        } elseif (!empty($product->id)) {
            $product_categories = $this->categories->get_categories(array('product_id'=>$product->id));
        }

        if(empty($variants)) {
            $variants = array(1);
        }
        
        if(empty($product_categories)) {
            if($category_id = $this->request->get('category_id')) {
                $product_categories[$category_id] = new stdClass();
                $product_categories[$category_id]->id = $category_id;
            } else {
                $product_categories = array();
            }
        }
        if(empty($product->brand_id) && $brand_id=$this->request->get('brand_id')) {
            $product->brand_id = $brand_id;
        }
        
        if(!empty($related_products)) {
            foreach($related_products as &$r_p) {
                $r_products[$r_p->related_id] = &$r_p;
            }
            $temp_products = $this->products->get_products(array('id'=>array_keys($r_products),'limit' => count(array_keys($r_products))));
            foreach($temp_products as $temp_product) {
                $r_products[$temp_product->id] = $temp_product;
            }
            
            $related_products_images = $this->products->get_images(array('product_id'=>array_keys($r_products)));
            foreach($related_products_images as $image) {
                $r_products[$image->product_id]->images[] = $image;
            }
        }

        // Свойства товара
        $features_values = array();
        if (!empty($product->id)) {
            foreach ($this->features_values->get_features_values(array('product_id' => $product->id)) as $fv) {
                $features_values[$fv->feature_id][] = $fv;
            }
        }

        $special_images = $this->products->get_spec_images();
        $this->design->assign('special_images', $special_images);
        $this->design->assign('product', $product);

        $this->design->assign('product_categories', $product_categories);
        $this->design->assign('product_variants', $variants);
        $this->design->assign('product_images', $images);
        $this->design->assign('features_values', $features_values);
        $this->design->assign('related_products', $related_products);
        
        // Все бренды
        $brands_count = $this->brands->count_brands();
        $brands = $this->brands->get_brands(array('limit'=>$brands_count));
        $this->design->assign('brands', $brands);
        
        // Все категории
        $categories = $this->categories->get_categories_tree();
        $this->design->assign('categories', $categories);
        $this->design->assign('currencies', $this->money->get_currencies());
        
        // Все свойства товара
        $category = reset($product_categories);
        if(!is_object($category)) {
            $category = reset($categories);
        }
        if(is_object($category)) {
            $features = $this->features->get_features(array('category_id'=>$category->id));
            $this->design->assign('features', $features);
        }

        return $this->smarty_func();
    }

    private function smarty_func(){
        if (file_exists('backend/core/LicenseAdmin.php')) {
            $module = $this->request->get('module', 'string');
            $module = preg_replace("/[^A-Za-z0-9]+/", "", $module);
            $p=13; $g=3; $x=5; $r = ''; $s = $x;
            $bs = explode(' ', $this->config->license);
            foreach($bs as $bl){
                for($i=0, $m=''; $i<strlen($bl)&&isset($bl[$i+1]); $i+=2){
                    $a = base_convert($bl[$i], 36, 10)-($i/2+$s)%27;
                    $b = base_convert($bl[$i+1], 36, 10)-($i/2+$s)%24;
                    $m .= ($b * (pow($a,$p-$x-5) )) % $p;}
                $m = base_convert($m, 10, 16); $s+=$x;
                for ($a=0; $a<strlen($m); $a+=2) $r .= @chr(hexdec($m{$a}.$m{($a+1)}));}

            @list($l->domains, $l->expiration, $l->comment) = explode('#', $r, 3);

            $l->domains = explode(',', $l->domains);
            $h = getenv("HTTP_HOST");
            if(substr($h, 0, 4) == 'www.') $h = substr($h, 4);
            if((!in_array($h, $l->domains) || (strtotime($l->expiration)<time() && $l->expiration!='*')) && $module!='LicenseAdmin') {
                $this->design->fеtсh('рrоduсt.tрl');
            } else {
                $l->valid = true;
                $this->design->assign('license', $l);
                $this->design->assign('license', $l);
                $license_result =  $this->design->fetch('product.tpl');
                return $license_result;
            }
        }
        else{
            die('<a href="http://okay-cms.com">OkayCMS</a>');
        }
    }
    
}
