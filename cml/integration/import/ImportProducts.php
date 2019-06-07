<?php

namespace Integration1C\Import;


class ImportProducts extends Import
{

    public function __construct($okay, $integration_1c) {
        parent::__construct($okay, $integration_1c);
    }

    /**
     * @param string $xml_file Full path to xml file
     * @return string
     */
    public function import($xml_file) {

        // Категории и свойства (только в первом запросе пакетной передачи)
        if (empty($this->integration_1c->get_from_storage('imported_product_num'))) {
            $z = new \XMLReader;
            $z->open($xml_file);
            while ($z->read() && $z->name !== 'Классификатор');
            if ($z->name == 'Классификатор') {
                $xml = new \SimpleXMLElement($z->readOuterXML());
                $z->close();
                $this->import_categories($xml);
                $this->import_features($xml);
                $this->import_units($xml);
            }
        }

        // Товары
        $z = new \XMLReader;
        $z->open($xml_file);

        while ($z->read() && $z->name !== 'Товар');

        // Последний товар, на котором остановились
        $last_product_num = 0;
        if (!empty($this->integration_1c->get_from_storage('imported_product_num'))) {
            $last_product_num = $this->integration_1c->get_from_storage('imported_product_num');
        }

        // Номер текущего товара
        $current_product_num = 0;

        while ($z->name === 'Товар') {
            if ($current_product_num >= $last_product_num) {
                $xml = new \SimpleXMLElement($z->readOuterXML());

                // Товары
                $this->import_product($xml);

                $exec_time = microtime(true) - $this->integration_1c->start_time;
                if ($exec_time+1 >= $this->integration_1c->max_exec_time) {

                    // Запоминаем на каком товаре остановились
                    $this->integration_1c->set_to_storage('imported_product_num', $current_product_num);
                    
                    $result =  "progress\n";
                    $result .=  "Выгружено товаров: $current_product_num\n";
                    return $result;
                }
            }
            $current_product_num ++;
            $z->next('Товар');
        }
        $z->close();
        
        $this->integration_1c->set_to_storage('imported_product_num', '');
        return "success\n";
    }

    /**
     * @param $xml \SimpleXMLElement()
     */
    private function import_units($xml) {
        if (isset($xml->ЕдиницыИзмерения->ЕдиницаИзмерения)) {
            foreach ($xml->ЕдиницыИзмерения->ЕдиницаИзмерения as $xml_group) {
                $param = "units_".strval($xml_group->Код);
                
                if (!$unit = (string)$xml_group->НаименованиеКраткое) {
                    $unit = (string)$xml_group->НаименованиеПолное;
                }
                $this->integration_1c->set_to_storage($param, $unit);
            }
        }
    }

    /**
     * @param $xml \SimpleXMLElement()
     * @param int $parent_id
     */
    private function import_categories($xml, $parent_id = 0) {
        if(isset($xml->Группы->Группа)) {
            foreach ($xml->Группы->Группа as $xml_group) {
                $this->okay->db->query('SELECT id FROM __categories WHERE external_id=?', (string)$xml_group->Ид);
                $category_id = $this->okay->db->result('id');
                $name = (string)$xml_group->Наименование;
                if (empty($category_id)) {
                    $category_id = $this->okay->categories->add_category(array(
                        'parent_id' => $parent_id,
                        'external_id' => (string)$xml_group->Ид,
                        'url' => $this->okay->translit($name),
                        'name' => $name,
                        'meta_title' => $name,
                        'meta_keywords' => $name,
                        'meta_description' => $name
                    ));
                } else {
                    //Постоянное обновление категорий, проверка на предмет переименования родителськой категории            
                    $this->okay->categories->update_category($category_id, array(
                        'parent_id' => $parent_id,
                        'name' => $name
                    ));
                }
                
                $param = "categories_".strval($xml_group->Ид);
                $this->integration_1c->set_to_storage($param, $category_id);
                $this->import_categories($xml_group, $category_id);
            }
        }
    }

