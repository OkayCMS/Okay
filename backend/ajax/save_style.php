<?php

if(!$okay->managers->access('design')) {
    exit();
}

// Проверка сессии для защиты от xss
if(!$okay->request->check_session()) {
    trigger_error('Session expired', E_USER_WARNING);
    exit();
}
$content = $okay->request->post('content');
$style = $okay->request->post('style');
$theme = $okay->request->post('theme', 'string');

if(pathinfo($style, PATHINFO_EXTENSION) != 'css') {
    exit();
}

/*Сохранение стилей из админки*/
$file = $okay->config->root_dir.'design/'.$theme.'/css/'.$style;
if(is_file($file) && is_writable($file) && !is_file($okay->config->root_dir.'design/'.$theme.'/locked')) {
    file_put_contents($file, $content);
}

$result = true;
header("Content-type: application/json; charset=UTF-8");
header("Cache-Control: must-revalidate");
header("Pragma: no-cache");
header("Expires: -1");
$json = json_encode($result);
print $json;
