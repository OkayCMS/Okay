<?php

require_once('api/Okay.php');

class LanguagesAdmin extends Okay {
    
    public function fetch() {
        // Обработка действий
        if($this->request->method('post')) {
            // Действия с выбранными
            $ids = $this->request->post('check');
            if(is_array($ids)) {
                switch($this->request->post('action')) {
                    case 'delete': {
                        foreach($ids as $id) {
                            $this->languages->delete_language($id);
                        }
                        break;
                    }
                    case 'disable': {
                        $this->languages->update_language($ids, array('enabled'=>0));
                        break;
                    }
                    case 'enable': {
                        $this->languages->update_language($ids, array('enabled'=>1));
                        break;
                    }
                }
            }
            
            // Сортировка
            $positions = $this->request->post('positions');
            foreach($positions as $position=>$id) {
                $this->languages->update_language($id, array('position'=>$position+1));
            }
        }
        
        $this->db->query("SHOW TABLES LIKE '%__languages%'");
        $exist = $this->db->result();
        
        $debug='';
        if($debug) {
            print '<div style="background-color: #FFFFCC; position: absolute; z-index: 99" align="left"><pre>';
            print_r($exist);
            print '</pre></div><br />';
        }
        
        //$this->db->query("DROP TABLE s_languages");
        
        if($_GET['install'] && empty($exist)) {
            //$this->db->query('CREATE TABLE IF NOT EXISTS `s_languages` (`id` int(11) NOT NULL AUTO_INCREMENT, `name` varchar(255) NOT NULL, `label` varchar(10) NOT NULL, `is_default` tinyint(1) NOT NULL, PRIMARY KEY (`id`)) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=0;');
            $this->db->query("CREATE TABLE IF NOT EXISTS `s_languages` (
                    `id` int(11) NOT NULL AUTO_INCREMENT,
                    `name` varchar(255) NOT NULL,
                    `label` varchar(10) NOT NULL,
                    `is_default` tinyint(1) NOT NULL,
                    `enabled` tinyint(4) NOT NULL DEFAULT '0',
                    `position` int(11) NOT NULL,
                    PRIMARY KEY (`id`)
                ) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=0;");
            
            // Переводы
            $this->db->query("CREATE TABLE IF NOT EXISTS `s_translations` (
                    `id` int(11) NOT NULL AUTO_INCREMENT,
                    `template` varchar(255) NOT NULL,
                    `in_config` tinyint(1) NOT NULL,
                    `label` varchar(255) NOT NULL,
                    `lang_ru` varchar(255) NOT NULL,
                    `lang_en` varchar(255) NOT NULL,
                    `lang_uk` varchar(255) NOT NULL,
                    `lang_ch` varchar(255) NOT NULL,
                    `lang_by` varchar(255) NOT NULL,
                    PRIMARY KEY (`id`)
                ) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=0;");
            
            // Блог
            $this->db->query("CREATE TABLE IF NOT EXISTS `s_lang_blog` (
                    `lang_id` int(11) NOT NULL,
                    `lang_label` varchar(4) NOT NULL,
                    `blog_id` int(11) NOT NULL,
                    `name` varchar(255) NOT NULL,
                    `meta_title` varchar(255) NOT NULL,
                    `meta_keywords` varchar(255) NOT NULL,
                    `meta_description` varchar(255) NOT NULL,
                    `annotation` text NOT NULL,
                    `text` text NOT NULL,
                    UNIQUE KEY `lang_id` (`lang_id`,`blog_id`)
                ) ENGINE=MyISAM DEFAULT CHARSET=utf8;");
            
            $this->db->query("CREATE TABLE IF NOT EXISTS `s_lang_pages` (
                    `lang_id` int(11) NOT NULL,
                    `lang_label` varchar(4) NOT NULL,
                    `page_id` int(11) NOT NULL,
                    `name` varchar(255) NOT NULL DEFAULT '',
                    `meta_title` varchar(500) NOT NULL,
                    `meta_description` varchar(500) NOT NULL,
                    `meta_keywords` varchar(500) NOT NULL,
                    `body` longtext NOT NULL,
                    `header` varchar(1024) NOT NULL,
                    UNIQUE KEY `lang_id` (`lang_id`,`page_id`)
                ) ENGINE=MyISAM DEFAULT CHARSET=utf8;");
            
            $this->db->query("CREATE TABLE IF NOT EXISTS `s_lang_categories` (
                    `lang_id` int(11) NOT NULL,
                    `lang_label` varchar(4) NOT NULL,
                    `category_id` int(11) NOT NULL,
                    `name` varchar(255) NOT NULL,
                    `meta_title` varchar(255) NOT NULL,
                    `meta_keywords` varchar(255) NOT NULL,
                    `meta_description` varchar(255) NOT NULL,
                    `description` text NOT NULL,
                    UNIQUE KEY `lang_id` (`lang_id`,`category_id`)
                ) ENGINE=MyISAM DEFAULT CHARSET=utf8;");
            
            $this->db->query("CREATE TABLE IF NOT EXISTS `s_lang_brands` (
                    `lang_id` int(11) NOT NULL,
                    `lang_label` varchar(4) NOT NULL,
                    `brand_id` int(11) NOT NULL,
                    `name` varchar(255) NOT NULL,
                    `meta_title` varchar(255) NOT NULL,
                    `meta_keywords` varchar(255) NOT NULL,
                    `meta_description` varchar(255) NOT NULL,
                    `description` text NOT NULL,
                    UNIQUE KEY `lang_id` (`lang_id`,`brand_id`)
                ) ENGINE=MyISAM DEFAULT CHARSET=utf8;");
            
            $this->db->query("CREATE TABLE IF NOT EXISTS `s_lang_features` (
                    `lang_id` int(11) NOT NULL,
                    `lang_label` varchar(4) NOT NULL,
                    `feature_id` int(11) NOT NULL,
                    `name` varchar(255) NOT NULL,
                    UNIQUE KEY `lang_id` (`lang_id`,`feature_id`)
                ) ENGINE=MyISAM DEFAULT CHARSET=utf8;");
            
            $this->db->query("ALTER TABLE `s_options` ADD  `lang_id` INT( 11 ) NULL AFTER  `feature_id`");
            $this->db->query("ALTER TABLE `s_options` ADD INDEX ( `lang_id` )");
            $this->db->query("ALTER TABLE `s_options` DROP PRIMARY KEY, ADD PRIMARY KEY (`lang_id`,`product_id`, `feature_id`)");
            
            $this->db->query("CREATE TABLE IF NOT EXISTS `s_lang_products` (
                    `lang_id` int(11) NOT NULL,
                    `lang_label` varchar(4) NOT NULL,
                    `product_id` int(11) NOT NULL,
                    `name` varchar(255) NOT NULL,
                    `annotation` text NOT NULL,
                    `body` text NOT NULL,
                    `meta_title` varchar(255) NOT NULL,
                    `meta_keywords` varchar(255) NOT NULL,
                    `meta_description` varchar(255) NOT NULL,
                    UNIQUE KEY `lang_id` (`lang_id`,`product_id`)
                ) ENGINE=MyISAM DEFAULT CHARSET=utf8;");
            
            $this->db->query("CREATE TABLE IF NOT EXISTS `s_lang_variants` (
                    `lang_id` int(11) NOT NULL,
                    `lang_label` varchar(4) NOT NULL,
                    `variant_id` int(11) NOT NULL,
                    `name` varchar(255) NOT NULL,
                    UNIQUE KEY `lang_id` (`lang_id`,`variant_id`)
                ) ENGINE=MyISAM DEFAULT CHARSET=utf8;");
            
            $this->db->query("CREATE TABLE IF NOT EXISTS `s_lang_delivery` (
                    `lang_id` int(11) NOT NULL,
                    `lang_label` varchar(4) NOT NULL,
                    `delivery_id` int(11) NOT NULL,
                    `name` varchar(255) NOT NULL,
                    `description` text NOT NULL,
                    UNIQUE KEY `lang_id` (`lang_id`,`delivery_id`)
                ) ENGINE=MyISAM DEFAULT CHARSET=utf8;");
            
            $this->db->query("CREATE TABLE IF NOT EXISTS `s_lang_payment_methods` (
                    `lang_id` int(11) NOT NULL,
                    `lang_label` varchar(4) NOT NULL,
                    `payment_id` int(11) NOT NULL,
                    `name` varchar(255) NOT NULL,
                    `description` text NOT NULL,
                    UNIQUE KEY `lang_id` (`lang_id`,`payment_id`)
                ) ENGINE=MyISAM DEFAULT CHARSET=utf8;");
            
            $this->db->query("CREATE TABLE IF NOT EXISTS `s_lang_currencies` (
                    `lang_id` int(11) NOT NULL,
                    `lang_label` varchar(4) NOT NULL,
                    `currency_id` int(11) NOT NULL,
                    `name` varchar(255) NOT NULL,
                    `sign` varchar(20) NOT NULL,
                    UNIQUE KEY `lang_id` (`lang_id`,`currency_id`)
                ) ENGINE=MyISAM DEFAULT CHARSET=utf8;");
            
            
            $this->languages->add_language(array('name'=>'Русский', 'label'=>'ru', 'enabled'=>'0'));
            
            $exist = 1;
        }
        
        //$languages = null;
        if($exist) {
            $languages = $this->languages->get_languages();
        }
        $this->design->assign('languages', $languages);
        $this->design->assign('exist', $exist);
        
        return $this->design->fetch('languages.tpl');
    }
    
}