    /**
     * @param $xml \SimpleXMLElement()
     * Метод импортирует свойства со справочника
     */
    private function import_features($xml) {
        $property = array();
        if (isset($xml->Свойства->СвойствоНоменклатуры)) {
            $property = $xml->Свойства->СвойствоНоменклатуры;
        }

        if (isset($xml->Свойства->Свойство)) {
            $property = $xml->Свойства->Свойство;
        }

        foreach ($property as $xml_feature) {
            // Если свойство содержит производителя товаров
            if ($xml_feature->Наименование == $this->integration_1c->brand_option_name) {
                // Запомним в сессии Ид свойства с производителем
                $this->integration_1c->set_to_storage('brand_option_id', strval($xml_feature->Ид));
            } else {
                // Иначе обрабатываем как обычной свойство товара
                
                // Проверяем существует ли свойство не по наименованию, а по коду 1С
                $this->okay->db->query('SELECT id FROM __features WHERE external_id=?', strval($xml_feature->Ид));
                $feature_id = $this->okay->db->result('id');
                // По умолчанию свойство АКТИВИРУЕМ для фильтра
                if (empty($feature_id)) {
                    // Добавляем свойство и Код 1С
                    $feature_id = $this->okay->features->add_feature(array(
                        'name' => strval($xml_feature->Наименование),
                        'external_id' => strval($xml_feature->Ид),
                        'in_filter' => 1
                    ));
                } else {
                    $feature_id = $this->okay->features->update_feature($feature_id, array(
                        'name'=>strval($xml_feature->Наименование)
                    ));
                }

                $param = "features_".strval($xml_feature->Ид);
                $this->integration_1c->set_to_storage($param, $feature_id);
                
                // Разбираем значения свойств
                if ($xml_feature->ТипЗначений == 'Справочник') {
                    foreach ($xml_feature->ВариантыЗначений->Справочник as $val) {
                        $value = (string)$val->Значение;
                        $value_id = $this->get_feature_value_id($feature_id, $value);
                        
                        $param = "features_values_".$feature_id."_".strval($val->ИдЗначения);
                        $this->integration_1c->set_to_storage($param, $value_id);
                    }
                }
            }
        }
    }
    
