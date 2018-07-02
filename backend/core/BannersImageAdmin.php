<?php

require_once('api/Okay.php');

class BannersImageAdmin extends Okay {
    
    private	$allowed_image_extentions = array('png', 'gif', 'jpg', 'jpeg', 'ico');
    
    public function fetch() {
        $banners_image = new stdClass;
        /*Принимаем данные о слайде*/
        if($this->request->method('post')) {
            $banners_image->id = $this->request->post('id', 'integer');
            $banners_image->name = $this->request->post('name');
            $banners_image->visible = $this->request->post('visible', 'boolean');
            $banners_image->banner_id = $this->request->post('banner_id', 'integer');
            
            $banners_image->url = $this->request->post('url');
            $banners_image->title = $this->request->post('title');
            $banners_image->alt = $this->request->post('alt');
            $banners_image->description = $this->request->post('description');
            
            /*Добавляем/удаляем слайд*/
            if(empty($banners_image->id)) {
                $banners_image->id = $this->banners->add_banners_image($banners_image);
                $this->design->assign('message_success', 'added');
            } else {
                $this->banners->update_banners_image($banners_image->id, $banners_image);
                $this->design->assign('message_success', 'updated');
            }
            // Удаление изображения
            if($this->request->post('delete_image')) {
                $this->image->delete_image($banners_image->id, 'image', 'banners_images', $this->config->banners_images_dir, $this->config->resized_banners_images_dir);
            }
            // Загрузка изображения
            $image = $this->request->files('image');
            if (!empty($image['name']) && ($filename = $this->image->upload_image($image['tmp_name'], $image['name'], $this->config->banners_images_dir))) {
                $this->image->delete_image($banners_image->id, 'image', 'banners_images', $this->config->banners_images_dir, $this->config->resized_banners_images_dir);
                $this->banners->update_banners_image($banners_image->id, array('image'=>$filename));
            }
            $banners_image = $this->banners->get_banners_image(intval($banners_image->id));
        } else {
            $banners_image->id = $this->request->get('id', 'integer');
            $banners_image = $this->banners->get_banners_image($banners_image->id);
        }
        
        $banners = $this->banners->get_banners();
        
        $this->design->assign('banners_image', $banners_image);
        $this->design->assign('banners', $banners);
        return  $this->design->fetch('banners_image.tpl');
    }
    
}
