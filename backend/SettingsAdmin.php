<?php

require_once('api/Okay.php');

class SettingsAdmin extends Okay {
    
    private $allowed_image_extentions = array('png', 'gif', 'jpg', 'jpeg', 'ico');
    
    public function fetch() {
        $this->passwd_file = $this->config->root_dir.'/backend/.passwd';
        $this->htaccess_file = $this->config->root_dir.'/backend/.htaccess';
        
        $managers = $this->managers->get_managers();
        $this->design->assign('managers', $managers);
        
        if($this->request->method('POST')) {
            $this->settings->site_name = $this->request->post('site_name');
            $this->settings->company_name = $this->request->post('company_name');
            $this->settings->date_format = $this->request->post('date_format');
            $this->settings->admin_email = $this->request->post('admin_email');
            
            $this->settings->order_email = $this->request->post('order_email');
            $this->settings->comment_email = $this->request->post('comment_email');
            $this->settings->notify_from_email = $this->request->post('notify_from_email');
            
            $this->settings->decimals_point = $this->request->post('decimals_point');
            $this->settings->thousands_separator = $this->request->post('thousands_separator');
            
            $this->settings->products_num = $this->request->post('products_num');
            $this->settings->products_num_admin = $this->request->post('products_num_admin');
            $this->settings->max_order_amount = $this->request->post('max_order_amount');
            $this->settings->comparison_count = $this->request->post('comparison_count');
            $this->settings->units = $this->request->post('units');
            $this->settings->is_preorder = $this->request->post('is_preorder', 'integer');
            
            $this->settings->yandex_export_not_in_stock = $this->request->post('yandex_export_not_in_stock', 'boolean');
            $this->settings->yandex_available_for_retail_store = $this->request->post('yandex_available_for_retail_store', 'boolean');
            $this->settings->yandex_available_for_reservation = $this->request->post('yandex_available_for_reservation', 'boolean');
            $this->settings->yandex_short_description = $this->request->post('yandex_short_description', 'boolean');
            $this->settings->yandex_has_manufacturer_warranty = $this->request->post('yandex_has_manufacturer_warranty', 'boolean');
            $this->settings->yandex_has_seller_warranty = $this->request->post('yandex_has_seller_warranty', 'boolean');
            $this->settings->yandex_sales_notes = $this->request->post('yandex_sales_notes');
            
            // Водяной знак
            $clear_image_cache = false;
            $watermark = $this->request->files('watermark_file', 'tmp_name');
            if(!empty($watermark) && in_array(pathinfo($this->request->files('watermark_file', 'name'), PATHINFO_EXTENSION), $this->allowed_image_extentions)) {
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
            if($this->settings->watermark_transparency != $this->request->post('watermark_transparency')) {
                $this->settings->watermark_transparency = $this->request->post('watermark_transparency');
                $clear_image_cache = true;
            }
            if($this->settings->images_sharpen != $this->request->post('images_sharpen')) {
                $this->settings->images_sharpen = $this->request->post('images_sharpen');
                $clear_image_cache = true;
            }
            
            // Удаление заресайзеных изображений
            if($clear_image_cache) {
                $this->clear_resized_dirs($this->config->resized_images_dir);
                
                $this->clear_resized_dirs($this->config->resized_blog_dir);
                $this->clear_resized_dirs($this->config->resized_brands_dir);
                $this->clear_resized_dirs($this->config->resized_categories_dir);
            }
            $this->design->assign('message_success', 'saved');
        }
        return $this->design->fetch('settings.tpl');
    }
    
    private function clear_resized_dirs($dir = '') {
        if (empty($dir)) {
            return false;
        }
        if($handle = opendir($dir)) {
            while(false !== ($file = readdir($handle))) {
                if($file != "." && $file != ".." && $file != '.keep_folder') {
                    @unlink($dir."/".$file);
                }
            }
            closedir($handle);
        }
    }
    
}
