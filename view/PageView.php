<?php

require_once('View.php');

class PageView extends View {

    /*Отображение страниц сайта*/
    public function fetch() {
        $url = $this->request->get('page_url', 'string');
        $page = $this->pages->get_page($url);
        
        // Отображать скрытые страницы только админу
        if((empty($page) || (!$page->visible && empty($_SESSION['admin']))) && $url != '404') {
            return false;
        }
        
        //lastModify
        if ($page->url != '404') {
            $this->setHeaderLastModify($page->last_modify);
        }
        
        $this->design->assign('page', $page);
        $this->design->assign('meta_title', $page->meta_title);
        $this->design->assign('meta_keywords', $page->meta_keywords);
        $this->design->assign('meta_description', $page->meta_description);
        
        return $this->design->fetch('page.tpl');
    }
    
}
