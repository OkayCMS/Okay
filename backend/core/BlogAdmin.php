<?php

require_once('api/Okay.php');

class BlogAdmin extends Okay {
    
    public function fetch() {
        // Обработка действий
        if($this->request->method('post')) {
            // Действия с выбранными
            $ids = $this->request->post('check');
            if(is_array($ids)) {
                switch($this->request->post('action')) {
                    case 'disable': {
                        /*Выключение записей*/
                        $this->blog->update_post($ids, array('visible'=>0));
                        break;
                    }
                    case 'enable': {
                        /*Включение записей*/
                        $this->blog->update_post($ids, array('visible'=>1));
                        break;
                    }
                    case 'delete': {
                        /*Удаление записей*/
                        foreach($ids as $id) {
                            $this->blog->delete_post($id);
                        }
                        break;
                    }
                }
            }
        }
        
        $filter = array();
        $filter['page'] = max(1, $this->request->get('page', 'integer'));
        $filter['limit'] = 20;
        
        // Поиск
        $keyword = $this->request->get('keyword', 'string');
        if(!empty($keyword)) {
            $filter['keyword'] = $keyword;
            $this->design->assign('keyword', $keyword);
        }

        $type_post = $this->request->get('type_post', 'string');
        if(!empty($type_post)) {
            $filter['type_post'] = $type_post;
            $this->design->assign('type_post', $type_post);
        }
        
        $posts_count = $this->blog->count_posts($filter);
        // Показать все страницы сразу
        if($this->request->get('page') == 'all') {
            $filter['limit'] = $posts_count;
        }
        /*Выбираем записи*/
        $posts = $this->blog->get_posts($filter);
        $this->design->assign('posts_count', $posts_count);
        
        $this->design->assign('pages_count', ceil($posts_count/$filter['limit']));
        $this->design->assign('current_page', $filter['page']);
        
        $this->design->assign('posts', $posts);
        return $this->design->fetch('blog.tpl');
    }
    
}
