<?php

namespace Integration1C;


class Response implements ResponseInterface
{
    private $content = array();
    private $headers = array();
    
    public function set_content($content) {
        $this->content[] = $content;
    }
    
    public function add_header($header) {
        $this->headers[] = $header;
    }

    public function send() {
        
        // Отправляем заголовки
        if (!empty($this->headers)) {
            foreach ($this->headers as $header) {
                header($header);
            }
        }
        
        print implode('', $this->content);
    }
}
