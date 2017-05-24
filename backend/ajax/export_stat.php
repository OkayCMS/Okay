<?php

class ExportAjax extends Okay {
    
    public $total_price;
    public $total_amount;
    /*Поля(столбцы) для файла экспорта*/
    private $columns_names = array(
        'name'=>             'Категория',
        'amount'=>            'Количество',
        'price'=>            'Цена'
        
    );
    
    private $column_delimiter = ';';
    private $export_files_dir = 'backend/files/export/';
    private $filename = 'export_stat.csv';
    
    public function fetch() {
        if(!$this->managers->access('stats')) {
            return false;
        }

        // Эксель кушает только 1251
        setlocale(LC_ALL, 'ru_RU.1251');
        $this->db->query('SET NAMES cp1251');
        
        // Страница, которую экспортируем
        $page = $this->request->get('page');
        if (empty($page) || $page==1) {
            $page = 1;
            // Если начали сначала - удалим старый файл экспорта
            if (is_writable($this->export_files_dir.$this->filename)) {
                unlink($this->export_files_dir.$this->filename);
            }
        }
        
        // Открываем файл экспорта на добавление
        $f = fopen($this->export_files_dir.$this->filename, 'ab');
        
        // Если начали сначала - добавим в первую строку названия колонок
        if ($page == 1) {
            fputcsv($f, $this->columns_names, $this->column_delimiter);
        }
        
        $filter = array();
        $filter['page'] = $page;
        $this->total_price = 0;
        $this->total_amount = 0;
        $category_id = $this->request->get('category','integer');
        if (!empty($category_id)) {
            $category = $this->categories->get_category($category_id);
            $this->design->assign('category',$category);
            $filter['category_id'] = $category->children;
        }
        $brand_id = $this->request->get('brand','integer');
        if (!empty($brand_id)) {
            $filter['brand_id'] = $brand_id;
            $brand = $this->brands->get_brand($brand_id);
            $this->design->assign('brand',$brand);
        }
        
        $date_from = $this->request->get('date_from');
        $date_to = $this->request->get('date_to');
        
        if (!empty($date_from) || !empty($date_to)) {
            if (!empty($date_from)) {
                $filter['date_from'] = date("Y-m-d 00:00:01",strtotime($date_from));
            }
            if (!empty($date_to)) {
                $filter['date_to'] = date("Y-m-d 23:59:00",strtotime($date_to));
            }
        }
        
        $categories = $this->categories->get_categories_tree();

        $purchases = $this->reportstat->get_categorized_stat($filter);
        
        if (!empty($category)) {
            $categories_list = $this->cat_tree(array($category),$purchases);
        } else {
            $categories_list = $this->cat_tree($categories,$purchases);
        }
        foreach ($categories_list as $c) {
            fputcsv($f, $c, $this->column_delimiter);
        }


        $total = array('name'=>'Итого','amount'=>$this->total_amount,'price'=>$this->total_price);
        fputcsv($f, $total, $this->column_delimiter);
        fclose($f);

        return true;
    }
    
    private function cat_tree($categories,$purchases = array(),&$result = array()) {
        foreach ($categories as $k=>$v) {
            $category = array();
            $path = array();
            foreach ($v->path as $p) {
                $path[] = str_replace($this->subcategory_delimiter, '\\'.$this->subcategory_delimiter, $p->name);
            }
            if (isset($purchases[$v->id])) {
                $price = floatval($purchases[$v->id]->price);
                $amount = intval($purchases[$v->id]->amount);
            } else {
                $price = 0;
                $amount = 0;
            }
            $category['name'] = implode('/', $path);
            $category['price'] = $price;
            $category['amount'] = $amount;
            $result[] = $category;
            $this->total_price += $price;
            $this->total_amount += $amount;
            if (isset($v->subcategories)) {
                array_merge($result,$this->cat_tree($v->subcategories,$purchases,$result));
            }
        }
        return $result;
    }
    
}

$export_ajax = new ExportAjax();
$data = $export_ajax->fetch();
if ($data) {
    header("Content-type: application/json; charset=utf-8");
    header("Cache-Control: must-revalidate");
    header("Pragma: no-cache");
    header("Expires: -1");
    $json = json_encode($data);
    print $json;
}
