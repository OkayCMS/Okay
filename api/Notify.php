<?php

class Notify extends Okay {
    
    public function email($to, $subject, $message, $from = '', $reply_to = '') {
        $headers = "MIME-Version: 1.0\n" ;
        $headers .= "Content-type: text/html; charset=utf-8; \r\n";
        $headers .= "From: $from\r\n";
        if(!empty($reply_to)) {
            $headers .= "reply-to: $reply_to\r\n";
        }
        
        $subject = "=?utf-8?B?".base64_encode($subject)."?=";
        
        @mail($to, $subject, $message, $headers);
    }
    
    public function email_order_user($order_id) {
        if(!($order = $this->orders->get_order(intval($order_id))) || empty($order->email)) {
            return false;
        }
        
        /*lang_modify...*/
        $languages = $this->languages->languages();
        if (!empty($order->lang_id) && isset($languages[$order->lang_id])) {
            $cur_lang_id = $this->languages->lang_id();
            $this->languages->set_lang_id($order->lang_id);
            $lang_link = '';
            $f_lang = reset($languages);
            if ($order->lang_id != $f_lang->id) {
                $lang_link = $languages[$order->lang_id]->label . '/';
            }
            $this->design->assign('lang_link', $lang_link);
            $this->money->init_currencies();
            $this->design->assign("currency", $this->money->get_currency());
            $this->translations->init_translations();
            $this->design->assign('lang', $this->translations);
        }
        /*/lang_modify...*/
        
        $purchases = $this->orders->get_purchases(array('order_id'=>$order->id));
        $this->design->assign('purchases', $purchases);
        
        $products_ids = array();
        $variants_ids = array();
        foreach($purchases as $purchase) {
            $products_ids[] = $purchase->product_id;
            $variants_ids[] = $purchase->variant_id;
        }
        
        $products = array();
        foreach($this->products->get_products(array('id'=>$products_ids,'limit' => count($products_ids))) as $p) {
            $products[$p->id] = $p;
        }
        
        $images = $this->products->get_images(array('product_id'=>$products_ids));
        foreach($images as $image) {
            $products[$image->product_id]->images[] = $image;
        }
        
        $variants = array();
        foreach($this->variants->get_variants(array('id'=>$variants_ids)) as $v) {
            $variants[$v->id] = $v;
            $products[$v->product_id]->variants[] = $v;
        }
        
        foreach($purchases as $purchase) {
            if(!empty($products[$purchase->product_id])) {
                $purchase->product = $products[$purchase->product_id];
            }
            if(!empty($variants[$purchase->variant_id])) {
                $purchase->variant = $variants[$purchase->variant_id];
            }
        }
        
        // Способ доставки
        $delivery = $this->delivery->get_delivery($order->delivery_id);
        $this->design->assign('delivery', $delivery);
        
        $this->design->assign('order', $order);
        $this->design->assign('purchases', $purchases);
        
        // Отправляем письмо
        // Если в шаблон не передавалась валюта, передадим
        if ($this->design->smarty->getTemplateVars('currency') === null) {
            $this->design->assign('currency', current($this->money->get_currencies(array('enabled'=>1))));
        }
        $email_template = $this->design->fetch($this->config->root_dir.'design/'.$this->settings->theme.'/html/email_order.tpl');
        $subject = $this->design->get_var('subject');
        $from = ($this->settings->notify_from_name ? $this->settings->notify_from_name." <".$this->settings->notify_from_email.">" : $this->settings->notify_from_email);
        $this->email($order->email, $subject, $email_template, $from);
        
        /*lang_modify...*/
        if (!empty($order->lang_id) && isset($languages[$order->lang_id])) {
            $this->languages->set_lang_id($cur_lang_id);
            $lang_link = '';
            $f_lang = reset($languages);
            if ($order->lang_id != $f_lang->id) {
                $lang_link = $languages[$order->lang_id]->label . '/';
            }
            $this->design->assign('lang_link', $lang_link);
            $this->money->init_currencies();
            $this->design->assign("currency", $this->money->get_currency());
            $this->translations->init_translations();
            $this->design->assign('lang', $this->translations);
        }
        /*/lang_modify...*/
    }
    
