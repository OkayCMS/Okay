<?php

class ExportAjax extends Okay {

    /*Поля(столбцы) для файла экспорта*/
    private $columns_names = array(
        'category'=>         'Category',
        'brand'=>            'Brand',
        'name'=>             'Product',
        'variant'=>          'Variant',
        'sku'=>              'SKU',
        'price'=>            'Price',
        'compare_price'=>    'Old price',
        'currency'=>         'Currency ID',
        'weight'=>           'Weight',
        'stock'=>            'Stock',
        'units'=>            'Units',
        'visible'=>          'Visible',
        'featured'=>         'Featured',
        'meta_title'=>       'Meta title',
        'meta_keywords'=>    'Meta keywords',
        'meta_description'=> 'Meta description',
        'annotation'=>       'Annotation',
        'description'=>      'Description',
        'images'=>           'Images',
        'url'=>              'URL'
        
    );
    
    private $column_delimiter = ';';
    private $values_delimiter = ',,';
    private $subcategory_delimiter = '/';
    private $products_count = 100;
    private $export_files_dir = 'backend/files/export/';
    private $filename = 'export.csv';
    
    public function fetch() {
        if(!$this->managers->access('export')) {
            return false;
        }
        session_write_close();
        unset($_SESSION['lang_id']);
        unset($_SESSION['admin_lang_id']);

        // Эксель кушает только 1251
        setlocale(LC_ALL, 'ru_RU.1251');
        $this->db->query('SET NAMES cp1251');
        
        // Страница, которую экспортируем
        $page = $this->request->get('page');
        if(empty($page) || $page==1) {
            $page = 1;
            // Если начали сначала - удалим старый файл экспорта
            if(is_writable($this->export_files_dir.$this->filename)) {
                unlink($this->export_files_dir.$this->filename);
            }
        }
        
        // Открываем файл экспорта на добавление
        $f = fopen($this->export_files_dir.$this->filename, 'ab');

        $filter = array('page'=>$page, 'limit'=>$this->products_count);
        $features_filter = array();
        if (($cid = $this->request->get('category_id', 'integer')) && ($category = $this->categories->get_category($cid))) {
            $categories_ids = $category->children;
            $this->db->query("SELECT DISTINCT product_id FROM __products_categories WHERE category_id in (?@)", $category->children);
            $products_ids = $this->db->results('product_id');
            
            if (!empty($products_ids)) {
                $this->db->query("SELECT DISTINCT category_id FROM __products_categories WHERE product_id in (?@) AND position=0", $products_ids);
                $cat_ids = $this->db->results('category_id');

                foreach ($cat_ids as $cat_id) {
                    if ($tmp_cat = $this->categories->get_category((int)$cat_id)) {
                        $categories_ids = array_merge($categories_ids, $tmp_cat->children);
                    }
                }
            }
            
            $filter['category_id'] = $category->children;
            $features_filter['category_id'] = array_unique($categories_ids);
        }
        if ($brand_id = $this->request->get('brand_id', 'integer')) {
            $filter['brand_id'] = $brand_id;
        }
        
        // Добавим в список колонок свойства товаров
        $features_filter['limit'] = $this->features->count_features($features_filter);
        $features = $this->features->get_features($features_filter);
        foreach($features as $feature) {
            $this->columns_names[$feature->name] = $feature->name;
        }
        
        // Если начали сначала - добавим в первую строку названия колонок
        if($page == 1) {
            fputcsv($f, $this->columns_names, $this->column_delimiter);
        }

        // Все товары
        $products = array();
        foreach($this->products->get_products($filter) as $p) {
            $products[$p->id] = (array)$p;
        }
        
        if(empty($products)) {
            return false;
        }

        $products_ids = array_keys($products);

        $features_values = array();
        foreach ($this->features_values->get_features_values(array('product_id' => $products_ids)) as $fv) {
            $features_values[$fv->id] = $fv;
        }

        $products_values = array();
        foreach ($this->features_values->get_product_value_id($products_ids) as $pv) {
            $products_values[$pv->product_id][$pv->value_id] = $pv->value_id;
        }

        // Значения свойств товара
        foreach($products as $p_id=>&$product) {

            if (isset($products_values[$p_id])) {
                $product_feature_values = array();
                foreach($products_values[$p_id] as $value_id) {
                    if(isset($features_values[$value_id])) {
                        $feature = $features_values[$value_id];
                        $product_feature_values[$feature->name][] = str_replace(',', '.', trim($feature->value));
                    }
                }

                foreach ($product_feature_values as $feature_name=>$values) {
                    $product[$feature_name] = implode($this->values_delimiter, $values);
                }
            }

            $categories = array();
            $cats = $this->categories->get_product_categories($p_id);
            foreach($cats as $category) {
                $path = array();
                $cat = $this->categories->get_category((int)$category->category_id);
                if(!empty($cat)) {
                    // Вычисляем составляющие категории
                    foreach($cat->path as $p) {
                        $path[] = str_replace($this->subcategory_delimiter, '\\'.$this->subcategory_delimiter, $p->name);
                    }
                    // Добавляем категорию к товару
                    $categories[] = implode('/', $path);
                }
            }
            $product['category'] = implode(',, ', $categories);
        }
        
        // Изображения товаров
        $images = $this->products->get_images(array('product_id'=>array_keys($products)));
        foreach($images as $image) {
            // Добавляем изображения к товару чезер запятую
            if(empty($products[$image->product_id]['images'])) {
                $products[$image->product_id]['images'] = $image->filename;
            } else {
                $products[$image->product_id]['images'] .= ', '.$image->filename;
            }
        }
        
        $variants = $this->variants->get_variants(array('product_id'=>array_keys($products)));
        
        foreach($variants as $variant) {
            if(isset($products[$variant->product_id])) {
                $v                    = array();
                $v['variant']         = $variant->name;
                $v['price']           = $variant->price;
                $v['compare_price']   = $variant->compare_price;
                $v['sku']             = $variant->sku;
                $v['stock']           = $variant->stock;
                $v['weight']           = $variant->weight;
                $v['units']           = $variant->units;
                $v['currency']        = $variant->currency_id;
                if($variant->infinity) {
                    $v['stock']           = '';
                }
                $products[$variant->product_id]['variants'][] = $v;
            }
        }
        
        $all_brands = array();
        $brands_count = $this->brands->count_brands();
        foreach ($this->brands->get_brands(array('limit'=>$brands_count)) as $b) {
            $all_brands[$b->id] = $b;
        }
        
        foreach($products as &$product) {
            if ($product['brand_id'] && isset($all_brands[$product['brand_id']])) {
                $product['brand'] = $all_brands[$product['brand_id']]->name;
            }
            $variants = $product['variants'];
            unset($product['variants']);
            
            if(isset($variants)) {
                foreach($variants as $variant) {
                    $result = array();
                    $result =  $product;
                    foreach($variant as $name=>$value) {
                        $result[$name]=$value;
                    }
                    
                    foreach($this->columns_names as $internal_name=>$column_name) {
                        if(isset($result[$internal_name])) {
                            $res[$internal_name] = $result[$internal_name];
                        } else {
                            $res[$internal_name] = '';
                        }
                    }
                    fputcsv($f, $res, $this->column_delimiter);
                }
            }
        }
        
        $total_products = $this->products->count_products($filter);
        fclose($f);
        if($this->products_count*$page < $total_products) {
            return array('end'=>false, 'page'=>$page, 'totalpages'=>$total_products/$this->products_count);
        } else {
            return array('end'=>true, 'page'=>$page, 'totalpages'=>$total_products/$this->products_count);
        }
    }


