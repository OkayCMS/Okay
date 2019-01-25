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
$template = $okay->request->post('template');
$theme = $okay->request->post('theme', 'string');

/*Сохранение файлов шаблона из админки*/
$file = $okay->config->root_dir.'design/'.$theme.'/html/'.$template;

if(pathinfo($template, PATHINFO_EXTENSION) != 'tpl' || $file != realpath($file)) {
    exit();
}

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
