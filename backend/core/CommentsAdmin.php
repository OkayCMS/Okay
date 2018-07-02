<?php

require_once('api/Okay.php');

class CommentsAdmin extends Okay {
    
    public function fetch() {
        $filter = array();
        $filter['page'] = max(1, $this->request->get('page', 'integer'));
        
        if ($filter['limit'] = $this->request->get('limit', 'integer')) {
            $filter['limit'] = max(5, $filter['limit']);
            $filter['limit'] = min(100, $filter['limit']);
            $_SESSION['comments_num_admin'] = $filter['limit'];
        } elseif (!empty($_SESSION['comments_num_admin'])) {
            $filter['limit'] = $_SESSION['comments_num_admin'];
        } else {
            $filter['limit'] = 25;
        }
        $this->design->assign('current_limit', $filter['limit']);
        
        // Выбираем главные сообщения
        $filter['has_parent'] = false;
        
        // Тип
        $type = $this->request->get('type', 'string');
        if($type) {
            $filter['type'] = $type;
            $this->design->assign('type', $type);
        }

        // Сортировка по статусу
        $status = $this->request->get('status', 'string');
        if ($status == 'approved') {
            $filter['approved'] = 1;
        } elseif ($status == 'unapproved') {
            $filter['approved'] = 0;
        }
        $this->design->assign('status', $status);
        
        // Поиск
        $keyword = $this->request->get('keyword');
        if(!empty($keyword)) {
            $filter['keyword'] = $keyword;
            $this->design->assign('keyword', $keyword);
        }
        
        /*Принимаем ответ администратора на комментарий*/
        if($this->request->method('post')) {
            if ($this->request->post('comment_answer', 'boolean') && ($parent_comment = $this->comments->get_comment($this->request->post('parent_id', 'integer')))) {
                $comment = new stdClass();
                $comment->parent_id = $parent_comment->id;
                $comment->type = $parent_comment->type;
                $comment->object_id = $parent_comment->object_id;
                $comment->text = $this->request->post('text');
                $comment->name = ($this->settings->notify_from_name ? $this->settings->notify_from_name : 'Administrator');
                $comment->approved = 1;
                $comment->id = $this->comments->add_comment($comment);
                if (!empty($parent_comment->email) && $comment->id) {
                    $this->notify->email_comment_answer_to_user($comment->id);
                }
            }
            // Действия с выбранными
            $ids = $this->request->post('check');
            if(!empty($ids) && is_array($ids)) {
                switch($this->request->post('action')) {
                    case 'approve': {
                        /*Модерация комментария*/
                        foreach($ids as $id) {
                            $this->comments->update_comment($id, array('approved'=>1));
                        }
                        break;
                    }
                    case 'delete': {
                        /*Удаления комментария*/
                        foreach($ids as $id) {
                            $this->comments->delete_comment($id);
                        }
                        break;
                    }
                }
            }
        }

        // Отображение
        $comments_count = $this->comments->count_comments($filter);
        // Показать все страницы сразу
        if($this->request->get('page') == 'all') {
            $filter['limit'] = $comments_count;
        }
        $comments = $this->comments->get_comments($filter);

        // Сохраняем id комментариев для выборки ответов
        $comments_ids = array();
        foreach ($comments as $comment) {
            $comments_ids[] = $comment->id;
        }
        
        // Выбераем ответы на комментарии
        if (!empty($comments_ids)) {
            $children = array();
            foreach ($this->comments->get_comments(array('parent_id' => $comments_ids)) as $c) {
                $children[$c->parent_id][] = $c;
            }
            $this->design->assign('children', $children);
        }
        
        // Выбирает объекты, которые прокомментированы:
        $products_ids = array();
        $posts_ids = array();
        foreach($comments as $comment) {
            if($comment->type == 'product') {
                $products_ids[] = $comment->object_id;
            }
            if($comment->type == 'blog') {
                $posts_ids[] = $comment->object_id;
            }
            if($comment->type == 'news') {
                $posts_ids[] = $comment->object_id;
            }
        }
        $products = array();
        foreach($this->products->get_products(array('id'=>$products_ids, 'limit' => count($products_ids))) as $p) {
            $products[$p->id] = $p;
        }
        
        $posts = array();
        foreach($this->blog->get_posts(array('id'=>$posts_ids)) as $p) {
            $posts[$p->id] = $p;
        }

        /*Определение сущности, к которой был оставлен комментарий*/
        foreach($comments as $comment) {
            if($comment->type == 'product' && isset($products[$comment->object_id])) {
                $comment->product = $products[$comment->object_id];
            }
            if($comment->type == 'blog' && isset($posts[$comment->object_id])) {
                $comment->post = $posts[$comment->object_id];
            }
            if($comment->type == 'news' && isset($posts[$comment->object_id])) {
                $comment->post = $posts[$comment->object_id];
            }
        }
        
        $this->design->assign('pages_count', ceil($comments_count/$filter['limit']));
        $this->design->assign('current_page', $filter['page']);
        
        $this->design->assign('comments', $comments);
        $this->design->assign('comments_count', $comments_count);
        
        return $this->design->fetch('comments.tpl');
    }
    
}
