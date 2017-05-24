<?php

require_once('api/Okay.php');

class ExportAdmin extends Okay {
    
    private $export_files_dir = 'backend/files/export/';

    /*Экспорт товаров*/
    public function fetch() {
        $this->design->assign('export_files_dir', $this->export_files_dir);
        if(!is_writable($this->export_files_dir)) {
            $this->design->assign('message_error', 'no_permission');
        }
        $this->design->assign('brands', $this->brands->get_brands());
        $this->design->assign('categories', $this->categories->get_categories_tree());
        return $this->design->fetch('export.tpl');
    }
    
}
