<?php

$start_time = microtime(true);

if (!empty($_SERVER['HTTP_USER_AGENT'])){
    session_name(md5($_SERVER['HTTP_USER_AGENT']));
}
session_start();

require_once(dirname(__DIR__).'/api/Okay.php');
require_once('vendor/autoload.php');
$okay = new \Okay();
$integration_1c = new \Integration1C\Integration1C($okay, $start_time);
$response = new \Integration1C\Response();

// Аутентификация (лигинимся под менеджером из админки)
if ($integration_1c->check_auth() === false) {
    $response->add_header("WWW-Authenticate: Basic realm=\"1C integration for OkayCMS {$okay->config->version} {$okay->config->version_type}\"");
    $response->add_header("HTTP/1.0 401 Unauthorized");
    $response->send();
    exit;
}

if ($okay->request->get('mode') == 'checkauth') {
    $response->set_content("success\n");
    $response->set_content(session_name()."\n");
    $response->set_content(session_id()."\n");
}

// Инициализация обмена
if ($okay->request->get('mode') == 'init') {
    
    $integration_1c->rrmdir($integration_1c->get_tmp_dir());
    
    // Очищаем все временнные данные
    $integration_1c->clear_storage();
    
    // Если нужно, очищаем базу
    if ($integration_1c->delete_all === true) {
        $integration_1c->flush_database();
    }
    
    $response->set_content("zip=no\n");
    $response->set_content("file_limit=1000000\n");
}

if ($okay->request->get('mode') == 'file' && in_array($okay->request->get('type'), array('catalog', 'sale'))) {
    
    $filename = $okay->request->get('filename');
    $xml_file = $integration_1c->get_full_path($filename);

    // Загружаем файл
    $integration_1c->upload_file($xml_file);

    // Если файл не валидный, прекращаем всё
    if ($integration_1c->validate_file($xml_file) === false) {
        $response->set_content("error import file\n");
        $response->send();
        exit;
    }
    
    // Здесь "success" отвечаем только когда импортирууется каталог, в случае с заказами, ответ отдаст клас импорта заказов
    if ($okay->request->get('type') == 'catalog') {
        $response->set_content("success\n");
    }
}

if ($okay->request->get('type') == 'sale') {

    if ($okay->request->get('mode') == 'success') {

        $okay->settings->last_1c_orders_export_date = date("Y-m-d H:i:s");
        
        $response->set_content("success\n");
        $response->send();
        exit;
    } elseif ($okay->request->get('mode') == 'query') {
        $export_factory = new \Integration1C\Export\ExportFactory\ExportOrdersFactory();
        $export = $export_factory->create_export($okay, $integration_1c);

        if ($xml = $export->export()) {
            $okay->settings->last_1c_orders_export_date = date("Y-m-d H:i:s");
            $response->set_content("\xEF\xBB\xBF"); // Добавим BOM
            $response->set_content($xml);
            $response->add_header("Content-type: text/xml; charset=utf-8");
        }
    }
    
    if ($okay->request->get('mode') == 'file') {
        $import_factory = new \Integration1C\Import\ImportFactory\ImportOrdersFactory();
        $okay->settings->last_1c_orders_export_date = date("Y-m-d H:i:s");
    }
    
    if ($okay->request->get('mode') == 'success') {
        $okay->settings->last_1c_orders_export_date = date("Y-m-d H:i:s");
    }
    
} elseif ($okay->request->get('type') == 'catalog') {
    
    if ($okay->request->get('mode') == 'import') {
        $filename = $okay->request->get('filename');
        // Определяем какую фабрику импорта создать, импорта товаров или предложений
        if (preg_match('~^.*import.*\.xml$~', $filename)) {
            $import_factory = new \Integration1C\Import\ImportFactory\ImportProductsFactory();
        } elseif (preg_match('~^.*(offers|prices|rests).*\.xml$~', $filename)) {
            $import_factory = new \Integration1C\Import\ImportFactory\ImportOffersFactory();
        }
    }
}

// Если определили фабрику импорта, тогда запустим импорт
if (!empty($import_factory) && $import_factory instanceof \Integration1C\Import\ImportFactory\ImportFactoryInterface) {
    $import = $import_factory->create_import($okay, $integration_1c);

    $filename = $okay->request->get('filename');
    $xml_file = $integration_1c->get_full_path($filename);

    //$response->set_content("\xEF\xBB\xBF"); // Добавим BOM
    //$response->add_header("Content-type: text/xml; charset=utf-8");

    // Запускаем импорт, и утанавливаем результат как контент ответа
    $result = $import->import($xml_file);
    $response->set_content($result);
}

$response->send();