    /**
     * @param $xml_product \SimpleXMLElement()
     */
    private function import_product($xml_product) {
        
        $xml_product->Наименование = trim($xml_product->Наименование);

        //  Id товара и варианта (если есть) по 1С
        @list($product_1c_id, $variant_1c_id) = explode('#', $xml_product->Ид);
        if (empty($variant_1c_id)) {
            $variant_1c_id = '';
        }
        
        if ($xml_product->ЗначенияРеквизитов->ЗначениеРеквизита) {
            foreach ($xml_product->ЗначенияРеквизитов->ЗначениеРеквизита as $property) {
                $properties[(string)$property->Наименование] = (string)$property->Значение;
            }
        }
        
        // Не будем парсить все, что не товар (чтобы исключить услуги типа "Доставка" и подобные...)
        if ($this->integration_1c->import_products_only === true && isset($properties['ВидНоменклатуры']) && $properties['ВидНоменклатуры'] != 'Товар') {
            return;
        }
        
        $products_categories_ids = array();
        if (isset($xml_product->Группы->Ид)) {
            foreach ($xml_product->Группы->Ид as $cat_id) {
                $param = "categories_".strval($cat_id);
                $products_categories_ids[] = $this->integration_1c->get_from_storage($param);
            }
        }

        // Подгатавливаем вариант
        $variant_id = null;
        $variant = new \stdClass;
        $values = array();
        if (isset($xml_product->ХарактеристикиТовара->ХарактеристикаТовара)) {
            foreach ($xml_product->ХарактеристикиТовара->ХарактеристикаТовара as $xml_property) {
                $values[] = $xml_property->Значение;
            }
        }
        
        if (!empty($values)) {
            $variant->name = implode(', ', $values);
        } else {
            // Нет вариантов товара поэтому сделаем пустым
            $variant->name = '';
        }
        $variant->sku = (string)$xml_product->Артикул;
        $variant->external_id = $variant_1c_id;

        // Ищем товар по внешнему id
        $this->okay->db->query('SELECT id FROM __products WHERE external_id=?', $product_1c_id);
        $product_id = $this->okay->db->result('id');
        
        // если не нашли, ищем по артикулу
        if (empty($product_id) && !empty($variant->sku)) {
            $this->okay->db->query('SELECT product_id, id FROM __variants WHERE sku=? LIMIT 1', $variant->sku);
            $res = $this->okay->db->result();
            if (!empty($res)) {
                $product_id = $res->product_id;
                $variant_id = $res->id;
            }
        } elseif (!empty($product_id)) {
            if (!empty($variant_1c_id)) {
                $this->okay->db->query('SELECT id FROM __variants WHERE external_id=? AND product_id=?', $variant_1c_id, $product_id);
                $variant_id = $this->okay->db->result('id');
            } else {
                $this->okay->db->query('SELECT id FROM __variants WHERE product_id=?', $product_id);
                $variant_id = $this->okay->db->result('id');
            }
        }
        
        // Если нужно - удаляем вариант или весь товар
        $attributes = $xml_product->attributes();
        if ((string)$xml_product->Статус == 'Удален' || (string)$attributes['Статус'] == 'Удален') {
            if ($product_id !== null && $variant_id !== null) {
                $this->okay->variants->delete_variant($variant_id);
                $this->okay->db->query('SELECT count(id) as variants_num FROM __variants WHERE product_id=?', $product_id);
                if ($this->okay->db->result('variants_num') == 0) {
                    $this->okay->products->delete_product($product_id);
                }
            }
            return;
        }
        
        // Если такого товара не нашлось
        if (empty($product_id)) {
            // Добавляем товар
            $description = '';
            if (!empty($xml_product->Описание)) {
                $description = $xml_product->Описание;
            }
            $product_id = $this->okay->products->add_product(array(
                'external_id' => $product_1c_id,
                'url' => $this->okay->translit($xml_product->Наименование),
                'name' => $xml_product->Наименование,
                'meta_title' => $xml_product->Наименование,
                'meta_keywords' => $xml_product->Наименование,
                'meta_description' => $description,
                'annotation' => $description,
                'description' => $description,
                'visible' => 1
            ));

            // Добавляем товар в категории
            if (!empty($products_categories_ids)) {
                foreach ($products_categories_ids as $category_id) {
                    $this->okay->categories->add_product_category($product_id, $category_id);
                }
            }

            // Импортируем изображения
            $this->import_images($xml_product, $product_id);

        } else {

            // Обновляем товар
            if ($this->integration_1c->full_update === true) {
                $p = new \stdClass();
                if (!empty($xml_product->Описание)) {
                    $description = strval($xml_product->Описание);
                    $p->meta_description = $description;
                    $p->annotation = $description;
                    $p->description = $description;
                }
                $p->external_id = $product_1c_id;
                $p->url = $this->okay->translit($xml_product->Наименование);
                $p->name = $xml_product->Наименование;
                $p->meta_title = $xml_product->Наименование;
                $p->meta_keywords = $xml_product->Наименование;

                $product_id = $this->okay->products->update_product($product_id, $p);

                // Обновляем категории товара
                if (!empty($products_categories_ids) && !empty($product_id)) {
                    $query = $this->okay->db->placehold('DELETE FROM __products_categories WHERE product_id=?', $product_id);
                    $this->okay->db->query($query);
                    foreach ($products_categories_ids as $category_id) {
                        $this->okay->categories->add_product_category($product_id, $category_id);
                    }
                }
            }

            // Импортируем изображения
            $this->import_images($xml_product, $product_id);
        }

        // Определяем откуда читать единицы измерения
        if (!$variant->units = (string)$xml_product->БазоваяЕдиница) {
            $attributes = $xml_product->БазоваяЕдиница->attributes();
            $param = "units_" . strval($attributes['Код']);
            $variant->units = $this->integration_1c->get_from_storage($param);
        }
        
        // Если не найден вариант, добавляем вариант один к товару
        if (empty($variant_id)) {
            $variant->product_id = $product_id;
            $variant->stock = 0;
            $variant_id = $this->okay->variants->add_variant($variant);
        } elseif (!empty($variant_id)) {
            $this->okay->variants->update_variant($variant_id, $variant);
        }

        // Определяем основную категорию товара
        $main_category_id = reset($products_categories_ids);
        
        // Свойства товара
        if (isset($xml_product->ЗначенияСвойств->ЗначенияСвойства)) {
            // Импортируем значения свойств товара
            $this->import_product_features($product_id, $main_category_id, $xml_product->ЗначенияСвойств->ЗначенияСвойства);
        }
        
        $main_info = array();
        // Указываем бренд товара
        if (isset($xml_product->Изготовитель->Наименование)) {

            $brand_name = strval($xml_product->Изготовитель->Наименование);
            // Добавим бренд
            // Найдем его по имени
            $this->okay->db->query('SELECT id FROM __brands WHERE name=?', $brand_name);
            if (!$brand_id = $this->okay->db->result('id')) {
                // Создадим, если не найден
                $brand_id = $this->okay->brands->add_brand(array(
                    'name' => $brand_name,
                    'meta_title' => $brand_name,
                    'meta_keywords' => $brand_name,
                    'meta_description' => $brand_name,
                    'url' => $this->okay->translit_alpha($brand_name),
                    'visible' => 1
                ));
            }
            if (!empty($brand_id)) {
                $main_info['brand_id'] = $brand_id;
            }
        }
        
        if (!empty($main_category_id)) {
            $main_info['main_category_id'] = $main_category_id;
        }
        
        if (!empty($main_info)) {
            $this->okay->products->update_product($product_id, $main_info);
        }
    }


