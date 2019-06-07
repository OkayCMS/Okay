<?php

require_once('api/Okay.php');

class ManagerAdmin extends Okay {
    
    public function fetch() {
        $manager = new stdClass();
        /*Прием информации о менеджере*/
        if($this->request->method('post')) {
            if ($this->request->post('reset_menu')) {
                $id = $this->request->post('id', 'integer');
                $this->managers->update_manager($id, array('menu'=>''));
                header('location: '.$this->config->root_url.'/backend/index.php?module=ManagerAdmin&id='.$id);
                exit();
            }
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

        $btr = $this->design->get_var('btr');
        /*Группировка списка доступов менеджера*/
        $permission = array(
            'left_catalog'  => array(
                'products'      => $btr->left_products_title,
                'categories'    => $btr->left_categories_title,
                'brands'        => $btr->left_brands_title,
                'features'      => $btr->left_features_title,
            ),
            'left_orders'   => array(
                'orders'        => $btr->left_orders,
                'order_settings'=> $btr->left_orders_settings_title,
            ),
            'left_users'    => array(
                'users'         => $btr->left_users,
                'groups'        => $btr->left_groups_title,
                'coupons'       => $btr->left_coupons_title,
                'subscribes'    => $btr->left_subscribe_title,
            ),
            'left_pages'    => array(
                'pages'         => $btr->left_pages,
                'menu'          => $btr->left_menus_title,
            ),
            'left_blog'     => array(
                'blog'          => $btr->left_blog,
            ),
            'left_comments' => array(
                'comments'      => $btr->left_comments_title,
                'feedbacks'     => $btr->left_feedbacks_title,
                'callbacks'     => $btr->left_callbacks_title,
            ),
            'left_auto'     => array(
                'import'        => $btr->left_import_title,
                'export'        => $btr->left_export_title,
                'integration_1c' => $btr->integration_1c,
            ),
            'left_stats'    => array(
                'stats'         => $btr->left_stats,
            ),
            'left_seo'      => array(
                'robots'              => $btr->left_robots_title,
                'settings_counter'    => $btr->left_setting_counter_title,
                'seo_patterns'        => $btr->left_seo_patterns_title,
                'seo_filter_patterns' => $btr->left_seo_filter_patterns_title,
                'features_aliases'    => $btr->left_feature_aliases_title,
            ),
            'left_support'  => array(
                'support'       => $btr->left_support,
            ),
            'left_design'   => array(
                'design'        => $btr->left_design,
            ),
            'left_banners'  => array(
                'banners'       => $btr->left_banners,
            ),
            'left_settings' => array(
                'settings'      => $btr->left_settings,
                'currency'      => $btr->left_currency_title,
                'delivery'      => $btr->left_delivery_title,
                'payment'       => $btr->left_payment_title,
                'managers'      => $btr->left_managers_title,
                'license'       => $btr->left_license_title,
                'languages'     => $btr->left_languages_title,
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
