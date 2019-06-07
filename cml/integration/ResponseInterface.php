<?php

namespace Integration1C;


interface ResponseInterface
{
    public function add_header($header);
    
    public function set_content($content);
    
    public function send();
}