    public function email_order_admin($order_id) {
        if(!($order = $this->orders->get_order(intval($order_id)))) {
            return false;
        }
        
        $purchases = $this->orders->get_purchases(array('order_id'=>$order->id));
        $this->design->assign('purchases', $purchases);
        
        $products_ids = array();
        $variants_ids = array();
        foreach($purchases as $purchase) {
            $products_ids[] = $purchase->product_id;
            $variants_ids[] = $purchase->variant_id;
        }
        
        $products = array();
        foreach($this->products->get_products(array('id'=>$products_ids,'limit' => count($products_ids))) as $p) {
            $products[$p->id] = $p;
        }
        
        $images = $this->products->get_images(array('product_id'=>$products_ids));
        foreach($images as $image) {
            $products[$image->product_id]->images[] = $image;
        }
        
        $variants = array();
        foreach($this->variants->get_variants(array('id'=>$variants_ids)) as $v) {
            $variants[$v->id] = $v;
            $products[$v->product_id]->variants[] = $v;
        }
        
        foreach($purchases as $purchase) {
            if(!empty($products[$purchase->product_id])) {
                $purchase->product = $products[$purchase->product_id];
            }
            if(!empty($variants[$purchase->variant_id])) {
                $purchase->variant = $variants[$purchase->variant_id];
            }
        }
        
        // Способ доставки
        $delivery = $this->delivery->get_delivery($order->delivery_id);
        $this->design->assign('delivery', $delivery);
        
        // Пользователь
        $user = $this->users->get_user(intval($order->user_id));
        $this->design->assign('user', $user);
        
        $this->design->assign('order', $order);
        $this->design->assign('purchases', $purchases);
        
        // В основной валюте
        $this->design->assign('main_currency', $this->money->get_currency());
        
        // Отправляем письмо
        $email_template = $this->design->fetch($this->config->root_dir.'backend/design/html/email_order_admin.tpl');
        $subject = $this->design->get_var('subject');
        $this->email($this->settings->order_email, $subject, $email_template, $this->settings->notify_from_email);
    
    }
    
    public function email_comment_admin($comment_id) {
        if(!($comment = $this->comments->get_comment(intval($comment_id)))) {
            return false;
        }
        
        if($comment->type == 'product') {
            $comment->product = $this->products->get_product(intval($comment->object_id));
        }
        if($comment->type == 'blog') {
            $comment->post = $this->blog->get_post(intval($comment->object_id));
        }
        
        $this->design->assign('comment', $comment);
        
        // Отправляем письмо
        $email_template = $this->design->fetch($this->config->root_dir.'backend/design/html/email_comment_admin.tpl');
        $subject = $this->design->get_var('subject');
        $this->email($this->settings->comment_email, $subject, $email_template, $this->settings->notify_from_email);
    }

    public function email_comment_answer_to_user($comment_id) {
        if(!($comment = $this->comments->get_comment(intval($comment_id)))
                || !($parent_comment = $this->comments->get_comment(intval($comment->parent_id)))
                || !$parent_comment->email) {
            return false;
        }

        /*lang_modify...*/
        $languages = $this->languages->languages();
        if (!empty($parent_comment->lang_id) && isset($languages[$parent_comment->lang_id])) {
            $cur_lang_id = $this->languages->lang_id();
            $this->languages->set_lang_id($parent_comment->lang_id);
            $lang_link = '';
            $f_lang = reset($languages);
            if ($parent_comment->lang_id != $f_lang->id) {
                $lang_link = $languages[$parent_comment->lang_id]->label . '/';
            }
            $this->design->assign('lang_link', $lang_link);
            $this->translations->init_translations();
            $this->design->assign('lang', $this->translations);
        }
        /*/lang_modify...*/

        if($comment->type == 'product') {
            $comment->product = $parent_comment->product = $this->products->get_product(intval($comment->object_id));
        }
        if($comment->type == 'blog') {
            $comment->post = $parent_comment->post = $this->blog->get_post(intval($comment->object_id));
        }

        $this->design->assign('comment', $comment);
        $this->design->assign('parent_comment', $parent_comment);

        // Отправляем письмо
        $email_template = $this->design->fetch($this->config->root_dir.'design/'.$this->settings->theme.'/html/email_comment_answer_to_user.tpl');
        $subject = $this->design->get_var('subject');
        $from = ($this->settings->notify_from_name ? $this->settings->notify_from_name." <".$this->settings->notify_from_email.">" : $this->settings->notify_from_email);
        $this->email($parent_comment->email, $subject, $email_template, $from, $from);

        /*lang_modify...*/
        if (!empty($parent_comment->lang_id) && isset($languages[$parent_comment->lang_id])) {
            $this->languages->set_lang_id($cur_lang_id);
            $lang_link = '';
            $f_lang = reset($languages);
            if ($parent_comment->lang_id != $f_lang->id) {
                $lang_link = $languages[$parent_comment->lang_id]->label . '/';
            }
            $this->design->assign('lang_link', $lang_link);
            $this->translations->init_translations();
            $this->design->assign('lang', $this->translations);
        }
        /*/lang_modify...*/
    }
    
