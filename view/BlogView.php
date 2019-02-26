<?php

require_once('View.php');

class BlogView extends View {
    
    private $type_post;
    
    public function fetch() {
        
        $this->type_post = explode('/', $this->current_url)[0];
        
        if (!in_array($this->type_post, array('blog', 'news'))) {
            return false;
        }
        
        $this->design->assign('type_post', $this->type_post);
        
        $url = $this->request->get('url', 'string');
        if(!empty($url)) {
            return $this->fetch_post($url);
        } else {
            return $this->fetch_blog();
        }
    }

    /*Выбираем пост из базы*/
    private function fetch_post($url) {
        $post = $this->blog->get_post($url, $this->type_post);
        
        // Если не найден - ошибка
        if(!$post || (!$post->visible && empty($_SESSION['admin']))) {
            return false;
        }
        
        //lastModify
        $this->setHeaderLastModify($post->last_modify);
        
        // Автозаполнение имени для формы комментария
        if(!empty($this->user)) {
            $this->design->assign('comment_name', $this->user->name);
            $this->design->assign('comment_email', $this->user->email);
        }
        
        /*Принимаем комментарий*/
        if ($this->request->method('post') && $this->request->post('comment')) {
            $comment = new stdClass;
            $comment->name = $this->request->post('name');
            $comment->email = $this->request->post('email');
            $comment->text = $this->request->post('text');
            $captcha_code =  $this->request->post('captcha_code', 'string');
            
            // Передадим комментарий обратно в шаблон - при ошибке нужно будет заполнить форму
            $this->design->assign('comment_text', $comment->text);
            $this->design->assign('comment_name', $comment->name);
            $this->design->assign('comment_email', $comment->email);
            
            // Проверяем капчу и заполнение формы
            if ($this->settings->captcha_post && !$this->validate->verify_captcha('captcha_post', $captcha_code)) {
                $this->design->assign('error', 'captcha');
            } elseif (!$this->validate->is_name($comment->name, true)) {
                $this->design->assign('error', 'empty_name');
            } elseif (!$this->validate->is_comment($comment->text, true)) {
                $this->design->assign('error', 'empty_comment');
            } elseif (!$this->validate->is_email($comment->email)) {
                $this->design->assign('error', 'empty_email');
            } else {
                // Создаем комментарий
                $comment->object_id = $post->id;
                $comment->type      = $post->type_post;
                $comment->ip        = $_SERVER['REMOTE_ADDR'];
                $comment->lang_id   = $_SESSION['lang_id'];
                // Добавляем комментарий в базу
                $comment_id = $this->comments->add_comment($comment);
                // Отправляем email
                $this->notify->email_comment_admin($comment_id);

                header('location: '.$_SERVER['REQUEST_URI'].'#comment_'.$comment_id);
            }
        }

        // Связанные товары
        $related_ids = array();
        $related_products = array();
        foreach($this->blog->get_related_products(array('post_id'=>$post->id)) as $p) {
            $related_ids[] = $p->related_id;
            $related_products[$p->related_id] = null;
        }
        if(!empty($related_ids)) {
            $images_ids = array();
            foreach($this->products->get_products(array('id'=>$related_ids, 'visible'=>1)) as $p) {
                $related_products[$p->id] = $p;
                $images_ids[] = $p->main_image_id;
            }

            if (!empty($images_ids)) {
                $images = $this->products->get_images(array('id'=>$images_ids));
                foreach ($images as $image) {
                    if (isset($related_products[$image->product_id])) {
                        $related_products[$image->product_id]->image = $image;
                    }
                }
            }
            $related_products_variants = $this->variants->get_variants(array('product_id'=>array_keys($related_products)));
            foreach($related_products_variants as $related_product_variant) {
                if(isset($related_products[$related_product_variant->product_id])) {
                    $related_products[$related_product_variant->product_id]->variants[] = $related_product_variant;
                }
            }
            foreach($related_products as $id=>$r) {
                if(is_object($r)) {
                    $r->variant = $r->variants[0];
                } else {
                    unset($related_products[$id]);
                }
            }
            $this->design->assign('related_products', $related_products);
        }
        
        // Комментарии к посту
        $comments = $this->comments->get_comments(array('has_parent'=>false, 'type'=>$post->type_post, 'object_id'=>$post->id, 'approved'=>1, 'ip'=>$_SERVER['REMOTE_ADDR']));
        $children = array();
        foreach ($this->comments->get_comments(array('has_parent'=>true, 'type'=>$post->type_post, 'object_id'=>$post->id, 'approved'=>1, 'ip'=>$_SERVER['REMOTE_ADDR'])) as $c) {
            $children[$c->parent_id][] = $c;
        }
        $this->design->assign('comments', $comments);
        $this->design->assign('children', $children);
        $this->design->assign('post',      $post);
        
        // Соседние записи
        $this->design->assign('next_post', $this->blog->get_next_post($post->id));
        $this->design->assign('prev_post', $this->blog->get_prev_post($post->id));
        
        // Мета-теги
        $this->design->assign('meta_title', $post->meta_title);
        $this->design->assign('meta_keywords', $post->meta_keywords);
        $this->design->assign('meta_description', $post->meta_description);
        
        return $this->design->fetch('post.tpl');
    }

    /*Отображение записей на странице*/
    private function fetch_blog() {
        //lastModify
        $this->db->query("SELECT b.last_modify FROM __blog b WHERE b.type_post=?", $this->type_post);
        $last_modify = $this->db->results('last_modify');
        $last_modify[] = $type_post == "news" ? $this->settings->lastModifyNews : $this->settings->lastModifyPosts;
        if ($this->page) {
            $last_modify[] = $this->page->last_modify;
        }
        $this->setHeaderLastModify(max($last_modify));
        
        // Количество постов на одной странице
        $items_per_page = max(1, intval($this->settings->posts_num));
        
        $filter = array();
        
        // Выбираем только видимые посты
        $filter['visible'] = 1;
        $filter['type_post'] = $this->type_post;
        
        // Текущая страница в постраничном выводе
        $current_page = $this->request->get('page', 'integer');
        
        // Если не задана, то равна 1
        $current_page = max(1, $current_page);
        $this->design->assign('current_page_num', $current_page);
        
        // Вычисляем количество страниц
        $posts_count = $this->blog->count_posts($filter);
        
        // Показать все страницы сразу
        if($this->request->get('page') == 'all') {
            $items_per_page = $posts_count;
        }
        
        $pages_num = ceil($posts_count/$items_per_page);
        $this->design->assign('total_pages_num', $pages_num);
        
        $filter['page'] = $current_page;
        $filter['limit'] = $items_per_page;
        
        // Выбираем статьи из базы
        $posts = $this->blog->get_posts($filter);
        if(empty($posts)) {
            return false;
        }
        
        // Передаем в шаблон
        $this->design->assign('posts', $posts);
        
        // Метатеги
        if($this->page) {
            $this->design->assign('meta_title', $this->page->meta_title);
            $this->design->assign('meta_keywords', $this->page->meta_keywords);
            $this->design->assign('meta_description', $this->page->meta_description);
        }
        $body = $this->design->fetch('blog.tpl');
        return $body;
    }
    
}
