<?php

require_once('View.php');

class FeedbackView extends View {
    
    public function fetch() {
        $feedback = new stdClass;
        /*Принимаем заявку с формы обратной связи*/
        if($this->request->method('post') && $this->request->post('feedback')) {
            $feedback->name         = $this->request->post('name');
            $feedback->email        = $this->request->post('email');
            $feedback->message      = $this->request->post('message');
            $captcha_code           = $this->request->post('captcha_code');
            
            $this->design->assign('name',  $feedback->name);
            $this->design->assign('email', $feedback->email);
            $this->design->assign('message', $feedback->message);

            /*Валидация данных клиента*/
            if(!$this->validate->is_name($feedback->name, true)) {
                $this->design->assign('error', 'empty_name');
            } elseif(!$this->validate->is_email($feedback->email, true)) {
                $this->design->assign('error', 'empty_email');
            } elseif(!$this->validate->is_comment($feedback->message, true)) {
                $this->design->assign('error', 'empty_text');
            } elseif($this->settings->captcha_feedback && !$this->validate->verify_captcha('captcha_feedback', $captcha_code)) {
                $this->design->assign('error', 'captcha');
            } else {
                $this->design->assign('message_sent', true);
                
                $feedback->ip = $_SERVER['REMOTE_ADDR'];
                $feedback->lang_id = $_SESSION['lang_id'];
                $feedback_id = $this->feedbacks->add_feedback($feedback);
                
                // Отправляем email
                $this->notify->email_feedback_admin($feedback_id);
            }
        }
        
        if($this->page) {
            $this->design->assign('meta_title', $this->page->meta_title);
            $this->design->assign('meta_keywords', $this->page->meta_keywords);
            $this->design->assign('meta_description', $this->page->meta_description);
        }
        
        $body = $this->design->fetch('feedback.tpl');
        return $body;
    }
    
}
