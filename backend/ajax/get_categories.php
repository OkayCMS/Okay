<?php

if(!$okay->managers->access('categories')) {
    exit();
}

$okay->design->set_templates_dir('backend/design/html');
$okay->design->set_compiled_dir('backend/design/compiled');
$lang_id  = $okay->languages->lang_id();
$lang_sql = $okay->languages->get_query(array('object'=>'category'));
$result = array();

// Перевод админки
$backend_translations = new stdClass();
$manager = $okay->managers->get_manager();
$file = "backend/lang/".$manager->lang.".php";
if (!file_exists($file)) {
    foreach (glob("backend/lang/??.php") as $f) {
        $file = "backend/lang/".pathinfo($f, PATHINFO_FILENAME).".php";
        break;
    }
}
require_once($file);
$okay->design->assign('btr', $backend_translations);

/*Выборка категории и её деток*/
if($okay->request->get("category_id")) {
    $category_id = $okay->request->get("category_id", 'integer');
    $categories = $okay->categories->get_category($category_id);
    $okay->design->assign('categories_ajax', $categories->subcategories);
    $result['success'] = true;
    $result['cats'] = $okay->design->fetch("categories_ajax.tpl");
} else {
    $result['success ']= false;
}

header("Content-type: application/json; charset=UTF-8");
header("Cache-Control: must-revalidate");
header("Pragma: no-cache");
header("Expires: -1");
print json_encode($result);
