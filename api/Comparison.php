<?php

require_once('Okay.php');

class Comparison extends Okay {

    /*Выборка списка товаров в сравнении*/
    public function get_comparison() {
        $comparison = new stdClass();
        $comparison->products = array();
        $comparison->features = array();
        $comparison->ids = array();

        $items = !empty($_COOKIE['comparison']) ? unserialize($_COOKIE['comparison']) : array();
        if(!empty($items) && is_array($items)) {
            $products = array();
            foreach ($this->products->get_products(array('id'=>$items, 'visible'=>1)) as $p) {
                $products[$p->id] = $p;
            }
            if(!empty($products)) {
                $products_ids = array_keys($products);
                $comparison->ids = $products_ids;
                foreach($products as $product) {
                    $product->variants = array();
                    $product->images = array();
                    $product->features = array();
                }
                
                $variants = $this->variants->get_variants(array('product_id'=>$products_ids));
                
                foreach($variants as $variant) {
                    $products[$variant->product_id]->variants[] = $variant;
                }
                
                $images = $this->products->get_images(array('product_id'=>$products_ids));
                foreach($images as $image) {
                    $products[$image->product_id]->images[] = $image;
                }
                
                $options = array();
                $features_ids = array();
                foreach($this->features->get_comparison_options($products_ids) as $o) {
                    $options[$o->feature_id][$o->product_id] = $o->value;
                    $features_ids[] = $o->feature_id;
                }
                $features = array();
                if (!empty($features_ids)) {
                    foreach ($this->features->get_features(array('id' => $features_ids)) as $f) {
                        $features[$f->id] = $f;
                        foreach ($products as $p) {
                            if(isset($options[$f->id][$p->id])){
                                $features[$f->id]->products[$p->id] = $options[$f->id][$p->id];
                            }
                            else{
                                $features[$f->id]->products[$p->id] = null;
                            }
                        }
                        $features[$f->id]->not_unique = (count(array_unique($features[$f->id]->products)) == 1) ? true : false;
                    }
                }
                if(!empty($features)) {
                    $comparison->features = $features;
                }
                
                foreach($products as $product) {
                    if(isset($product->variants[0])) {
                        $product->variant = $product->variants[0];
                    }
                    if(isset($product->images[0])) {
                        $product->image = $product->images[0];
                    }
                    foreach($features as $id=>$f) {
                        if(isset($options[$id][$product->id])){
                            $product->features[$id] = $options[$id][$product->id];
                        }
                        else{
                            $product->features[$id] = null;
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
        $items = !empty($_COOKIE['comparison']) ? unserialize($_COOKIE['comparison']) : array();
        $items = $items && is_array($items) ? $items : array();
        if (!in_array($product_id, $items)) {
            $items[] = $product_id;
            if ($this->settings->comparison_count && $this->settings->comparison_count < count($items)) {
                array_shift($items);
            }
        }
        $_COOKIE['comparison'] = serialize($items);
        setcookie('comparison', $_COOKIE['comparison'], time()+30*24*3600, '/');
    }

    /*Удаление товара из списка сравнения*/
    public function delete_item($product_id) {
        $items = !empty($_COOKIE['comparison']) ? unserialize($_COOKIE['comparison']) : array();
        if (!is_array($items)) {
            return;
        }
        $i = array_search($product_id, $items);
        if ($i !== false) {
            unset($items[$i]);
        }
        $_COOKIE['comparison'] = serialize($items);
        setcookie('comparison', $_COOKIE['comparison'], time()+30*24*3600, '/');
    }

    /*Очистка списка сравнения*/
    public function empty_comparison() {
        unset($_COOKIE['comparison']);
        setcookie('comparison', '', time()-3600, '/');
    }
    
}
