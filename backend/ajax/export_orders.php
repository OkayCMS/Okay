<?php

class ExportAjax extends Okay {

    /*Поля(столбцы) для файла экспорта*/
    private $columns_names = array(
        'id'=>           'Order ID',
        'date'=>         'Order date',
        'name'=>         'User name',
        'phone'=>        'User phone',
        'email'=>        'User email',
        'address'=>      'User address',
        'comment'=>      'User comment',
        'total_price'=>  'Total price',
        'currency'=>     'Currency'
        
    );
    
    private $column_delimiter = ';';
    private $orders_count = 100;
    private $export_files_dir = 'backend/files/export/';
    private $filename = 'export_orders.csv';
    
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

        $filter = array();

        $filter['page'] = $page;
        $filter['limit'] = $this->orders_count;
        
        // Статус
        $status_id = $this->request->get('status', 'integer');
        if (!empty($status_id)) {
            $filter['status'] = $status_id;
        }
        
        // Метка
        $label_id = $this->request->get('label', 'integer');
        if(!empty($label_id)) {
            $filter['label'] = $label_id;
        }

        // Дата
        $from_date = $this->request->get('from_date');
        $to_date = $this->request->get('to_date');
        
        if (!empty($from_date)) {
            $filter['from_date'] = $from_date;
        }
        if (!empty($to_date)) {
            $filter['to_date'] = $to_date;
        }
        
        // Если начали сначала - добавим в первую строку названия колонок
        if($page == 1) {
            fputcsv($f, $this->columns_names, $this->column_delimiter);
        }
        
        // Основная валюта
        $main_currency =  $this->money->get_currency();
        
        // Все заказы
        $orders = $this->orders->get_orders($filter);
        if (!empty($orders)) {
            foreach($orders as $o) {
                $str = array();
                $o->currency = $main_currency->code;
                foreach($this->columns_names as $n=>$c) {
                    $str[] = $o->$n;
                }
                fputcsv($f, $str, $this->column_delimiter);
            }
        }
        $total_orders = $this->orders->count_orders($filter);
        
        if($this->orders_count*$page < $total_orders) {
            return array('end'=>false, 'page'=>$page, 'totalpages'=>$total_orders/$this->orders_count);
        } else {
            return array('end'=>true, 'page'=>$page, 'totalpages'=>$total_orders/$this->orders_count);
        }
        
        fclose($f);
    }
    
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