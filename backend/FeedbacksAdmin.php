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
                        foreach($ids as $id) {
                            $this->feedbacks->delete_feedback($id);
                        }
                        break;
                    }
                }
            }
        }
        if($this->request->method('post')) {
            if ($this->request->post('feedback_answer', 'boolean') && ($feedback_id = $this->feedbacks->get_feedback($this->request->post('feedback_id', 'integer')))) {
                $txt = $this->request->post('text');
                if (!empty($feedback_id)) {
                    $this->notify->email_feedback_answer_to_user($feedback_id->id,$txt);
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
        
        // счетчик новых сообщений
        $new_orders_counter = $this->orders->count_orders(array('status'=>0));
        $this->design->assign("new_orders_counter", $new_orders_counter);
        
        $new_comments_counter = $this->comments->count_comments(array('approved'=>0));
        $this->design->assign("new_comments_counter", $new_comments_counter);

        $new_feedbacks = $this->feedbacks->get_feedbacks(array('processed'=>0));
        $new_feedbacks_counter = count($new_feedbacks);
        $this->design->assign("new_feedbacks_counter", $new_feedbacks_counter);
        
        $new_callbacks = $this->callbacks->get_callbacks(array('processed'=>0));
        $new_callbacks_counter = count($new_callbacks);
        $this->design->assign("new_callbacks_counter", $new_callbacks_counter);
        
        return $this->design->fetch('feedbacks.tpl');
    }
    
}

?>
