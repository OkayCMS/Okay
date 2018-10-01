<?php
    if(!$okay->managers->access('orders')) {
        exit();
    }
    if (!empty($_SESSION['admin_lang_id'])) {
        $okay->languages->set_lang_id($_SESSION['admin_lang_id']);
    }

    $limit = 30;
    /*Определение языка для поиска*/
    $lang_id  = $okay->languages->lang_id();
    $px = ($lang_id ? 'l' : 'p');
    $lang_sql = $okay->languages->get_query(array('object'=>'product', 'px'=>'p'));

    /*Поиск товара*/
    $keyword = $okay->request->get('query', 'string');
    $keywords = explode(' ', $keyword);
    $keyword_sql = '';
    foreach($keywords as $keyword) {
        $kw = $okay->db->escape(trim($keyword));
        $keyword_sql .= $okay->db->placehold("AND (
            $px.name LIKE '%$kw%' 
            OR $px.meta_keywords LIKE '%$kw%' OR 
            p.id in (SELECT product_id FROM __variants WHERE sku LIKE '%$kw%') 
        ) ");
    }
    
    $stock_filter = (!$okay->settings->is_preorder ? "AND (pv.stock IS NULL OR pv.stock>0)" : "");
    $okay->db->query("SELECT 
            p.id, 
            $px.name, 
            i.filename as image 
        FROM __products p
        $lang_sql->join
        LEFT JOIN __images i ON i.id=p.main_image_id
        LEFT JOIN __variants pv ON pv.product_id=p.id $stock_filter
        WHERE 
            1 
            $keyword_sql 
            AND pv.id
        GROUP BY p.id
        ORDER BY $px.name 
        LIMIT ?
    ", $limit);
    
    foreach($okay->db->results() as $product) {
        $products[$product->id] = $product;
    }

    /*Выборка вариантов для найденных товаров*/
    $lang_sql = $okay->languages->get_query(array('object'=>'variant', 'px'=>'pv'));
    $variants = array();
    if(!empty($products)) {
        $okay->db->query("SELECT 
                pv.id, 
                $lang_sql->fields,
                pv.sku, 
                pv.price, 
                IF(pv.stock=0, ?, IFNULL(pv.stock, ?)) as stock, 
                (pv.stock IS NULL) as infinity, 
                pv.product_id, 
                pv.currency_id 
            FROM __variants pv 
            $lang_sql->join
            WHERE 
                pv.product_id in(?@) 
                $stock_filter 
                AND pv.price>0 
            ORDER BY pv.position
        ", $okay->settings->max_order_amount, $okay->settings->max_order_amount, array_keys($products));
        $variants = $okay->db->results();
    }
    
    foreach($variants as $variant) {
        if(isset($products[$variant->product_id])) {
            $variant->units = $variant->units ? $variant->units : $okay->settings->units;
            $products[$variant->product_id]->variants[] = $variant;
            if ($variant->currency_id && ($currency = $okay->money->get_currency(intval($variant->currency_id)))) {
                if ($currency->rate_from != $currency->rate_to) {
                    $variant->price = round($variant->price*$currency->rate_to/$currency->rate_from,2);
                    $variant->compare_price = round($variant->compare_price*$currency->rate_to/$currency->rate_from,2);
                }
            }
        }
    }
    
    $suggestions = array();
    foreach($products as $product) {
        if(!empty($product->variants)) {
            $suggestion = new stdClass;
            if(!empty($product->image)) {
                $product->image = $okay->design->resize_modifier($product->image, 35, 35);
            }
            $suggestion->value = $product->name;
            $suggestion->data = $product;
            $suggestions[] = $suggestion;
        }
    }
    
    $res = new stdClass;
    $res->query = $keyword;
    $res->suggestions = $suggestions;
    header("Content-type: application/json; charset=UTF-8");
    header("Cache-Control: must-revalidate");
    header("Pragma: no-cache");
    header("Expires: -1");
    print json_encode($res);
