<?php

// Проверка сессии для защиты от xss
if(!$okay->request->check_session()) {
    trigger_error('Session expired', E_USER_WARNING);
    exit();
}

$result = '';
/*Принимаем данные от объекта, который нужно обновить*/
$id = intval($okay->request->post('id'));
$object = $okay->request->post('object');
$values = $okay->request->post('values');

/*В зависимости от сущности, обновляем её*/
switch ($object) {
    case 'product':
        if($okay->managers->access('products')) {
            $result = $okay->products->update_product($id, $values);
        }
        break;
    case 'variant':
        if($okay->managers->access('products')) {
            $result = $okay->variants->update_variant($id, $values);
        }
        break;
    case 'category':
        if($okay->managers->access('categories')) {
            $result = $okay->categories->update_category($id, $values);
        }
        break;
    case 'brands':
        if($okay->managers->access('brands')) {
            $result = $okay->brands->update_brand($id, $values);
        }
        break;
    case 'feature':
        if($okay->managers->access('features')) {
            $result = $okay->features->update_feature($id, $values);
        }
        break;
    case 'page':
        if($okay->managers->access('pages')) {
            $result = $okay->pages->update_page($id, $values);
        }
        break;
    case 'menu':
        if($okay->managers->access('pages')) {
            $result = $okay->menu->update_menu($id, $values);
        }
        break;
    case 'menu_item':
        if($okay->managers->access('pages')) {
            $result = $okay->menu->update_menu_item($id, $values);
        }
        break;
    case 'blog':
        if($okay->managers->access('blog')) {
            $result = $okay->blog->update_post($id, $values);
        }
        break;
    case 'delivery':
        if($okay->managers->access('delivery')) {
            $result = $okay->delivery->update_delivery($id, $values);
        }
        break;
    case 'payment':
        if($okay->managers->access('payment')) {
            $result = $okay->payment->update_payment_method($id, $values);
        }
        break;
    case 'currency':
        if($okay->managers->access('currency')) {
            if (!empty($values['cents'])) {
                $values['cents'] = 2;
            }
            $result = $okay->money->update_currency($id, $values);
        }
        break;
    case 'comment':
        if($okay->managers->access('comments')) {
            $result = $okay->comments->update_comment($id, $values);
        }
        break;
    case 'user':
        if($okay->managers->access('users')) {
            $result = $okay->users->update_user($id, $values);
        }
        break;
    case 'label':
        if($okay->managers->access('labels')) {
            $result = $okay->orders->update_label($id, $values);
        }
        break;
    case 'language':
        if($okay->managers->access('languages')) {
            $result = $okay->languages->update_language($id, $values);
        }
        break;
    case 'banner':
        if($okay->managers->access('banners')) {
            $result = $okay->banners->update_banner($id, $values);
        }
        break;
    case 'banners_image':
        if($okay->managers->access('banners')) {
            $result = $okay->banners->update_banners_image($id, $values);
        }
        break;
    case 'callback':
        if($okay->managers->access('callbacks')) {
            $result = $okay->callbacks->update_callback($id, $values);
        }
        break;
    case 'feedback':
        if($okay->managers->access('feedbacks')) {
            $result = $okay->feedbacks->update_feedback($id, $values);
        }
        break;
    case 'managers':
        if($okay->managers->access('managers')) {
            $result = $okay->managers->update_manager($id, $values);
        } elseif(isset($values['menu_status'])) {
            $result = $okay->managers->update_manager($id, array('menu_status'=>$values['menu_status']));
        }
        break;
}

header("Content-type: application/json; charset=UTF-8");
header("Cache-Control: must-revalidate");
header("Pragma: no-cache");
header("Expires: -1");
$json = json_encode($result);
print $json;
