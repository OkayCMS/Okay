<?php

require_once('api/Import.php');

class ImportAjax extends Import {
    
    public function import() {
        if(!$this->managers->access('import')) {
            return false;
        }
        $fields = $_SESSION['csv_fields'];
        session_write_close();
        unset($_SESSION['lang_id']);
        unset($_SESSION['admin_lang_id']);
        
        // Для корректной работы установим локаль UTF-8
        setlocale(LC_ALL, $this->locale);
        
        $result = new stdClass();
        
        // Определяем колонки из первой строки файла
        $f = fopen($this->import_files_dir.$this->import_file, 'r');
        $this->columns = fgetcsv($f, null, $this->column_delimiter);
        
        $this->init_internal_columns($fields);

        // Если нет названия товара - не будем импортировать
        if (empty($fields) || !in_array('sku', $fields) && !in_array('name', $fields)) {
            return false;
        }

        // Переходим на заданную позицию, если импортируем не сначала
        if($from = $this->request->get('from')) {
            fseek($f, $from);
        } else {
            $this->db->query("TRUNCATE __import_log");
        }
        
        // Массив импортированных товаров
        $imported_items = array();
        
        // Проходимся по строкам, пока не конец файла
        // или пока не импортировано достаточно строк для одного запроса
        for($k=0; !feof($f) && $k<$this->products_count; $k++) {
            // Читаем строку
            $line = fgetcsv($f, 0, $this->column_delimiter);

            $product = null;
            if(is_array($line) && !empty($line)) {
                $i = 0;
                // Проходимся по колонкам строки
                foreach ($fields as $csv=>$inner) {
                    // Создаем массив item[название_колонки]=значение
                    if (isset($line[$i]) && !empty($inner)) {
                        $product[$inner] = $line[$i];
                    }
                    $i++;
                }
            }
            // Импортируем этот товар
            if($imported_item = $this->import_item($product)) {
                $imported_items[] = $imported_item;
            }
        }
        
        // Запоминаем на каком месте закончили импорт
        $from = ftell($f);
        
        // И закончили ли полностью весь файл
        $result->end = feof($f);
        
        fclose($f);
        $size = filesize($this->import_files_dir.$this->import_file);
        
        // Создаем объект результата
        $result->from = $from;          // На каком месте остановились
        $result->totalsize = $size;     // Размер всего файла
        foreach ($imported_items as $item) {
            $res = array(
                'product_id'    => $item->product->id,
                'status'        => $item->status,
                'product_name'  => $item->product->name,
                'variant_name'  => $item->variant->name
            );
            $this->db->query("INSERT INTO __import_log SET ?%", $res);
        }
        
        return $result;
    }
    
