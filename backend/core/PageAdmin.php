<?php

require_once('api/Okay.php');

class PageAdmin extends Okay {
    
    public function fetch() {
        $page = new stdClass;
        /*Прием информации о страницу*/
        if($this->request->method('POST')) {
            $page->id = $this->request->post('id', 'integer');
            $page->name = $this->request->post('name');
            $page->name_h1 = $this->request->post('name_h1');
            $page->url = trim($this->request->post('url'));
            $page->meta_title = $this->request->post('meta_title');
            $page->meta_keywords = $this->request->post('meta_keywords');
            $page->meta_description = $this->request->post('meta_description');
            $page->description = $this->request->post('description');
            $page->visible = $this->request->post('visible', 'boolean');
            
            /*Не допустить одинаковые URL разделов*/
            if(($p = $this->pages->get_page($page->url)) && $p->id!=$page->id) {
                $this->design->assign('message_error', 'url_exists');
            } elseif(empty($page->name)) {
                $this->design->assign('message_error', 'empty_name');
            } elseif(substr($page->url, -1) == '-' || substr($page->url, 0, 1) == '-') {
                $this->design->assign('message_error', 'url_wrong');
            } else {
                /*Добавление/Обновление страницы*/
                if(empty($page->id)) {
                    $page->id = $this->pages->add_page($page);
                    $page = $this->pages->get_page($page->id);
                    $this->design->assign('message_success', 'added');
                } else {
                    // Запретим изменение системных url.
                    $check_page = $this->pages->get_page(intval($page->id));
                    if (in_array($check_page->url, $this->pages->system_pages) && $page->url != $check_page->url) {
                        $page->url = $check_page->url;
                        $this->design->assign('message_error', 'url_system');
                    }
                    $this->pages->update_page($page->id, $page);
                    $page = $this->pages->get_page($page->id);
                    $this->design->assign('message_success', 'updated');
                }
            }
        } else {
            $id = $this->request->get('id', 'integer');
            if(!empty($id)) {
                $page = $this->pages->get_page(intval($id));
            } else {
                $page->visible = 1;
            }
        }
        
        $this->design->assign('page', $page);
        return $this->design->fetch('page.tpl');
    }
    
}
