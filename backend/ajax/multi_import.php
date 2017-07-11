<?php

class ImportAjax extends Okay {

    /*Соответствие полей в базе и имён колонок в файле*/
    private $columns_names = array(
        'name'=>             array('product', 'name', 'товар', 'название', 'наименование'),
        'variant_id'=>       array('variant_id', 'ID варианта', 'variant id'),
        'variant'=>          array('variant', 'вариант'),
        'price'=>            array('price', 'цена'),
        'compare_price'=>    array('compare price', 'old price', 'старая цена'),
        'currency'=>         array('currency_id', 'currency', 'currency id', 'ID валюты'),
        'meta_title'=>       array('meta title', 'заголовок страницы'),
        'meta_keywords'=>    array('meta keywords', 'ключевые слова'),
        'meta_description'=> array('meta description', 'описание страницы'),
        'annotation'=>       array('annotation', 'аннотация', 'краткое описание'),
        'description'=>      array('description', 'описание')

    );

    // Соответствие имени колонки и поля в базе
    private $internal_columns_names = array();

    private $import_files_dir      = 'backend/files/import/'; // Временная папка
    private $import_file           = 'multi_import.csv';           // Временный файл
    private $column_delimiter      = ';';
    private $products_count        = 100;
    private $columns               = array();

    public function import() {
        if(!$this->managers->access('import') || !$this->languages->lang_id()) {
            return false;
        }
        session_write_close();
        unset($_SESSION['lang_id']);
        unset($_SESSION['admin_lang_id']);

        // Для корректной работы установим локаль UTF-8
        setlocale(LC_ALL, 'ru_RU.UTF-8');

        $result = new stdClass;

        // Определяем колонки из первой строки файла
        $f = fopen($this->import_files_dir.$this->import_file, 'r');
        $this->columns = fgetcsv($f, null, $this->column_delimiter);

        // Заменяем имена колонок из файла на внутренние имена колонок
        foreach($this->columns as &$column) {
            if($internal_name = $this->internal_column_name($column)) {
                $this->internal_columns_names[$column] = $internal_name;
                $column = $internal_name;
            }
        }

        $required_fields = array_keys($this->columns_names);
        $import_fields = array_values($this->internal_columns_names);
        $diff = array_diff($required_fields, $import_fields);
        if (count($diff)) {
            fclose($f);
            $result = new stdClass();
            $result->error = 1;
            $result->missing_fields = array();
            foreach ($diff as $field) {
                $result->missing_fields[] = $this->columns_names[$field][count($this->columns_names[$field])-1];
            }
            return $result;
        }

        // Если нет названия товара - не будем импортировать
        if(!in_array('name', $this->columns) && !in_array('variant_id', $this->columns)) {
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
            if(is_array($line)) {
                // Проходимся по колонкам строки
                foreach($this->columns as $i=>$col) {
                    // Создаем массив item[название_колонки]=значение
                    if(isset($line[$i]) && !empty($line) && !empty($col)) {
                        $product[$col] = $line[$i];
                    }
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
        if(empty($item['name']) || empty($item['variant_id'])) {
            return false;
        }

        // Подготовим товар для добавления в базу
        $product = array();

        if(isset($item['name'])) {
            $product['name'] = trim($item['name']);
        }

        if(isset($item['meta_title'])) {
            $product['meta_title'] = trim($item['meta_title']);
        } else {
            $product['meta_title'] = $product['name'];
        }

        if(isset($item['meta_keywords'])) {
            $product['meta_keywords'] = trim($item['meta_keywords']);
        } else {
            $product['meta_keywords'] = $product['name'];
        }

        if(isset($item['meta_description'])) {
            $product['meta_description'] = trim($item['meta_description']);
        } else {
            $product['meta_description'] = $product['name'];
        }

        if(isset($item['annotation'])) {
            $product['annotation'] = trim($item['annotation']);
        }

        if(isset($item['description'])) {
            $product['description'] = trim($item['description']);
        }

        // Подготовим вариант товара
        $variant = array();
        if(isset($item['variant_id'])) {
            $variant['id'] = trim($item['variant_id']);
        }

        if(isset($item['variant'])) {
            $variant['name'] = trim($item['variant']);
        }

        if(isset($item['price'])) {
            $variant['price'] = str_replace(',', '.', str_replace(' ', '', trim($item['price'])));
        }

        if (isset($item['currency'])) {
            $variant['currency_id'] = intval($item['currency']);
        }

        if(isset($item['compare_price'])) {
            $variant['compare_price'] = trim($item['compare_price']);
        }

        // Если задан артикул варианта, найдем этот вариант и соответствующий товар
        if(!empty($variant['id'])) {
            $this->db->query('SELECT v.id as variant_id, v.product_id FROM __variants v WHERE v.id=? LIMIT 1', $variant['id']);
            $result = $this->db->result();
            if($result) {
                // и обновим товар
                if(!empty($product)) {
                    $this->products->update_product($result->product_id, $product);
                }
                // и вариант
                if(!empty($variant)) {
                    $this->variants->update_variant($result->variant_id, $variant);
                }

                $product_id = $result->product_id;
                $variant_id = $result->variant_id;
                // Обновлен
                $imported_item->status = 'updated';
            }
        }

        if(!empty($variant_id) && !empty($product_id)) {
            // Нужно вернуть обновленный товар
            $imported_item->variant = $this->variants->get_variant(intval($variant_id));
            $imported_item->product = $this->products->get_product(intval($product_id));

            $category_id = $this->categories->get_product_categories($product_id);
            if (!empty($category_id)) {
                $category_id = reset($category_id);
                $category_id = $category_id->category_id;
            }

            // Характеристики товаров
            if ($category_id) {
                foreach ($item as $feature_name => $feature_value) {
                    // Если нет такого названия колонки, значит это название свойства
                    if (!in_array($feature_name, $this->internal_columns_names)) {
                        if ($feature_value !== '') {
                            $this->db->query('SELECT fl.feature_id
                                FROM __lang_features fl
                                LEFT JOIN __categories_features fc ON (fc.feature_id=fl.feature_id)
                                WHERE fl.name=? and fl.lang_id=? and fc.category_id=? LIMIT 1', $feature_name, $this->languages->lang_id(), $category_id);
                            if ($feature_id = $this->db->result('feature_id')) {
                                $this->features->update_option($product_id, $feature_id, $feature_value);
                            }
                        }
                    }
                }
            }
            return $imported_item;
        }
        return false;
    }

    // Фозвращает внутреннее название колонки по названию колонки в файле
    private function internal_column_name($name) {
        $name = trim($name);
        $name = str_replace('/', '', $name);
        $name = str_replace('\/', '', $name);
        foreach($this->columns_names as $i=>$names) {
            foreach($names as $n) {
                if(!empty($name) && preg_match("/^".preg_quote($name)."$/ui", $n)) {
                    return $i;
                }
            }
        }
        return false;
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
