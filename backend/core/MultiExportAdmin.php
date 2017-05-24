<?php

require_once('api/Okay.php');

class MultiExportAdmin extends Okay {

    private $export_files_dir = 'backend/files/export/';

    /*Экспорт переводов*/
    public function fetch() {
        $this->design->assign('export_files_dir', $this->export_files_dir);
        if(!is_writable($this->export_files_dir)) {
            $this->design->assign('message_error', 'no_permission');
        }
        if (!$this->languages->lang_id()) {
            $this->design->assign('message_error', 'no_languages');
        } else {
            $this->design->assign('lang_id_default', $_SESSION['admin_lang_id']);
        }
        $this->design->assign('brands', $this->brands->get_brands());
        $this->design->assign('categories', $this->categories->get_categories_tree());
        return $this->design->fetch('multi_export.tpl');
    }

}
