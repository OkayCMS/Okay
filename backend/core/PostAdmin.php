<?php

require_once('api/Okay.php');

class PostAdmin extends Okay {
    
    public function fetch() {
        $related_products = array();
        $post = new stdClass;
        /*Прием информации о записи*/
        if($this->request->method('post')) {
            $post->id = $this->request->post('id', 'integer');
            $post->name = $this->request->post('name');
            $post->date = date('Y-m-d', strtotime($this->request->post('date')));
            $post->visible = $this->request->post('visible', 'boolean');
            $post->type_post = $this->request->post('type_post');
            $post->url = trim($this->request->post('url', 'string'));
            $post->meta_title = $this->request->post('meta_title');
            $post->meta_keywords = $this->request->post('meta_keywords');
            $post->meta_description = $this->request->post('meta_description');
            
            $post->annotation = $this->request->post('annotation');
            $post->description = $this->request->post('description');

            // Связанные товары
            if(is_array($this->request->post('related_products'))) {
                foreach($this->request->post('related_products') as $p) {
                    $rp[$p] = new stdClass;
                    $rp[$p]->post_id = $post->id;
                    $rp[$p]->related_id = $p;
                }
                $related_products = $rp;
            }
            
            // Не допустить одинаковые URL разделов.
            if(($a = $this->blog->get_post($post->url)) && $a->id!=$post->id) {
                $this->design->assign('message_error', 'url_exists');
            } elseif(empty($post->name)) {
                $this->design->assign('message_error', 'empty_name');
            } elseif(empty($post->url)) {
                $this->design->assign('message_error', 'empty_url');
            } elseif(substr($post->url, -1) == '-' || substr($post->url, 0, 1) == '-') {
                $this->design->assign('message_error', 'url_wrong');
            } else {
                /*Добавление/Обновление записи*/
                if(empty($post->id)) {
                    $post->id = $this->blog->add_post($post);
                    $this->design->assign('message_success', 'added');
                } else {
                    $this->blog->update_post($post->id, $post);
                    $this->design->assign('message_success', 'updated');
                }
                
                // Удаление изображения
                if ($this->request->post('delete_image')) {
                    $this->image->delete_image($post->id, 'image', 'blog', $this->config->original_blog_dir, $this->config->resized_blog_dir);
                }
                // Загрузка изображения
                $image = $this->request->files('image');
                if (!empty($image['name']) && ($filename = $this->image->upload_image($image['tmp_name'], $image['name'], $this->config->original_blog_dir))) {
                    $this->image->delete_image($post->id, 'image', 'blog', $this->config->original_blog_dir, $this->config->resized_blog_dir);
                    $this->blog->update_post($post->id, array('image'=>$filename));
                }
                // Связанные товары
                $query = $this->db->placehold('DELETE FROM __related_blogs WHERE post_id=?', $post->id);
                $this->db->query($query);
                if(is_array($related_products)) {
                    $pos = 0;
                    foreach($related_products  as $i=>$related_product) {
                        $this->blog->add_related_product($post->id, $related_product->related_id, $pos++);
                    }
                }
                $post = $this->blog->get_post($post->id);
            }
        } else {
            $post->id = $this->request->get('id', 'integer');
            $post = $this->blog->get_post(intval($post->id));
            // Связанные товары
            if($post->id) {
                $related_products = $this->blog->get_related_products(array('post_id' => $post->id));
            }
        }
        
        if(empty($post)) {
            $post = new stdClass;
            $post->date = date($this->settings->date_format, time());
            $post->visible = 1;
        }

        /*Связанные товары записи*/
        if(!empty($related_products)) {
            $images_ids = array();
            foreach($related_products as &$r_p) {
                $r_products[$r_p->related_id] = &$r_p;
            }
            $temp_products = $this->products->get_products(array('id'=>array_keys($r_products)));
            foreach($temp_products as $temp_product) {
                $r_products[$temp_product->id] = $temp_product;
                $images_ids[] = $temp_product->main_image_id;
            }

            if (!empty($images_ids)) {
                $images = $this->products->get_images(array('id'=>$images_ids));
                foreach ($images as $image) {
                    if (isset($r_products[$image->product_id])) {
                        $r_products[$image->product_id]->image = $image;
                    }
                }
            }
        }

        $this->design->assign('related_products', $related_products);
        $this->design->assign('post', $post);
        return $this->design->fetch('post.tpl');
    }
    
}
