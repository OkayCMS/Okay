<?php

if(!$okay->managers->access('orders')) {
    exit();
}

$okay->design->set_templates_dir('backend/design/html');
$okay->design->set_compiled_dir('backend/design/compiled');

$result = array();
/*Принимаем метки, с которыми нужно сделать действие*/
if($okay->request->method("post")) {
    $order_id = $okay->request->post("order_id", "integer");
    $state = $okay->request->post("state", "string");
    $label_id = $okay->request->post("label_id", "integer");

    if(empty($order_id) || empty($state)){
        $result['success ']= false;
    } else {
        switch ($state) {
            case "add" : {
                $okay->orderlabels->add_order_labels($order_id, (array)$label_id);
                $result['success'] = true;
                break;
            }
            case "remove": {
                $okay->orderlabels->delete_order_labels($order_id, (array)$label_id);
                $result['success'] = true;
                break;
            }
        }
        $order = new stdClass();
        $order->labels = $okay->orderlabels->get_order_labels((array)$order_id);
        $okay->design->assign("order", $order);
        $result['data'] = $okay->design->fetch("labels_ajax.tpl");

    }

} else {
    $result['success ']= false;
}
header("Content-type: application/json; charset=UTF-8");
header("Cache-Control: must-revalidate");
header("Pragma: no-cache");
header("Expires: -1");
print json_encode($result);