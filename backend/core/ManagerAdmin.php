<?php

require_once('api/Okay.php');

class ManagerAdmin extends Okay {
    
    public function fetch() {
        $manager = new stdClass();
        /*Прием информации о менеджере*/
        if($this->request->method('post')) {
            $manager->id = $this->request->post('id', 'integer');
            $manager->lang = $this->request->post('manager_lang');
            $manager->comment = $this->request->post('comment');
            $manager->menu_status = $this->request->post('menu_status','integer');
            if ($this->request->post('unlock_manager')) {
                $this->managers->update_manager($manager->id, array('cnt_try'=>0));
                $id = $this->request->get('id', 'integer');
                if(!empty($id)) {
                    $manager = $this->managers->get_manager($id);
                }
            } else {
                $manager->login = $this->request->post('login');

                if(empty($manager->login)) {
                    $this->design->assign('message_error', 'empty_login');
                } elseif(($m = $this->managers->get_manager($manager->login)) && $m->id!=$manager->id) {
                    $manager->permissions = (array)$this->request->post('permissions');
                    $this->design->assign('message_error', 'login_exists');
                } else {
                    if($this->request->post('password') != "" && $this->request->post('password') == $this->request->post('password_check')) {
                        $manager->password = $this->request->post('password');
                    } elseif($this->request->post('password') != $this->request->post('password_check')) {
                        $this->design->assign('message_error', 'password_wrong');
                    }

                    // Обновляем права только другим менеджерам
                    $current_manager = $this->managers->get_manager();
                    if($manager->id != $current_manager->id) {
                        $manager->permissions = (array)$this->request->post('permissions');
                    }

                    /*Добавление/Обновление менеджера*/
                    if(empty($manager->id)) {
                        $manager->id = $this->managers->add_manager($manager);
                        $this->design->assign('message_success', 'added');
                    } else {
                        $this->managers->update_manager($manager->id, $manager);
                        $this->design->assign('message_success', 'updated');
                        if ($manager->lang != $m->lang) {
                            header('location: '.$this->config->root_url.'/backend/index.php?module=ManagerAdmin&id='.$manager->id);
                            exit();
                        }
                    }
                    $manager = $this->managers->get_manager($manager->login);
                }
            }
        } else {
            $id = $this->request->get('id', 'integer');
            if(!empty($id)) {
                $manager = $this->managers->get_manager($id);
            }
        }

        /*Группировка списка доступов менеджера*/
        $permission = array(
            'left_catalog' => array(
                'products'     => 'Товары',
                'categories'   => 'Категории',
                'brands'       => 'Бренды',
                'features'     => 'Свойства',
            ),
            'left_orders' => array(
                'orders'     => 'Заказы',
                'order_settings'     => 'Настройки заказов',
            ),
            'left_users' => array(
                'users'      => 'Пользователи',
                'groups'     => 'Группы пользователей',
                'coupons'    => 'Купоны',
            ),
            'left_pages' => array(
                'pages'      => 'Страницы',
            ),
            'left_blog' => array(
                'blog'       => 'Блог',
            ),
            'left_comments' => array(
                'comments'   => 'Комментарии',
                'feedbacks'   => 'Обратная связь',
                'callbacks' => 'Заявки обратного звонка'
            ),
            'left_auto' => array(
                'import'     => 'Импорт',
                'export'     => 'Экспорт',
            ),
            'left_stats' => array(
                'stats'      => 'Статистика',
                'yametrika' => 'Яндекс метрика'
            ),
            'left_seo' => array(
                'seo_patterns' => 'Автоматизация SEO'
            ),
            'left_support' => array(
                'support' => 'Техподдержка'
            ),
            'left_design' => array(
                'design'      => 'Дизайн',
                'robots'    => 'Rotbots.txt'
            ),
            'left_banners' => array(
                'banners' => 'Баннера',
            ),
            'left_settings' => array(
                'settings'   => 'Настройки',
                'currency'   => 'Валюты',
                'delivery'   => 'Способы доставки',
                'payment'    => 'Способы оплаты',
                'managers'   => 'Менеджеры',
                'license'    => 'Лицензия',
                'languages'  => 'Языки',
            ),
        );

        $btr_languages = array();
        foreach ($this->languages->lang_list() as $label=>$l) {
            if (file_exists("backend/lang/".$label.".php")) {
                $btr_languages[$l->name] = $l->label;
            }
        }
        $this->design->assign('btr_languages', $btr_languages);
        $this->design->assign('m', $manager);
        $this->design->assign('permission', $permission);

        return $this->design->fetch('manager.tpl');
    }
    
}
