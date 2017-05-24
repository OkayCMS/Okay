<?php

require_once('api/Okay.php');

class BrandAdmin extends Okay {
    
    public function fetch() {
        $brand = new stdClass;
        /*Принимаем инофмрацию о бренде*/
        if($this->request->method('post')) {
            $brand->id = $this->request->post('id', 'integer');
            $brand->name = $this->request->post('name');
            $brand->annotation = $this->request->post('annotation');
            $brand->description = $this->request->post('description');
            $brand->visible = $this->request->post('visible', 'boolean');
            
            $brand->url = trim($this->request->post('url', 'string'));
            $brand->meta_title = $this->request->post('meta_title');
            $brand->meta_keywords = $this->request->post('meta_keywords');
            $brand->meta_description = $this->request->post('meta_description');
            
            $brand->url = preg_replace("/[\s]+/ui", '', $brand->url);
            $brand->url = strtolower(preg_replace("/[^0-9a-z]+/ui", '', $brand->url));
            if (empty($brand->url)) {
                $brand->url = $this->translit_alpha($brand->name);
            }
            
            // Не допустить одинаковые URL разделов.
            if(($c = $this->brands->get_brand($brand->url)) && $c->id!=$brand->id) {
                $this->design->assign('message_error', 'url_exists');
            } elseif(empty($brand->name)) {
                $this->design->assign('message_error', 'empty_name');
            } elseif(empty($brand->url)) {
                $this->design->assign('message_error', 'empty_url');
            } else {
                /*Добавляем/обновляем бренд*/
                if(empty($brand->id)) {
                    $brand->id = $this->brands->add_brand($brand);
                    $this->design->assign('message_success', 'added');
                } else {
                    $this->brands->update_brand($brand->id, $brand);
                    $this->design->assign('message_success', 'updated');
                }
                
                // Удаление изображения
                if ($this->request->post('delete_image')) {
                    $this->image->delete_image($brand->id, 'image', 'brands', $this->config->original_brands_dir, $this->config->resized_brands_dir);
                }
                // Загрузка изображения
                $image = $this->request->files('image');
                if (!empty($image['name']) && ($filename = $this->image->upload_image($image['tmp_name'], $image['name'], $this->config->original_brands_dir))) {
                    $this->image->delete_image($brand->id, 'image', 'brands', $this->config->original_brands_dir, $this->config->resized_brands_dir);
                    $this->brands->update_brand($brand->id, array('image'=>$filename));
                }
                $brand = $this->brands->get_brand($brand->id);
            }
        } else {
            $brand->id = $this->request->get('id', 'integer');
            $brand = $this->brands->get_brand($brand->id);
        }
        
        $this->design->assign('brand', $brand);
        return  $this->design->fetch('brand.tpl');
    }
    
}
