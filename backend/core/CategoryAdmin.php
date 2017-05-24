<?php

require_once('api/Okay.php');

class CategoryAdmin extends Okay {
    
    public function fetch() {
        $category = new stdClass;
        /*Принимаем данные о категории*/
        if($this->request->method('post')) {
            $category->id = $this->request->post('id', 'integer');
            $category->parent_id = $this->request->post('parent_id', 'integer');
            $category->name = $this->request->post('name');
            $category->name_h1 = $this->request->post('name_h1');
            $category->yandex_name = $this->request->post('yandex_name');
            $category->visible = $this->request->post('visible', 'boolean');
            
            $category->url = trim($this->request->post('url', 'string'));
            $category->meta_title = $this->request->post('meta_title');
            $category->meta_keywords = $this->request->post('meta_keywords');
            $category->meta_description = $this->request->post('meta_description');

            $category->annotation = $this->request->post('annotation');
            $category->description = $this->request->post('description');
            
            // Не допустить одинаковые URL разделов.
            if(($c = $this->categories->get_category($category->url)) && $c->id!=$category->id) {
                $this->design->assign('message_error', 'url_exists');
            } elseif(empty($category->name)) {
                $this->design->assign('message_error', 'empty_name');
            } elseif(empty($category->url)) {
                $this->design->assign('message_error', 'empty_url');
            } elseif(substr($category->url, -1) == '-' || substr($category->url, 0, 1) == '-') {
                $this->design->assign('message_error', 'url_wrong');
            } else {
                /*Добавление/обновление категории*/
                if(empty($category->id)) {
                    $category->id = $this->categories->add_category($category);
                    $this->design->assign('message_success', 'added');
                } else {
                    $this->categories->update_category($category->id, $category);
                    $this->design->assign('message_success', 'updated');
                }
                // Удаление изображения
                if ($this->request->post('delete_image')) {
                    $this->image->delete_image($category->id, 'image', 'categories', $this->config->original_categories_dir, $this->config->resized_categories_dir);
                }
                // Загрузка изображения
                $image = $this->request->files('image');
                if (!empty($image['name']) && ($filename = $this->image->upload_image($image['tmp_name'], $image['name'], $this->config->original_categories_dir))) {
                    $this->image->delete_image($category->id, 'image', 'categories', $this->config->original_categories_dir, $this->config->resized_categories_dir);
                    $this->categories->update_category($category->id, array('image'=>$filename));
                }
                $category = $this->categories->get_category(intval($category->id));
            }
        } else {
            $category->id = $this->request->get('id', 'integer');
            $category = $this->categories->get_category($category->id);
        }
        /*Выборка дерева категорий*/
        $categories = $this->categories->get_categories_tree();
        
        $this->design->assign('category', $category);
        $this->design->assign('categories', $categories);
        return  $this->design->fetch('category.tpl');
    }

}
