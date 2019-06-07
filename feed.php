<?php

require_once('api/Okay.php');
$okay = new Okay();

header("Content-type: text/xml; charset=UTF-8");
print (pack('CCC', 0xef, 0xbb, 0xbf));
// Заголовок
print
"<?xml version='1.0' encoding='UTF-8'?>
<!DOCTYPE yml_catalog SYSTEM 'shops.dtd'>
<yml_catalog date='".date('Y-m-d H:i')."'>
<shop>
<name>".$okay->settings->site_name."</name>
<company>".$okay->settings->site_name."</company>
<url>".$okay->config->root_url."</url>
<platform>OkayCMS</platform>
<version>".$okay->config->version."</version>
";

// Валюты
$currencies = $okay->money->get_currencies(array('enabled'=>1));
$main_currency = reset($currencies);
print "<currencies>
";
foreach($currencies as $c)
if($c->enabled)
print "<currency id='".$c->code."' rate='".$c->rate_to/$c->rate_from*$main_currency->rate_from/$main_currency->rate_to."'/>
";
print "</currencies>
";


// Категории
$categories = $okay->categories->get_categories();
print "<categories>
";
foreach($categories as $c)
{
print "<category id='$c->id'";
if($c->parent_id>0)
    print " parentId='$c->parent_id'";
print ">".htmlspecialchars($c->name)."</category>
";
}
print "</categories>
";

$stock_filter = $okay->settings->yandex_export_not_in_stock ? '' : ' AND (v.stock >0 OR v.stock is NULL) ';
$price_filter = $okay->settings->yandex_no_export_without_price ? ' AND v.price >0 ' : '';

// Товары
$okay->db->query("SET SQL_BIG_SELECTS=1");
// Товары
$okay->db->query("SELECT 
        p.description, 
        b.name as vendor, 
        v.stock, 
        v.compare_price, 
        v.sku, 
        v.price, 
        v.id as variant_id, 
        p.name as product_name, 
        v.name as variant_name, 
        v.position as variant_position, 
        p.id as product_id, 
        p.url, 
        p.annotation, 
        p.main_category_id as category_id, 
        c.rate_from, 
        c.rate_to, 
        v.currency_id 
    FROM __variants v 
    LEFT JOIN __products p ON v.product_id=p.id
    left join __currencies as c on(c.id=v.currency_id)
    LEFT JOIN __brands b on (b.id = p.brand_id)
    WHERE 
        1 
        AND p.visible 
        AND v.feed = 1 
        $stock_filter
        $price_filter 
    GROUP BY v.id 
    ORDER BY p.id, v.position ");
print "<offers>
";


$currency_code = reset($currencies)->code;
$prev_product_id = null;

$products = $okay->db->results();
$p_ids = array();
foreach ($products as $p) {
    if (!in_array($p->product_id, $p_ids)) {
        $p_ids[] = $p->product_id;
    }
}
$p_images = array();
foreach($okay->products->get_images(array('product_id' => $p_ids)) as $image) {
    $p_images[$image->product_id][] = $image->filename;
}

// Получаем список свойств для фида
$features_values = array();
foreach ($okay->features_values->get_features_values(array('yandex'=>1)) as $fv) {
    $features_values[$fv->id] = $fv;
}

// Получаем связь товара и значения свойства
$products_values = array();
foreach ($okay->features_values->get_product_value_id($p_ids) as $pv) {
    $products_values[$pv->product_id][] = $pv->value_id;
}

foreach($products as $p) {
    $variant_url = '';
    if ($prev_product_id === $p->product_id) {
        $variant_url = '?variant='.$p->variant_id;
    }
    $prev_product_id = $p->product_id;
    
    //если задана валюта варианта - переводим к основной
    if ($p->currency_id > 0) {
        if ($p->rate_from != $p->rate_to) {
            $p->price = $p->price*$p->rate_to/$p->rate_from;
            $p->compare_price = $p->compare_price*$p->rate_to/$p->rate_from;
        }
        $price = round($p->price, 2);
        $old_price = round($p->compare_price, 2);
    } else {
        $price = round($okay->money->convert($p->price, $main_currency->id, false),2);
        $old_price = round($okay->money->convert($p->compare_price, $main_currency->id, false),2);
    }
    $old_price = ($old_price > 0 ? "<oldprice>$old_price</oldprice>" : '');
    print
    "
    <offer id='$p->variant_id' type='vendor.model' available='".($p->stock > 0 || $p->stock === null ? 'true' : 'false')."'>
    <url>".$okay->config->root_url.'/products/'.$p->url.$variant_url."</url>";
    print "
    <price>$price</price>
    $old_price
    <currencyId>".$currency_code."</currencyId>
    <categoryId>".$p->category_id."</categoryId>
    <market_category>".$categories[$p->category_id]->yandex_name."</market_category>
    ";
    
    if(!empty($p_images[$p->product_id])) {
        foreach($p_images[$p->product_id] as $img) {
            print "<picture>".$okay->design->resize_modifier($img, 800, 600)."</picture>";
        }
    }
    
    print "
    <store>".($okay->settings->yandex_available_for_retail_store ? 'true' : 'false')."</store>
    <pickup>".($okay->settings->yandex_available_for_reservation ? 'true' : 'false')."</pickup>
    <delivery>true</delivery>
    <vendor>".htmlspecialchars($p->vendor)."</vendor>
    ".($p->sku ? '<vendorCode>'.$p->sku.'</vendorCode>' : '')."
    ";
    
    print "<model>".htmlspecialchars($p->product_name).($p->variant_name?' '.htmlspecialchars($p->variant_name):'')."</model>
    <description>".htmlspecialchars(strip_tags(($okay->settings->yandex_short_description ? $p->description : $p->annotation)))."</description>
    ".($okay->settings->yandex_sales_notes ? "<sales_notes>".htmlspecialchars(strip_tags($okay->settings->yandex_sales_notes))."</sales_notes>" : "")."
    ";
    
    print "
    <manufacturer_warranty>".($okay->settings->yandex_has_manufacturer_warranty ? 'true' : 'false')."</manufacturer_warranty>
    <seller_warranty>".($okay->settings->yandex_has_seller_warranty ? 'true' : 'false')."</seller_warranty>
    ";
    
    if (!empty($products_values[$p->product_id])) {
        foreach($products_values[$p->product_id] as $value_id) {
            if (isset($features_values[$value_id])) {
                $feature = $features_values[$value_id];
                print "
                <param name='".htmlspecialchars($feature->name)."'>".htmlspecialchars($feature->value)."</param>
                ";
            }
        }
    }
    print "</offer>";
}

print "</offers>
";
print "</shop>
</yml_catalog>
";