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
$script = $okay->request->post('script');
$theme = $okay->request->post('theme', 'string');

/*Сохранение скриптов из админки*/
$file = $okay->config->root_dir.'design/'.$theme.'/js/'.$script;

if(pathinfo($script, PATHINFO_EXTENSION) != 'js' || $file != realpath($file)) {
    exit();
}

if(is_file($file) && is_writable($file) && !is_file($okay->config->root_dir.'design/'.$theme.'/locked')) {
    file_put_contents($file, $content);

    $js_version = ltrim($okay->settings->js_version, '0');
    if (!$js_version) {
        $js_version = 0;
    }
    $okay->settings->js_version = str_pad(++$js_version, 6, 0, STR_PAD_LEFT);

}

$result = true;
header("Content-type: application/json; charset=UTF-8");
header("Cache-Control: must-revalidate");
header("Pragma: no-cache");
header("Expires: -1");
$json = json_encode($result);
print $json;
