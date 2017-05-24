<?php

class ExportAjax extends Okay {

    /*Поля(столбцы) для файла экспорта*/
    private $columns_names = array(
        'email'=>            'Email'
    );
    
    private $column_delimiter = ';';
    private $subscribes_count = 5;
    private $export_files_dir = 'backend/files/export_users/';
    private $filename = 'subscribes.csv';
    
    public function fetch() {
        if(!$this->managers->access('users')) {
            return false;
        }
        
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
        
        // Если начали сначала - добавим в первую строку названия колонок
        if($page == 1) {
            fputcsv($f, $this->columns_names, $this->column_delimiter);
        }
        
        $filter = array();
        $filter['page'] = $page;
        $filter['limit'] = $this->users_count;
        $filter['sort'] = $this->request->get('sort');
        $filter['keyword'] = $this->request->get('keyword');
        
        // Выбираем пользователей
        $users = array();
        foreach($this->subscribes->get_subscribes($filter) as $s) {
            $str = array();
            foreach($this->columns_names as $n=>$c) {
                $str[] = $s->$n;
            }
            
            fputcsv($f, $str, $this->column_delimiter);
        }
        
        $total_subscribes = $this->subscribes->count_subscribes();
        
        if($this->subscribes_count*$page < $total_subscribes) {
            return array('end'=>false, 'page'=>$page, 'totalpages'=>$total_subscribes/$this->subscribes_count);
        } else {
            return array('end'=>true, 'page'=>$page, 'totalpages'=>$total_subscribes/$this->subscribes_count);
        }
        
        fclose($f);
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
