<?php

require_once('api/Okay.php');

class FeedbacksAdmin extends Okay {
    
    public function fetch() {
        // Обработка действий
        if($this->request->method('post')) {
            // Действия с выбранными
            $ids = $this->request->post('check');
            if(!empty($ids)) {
                switch($this->request->post('action')) {
                    case 'delete': {
                        /*Удалить заявку с формы обратной связи*/
                        foreach($ids as $id) {
                            $this->feedbacks->delete_feedback($id);
                        }
                        break;
                    }
                }
            }
        }

        /*Ответ админисратора на заявку с формы обратной связи*/
        if($this->request->method('post')) {
            if ($this->request->post('feedback_answer', 'boolean') && ($feedback_id = $this->feedbacks->get_feedback($this->request->post('feedback_id', 'integer')))) {
                $txt = $this->request->post('text');
                if (!empty($feedback_id)) {
                    $new_feedback = new stdClass();
                    $new_feedback->is_admin = 1;
                    $new_feedback->message = $txt;
                    $new_feedback->email = $this->settings->notify_from_email;
                    $new_feedback->name = $this->settings->notify_from_name;
                    $new_feedback->processed = 1;
                    $new_feedback->ip = $_SERVER['REMOTE_ADDR'];
                    $new_feedback->lang_id = $_SESSION['admin_lang_id'];
                    $new_feedback->parent_id = $feedback_id->id;
                    $res = $this->feedbacks->add_feedback($new_feedback);
                    //$this->feedbacks->update_feedback($new_feedback->parent_id, array('is_admin'))
                    if($res) {
                        $this->notify->email_feedback_answer_to_user($feedback_id->id, $txt);
                    }
                }
            }
        }
        // Отображение
        $filter = array();
        $filter['page'] = max(1, $this->request->get('page', 'integer'));
        $filter['limit'] = 40;
        
        // Поиск
        $keyword = $this->request->get('keyword', 'string');
        if(!empty($keyword)) {
            $filter['keyword'] = $keyword;
            $this->design->assign('keyword', $keyword);
        }

        if (empty($keyword)) {
            $filter2 = $filter;
            $filter2['limit'] = 10000;
            $filter2['has_parent'] = true;
            $children = array();
            foreach ($this->feedbacks->get_feedbacks($filter2) as $feed) {
                $admin_answer[$feed->parent_id][] = $feed;
            }
            $this->design->assign('admin_answer', $admin_answer);
            $filter['has_parent'] = false;
        }

        
        $feedbacks_count = $this->feedbacks->count_feedbacks($filter);
        // Показать все страницы сразу
        if($this->request->get('page') == 'all') {
            $filter['limit'] = $feedbacks_count;
        }
        
        $feedbacks = $this->feedbacks->get_feedbacks($filter, true);
        
        $this->design->assign('pages_count', ceil($feedbacks_count/$filter['limit']));
        $this->design->assign('current_page', $filter['page']);
        
        $this->design->assign('feedbacks', $feedbacks);
        $this->design->assign('feedbacks_count', $feedbacks_count);
        
        return $this->design->fetch('feedbacks.tpl');
    }
    
}

?>