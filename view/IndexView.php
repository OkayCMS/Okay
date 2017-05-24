<?php

require_once('View.php');

class IndexView extends View {
    
    public $modules_dir = 'view/';
    
    public function __construct() {
        parent::__construct();
    }
    
    public function fetch() {
        /*Принимаем данные с формы заказа обратного звонка*/
        if($this->request->method('post') && $this->request->post('callback')) {
            $callback = new stdClass();
            $callback->phone        = $this->request->post('phone');
            $callback->name         = $this->request->post('name');
            $callback->url          = 'http://'.$_SERVER['HTTP_HOST'].$_SERVER['REQUEST_URI'];
            $callback->message      = $this->request->post('message');
            
            $this->design->assign('callname',  $callback->name);
            $this->design->assign('callemail', $callback->phone);
            $this->design->assign('callmessage', $callback->message);

            /*Валидация данных клиента*/
            if (!$this->validate->is_name($callback->name, true)) {
                $this->design->assign('call_error', 'empty_name');
            } elseif(!$this->validate->is_phone($callback->phone, true)) {
                $this->design->assign('call_error', 'empty_phone');
            } elseif(!$this->validate->is_comment($callback->message)) {
                $this->design->assign('call_error', 'empty_comment');
            } elseif($callback_id = $this->callbacks->add_callback($callback)) {
                $this->design->assign('call_sent', true);
                // Отправляем email
                $this->callbacks->email_callback_admin($callback_id);
            } else {
                $this->design->assign('call_error', 'unknown error');
            }
        }
        
        /*E-mail подписка*/
        if ($this->request->post('subscribe')) {
            $email = $this->request->post('subscribe_email');
            $this->db->query("select count(id) as cnt from __subscribe_mailing where email=?", $email);
            $cnt = $this->db->result('cnt');
            if (!$this->validate->is_email($email, true)) {
                $this->design->assign('subscribe_error', 'empty_email');
            } elseif ($cnt > 0) {
                $this->design->assign('subscribe_error', 'email_exist');
            } else {
                $this->db->query("insert into __subscribe_mailing set email=?", $email);
                $this->design->assign('subscribe_success', '1');
            }
        }
        
        // Содержимое корзины
        $this->design->assign('cart', $this->cart->get_cart());
        
        // Избранное
        if($_COOKIE['wished_products']) {
            $wished = (array)explode(',', $_COOKIE['wished_products']);
        } else {
            $wished = array();
        }
        $this->design->assign('wished_products', ($wished[0] > 0) ? $wished : array());
        
        // Сравнение
        $this->design->assign('comparison', $this->comparison->get_comparison());
        
        // Категории товаров
        $this->count_visible($this->categories->get_categories_tree());
        $this->design->assign('categories', $this->categories->get_categories_tree());
        
        // Страницы
        $pages = $this->pages->get_pages(array('visible'=>1));
        $this->design->assign('pages', $pages);

        $is_mobile = $this->design->is_mobile();
        $is_tablet = $this->design->is_tablet();
        $this->design->assign('is_mobile',$is_mobile);
        $this->design->assign('is_tablet',$is_tablet);
        
        // Текущий модуль (для отображения центрального блока)
        $module = $this->request->get('module', 'string');
        $module = preg_replace("/[^A-Za-z0-9]+/", "", $module);
        
        // Если не задан - берем из настроек
        if(empty($module)) {
            return false;
        }
        
        // Создаем соответствующий класс
        if (is_file($this->modules_dir."$module.php")) {
            include_once($this->modules_dir."$module.php");
            if (class_exists($module)) {
                $this->main = new $module($this);
            } else {
                return false;
            }
        } else {
            return false;
        }
        
        // Создаем основной блок страницы
        if (!$content = $this->main->fetch()) {
            return false;
        }
        
        // Передаем основной блок в шаблон
        $this->design->assign('content', $content);
        
        // Передаем название модуля в шаблон, это может пригодиться
        $this->design->assign('module', $module);
        
        // Создаем текущую обертку сайта (обычно index.tpl)
        $wrapper = $this->design->get_var('wrapper');
        if(is_null($wrapper)) {
            $wrapper = 'index.tpl';
        }

        if(empty($_SESSION['admin'])) {
            if ($this->settings->site_work == "off") {
                header('HTTP/1.0 503 Service Temporarily Unavailable');
                header('Status: 503 Service Temporarily Unavailable');
                header('Retry-After: 300');//300 seconds
                return $this->design->fetch('tech.tpl');
            }
        }
        
        if(!empty($wrapper)) {
            return $this->body = $this->design->fetch($wrapper);
        } else {
            return $this->body = $content;
        }
    }

    /*Подсчет количества видимых дочерних категорий*/
    private function count_visible($categories = array()) {
        $all_categories = $this->categories->get_categories();
        foreach ($categories as $category) {
            $category->has_children_visible = 0;
            if ($category->parent_id && $category->visible) {
                $all_categories[$category->parent_id]->has_children_visible = 1;
            }
            if ($category->subcategories) {
                $this->count_visible($category->subcategories);
            }
        }
    }
    
}
