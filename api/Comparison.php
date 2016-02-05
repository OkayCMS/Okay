<?php

require_once('Okay.php');

class Comparison extends Okay {
    
    public function get_comparison() {
        $comparison = new stdClass();
        $comparison->products = array();
        $comparison->features = array();
        $comparison->ids = array();
        
        if(!empty($_SESSION['comparison'])) {
            $session_items = $_SESSION['comparison'];
            $products = array();
            foreach($session_items as $v) {
                $products[intval($v)]=$this->products->get_product(intval($v));
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
    
    public function add_item($product_id) {
        if(is_array($_SESSION['comparison']) && !in_array($product_id,$_SESSION['comparison'])) {
            $_SESSION['comparison'][] = $product_id;
            if($this->settings->comparison_count && $this->settings->comparison_count < count($_SESSION['comparison'])) {
                array_shift($_SESSION['comparison']);
            }
        } else {
            $_SESSION['comparison'][] = $product_id;
        }
    }
    
    public function delete_item($product_id) {
        foreach($_SESSION['comparison'] as $k=>$id) {
            if($id == $product_id) {
                unset($_SESSION['comparison'][$k]);
            }
        }
    }
    
    public function empty_comparison() {
        unset($_SESSION['comparison']);
    }
    
}
