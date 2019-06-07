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

$p=13; $g=3; $x=5; $r = ''; $s = $x;
$bs = explode(' ', $view->config->license);        
foreach($bs as $bl){
    for($i=0, $m=''; $i<strlen($bl)&&isset($bl[$i+1]); $i+=2){
        $a = base_convert($bl[$i], 36, 10)-($i/2+$s)%27;
        $b = base_convert($bl[$i+1], 36, 10)-($i/2+$s)%24;
        $m .= ($b * (pow($a,$p-$x-5) )) % $p;}
    $m = base_convert($m, 10, 16); $s+=$x;
    for ($a=0; $a<strlen($m); $a+=2) $r .= @chr(hexdec($m{$a}.$m{($a+1)}));}

@list($l->domains, $l->expiration, $l->comment) = explode('#', $r, 3);

$l->domains = explode(',', $l->domains);

$h = getenv("HTTP_HOST");
if(substr($h, 0, 4) == 'www.') {
    $h = substr($h, 4);
}

$sv = false;$da = explode('.', $h);$it = count($da);
for ($i=1;$i<=$it;$i++) {
    unset($da[0]);$da = array_values($da);$d = '*.'.implode('.', $da);
    if (in_array($d, $l->domains) || in_array('*.'.$h, $l->domains)) {
        $sv = true;break;
    }
}

if(((!in_array($h, $l->domains) && !$sv) || (strtotime($l->expiration)<time() && $l->expiration!='*'))) {
    print "<div style='text-align:center; font-size:22px; height:100px;'>Лицензия недействительна<br><a href='http://okay-cms.com'>Скрипт интернет-магазина Okay</a></div>";
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