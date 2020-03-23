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
            $captcha_code =  $this->request->post('captcha_code', 'string');
            
            $this->design->assign('callname',  $callback->name);
            $this->design->assign('callphone', $callback->phone);
            $this->design->assign('callmessage', $callback->message);

            /*Валидация данных клиента*/
            if (!$this->validate->is_name($callback->name, true)) {
                $this->design->assign('call_error', 'empty_name');
            } elseif(!$this->validate->is_phone($callback->phone, true)) {
                $this->design->assign('call_error', 'empty_phone');
            } elseif(!$this->validate->is_comment($callback->message)) {
                $this->design->assign('call_error', 'empty_comment');
            } elseif($this->settings->captcha_callback && !$this->validate->verify_captcha('captcha_callback', $captcha_code)) {
                $this->design->assign('call_error', 'captcha');
            } elseif($callback_id = $this->callbacks->add_callback($callback)) {
                $this->design->assign('call_sent', true);
                // Отправляем email
                $this->notify->email_callback_admin($callback_id);
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

        // Менюшки
        $menus = $this->menu->get_menus(array('visible'=>1));
        if (!empty($menus)) {
            foreach ($menus as $menu) {
                $this->design->assign("menu", $menu);
                $all_menu_items = $this->menu->get_menu_items();
                $this->count_visible($this->menu->get_menu_items_tree((int)$menu->id), $all_menu_items, 'submenus');
                $this->design->assign("menu_items", $this->menu->get_menu_items_tree((int)$menu->id));
                $this->design->assign(Menu::MENU_VAR_PREFIX.$menu->group_id, $this->design->fetch("menu.tpl"));
            }
        }
        
        if (!empty($_SESSION['admin']) && ($manager = $this->managers->get_manager())) {
            // Перевод админки
            $backend_translations = $this->backend_translations;
            $file = "backend/lang/".$manager->lang.".php";
            if (!file_exists($file)) {
                foreach (glob("backend/lang/??.php") as $f) {
                    $file = "backend/lang/".pathinfo($f, PATHINFO_FILENAME).".php";
                    break;
                }
            }
            require_once($file);
            $this->design->assign('btr', $backend_translations);
            $this->design->assign('admintooltip', $this->design->fetch($this->config->root_dir.'backend/design/html/admintooltip.tpl'));
        }
        
        // Пользовательские скриты из админки
        $counters = array();
        foreach ((array)$this->settings->counters as $c) {
            $counters[$c->position][] = $c;
        }
        $this->design->assign('counters', $counters);

        // Содержимое корзины
        $this->design->assign('cart', $this->cart->get_cart());
        
        // Избранное
        if(!empty($_COOKIE['wished_products'])) {
            $wished = (array)explode(',', $_COOKIE['wished_products']);
        } else {
            $wished = array();
        }

        $this->design->assign('wished_products', (!empty($wished) ? $wished : array()));
        
        // Сравнение
        $this->design->assign('comparison', $this->comparison->get_comparison());
        
        // Категории товаров
        $all_categories = $this->categories->get_categories();
        $this->count_visible($this->categories->get_categories_tree(), $all_categories);
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

    /*Подсчет количества видимых дочерних элементов*/
    private function count_visible($items = array(), $all_items, $subitems_name = 'subcategories') {
        foreach ($items as $item) {
            if ($item->parent_id > 0 && !isset($all_items[$item->parent_id]->count_children_visible)) {
                $all_items[$item->parent_id]->count_children_visible = 0;
            }
            if ($item->parent_id && $item->visible) {
                $all_items[$item->parent_id]->count_children_visible++;
            }
            if (!empty($item->{$subitems_name})) {
                $this->count_visible($item->{$subitems_name}, $all_items, $subitems_name);
            }
        }
    }
    
}
