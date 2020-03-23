<?php

use PHPMailer\PHPMailer\PHPMailer;

class Notify extends Okay {

    /* SMTP отправка емейла*/
    public function SMTP($to, $subject, $message) {
        $mail = new PHPMailer();
        $mail->IsSMTP(); // telling the class to use SMTP
        $mail->Host       = $this->settings->smtp_server;
        $mail->SMTPDebug  = 0;
        $mail->SMTPAuth   = true;
        $mail->CharSet    = 'utf-8';
        $mail->Port       = $this->settings->smtp_port;
        if ($mail->Port == 465) {
            $mail->SMTPSecure = "ssl";
            // Добавляем протокол, если не указали
            $mail->Host = (strpos($mail->Host, "ssl://") === false) ? "ssl://".$mail->Host : $mail->Host;
        }
        $mail->Username   = $this->settings->smtp_user;
        $mail->Password   = $this->settings->smtp_pass;
        $mail->SetFrom($this->settings->smtp_user, $this->settings->notify_from_name);
        $mail->AddReplyTo($this->settings->smtp_user, $this->settings->notify_from_name);
        $mail->Subject    = $subject;

        $mail->MsgHTML($message);
        $mail->addCustomHeader("MIME-Version: 1.0\n");

        $recipients = explode(',',$to);
        if (!empty($recipients)) {
            foreach ($recipients as $i=>$r) {
                $mail->AddAddress($r);
            }
        } else {
            $mail->AddAddress($to);
        }

        if (!$mail->Send()) {
            //file_put_contents('error_log.txt',$mail->ErrorInfo);
        }
    }

    /*Отправка емейла*/
    public function email($to, $subject, $message, $from = '', $reply_to = '') {
        $headers = "MIME-Version: 1.0\n" ;
        $headers .= "Content-type: text/html; charset=utf-8; \r\n";
        $headers .= "From: $from\r\n";
        if(!empty($reply_to)) {
            $headers .= "reply-to: $reply_to\r\n";
        }
        
        $subject = "=?utf-8?B?".base64_encode($subject)."?=";

        if ($this->settings->use_smtp) {
            $this->SMTP($to, $subject, $message);
        } else {
            mail($to, $subject, $message, $headers);
        }
    }

