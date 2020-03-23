<?php

require_once('Okay.php');

class Comparison extends Okay {

    /*Выборка списка товаров в сравнении*/
    public function get_comparison() {
        $comparison = new stdClass();
        $comparison->products = array();
        $comparison->features = array();
        $comparison->ids = array();

        $items = !empty($_COOKIE['comparison']) ? json_decode($_COOKIE['comparison']) : array();
        if(!empty($items) && is_array($items)) {
            $products = array();
            $images_ids = array();
            foreach ($this->products->get_products(array('id'=>$items, 'visible'=>1)) as $p) {
                $products[$p->id] = $p;
                $images_ids[] = $p->main_image_id;
            }
            if(!empty($products)) {
                $products_ids = array_keys($products);
                $comparison->ids = $products_ids;
                foreach($products as $product) {
                    $product->variants = array();
                    $product->features = array();
                }
                
                $variants = $this->variants->get_variants(array('product_id'=>$products_ids));
                
                foreach($variants as $variant) {
                    $products[$variant->product_id]->variants[] = $variant;
                }

                if (!empty($images_ids)) {
                    $images = $this->products->get_images(array('id'=>$images_ids));
                    foreach ($images as $image) {
                        if (isset($products[$image->product_id])) {
                            $products[$image->product_id]->image = $image;
                        }
                    }
                }

                $features_values = array();
                foreach ($this->features_values->get_features_values(array('product_id'=>$products_ids)) as $fv) {
                    $features_values[$fv->id] = $fv;
                }

                $products_values = array();
                foreach ($this->features_values->get_product_value_id($products_ids) as $pv) {
                    $products_values[$pv->product_id][$pv->value_id] = $pv->value_id;
                }

                $features = array();
                foreach ($features_values as $fv) {
                    if (!isset($features[$fv->feature_id])) {
                        $features[$fv->feature_id] = $fv;
                    }

                    foreach ($products as $p) {
                        if(isset($products_values[$p->id][$fv->id])){
                            $features[$fv->feature_id]->products[$p->id][] = $fv->value;
                        } else {
                            $features[$fv->feature_id]->products[$p->id] = null;
                        }
                    }
                }

                foreach ($features_values as $fv) {
                    foreach ($products as $p) {
                        if(is_array($features[$fv->feature_id]->products[$p->id])){
                            $features[$fv->feature_id]->products[$p->id] = implode(", ", $features[$fv->feature_id]->products[$p->id]);
                        }
                    }
                    $features[$fv->feature_id]->not_unique = (count(array_unique($features[$fv->feature_id]->products)) == 1) ? true : false;
                }

                if(!empty($features)) {
                    $comparison->features = $features;
                }
                
                foreach($products as $product) {
                    if(isset($product->variants[0])) {
                        $product->variant = $product->variants[0];
                    }

                    $product_features = array();
                    if (isset($products_values[$product->id])) {
                        foreach ($products_values[$product->id] as $value_id) {
                            if ($feature = $features_values[$value_id]) {
                                $product_features[$feature->feature_id][] = $feature->value;
                            }
                        }
                    }

                    foreach($features as $f) {
                        if (isset($product_features[$f->feature_id])) {
                            $product->features[$f->feature_id] = implode(", ", $product_features[$f->feature_id]);
                        } else {
                            $product->features[$f->feature_id] = null;
                        }
                    }
                }
                $comparison->products = $products;
            }
        }
        return $comparison;
    }

    /*Добавление товара в список сравнения*/
    public function add_item($product_id) {
        $items = !empty($_COOKIE['comparison']) ? json_decode($_COOKIE['comparison']) : array();
        $items = $items && is_array($items) ? $items : array();
        if (!in_array($product_id, $items)) {
            $items[] = $product_id;
            if ($this->settings->comparison_count && $this->settings->comparison_count < count($items)) {
                array_shift($items);
            }
        }
        $_COOKIE['comparison'] = json_encode(array_values($items));
        setcookie('comparison', $_COOKIE['comparison'], time()+30*24*3600, '/');
    }

    /*Удаление товара из списка сравнения*/
    public function delete_item($product_id) {
        $items = !empty($_COOKIE['comparison']) ? json_decode($_COOKIE['comparison']) : array();
        
        if (!is_array($items)) {
            return;
        }
        $i = array_search($product_id, $items);
        if ($i !== false) {
            unset($items[$i]);
        }
        $_COOKIE['comparison'] = json_encode(array_values($items));
        setcookie('comparison', $_COOKIE['comparison'], time()+30*24*3600, '/');
    }

    /*Очистка списка сравнения*/
    public function empty_comparison() {
        unset($_COOKIE['comparison']);
        setcookie('comparison', '', time()-3600, '/');
    }
    
}
