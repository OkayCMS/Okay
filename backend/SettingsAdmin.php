<?php

require_once('api/Okay.php');

class SettingsAdmin extends Okay {
    
    private $allowed_image_extentions = array('png', 'gif', 'jpg', 'jpeg', 'ico');
    public $passwd_file_1c = "cml/.passwd";

    public function fetch() {
        $managers = $this->managers->get_managers();
        $this->design->assign('managers', $managers);
        $user_1c = $this->get_user_1c();
        
        if($this->request->method('POST')) {
            $this->settings->site_name = $this->request->post('site_name');
            $this->settings->company_name = $this->request->post('company_name');
            $this->settings->date_format = $this->request->post('date_format');
            $this->settings->admin_email = $this->request->post('admin_email');

            $this->settings->captcha_product = $this->request->post('captcha_product', 'boolean');
            $this->settings->captcha_post = $this->request->post('captcha_post', 'boolean');
            $this->settings->captcha_cart = $this->request->post('captcha_cart', 'boolean');
            $this->settings->captcha_register = $this->request->post('captcha_register', 'boolean');
            $this->settings->captcha_feedback = $this->request->post('captcha_feedback', 'boolean');

            $this->settings->order_email = $this->request->post('order_email');
            $this->settings->comment_email = $this->request->post('comment_email');
            $this->settings->notify_from_email = $this->request->post('notify_from_email');
            $this->settings->notify_from_name = $this->request->post('notify_from_name');
            
            $this->settings->decimals_point = $this->request->post('decimals_point');
            $this->settings->thousands_separator = $this->request->post('thousands_separator');
            
            $this->settings->products_num = $this->request->post('products_num');
            $this->settings->max_order_amount = $this->request->post('max_order_amount');
            $this->settings->comparison_count = $this->request->post('comparison_count');
            $this->settings->units = $this->request->post('units');
            $this->settings->posts_num = $this->request->post('posts_num');
            $this->settings->is_preorder = $this->request->post('is_preorder', 'integer');
            
            $this->settings->yandex_export_not_in_stock = $this->request->post('yandex_export_not_in_stock', 'boolean');
            $this->settings->yandex_available_for_retail_store = $this->request->post('yandex_available_for_retail_store', 'boolean');
            $this->settings->yandex_available_for_reservation = $this->request->post('yandex_available_for_reservation', 'boolean');
            $this->settings->yandex_short_description = $this->request->post('yandex_short_description', 'boolean');
            $this->settings->yandex_has_manufacturer_warranty = $this->request->post('yandex_has_manufacturer_warranty', 'boolean');
            $this->settings->yandex_has_seller_warranty = $this->request->post('yandex_has_seller_warranty', 'boolean');
            $this->settings->yandex_sales_notes = $this->request->post('yandex_sales_notes');
            
            $this->settings->site_work = $this->request->post('site_work');
            $this->settings->site_annotation = $this->request->post('site_annotation');

            /*google and yandex analytics*/
            $this->settings->g_analytics = $this->request->post('g_analytics');
            $this->settings->g_webmaster = $this->request->post('g_webmaster');
            $this->settings->y_metric = $this->request->post('y_metric');
            $this->settings->y_webmaster = $this->request->post('y_webmaster');
            $this->settings->yandex_metrika_app_id = $this->request->post('yandex_metrika_app_id');
            $this->settings->yandex_metrika_token = $this->request->post('yandex_metrika_token');
            $this->settings->yandex_metrika_counter_id = $this->request->post('yandex_metrika_counter_id');

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

            $pass_1c = $this->request->post('pass_1c');
            if (!empty($pass_1c)) {
                $login_1c = $this->request->post('login_1c');
                if (!empty($login_1c)) {
                    $user_1c = $this->update_user_1c($login_1c, $pass_1c);
                }
            }
        }
        $this->design->assign('login_1c', isset($user_1c[0]) ? $user_1c[0] : '');
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

    private function get_user_1c() {
        //echo dirname(dirname(__FILE__)).'/'.$this->passwd_file_1c;
        $line = explode("\n", @file_get_contents($this->passwd_file_1c));
        $line = reset($line);
        $line = explode(':', $line);
        return $line;
    }

    private function update_user_1c($login, $pass) {
        $pass = $this->crypt_apr1_md5($pass);
        $line = $login.':'.$pass;
        file_put_contents($this->passwd_file_1c, $line);
        return explode(':', $line);
    }

    private function crypt_apr1_md5($plainpasswd, $salt = '') {
        if (empty($salt)) {
            $salt = substr(str_shuffle("abcdefghijklmnopqrstuvwxyz0123456789"), 0, 8);
        }
        $len = strlen($plainpasswd);
        $text = $plainpasswd.'$apr1$'.$salt;
        $bin = pack("H32", md5($plainpasswd.$salt.$plainpasswd));
        for($i = $len; $i > 0; $i -= 16) { $text .= substr($bin, 0, min(16, $i)); }
        for($i = $len; $i > 0; $i >>= 1) { $text .= ($i & 1) ? chr(0) : $plainpasswd{0}; }
        $bin = pack("H32", md5($text));
        for($i = 0; $i < 1000; $i++) {
            $new = ($i & 1) ? $plainpasswd : $bin;
            if ($i % 3) $new .= $salt;
            if ($i % 7) $new .= $plainpasswd;
            $new .= ($i & 1) ? $bin : $plainpasswd;
            $bin = pack("H32", md5($new));
        }
        $tmp = '';
        for ($i = 0; $i < 5; $i++) {
            $k = $i + 6;
            $j = $i + 12;
            if ($j == 16) $j = 5;
            $tmp = $bin[$i].$bin[$k].$bin[$j].$tmp;
        }
        $tmp = chr(0).chr(0).$bin[11].$tmp;
        $tmp = strtr(strrev(substr(base64_encode($tmp), 2)),
            "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/",
            "./0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz");
        return "$"."apr1"."$".$salt."$".$tmp;
    }
    
}