    public function email_password_remind($user_id, $code) {
        if(!($user = $this->users->get_user(intval($user_id)))) {
            return false;
        }
        
        $this->design->assign('user', $user);
        $this->design->assign('code', $code);
        
        // Отправляем письмо
        $email_template = $this->design->fetch($this->config->root_dir.'design/'.$this->settings->theme.'/html/email_password_remind.tpl');
        $subject = $this->design->get_var('subject');
        $from = ($this->settings->notify_from_name ? $this->settings->notify_from_name." <".$this->settings->notify_from_email.">" : $this->settings->notify_from_email);
        $this->email($user->email, $subject, $email_template, $from);
        
        $this->design->smarty->clearAssign('user');
        $this->design->smarty->clearAssign('code');
    }
    
    public function email_feedback_admin($feedback_id) {
        if(!($feedback = $this->feedbacks->get_feedback(intval($feedback_id)))) {
            return false;
        }
        
        $this->design->assign('feedback', $feedback);
        
        // Отправляем письмо
        $email_template = $this->design->fetch($this->config->root_dir.'backend/design/html/email_feedback_admin.tpl');
        $subject = $this->design->get_var('subject');
        $this->email($this->settings->comment_email, $subject, $email_template, "$feedback->name <$feedback->email>", "$feedback->name <$feedback->email>");
    }

    public function email_feedback_answer_to_user($comment_id,$text) {
        if(!($feedback = $this->feedbacks->get_feedback(intval($comment_id)))) {
            return false;
        }

        /*lang_modify...*/
        $languages = $this->languages->languages();
        if (!empty($feedback->lang_id) && isset($languages[$feedback->lang_id])) {
            $cur_lang_id = $this->languages->lang_id();
            $this->languages->set_lang_id($feedback->lang_id);
            $lang_link = '';
            $f_lang = reset($languages);
            if ($feedback->lang_id != $f_lang->id) {
                $lang_link = $languages[$feedback->lang_id]->label . '/';
            }
            $this->design->assign('lang_link', $lang_link);
            $this->money->init_currencies();
            $this->design->assign("currency", $this->money->get_currency());
            $this->translations->init_translations();
            $this->design->assign('lang', $this->translations);
        }
        /*/lang_modify...*/

        $this->design->assign('feedback', $feedback);
        $this->design->assign('text', $text);

        // Отправляем письмо
        $email_template = $this->design->fetch($this->config->root_dir.'design/'.$this->settings->theme.'/html/email_feedback_answer_to_user.tpl');
        $subject = $this->design->get_var('subject');
        $from = ($this->settings->notify_from_name ? $this->settings->notify_from_name." <".$this->settings->notify_from_email.">" : $this->settings->notify_from_email);
        $this->email($feedback->email, $subject, $email_template, $from, $from);

        /*lang_modify...*/
        if (!empty($feedback->lang_id) && isset($languages[$feedback->lang_id])) {
            $this->languages->set_lang_id($cur_lang_id);
            $lang_link = '';
            $f_lang = reset($languages);
            if ($feedback->lang_id != $f_lang->id) {
                $lang_link = $languages[$feedback->lang_id]->label . '/';
            }
            $this->design->assign('lang_link', $lang_link);
            $this->money->init_currencies();
            $this->design->assign("currency", $this->money->get_currency());
            $this->translations->init_translations();
            $this->design->assign('lang', $this->translations);
        }
        /*/lang_modify...*/
    }
    
}
