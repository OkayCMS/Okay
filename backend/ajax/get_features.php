<?php

    if(!$okay->managers->access('products')) {
        exit();
    }

    /*Принимаем данные о товаре и категории*/
    $category_id = $okay->request->get('category_id', 'integer');
    $product_id = $okay->request->get('product_id', 'integer');
    if(!empty($category_id)) {
        $features = $okay->features->get_features(array('category_id'=>$category_id));
    } else {
        $features = $okay->features->get_features();
    }

    /*Выборка значений свойств*/
    $options = array();
    if(!empty($product_id)) {
        foreach($okay->features_values->get_features_values(array('product_id'=>$product_id)) as $fv) {
            $features_values[$fv->feature_id][] = $fv;
        }
    }
    
    foreach($features as $f) {
        if(isset($features_values[$f->id])) {
            $f->values = $features_values[$f->id];
        } else {
            $f->values = array(array('value'=>'', 'id'=>''));
        }
    }
    
    header("Content-type: application/json; charset=UTF-8");
    header("Cache-Control: must-revalidate");
    header("Pragma: no-cache");
    header("Expires: -1");
    print json_encode($features);