    // Strips leading zeros
    // And returns str in UPPERCASE letters with a U+ prefix
    private function format($str) {
        $copy = false;
        $len = strlen($str);
        $res = '';

        for ($i = 0; $i < $len; ++$i) {
            $ch = $str[$i];

            if (!$copy) {
                if ($ch != '0') {
                    $copy = true;
                }
                // Prevent format("0") from returning ""
                else if (($i + 1) == $len) {
                    $res = '0';
                }
            }

            if ($copy) {
                $res .= $ch;
            }
        }

        return 'U+'.strtoupper($res);
    }

    private function convert_emoji($emoji) {
        // ?? --> 0000270a0001f3fe
        $emoji = mb_convert_encoding($emoji, 'UTF-32', 'UTF-8');
        $hex = bin2hex($emoji);

        // Split the UTF-32 hex representation into chunks
        $hex_len = strlen($hex) / 8;
        $chunks = array();

        for ($i = 0; $i < $hex_len; ++$i) {
            $tmp = substr($hex, $i * 8, 8);

            // Format each chunk
            $chunks[$i] = $this->format($tmp);
        }

        // Convert chunks array back to a string
        return implode($chunks, ' ');
    }

//echo convert_emoji('??');

}

$export_ajax = new ExportAjax();
$data = $export_ajax->fetch();
if($data) {
    header("Content-type: application/json; charset=utf-8");
    header("Cache-Control: must-revalidate");
    header("Pragma: no-cache");
    header("Expires: -1");
    $json = json_encode($data);
    print $json;
}