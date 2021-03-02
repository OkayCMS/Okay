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
        if (count($products_ids)) {
            $products = $this->products->get_products_compile(array('id'=>$products_ids, 'visible'=>1));
        }
        
        // Содержимое списка избранного
        $this->design->assign('wished_products', $products);
        
        // Выводим шаблон
        return $this->design->fetch('wishlist.tpl');
    }
    
}
