<?php
    session_start();
    require_once('../api/Okay.php');
    $okay = new Okay();
    $limit = 30;
    
    $lang_id  = $okay->languages->lang_id();
    $language = $okay->languages->languages(array('id'=>$lang_id));
    
    $lang_link = '';
    $first_lang = $okay->languages->languages();
    if (!empty($first_lang)) {
        $first_lang = reset($first_lang);
        if($first_lang->id !== $language->id) {
            $lang_link = $language->label . '/';
        }
    }
    $px = ($lang_id ? 'l' : 'p');
    $lang_sql = $okay->languages->get_query(array('object'=>'product'));
    
    $keyword = $okay->request->get('query', 'string');
    $kw = $okay->db->escape($keyword);
	$okay->db->query("SELECT 
            p.id,
            p.url,
            $px.name, 
            i.filename as image 
        FROM __products p 
        $lang_sql->join
        LEFT JOIN __images i ON i.product_id=p.id AND i.position=(SELECT MIN(position) FROM __images WHERE product_id=p.id LIMIT 1)
        WHERE 
            ($px.name LIKE '%$kw%' OR $px.meta_keywords LIKE '%$kw%' OR p.id in (SELECT product_id FROM __variants WHERE sku LIKE '%$kw%')) 
            AND visible=1 
        ORDER BY p.name 
        LIMIT ?
    ", $limit);
    $products = $okay->db->results();
    
    $suggestions = array();
    
    foreach($products as $product) {
        $suggestion = new stdClass();
        if(!empty($product->image)) {
            $product->image = $okay->design->resize_modifier($product->image, 35, 35);
        }
        
        $suggestion->value = $product->name;
        $suggestion->data = $product;
        $suggestion->lang = $lang_link;
        $suggestions[] = $suggestion;
    }

    $res = new stdClass;
    $res->query = $keyword;
    $res->suggestions = $suggestions;
    header("Content-type: application/json; charset=UTF-8");
    header("Cache-Control: must-revalidate");
    header("Pragma: no-cache");
    header("Expires: -1");		
    print json_encode($res);