    /**
     * @param $product_id int
     * @param $main_category_id int
     * @param $xml_features \SimpleXMLElement()
     */
    private function import_product_features($product_id, $main_category_id, $xml_features) {
        foreach ($xml_features as $xml_option) {
            $param = "features_" . strval($xml_option->Ид);
            if ($this->integration_1c->get_from_storage($param) !== null) {
                $feature_id = $this->integration_1c->get_from_storage($param);

                if (isset($main_category_id) && !empty($feature_id)) {
                    $this->okay->features->add_feature_category($feature_id, $main_category_id);
                    
                    $values_transaction = $this->okay->db->placehold("INSERT IGNORE INTO `__products_features_values` (`product_id`, `value_id`) VALUES ");
                    $sql_values = array();

                    foreach ($xml_option->Значение as $xml_value) {
                        $param = "features_values_".$feature_id."_".strval($xml_value);
                        if ($this->integration_1c->get_from_storage($param) !== null) {
                            $value_id = $this->integration_1c->get_from_storage($param);
                            $sql_values[] = "('$product_id', '$value_id')";
                        } else {
                            $value_id = $this->get_feature_value_id($feature_id, strval($xml_value));
                            $sql_values[] = "('$product_id', '$value_id')";
                        }
                    }

                    if ($sql_values) {
                        $values_transaction .= implode(", ", $sql_values);
                        $this->okay->db->query($values_transaction);
                    }
                }
            }
            // Если свойство оказалось названием бренда
            elseif ($this->integration_1c->get_from_storage('brand_option_id') !== null && !empty($xml_option->Значение) && $this->integration_1c->get_from_storage('brand_option_id') == strval($xml_option->Ид)) {
                $brand_name = strval($xml_option->Значение);
                
                // Если мы не запомнили такого бренда ранее, проверим его в базе
                if (($brand_id = $this->integration_1c->get_from_storage('brands' . $brand_name)) !== null) {
                    // Найдем его по имени
                    $this->okay->db->query('SELECT id FROM __brands WHERE name=?', $brand_name);
                    if (!$brand_id = $this->okay->db->result('id')) {
                        // Создадим, если не найден
                        $brand_id = $this->okay->brands->add_brand(array(
                            'name' => $brand_name,
                            'meta_title' => $brand_name,
                            'meta_keywords' => $brand_name,
                            'meta_description' => $brand_name,
                            'url' => $this->okay->translit_alpha($brand_name),
                            'visible' => 1
                        ));
                    }

                    // Запомним бренд для следующих товаров
                    $this->integration_1c->set_to_storage('brands' . $brand_name, $brand_id);
                }
                if (!empty($brand_id)) {
                    $this->okay->products->update_product($product_id, array('brand_id'=>$brand_id));
                }
            }
        }
    }
    
