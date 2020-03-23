<?php

require_once('View.php');

class ProductView extends View {

    /*Отображение товара*/
    public function fetch() {
        $product_url = $this->request->get('product_url', 'string');
        
        if(empty($product_url)) {
            return false;
        }
        
        // Выбираем товар из базы
        $product = $this->products->get_product((string)$product_url);
        if(empty($product) || (!$product->visible && empty($_SESSION['admin']))) {
            return false;
        }
        
        //lastModify
        $this->setHeaderLastModify($product->last_modify);
        
        $product->images = $this->products->get_images(array('product_id'=>$product->id));
        $product->image = reset($product->images);
        foreach ($product->images as $image) {
            if (preg_match("~^https?://~", $image->filename)) {
                if($filename = $this->image->download_image($image->filename)) {
                    $image->filename = $filename;
                }
            }
        }
        
        $variants = array();
        foreach($this->variants->get_variants(array('product_id'=>$product->id)) as $v) {
            $variants[$v->id] = $v;
        }
        
        $product->variants = $variants;
        
        // Вариант по умолчанию
        if(($v_id = $this->request->get('variant', 'integer'))>0 && isset($variants[$v_id])) {
            $product->variant = $variants[$v_id];
        } else {
            $product->variant = reset($variants);
        }

        if ($product_values = $this->features_values->get_features_values(array('product_id'=>$product->id))) {
            foreach ($product_values as $pv) {
                if (!isset($product->features[$pv->feature_id])) {
                    $product->features[$pv->feature_id] = $pv;
                }
                $product->features[$pv->feature_id]->values[] = $pv;
            }
        }
        
        // Автозаполнение имени для формы комментария
        if(!empty($this->user)) {
            $this->design->assign('comment_name', $this->user->name);
            $this->design->assign('comment_email', $this->user->email);
        }
        
        // Принимаем комментарий
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
            if ($this->settings->captcha_product && !$this->validate->verify_captcha('captcha_product', $captcha_code)) {
                $this->design->assign('error', 'captcha');
            } elseif (!$this->validate->is_name($comment->name, true)) {
                $this->design->assign('error', 'empty_name');
            } elseif (!$this->validate->is_comment($comment->text, true)) {
                $this->design->assign('error', 'empty_comment');
            } elseif (!$this->validate->is_email($comment->email)) {
                $this->design->assign('error', 'empty_email');
            } else {
                // Создаем комментарий
                $comment->object_id = $product->id;
                $comment->type      = 'product';
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
        $images_ids = array();
        foreach($this->products->get_related_products($product->id) as $p) {
            $related_ids[] = $p->related_id;
            $related_products[$p->related_id] = null;
        }
        if(!empty($related_ids)) {
            foreach($this->products->get_products(array('id'=>$related_ids,'limit' => count($related_ids),'visible'=>1, 'in_stock'=>1)) as $p) {
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

        //Связянные статьи для товара
        $related_post = array();
        $related_post = $this->blog->get_related_products(array('product_id'=>$product->id));
        if(!empty($related_post)) {
            $filter_post['visible'] = 1;
            foreach ($related_post as $r_post) {
                $filter_post['id'][] = $r_post->post_id;
            }
            $posts = $this->blog->get_posts($filter_post);
            $this->design->assign('related_posts', $posts);
        }
        
        // Отзывы о товаре
        $comments = $this->comments->get_comments(array('has_parent'=>false, 'type'=>'product', 'object_id'=>$product->id, 'approved'=>1, 'ip'=>$_SERVER['REMOTE_ADDR']));
        $children = array();
        foreach ($this->comments->get_comments(array('has_parent'=>true, 'type'=>'product', 'object_id'=>$product->id, 'approved'=>1, 'ip'=>$_SERVER['REMOTE_ADDR'])) as $c) {
            $children[$c->parent_id][] = $c;
        }

        // И передаем его в шаблон
        $this->design->assign('product', $product);
        $this->design->assign('comments', $comments);
        $this->design->assign('children', $children);
        
        // Категория и бренд товара
        $brand = $this->brands->get_brand(intval($product->brand_id));
        if ($brand->visible) {
            $this->design->assign('brand', $brand);
        }
        $category = $this->categories->get_category((int)$product->main_category_id);
        $this->design->assign('category', $category);

        // Соседние товары
        if (!empty($category)) {
            $neighbors_products = $this->products->get_neighbors_products($category->id, $product->position);
            $this->design->assign('next_product', $neighbors_products['next']);
            $this->design->assign('prev_product', $neighbors_products['prev']);
        }
        
        // Добавление в историю просмотров товаров
        $max_visited_products = 100; // Максимальное число хранимых товаров в истории
        $expire = time()+60*60*24*30; // Время жизни - 30 дней
        if(!empty($_COOKIE['browsed_products'])) {
            $browsed_products = explode(',', $_COOKIE['browsed_products']);
            // Удалим текущий товар, если он был
            if(($exists = array_search($product->id, $browsed_products)) !== false) {
                unset($browsed_products[$exists]);
            }
        }
        // Добавим текущий товар
        $browsed_products[] = $product->id;
        $cookie_val = implode(',', array_slice($browsed_products, -$max_visited_products, $max_visited_products));
        setcookie("browsed_products", $cookie_val, $expire, "/");

        $default_products_seo_pattern = (object)$this->settings->default_products_seo_pattern;
        $parts = array(
            '{$brand}'    => ($this->design->get_var('brand') ? $this->design->get_var('brand')->name : ''),
            '{$product}'  => ($product->name ? $product->name : ''),
            '{$price}'    => ($product->variant->price != null ? $this->money->convert($product->variant->price, $this->currency->id, false).' '.$this->currency->sign : ''),
            '{$sitename}' => ($this->settings->site_name ? $this->settings->site_name : '')
        );
        
        //Автоматичекска генерация мета тегов и описания товара
        if (!empty($category)) {
            $parts['{$category}']    = ($category->name ? $category->name : '');
            $parts['{$category_h1}'] = ($category->name_h1 ? $category->name_h1 : '');
            foreach ($product->features as $feature) {
                if ($feature->auto_name_id) {
                    $parts['{$'.$feature->auto_name_id.'}'] = $feature->name;
                }
                if ($feature->auto_value_id) {
                    
                    if (count($feature->values) > 1) {
                        $value = array();
                        foreach ($feature->values as $fv) {
                            $value[] = $fv->value;
                        }
                        $value = implode(', ', $value);
                    } else {
                        $value = $feature->value;
                    }
                    
                    $parts['{$'.$feature->auto_value_id.'}'] = $value;
                }
            }

            if (!empty($category->auto_meta_title)) {
                $auto_meta_title = $category->auto_meta_title;
            } elseif (!empty($default_products_seo_pattern->auto_meta_title)) {
                $auto_meta_title = $default_products_seo_pattern->auto_meta_title;
            } else {
                $auto_meta_title = $product->meta_title;
            }

            if (!empty($category->auto_meta_keywords)) {
                $auto_meta_keywords = $category->auto_meta_keywords;
            } elseif (!empty($default_products_seo_pattern->auto_meta_keywords)) {
                $auto_meta_keywords = $default_products_seo_pattern->auto_meta_keywords;
            } else {
                $auto_meta_keywords = $product->meta_keywords;
            }

            if (!empty($category->auto_meta_desc)) {
                $auto_meta_description = $category->auto_meta_desc;
            } elseif (!empty($default_products_seo_pattern->auto_meta_desc)) {
                $auto_meta_description = $default_products_seo_pattern->auto_meta_desc;
            } else {
                $auto_meta_description = $product->meta_description;
            }

            if (!empty($category->auto_description) && empty($product->description)) {
                $product->description = strtr($category->auto_description, $parts);
                $product->description = preg_replace('/\{\$[^\$]*\}/', '', $product->description);
            } elseif (!empty($default_products_seo_pattern->auto_description) && empty($product->description)) {
                $product->description = strtr($default_products_seo_pattern->auto_description, $parts);
                $product->description = preg_replace('/\{\$[^\$]*\}/', '', $product->description);
            }
        } else {

            if ($default_products_seo_pattern->auto_meta_title) {
                $auto_meta_title = $default_products_seo_pattern->auto_meta_title;
            } else {
                $auto_meta_title = $product->meta_title;
            }

            if ($default_products_seo_pattern->auto_meta_keywords) {
                $auto_meta_keywords = $default_products_seo_pattern->auto_meta_keywords;
            } else {
                $auto_meta_keywords = $product->meta_keywords;
            }

            if ($default_products_seo_pattern->auto_meta_desc) {
                $auto_meta_description = $default_products_seo_pattern->auto_meta_desc;
            } else {
                $auto_meta_description = $product->meta_description;
            }

            if (!empty($default_products_seo_pattern->auto_description) && empty($product->description)) {
                $product->description = strtr($default_products_seo_pattern->auto_description, $parts);
                $product->description = preg_replace('/{\$[^$]*}/', '', $product->description);
            }
        }

        $auto_meta_title = strtr($auto_meta_title, $parts);
        $auto_meta_keywords = strtr($auto_meta_keywords, $parts);
        $auto_meta_description = strtr($auto_meta_description, $parts);
        
        $auto_meta_title = preg_replace('/{\$[^$]*}/', '', $auto_meta_title);
        $auto_meta_keywords = preg_replace('/{\$[^$]*}/', '', $auto_meta_keywords);
        $auto_meta_description = preg_replace('/{\$[^$]*}/', '', $auto_meta_description);
        
        $this->design->assign('meta_title', $auto_meta_title);
        $this->design->assign('meta_keywords', $auto_meta_keywords);
        $this->design->assign('meta_description', $auto_meta_description);
        
        return $this->design->fetch('product.tpl');
    }
    
}
