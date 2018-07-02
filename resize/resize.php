<?php

require_once('../api/Okay.php');

$filename = $_GET['file'];
$token = $_GET['token'];

$okay = new Okay();

/*Принимаем нужную сущность для ресаза её изображения*/
$original_img_dir = null;
$resized_img_dir = null;
if (isset($_GET['object']) && !empty($_GET['object'])) {
    //$_GET['object'] - по сути папка с нарезанными картинками
    if ($_GET['object'] == 'blog_resized') {
        $original_img_dir = $okay->config->original_blog_dir;
        $resized_img_dir = $okay->config->resized_blog_dir;
    }
    if ($_GET['object'] == 'brands_resized') {
        $original_img_dir = $okay->config->original_brands_dir;
        $resized_img_dir = $okay->config->resized_brands_dir;
    }
    if ($_GET['object'] == 'categories_resized') {
        $original_img_dir = $okay->config->original_categories_dir;
        $resized_img_dir = $okay->config->resized_categories_dir;
    }
    if ($_GET['object'] == 'deliveries_resized') {
        $original_img_dir = $okay->config->original_deliveries_dir;
        $resized_img_dir = $okay->config->resized_deliveries_dir;
    }
    if ($_GET['object'] == 'payments_resized') {
        $original_img_dir = $okay->config->original_payments_dir;
        $resized_img_dir = $okay->config->resized_payments_dir;
    }
    if ($_GET['object'] == 'slides_resized') {
        $original_img_dir = $okay->config->banners_images_dir;
        $resized_img_dir = $okay->config->resized_banners_images_dir;
    }

}

if (empty($original_img_dir) && empty($resized_img_dir) && $_GET['object'] != 'products') {
    header("http/1.1 404 not found");
    exit;
}

$resized_filename =  $okay->image->resize($filename, $original_img_dir, $resized_img_dir);
if(is_readable($resized_filename)) {
    header('Content-type: image');
    print file_get_contents($resized_filename);
}

