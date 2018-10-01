<?php

require_once('View.php');

class WishlistView extends View {
    
    public function __construct() {
        parent::__construct();
    }

    /*Отображение списка избранного*/
    public function fetch() {
        $limit = 500;
        $id = $this->request->get('id', 'integer');
        
        if(!empty($_COOKIE['wished_products'])) {
            $products_ids = explode(',', $_COOKIE['wished_products']);
            $products_ids = array_reverse($products_ids);
        } else {
            $products_ids = array();
        }
        
        if($this->request->get('action', 'string') == 'delete') {
            $key = array_search($id, $products_ids);
            if ($key !== false) {
                unset($products_ids[$key]);
            }
        } elseif($id > 0) {
            array_push($products_ids, $id);
            $products_ids = array_unique($products_ids);
        }
        
        $products_ids = array_slice($products_ids, 0, $limit);
        $products_ids = array_reverse($products_ids);
        
        if(!count($products_ids)) {
            unset($_COOKIE['wished_products']);
            setcookie('wished_products', '', time()-3600, '/');
        } else {
            setcookie('wished_products', implode(',', $products_ids), time()+30*24*3600, '/');
        }
        
        $products = array();
        $images_ids = array();
        
        if (count($products_ids)) {
            foreach ($this->products->get_products(array('id'=>$products_ids, 'visible'=>1)) as $p) {
                $products[$p->id] = $p;
                $images_ids[] = $p->main_image_id;
            }
            if (!empty($products)) {
                if (!empty($images_ids)) {
                    $images = $this->products->get_images(array('id'=>$images_ids));
                    foreach ($images as $image) {
                        if (isset($products[$image->product_id])) {
                            $products[$image->product_id]->image = $image;
                        }
                    }
                }

                foreach ($this->variants->get_variants(array('product_id' => $products_ids)) as $variant) {
                    if (isset($products[$variant->product_id])) {
                        $products[$variant->product_id]->variants[] = $variant;
                    }
                }

                foreach ($products_ids as $id) {
                    if (isset($products[$id])) {
                        if (isset($products[$id]->variants[0])) {
                            $products[$id]->variant = $products[$id]->variants[0];
                        }
                    }
                }
            }
        }
        
        // Содержимое списка избранного
        $this->design->assign('wished_products', $products);
        
        // Выводим шаблон
        return $this->design->fetch('wishlist.tpl');
    }
    
}