    /*Отправка емейла клиенту о заказе*/
    public function email_order_user($order_id) {
        if(!($order = $this->orders->get_order(intval($order_id))) || empty($order->email)) {
            return false;
        }
        
        /*lang_modify...*/
        $entity_language = $this->languages->get_language(intval($order->lang_id));
        if (!empty($entity_language)) {
            $cur_lang_id = $this->languages->lang_id();
            $this->languages->set_lang_id($entity_language->id);
            $this->design->assign('lang_link', $this->languages->get_lang_link());
            $this->money->init_currencies();
            $this->design->assign("currency", $this->money->get_currency());
            $this->settings->init_settings();
            $this->design->assign('settings', $this->settings);
            $this->translations->debug = (bool)$this->config->debug_translation;
            $this->design->assign('lang', $this->translations->get_translations(array('lang'=>$entity_language->label)));
        }
        /*/lang_modify...*/
        
        $purchases = $this->orders->get_purchases(array('order_id'=>$order->id));
        
        $products_ids = array();
        $variants_ids = array();
        foreach($purchases as $purchase) {
            $products_ids[] = $purchase->product_id;
            $variants_ids[] = $purchase->variant_id;
        }
        
        $products = array();
        $images_ids = array();
        foreach($this->products->get_products(array('id'=>$products_ids,'limit' => count($products_ids))) as $p) {
            $products[$p->id] = $p;
            $images_ids[] = $p->main_image_id;
        }

        if (!empty($images_ids)) {
            $images = $this->products->get_images(array('id'=>$images_ids));
            foreach ($images as $image) {
                if (isset($products[$image->product_id])) {
                    $products[$image->product_id]->image = $image;
                }
            }
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
        $order_status = $this->orderstatus->get_status(array("status"=>intval($order->status_id)));
        $this->design->assign('order_status', reset($order_status));
        
        // Отправляем письмо
        // Если в шаблон не передавалась валюта, передадим
        if ($this->design->smarty->getTemplateVars('currency') === null) {
            $this->design->assign('currency', current($this->money->get_currencies(array('enabled'=>1))));
        }
        $email_template = $this->design->fetch($this->config->root_dir.'design/'.$this->settings->theme.'/html/email/email_order.tpl');
        $subject = $this->design->get_var('subject');
        $from = ($this->settings->notify_from_name ? $this->settings->notify_from_name." <".$this->settings->notify_from_email.">" : $this->settings->notify_from_email);
        $this->email($order->email, $subject, $email_template, $from);
        
        /*lang_modify...*/
        if (!empty($entity_language)) {
            $this->languages->set_lang_id($cur_lang_id);
            $this->design->assign('lang_link', $this->languages->get_lang_link());
            $this->money->init_currencies();
            $this->design->assign("currency", $this->money->get_currency());
            $this->settings->init_settings();
            $this->design->assign('settings', $this->settings);
        }
        /*/lang_modify...*/
    }

    /*Отправка емейла о заказе администратору*/
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
        $images_ids = array();
        foreach($this->products->get_products(array('id'=>$products_ids,'limit' => count($products_ids))) as $p) {
            $products[$p->id] = $p;
            $images_ids[] = $p->main_image_id;
        }

        if (!empty($images_ids)) {
            $images = $this->products->get_images(array('id'=>$images_ids));
            foreach ($images as $image) {
                if (isset($products[$image->product_id])) {
                    $products[$image->product_id]->image = $image;
                }
            }
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
        $order_status = $this->orderstatus->get_status(array("status"=>intval($order->status_id)));
        $this->design->assign('order_status', reset($order_status));
        // В основной валюте
        $this->design->assign('main_currency', $this->money->get_currency());

        // Перевод админки
        $backend_translations = $this->backend_translations;
        $file = "backend/lang/".$this->settings->email_lang.".php";
        if (!file_exists($file)) {
            foreach (glob("backend/lang/??.php") as $f) {
                $file = "backend/lang/".pathinfo($f, PATHINFO_FILENAME).".php";
                break;
            }
        }
        require_once($file);
        $this->design->assign('btr', $backend_translations);
        
        // Отправляем письмо
        $email_template = $this->design->fetch($this->config->root_dir.'backend/design/html/email/email_order_admin.tpl');
        $subject = $this->design->get_var('subject');
        $this->email($this->settings->order_email, $subject, $email_template, $this->settings->notify_from_email);
    
    }

    /*Отправка емейла о комментарии администратору*/
    public function email_comment_admin($comment_id) {
        if(!($comment = $this->comments->get_comment(intval($comment_id)))) {
            return false;
        }
        
        if($comment->type == 'product') {
            $comment->product = $this->products->get_product(intval($comment->object_id));
        }
        if($comment->type == 'blog') {
            $comment->post = $this->blog->get_post(intval($comment->object_id), 'blog');
        } elseif ($comment->type == 'news') {
            $comment->post = $this->blog->get_post(intval($comment->object_id), 'news');
        }
        
        $this->design->assign('comment', $comment);
        // Перевод админки
        $backend_translations = $this->backend_translations;
        $file = "backend/lang/".$this->settings->email_lang.".php";
        if (!file_exists($file)) {
            foreach (glob("backend/lang/??.php") as $f) {
                $file = "backend/lang/".pathinfo($f, PATHINFO_FILENAME).".php";
                break;
            }
        }
        require_once($file);
        $this->design->assign('btr', $backend_translations);
        // Отправляем письмо
        $email_template = $this->design->fetch($this->config->root_dir.'backend/design/html/email/email_comment_admin.tpl');
        $subject = $this->design->get_var('subject');
        $this->email($this->settings->comment_email, $subject, $email_template, $this->settings->notify_from_email);
    }

    /*Отправка емейла администратору о заказе обратного звонка*/
    public function email_callback_admin($callback_id) {
        if(!($callback = $this->callbacks->get_callback(intval($callback_id)))) {
            return false;
        }
        $this->design->assign('callback', $callback);
        $backend_translations = $this->backend_translations;
        $file = "backend/lang/".$this->settings->email_lang.".php";
        if (!file_exists($file)) {
            foreach (glob("backend/lang/??.php") as $f) {
                $file = "backend/lang/".pathinfo($f, PATHINFO_FILENAME).".php";
                break;
            }
        }
        require_once($file);
        $this->design->assign('btr', $backend_translations);
        // Отправляем письмо
        $email_template = $this->design->fetch($this->config->root_dir.'backend/design/html/email/email_callback_admin.tpl');
        $subject = $this->design->get_var('subject');
        $this->notify->email($this->settings->comment_email, $subject, $email_template, "$callback->name <$callback->phone>", "$callback->name <$callback->phone>");
    }

    /*Отправка емейла с ответом на комментарий клиенту*/
    public function email_comment_answer_to_user($comment_id) {
        if(!($comment = $this->comments->get_comment(intval($comment_id)))
                || !($parent_comment = $this->comments->get_comment(intval($comment->parent_id)))
                || !$parent_comment->email) {
            return false;
        }

        /*lang_modify...*/
        $entity_language = $this->languages->get_language(intval($parent_comment->lang_id));
        if (!empty($entity_language)) {
            $cur_lang_id = $this->languages->lang_id();
            $this->languages->set_lang_id($entity_language->id);
            $this->design->assign('lang_link', $this->languages->get_lang_link());
            $this->settings->init_settings();
            $this->design->assign('settings', $this->settings);
            $this->translations->debug = (bool)$this->config->debug_translation;
            $this->design->assign('lang', $this->translations->get_translations(array('lang'=>$entity_language->label)));
        }
        /*/lang_modify...*/

        if($comment->type == 'product') {
            $comment->product = $parent_comment->product = $this->products->get_product(intval($comment->object_id));
        }
        if($comment->type == 'blog') {
            $comment->post = $parent_comment->post = $this->blog->get_post(intval($comment->object_id));
        }
        if($comment->type == 'news') {
            $comment->post = $parent_comment->post = $this->blog->get_post(intval($comment->object_id));
        }

        $this->design->assign('comment', $comment);
        $this->design->assign('parent_comment', $parent_comment);

        // Отправляем письмо
        $email_template = $this->design->fetch($this->config->root_dir.'design/'.$this->settings->theme.'/html/email/email_comment_answer_to_user.tpl');
        $subject = $this->design->get_var('subject');
        $from = ($this->settings->notify_from_name ? $this->settings->notify_from_name." <".$this->settings->notify_from_email.">" : $this->settings->notify_from_email);
        $this->email($parent_comment->email, $subject, $email_template, $from, $from);

        /*lang_modify...*/
        if (!empty($entity_language)) {
            $this->languages->set_lang_id($cur_lang_id);
            $this->design->assign('lang_link', $this->languages->get_lang_link());
            $this->settings->init_settings();
            $this->design->assign('settings', $this->settings);
        }
        /*/lang_modify...*/
    }

    /*Отправка емейла о восстановлении пароля клиенту*/
    public function email_password_remind($user_id, $code) {
        if(!($user = $this->users->get_user(intval($user_id)))) {
            return false;
        }
        
        $this->design->assign('user', $user);
        $this->design->assign('code', $code);
        
        // Отправляем письмо
        $email_template = $this->design->fetch($this->config->root_dir.'design/'.$this->settings->theme.'/html/email/email_password_remind.tpl');
        $subject = $this->design->get_var('subject');
        $from = ($this->settings->notify_from_name ? $this->settings->notify_from_name." <".$this->settings->notify_from_email.">" : $this->settings->notify_from_email);
        $this->email($user->email, $subject, $email_template, $from);
        
        $this->design->smarty->clearAssign('user');
        $this->design->smarty->clearAssign('code');
    }

    /*Отправка емейла о заявке с формы обратной связи администратору*/
    public function email_feedback_admin($feedback_id) {
        if(!($feedback = $this->feedbacks->get_feedback(intval($feedback_id)))) {
            return false;
        }
        
        $this->design->assign('feedback', $feedback);
        // Перевод админки
        $backend_translations = $this->backend_translations;
        $file = "backend/lang/".$this->settings->email_lang.".php";
        if (!file_exists($file)) {
            foreach (glob("backend/lang/??.php") as $f) {
                $file = "backend/lang/".pathinfo($f, PATHINFO_FILENAME).".php";
                break;
            }
        }
        require_once($file);
        $this->design->assign('btr', $backend_translations);
        // Отправляем письмо
        $email_template = $this->design->fetch($this->config->root_dir.'backend/design/html/email/email_feedback_admin.tpl');
        $subject = $this->design->get_var('subject');
        $this->email($this->settings->comment_email, $subject, $email_template, "$feedback->name <$feedback->email>", "$feedback->name <$feedback->email>");
    }

    /*Отправка емейла с ответом на заявку с формы обратной связи клиенту*/
    public function email_feedback_answer_to_user($comment_id,$text) {
        if(!($feedback = $this->feedbacks->get_feedback(intval($comment_id)))) {
            return false;
        }

        /*lang_modify...*/
        $entity_language = $this->languages->get_language(intval($feedback->lang_id));
        if (!empty($entity_language)) {
            $cur_lang_id = $this->languages->lang_id();
            $this->languages->set_lang_id($entity_language->id);
            $this->design->assign('lang_link', $this->languages->get_lang_link());
            $this->translations->debug = (bool)$this->config->debug_translation;
            $this->design->assign('lang', $this->translations->get_translations(array('lang'=>$entity_language->label)));
        }
        /*/lang_modify...*/

        $this->design->assign('feedback', $feedback);
        $this->design->assign('text', $text);

        // Отправляем письмо
        $email_template = $this->design->fetch($this->config->root_dir.'design/'.$this->settings->theme.'/html/email/email_feedback_answer_to_user.tpl');
        $subject = $this->design->get_var('subject');
        $from = ($this->settings->notify_from_name ? $this->settings->notify_from_name." <".$this->settings->notify_from_email.">" : $this->settings->notify_from_email);
        $this->email($feedback->email, $subject, $email_template, $from, $from);

        /*lang_modify...*/
        if (!empty($entity_language)) {
            $this->languages->set_lang_id($cur_lang_id);
            $this->design->assign('lang_link', $this->languages->get_lang_link());
        }
        /*/lang_modify...*/
    }

    /*Отправка емейла на восстановление пароля администратора*/
    public function password_recovery_admin($email, $code){
        if(empty($email) || empty($code)){
            return false;
        }

        // Перевод админки
        $backend_translations = $this->backend_translations;
        $file = "backend/lang/".$this->settings->email_lang.".php";
        if (!file_exists($file)) {
            foreach (glob("backend/lang/??.php") as $f) {
                $file = "backend/lang/".pathinfo($f, PATHINFO_FILENAME).".php";
                break;
            }
        }
        require_once($file);
        $this->design->assign('btr', $backend_translations);
        $this->design->assign('code',$code);
        $this->design->assign('recovery_url', $this->config->root_url.'/backend/index.php?module=AuthAdmin&code='.$code);
        $email_template = $this->design->fetch($this->config->root_dir.'backend/design/html/email/email_admin_recovery.tpl');
        $subject = $this->design->get_var('subject');
        $from = ($this->settings->notify_from_name ? $this->settings->notify_from_name." <".$this->settings->notify_from_email.">" : $this->settings->notify_from_email);
        $this->email($email, $subject, $email_template, $from, $from);
        return true;

    }
    
}
