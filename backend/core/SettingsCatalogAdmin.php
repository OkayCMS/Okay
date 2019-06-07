<?php

require_once('api/Okay.php');

class SettingsCatalogAdmin extends Okay {

    private $allowed_image_extentions = array('png', 'gif', 'jpg', 'jpeg', 'ico');

    /*Настройки каталога*/
    public function fetch() {
        $managers = $this->managers->get_managers();
        $this->design->assign('managers', $managers);

        if($this->request->method('POST')) {
            $this->settings->decimals_point = $this->request->post('decimals_point');
            $this->settings->thousands_separator = $this->request->post('thousands_separator');
            $this->settings->products_num = $this->request->post('products_num');
            $this->settings->max_order_amount = $this->request->post('max_order_amount');
            $this->settings->comparison_count = $this->request->post('comparison_count');
            $this->settings->update('units', $this->request->post('units'));
            $this->settings->posts_num = $this->request->post('posts_num');
            
            if ($this->request->post('truncate_table_confirm') && ($pass = $this->request->post('truncate_table_password'))) {
                $manager = $this->managers->get_manager();
                if ($this->managers->check_password($pass, $manager->password)) {
                    $this->truncate_tables();
                }
            }
            
            if($this->request->post('is_preorder', 'integer')){
                $this->settings->is_preorder = $this->request->post('is_preorder', 'integer');
            } else {
                $this->settings->is_preorder = 0;
            }
            // Водяной знак
            $clear_image_cache = false;

            if ($this->request->post('delete_watermark')) {
                $clear_image_cache = true;
                unlink($this->config->root_dir.$this->config->watermark_file);
                $this->config->watermark_file = '';
            }

            $watermark = $this->request->files('watermark_file', 'tmp_name');
            if(!empty($watermark) && in_array(pathinfo($this->request->files('watermark_file', 'name'), PATHINFO_EXTENSION), $this->allowed_image_extentions)) {
                $this->config->watermark_file = 'backend/files/watermark/watermark.png';
                if(@move_uploaded_file($watermark, $this->config->root_dir.$this->config->watermark_file)) {
                    $clear_image_cache = true;
                } else {
                    $this->design->assign('message_error', 'watermark_is_not_writable');
                }
            }

            if($this->settings->watermark_offset_x != $this->request->post('watermark_offset_x')) {
                $this->settings->watermark_offset_x = $this->request->post('watermark_offset_x');
                $clear_image_cache = true;
            }
            if($this->settings->watermark_offset_y != $this->request->post('watermark_offset_y')) {
                $this->settings->watermark_offset_y = $this->request->post('watermark_offset_y');
                $clear_image_cache = true;
            }

            if($this->settings->image_quality != $this->request->post('image_quality')) {
                $this->settings->image_quality = $this->request->post('image_quality');
                $clear_image_cache = true;
            }


            // Удаление заресайзеных изображений
            if($clear_image_cache) {
                $this->clear_files_dirs($this->config->resized_images_dir);

                $this->clear_files_dirs($this->config->resized_blog_dir);
                $this->clear_files_dirs($this->config->resized_brands_dir);
                $this->clear_files_dirs($this->config->resized_categories_dir);
            }
            $this->design->assign('message_success', 'saved');
            
        }
        
        return $this->design->fetch('settings_catalog.tpl');
    }

    private function truncate_tables() {
        $this->clear_catalog();

        $this->clear_files_dirs($this->config->original_images_dir);
        $this->clear_files_dirs($this->config->resized_images_dir);
        
        $this->clear_files_dirs($this->config->original_brands_dir);
        $this->clear_files_dirs($this->config->resized_brands_dir);
        
        $this->clear_files_dirs($this->config->original_categories_dir);
        $this->clear_files_dirs($this->config->resized_categories_dir);
        
    }

    private function clear_files_dirs($dir = '') {
        if (empty($dir)) {
            return false;
        }
        if($handle = opendir($dir)) {
            while(false !== ($file = readdir($handle))) {
                if($file != "." && $file != ".." && $file != '.keep_folder' && $file != '.htaccess') {
                    @unlink($dir."/".$file);
                }
            }
            closedir($handle);
        }
    }

}