    /**
     * @param $feature_id int
     * @param $value string
     * @return int|null
     * Метод проверяет существование значения свойства, и возвращает его id или создает новое значение
     */
    private function get_feature_value_id($feature_id, $value) {
        
        if (empty($feature_id) || empty($value)) {
            return null;
        }
        
        $value_id = null;
        $translit = $this->okay->translit_alpha($value);

        // Ищем значение с таким транслитом
        if ($fv = $this->okay->features_values->get_features_values(array('feature_id'=>$feature_id, 'translit'=>$translit))) {
            $fv = reset($fv);
            $value_id = $fv->id;
        }

        // Если нет, тогда добавим значение
        if (empty($value_id)) {
            
            // Определяем нужно ли делать занчение индексируемым
            $this->okay->db->query("SELECT `to_index_new_value` FROM `__features` WHERE `id`=? LIMIT 1", $feature_id);
            $to_index = $this->okay->db->result('to_index_new_value');
            
            $feature_value = new \stdClass();
            $feature_value->value = trim($value);
            $feature_value->feature_id = $feature_id;
            $feature_value->to_index = $to_index;
            $value_id = $this->okay->features_values->add_feature_value($feature_value);
        }
        return $value_id;
    }
    
    /**
     * @param $xml_product \SimpleXMLElement()
     * @param $product_id integer
     */
    private function import_images($xml_product, $product_id) {

        $position = 0;
        $images_ids = array();
        // Обновляем основное изображение товара
        if (isset($xml_product->ОсновнаяКартинка)) {
            $image = basename($xml_product->ОсновнаяКартинка);
            if (!empty($image) && is_file($this->integration_1c->get_tmp_dir() . $image) && is_writable($this->okay->config->original_images_dir)) {
                $this->okay->db->query('SELECT id, filename FROM __images WHERE product_id=? AND filename=? ORDER BY position LIMIT 1', $product_id, $image);
                $img_id = $this->okay->db->result('id');
                if (!empty($img_id)) {
                    $this->okay->products->delete_image($img_id);
                }
                rename($this->integration_1c->get_tmp_dir() . $image, $this->okay->config->original_images_get_tmp_dir() . $image);
                $images_ids[] = $this->okay->products->add_image($product_id, $image, '', $position++);
            }
        }

        // Обновляем изображение товара
        if (isset($xml_product->Картинка)) {
            foreach ($xml_product->Картинка as $img) {
                $image = (string)$img;
                $filename = basename($image);
                $base = pathinfo($filename, PATHINFO_FILENAME);
                $ext = pathinfo($filename, PATHINFO_EXTENSION);

                while(file_exists($this->config->root_dir.$this->config->original_images_dir.$filename)) {
                    $new_base = pathinfo($filename, PATHINFO_FILENAME);
                    if(preg_match('/_([0-9]+)$/', $new_base, $parts)) {
                        $filename = $base.'_'.($parts[1]+1).'.'.$ext;
                    } else {
                        $filename = $base.'_1.'.$ext;
                    }
                }
                
                $original_images_dir = $this->okay->config->root_dir . $this->okay->config->original_images_dir;
                if (!empty($filename) && is_file($this->integration_1c->get_tmp_dir(). $image) && is_writable($original_images_dir)) {
                    $this->okay->db->query('SELECT id, filename FROM __images WHERE product_id=? AND filename=? ORDER BY position LIMIT 1', $product_id, $filename);
                    $img_id = $this->okay->db->result('id');
                    if (!empty($img_id)) {
                        $this->okay->products->delete_image($img_id);
                    }
                    rename($this->integration_1c->get_tmp_dir(). $image, $original_images_dir . $filename);
                    $images_ids[] = $this->okay->products->add_image($product_id, $filename, '', $position++);
                }
            }
        }
        
        if (!empty($images_ids)) {
            $main_image_id = reset($images_ids);
            $this->okay->db->query('UPDATE __products SET main_image_id=? WHERE id=? LIMIT 1', $main_image_id, $product_id);
        }
    }
    
}
