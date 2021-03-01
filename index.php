<?php

$time_start = microtime(true);
if(!empty($_SERVER['HTTP_USER_AGENT'])){
    session_name(md5($_SERVER['HTTP_USER_AGENT']));
}
session_start();
require_once('view/IndexView.php');

$view = new IndexView();

header("X-Powered-CMS: OkayCMS ".$view->config->version." ".$view->config->version_type);

if(isset($_GET['logout'])) {
    unset($_SESSION['admin']);
    header('location: '.$view->config->root_url);
    exit();
}

if(($res = $view->fetch()) !== false) {
    header("Content-type: text/html; charset=UTF-8");
    print $res;
    
    // Сохраняем последнюю просмотренную страницу в переменной $_SESSION['last_visited_page']
    if (empty($_SESSION['last_visited_page']) || empty($_SESSION['current_page']) || $_SERVER['REQUEST_URI'] !== $_SESSION['current_page']) {
        if(!empty($_SESSION['current_page']) && $_SESSION['last_visited_page'] !== $_SESSION['current_page']) {
            $_SESSION['last_visited_page'] = $_SESSION['current_page'];
        }
        $_SESSION['current_page'] = $_SERVER['REQUEST_URI'];
    }
} else {
    // Иначе страница об ошибке
    header("http/1.0 404 not found");
    
    // Подменим переменную GET, чтобы вывести страницу 404
    $_GET['page_url'] = '404';
    $_GET['module'] = 'PageView';
    print $view->fetch();   
}

// Отладочная информация
print "<!--\r\n";
$time_end = microtime(true);
$exec_time = $time_end-$time_start;

if(function_exists('memory_get_peak_usage')) {
    print "memory peak usage: ".memory_get_peak_usage()." bytes\r\n";
}
print "page generation time: ".$exec_time." seconds\r\n";
print "-->";