    // Импорт одного товара $item[column_name] = value;
    private function import_item($item) {
        $imported_item = new stdClass();
        
        // Проверим не пустое ли название и артинкул (должно быть хоть что-то из них)
        if (empty($item['sku']) && empty($item['name'])) {
            return false;
        }
        
        // Подготовим товар для добавления в базу
        $product = array();
        
        if (isset($item['name'])) {
            $product['name'] = trim($item['name']);
        }
        
        if (isset($item['meta_title'])) {
            $product['meta_title'] = trim($item['meta_title']);
        }
        
        if (isset($item['meta_keywords'])) {
            $product['meta_keywords'] = trim($item['meta_keywords']);
        }
        
        if (isset($item['meta_description'])) {
            $product['meta_description'] = trim($item['meta_description']);
        }
        
        if (isset($item['annotation'])) {
            $product['annotation'] = trim($item['annotation']);
        }
        
        if (isset($item['description'])) {
            $product['description'] = trim($item['description']);
        }
        
        if (isset($item['visible'])) {
            $product['visible'] = intval($item['visible']);
        }
        
        if (isset($item['featured'])) {
            $product['featured'] = intval($item['featured']);
        }
        
        if (!empty($item['url'])) {
            $product['url'] = trim($item['url']);
        }
        
        // Если задан бренд
        if (!empty($item['brand'])) {
            $item['brand'] = trim($item['brand']);
            // Найдем его по имени
            if ($this->languages->lang_id()) {
                $this->db->query("SELECT brand_id as id FROM __lang_brands WHERE name=? AND lang_id=?", $item['brand'], $this->languages->lang_id());
            } else {
                $this->db->query("SELECT id FROM __brands WHERE name=?", $item['brand']);
            }
            if (!$product['brand_id'] = $this->db->result('id')) {
                // Создадим, если не найден
                $product['brand_id'] = $this->brands->add_brand(array('name'=>$item['brand'], 'meta_title'=>$item['brand'], 'meta_keywords'=>$item['brand'], 'meta_description'=>$item['brand']));
            }
        }
        
        // Если задана категория
        $category_id = null;
        $categories_ids = array();
        if (!empty($item['category'])) {
            foreach (explode($this->category_delimiter, $item['category']) as $c) {
                $categories_ids[] = $this->import_category($c);
            }
            $category_id = reset($categories_ids);
        }
        
        // Подготовим вариант товара
        $variant = array();
        
        if (isset($item['variant'])) {
            $variant['name'] = trim($item['variant']);
        }

        if (isset($item['price'])) {
            $variant['price'] = str_replace(',', '.', str_replace(' ', '', trim($item['price'])));
        }
        
        if (isset($item['compare_price'])) {
            $variant['compare_price'] = str_replace(',', '.', str_replace(' ', '', trim($item['compare_price'])));
        }
        
        if (isset($item['stock'])) {
            if ($item['stock'] == '') {
                $variant['stock'] = null;
            } else {
                $variant['stock'] = trim($item['stock']);
            }
        }
        
        if (isset($item['sku'])) {
            $variant['sku'] = trim($item['sku']);
        }
        
        if (isset($item['currency'])) {
            $variant['currency_id'] = intval($item['currency']);
        }
        if (isset($item['weight'])) {
            $variant['weight'] = str_replace(',', '.', str_replace(' ', '', trim($item['weight'])));
        }

        if (isset($item['units'])) {
            $variant['units'] = $item['units'];
        }
        
        // Если задан артикул варианта, найдем этот вариант и соответствующий товар
        if (!empty($variant['sku'])) {
            $this->db->query('SELECT v.id as variant_id, v.product_id, p.url FROM __variants v, __products p WHERE v.sku=? AND v.product_id = p.id LIMIT 1', $variant['sku']);
            $result = $this->db->result();
            if ($result) {
                $product_id = $result->product_id;
                $variant_id = $result->variant_id;
                $imported_item->status = 'updated';
            } elseif (!empty($product['name'])) {
                // если по артикулу не нашли попробуем по названию(если он задано)
                $this->db->query('SELECT p.id as product_id, p.url FROM __products p WHERE p.name=? LIMIT 1', $product['name']);
                $result = $this->db->result();
                if ($result) {
                    $product_id = $result->product_id;
                    $imported_item->status = 'added';
                } else {
                    $imported_item->status = 'added';
                }
            }
        } else {
            // если нет артикула попробуем по названию товара
            $this->db->query('SELECT v.id as variant_id, p.id as product_id, p.url
                FROM __products p
                LEFT JOIN __variants v ON v.product_id=p.id AND v.name=?
                WHERE p.name=?
                LIMIT 1', isset($variant['name']) ? $variant['name'] : "", $product['name']);
            $result = $this->db->result();
            if ($result) {
                $product_id = $result->product_id;
                $variant_id = $result->variant_id;
                if (empty($variant_id)) {
                    $imported_item->status = 'added';
                } else {
                    $imported_item->status = 'updated';
                    unset($variant['sku']);
                }
            } else {
                $imported_item->status = 'added';
            }
        }

        /* Какую ф-ию обновления значений св-тв вызывать:
         * если это новый товар то нужно значения добавить во все языки
         * иначе - только для текущего - вызываем старую добрую update_option()
        */
        $update_option_function = "update_option";
        if (isset($imported_item->status)) {
            if (!empty($product)) {
                if (!isset($product['url']) && !empty($product['name']) && empty($result->url)) {
                    $product['url'] = $this->translit($product['name']);
                }
                if (empty($product_id)) {
                    $product_id = $this->products->add_product($product);
                    $update_option_function = "update_option_all_languages";
                } else {
                    $this->products->update_product($product_id, $product);
                }
            }

            if (empty($variant_id) && !empty($product_id)) {
                $this->db->query('SELECT max(v.position) as pos FROM __variants v WHERE v.product_id=? LIMIT 1', $product_id);
                $pos =  $this->db->result('pos');
                $variant['position'] = $pos+1;
                $variant['product_id'] = $product_id;
                if (!isset($variant['currency_id'])) {
                    $currency = $this->money->get_currency();
                    $variant['currency_id'] = $currency->id;
                }

                // нужно хотяб одно поле из переводов
                $fields = $this->languages->get_fields('variants');
                $tm = array_intersect(array_keys($variant), $fields);
                if (empty($tm) && !empty($fields)) {
                    $variant[$fields[0]] = "";
                }

                $variant_id = $this->variants->add_variant($variant);
            } elseif (!empty($variant_id) && !empty($variant)) {
                $this->variants->update_variant($variant_id, $variant);
            }
        }

        if(!empty($variant_id) && !empty($product_id)) {
            // Нужно вернуть обновленный товар
            $imported_item->variant = $this->variants->get_variant(intval($variant_id));
            $imported_item->product = $this->products->get_product(intval($product_id));
            
            // Добавляем категории к товару
            $this->db->query("SELECT MAX(position) as pos FROM __products_categories WHERE product_id=?", $product_id);
            $pos = $this->db->result('pos');
            $pos = $pos === false ? 0 : $pos+1;
            if(!empty($categories_ids)) {
                foreach($categories_ids as $c_id) {
                    $this->categories->add_product_category($product_id, $c_id, $pos++);
                }
            }
            
            // Изображения товаров
            $images_ids = array();
            if(isset($item['images'])) {
                // Изображений может быть несколько, через запятую
                $images = explode(',', $item['images']);
                foreach($images as $image) {
                    $image = trim($image);
                    if(!empty($image)) {
                        // Имя файла
                        $image_filename = pathinfo($image, PATHINFO_BASENAME);
                        
                        // Добавляем изображение только если такого еще нет в этом товаре
                        $this->db->query('SELECT id, filename FROM __images WHERE product_id=? AND (filename=? OR filename=?) LIMIT 1', $product_id, $image_filename, $image);
                        $result = $this->db->result();
                        if(!$result->filename) {
                            $images_ids[] = $this->products->add_image($product_id, $image);
                        } else {
                            $images_ids[] = $result->id;
                        }
                    }
                }
            }
            
            $main_image = reset($images_ids);
            $main_image_id = $main_image ? $main_image : null;
            $this->products->update_product($product_id, array('main_category_id'=>$category_id, 'main_image_id'=>$main_image_id));
            
            // Характеристики товаров
            foreach($item as $feature_name=>$feature_value) {
                // Если нет такого названия колонки, значит это название свойства
                if(!in_array($feature_name, $this->internal_columns_names)) {
                    // Свойство добавляем только если для товара указана категория и непустое значение свойства
                    if($category_id && $feature_value!=='') {
                        $this->db->query('SELECT f.id FROM __features f WHERE f.name=? LIMIT 1', $feature_name);
                        if(!$feature_id = $this->db->result('id')) {
                            $feature_id = $this->features->add_feature(array('name'=>$feature_name));
                        }
                        
                        $this->features->add_feature_category($feature_id, $category_id);
                        $this->features->{$update_option_function}($product_id, $feature_id, $feature_value);
                    }
                }
            }
            return $imported_item;
        }
    }
    
    // Отдельная функция для импорта категории
    private function import_category($category) {
        // Поле "категория" может состоять из нескольких имен, разделенных subcategory_delimiter-ом
        // Только неэкранированный subcategory_delimiter может разделять категории
        $delimiter = $this->subcategory_delimiter;
        $regex = "/\\DELIMITER((?:[^\\\\\DELIMITER]|\\\\.)*)/";
        $regex = str_replace('DELIMITER', $delimiter, $regex);
        $names = preg_split($regex, $category, 0, PREG_SPLIT_DELIM_CAPTURE);
        $id = null;
        $parent = 0;
        
        // Для каждой категории
        foreach($names as $name) {
            // Заменяем \/ на /
            $name = trim(str_replace("\\$delimiter", $delimiter, $name));
            if(!empty($name)) {
                // Найдем категорию по имени
                $this->db->query('SELECT id FROM __categories WHERE name=? AND parent_id=?', $name, $parent);
                $id = $this->db->result('id');
                
                // Если не найдена - добавим ее
                if(empty($id)) {
                    $id = $this->categories->add_category(array('name'=>$name, 'parent_id'=>$parent, 'meta_title'=>$name,  'meta_keywords'=>$name,  'meta_description'=>$name, 'url'=>$this->translit($name)));
                }
                
                $parent = $id;
            }
        }
        return $id;
    }
    
}

$import_ajax = new ImportAjax();
$data = $import_ajax->import();
if ($data) {
    header("Content-type: application/json; charset=UTF-8");
    header("Cache-Control: must-revalidate");
    header("Pragma: no-cache");
    header("Expires: -1");
    $json = json_encode($data);
    print $json;
}
