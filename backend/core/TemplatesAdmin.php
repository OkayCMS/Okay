<?php

require_once('api/Okay.php');

class TemplatesAdmin extends Okay {

    /*Чтение файлов шаблона*/
    public function fetch() {
        $current_theme = $this->settings->theme;
        if ($this->settings->admin_theme) {
            $current_theme = $this->settings->admin_theme;
        }

        if($this->request->get("email")){
            $templates_dir = 'design/'.$current_theme.'/html/email/';
            $this->design->assign('current_dir', 'email');
        } else {
            $templates_dir = 'design/'.$current_theme.'/html/';
            $this->design->assign('current_dir', 'html');
        }

        $templates = array();
        // Читаем все tpl-файлы
        if($handle = opendir($templates_dir)) {
            while(false !== ($file = readdir($handle))) {
                if(is_file($templates_dir.$file) && $file[0] != '.'  && pathinfo($file, PATHINFO_EXTENSION) == 'tpl') {
                    $templates[] = $file;
                }
            }
            closedir($handle);
            asort($templates);
        }

        // Текущий шаблон
        $template_file = $this->request->get('file');
        
        if(!empty($template_file) && pathinfo($template_file, PATHINFO_EXTENSION) != 'tpl') {
            exit();
        }
        if(!isset($template_file)){
            $template_file = reset($templates);
        }

        // Передаем имя шаблона в дизайн
        $this->design->assign('template_file', $template_file);
        
        // Если можем прочитать файл - передаем содержимое в дизайн
        if(is_readable($templates_dir.$template_file)) {
            $template_content = file_get_contents($templates_dir.$template_file);
            $this->design->assign('template_content', $template_content);
        }
        
        // Если нет прав на запись - передаем в дизайн предупреждение
        if(!empty($template_file) && !is_writable($templates_dir.$template_file) && !is_file($templates_dir.'../locked')) {
            $this->design->assign('message_error', 'permissions');
        } elseif(is_file($templates_dir.'../locked')) {
            $this->design->assign('message_error', 'theme_locked');
        } else {
            // Запоминаем в сессии имя редактируемого шаблона
            $_SESSION['last_edited_template'] = $template_file;
        }

        $this->design->assign('theme', $current_theme);
        $this->design->assign('templates', $templates);
        return $this->design->fetch('templates.tpl');
    }
    
}
