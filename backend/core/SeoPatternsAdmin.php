<?php

require_once('api/Okay.php');

class SeoPatternsAdmin extends Okay {

    public function fetch() {
        $this->design->set_templates_dir('backend/design/html');
        $this->design->set_compiled_dir('backend/design/compiled');

        if($this->request->post("ajax")){
            /*Получение категории*/
            if($this->request->post("action") == "get") {
                $result = new stdClass();
                $category = $this->categories->get_category($this->request->post("category_id","integer"));
                if (!empty($category->id)) {
                    $this->design->assign('features', $this->features->get_features(array('category_id'=>$category->id)));
                    $this->design->assign("category", $category);
                    $result->success = true;
                } else {
                    $result->success = false;
                }
                $result->tpl = $this->design->fetch("seo_patterns_ajax.tpl");
                header("Content-type: application/json; charset=UTF-8");
                header("Cache-Control: must-revalidate");
                header("Pragma: no-cache");
                header("Expires: -1");
                print json_encode($result);
                die();

            }

            /*Обновление шаблона данных категории*/
            if($this->request->post("action") == "set") {
                $result = new stdClass();
                $category = new stdClass();
                $category = $this->categories->get_category($this->request->post("category_id","integer"));
                $category->auto_meta_title = $this->request->post('auto_meta_title');
                $category->auto_meta_keywords = $this->request->post('auto_meta_keywords');
                $category->auto_meta_desc = $this->request->post('auto_meta_desc');
                $category->auto_description = $this->request->post('auto_description');

                if($cat_id = $this->categories->update_category($category->id, $category)) {
                    $category = $this->categories->get_category(intval($cat_id));
                    $this->design->assign("category", $category);
                    $result->success = true;
                } else {
                    $result->success = false;
                }

                $result->tpl = $this->design->fetch("seo_patterns_ajax.tpl");
                header("Content-type: application/json; charset=UTF-8");
                header("Cache-Control: must-revalidate");
                header("Pragma: no-cache");
                header("Expires: -1");
                print json_encode($result);
                die();

            }
        }

        $categories = $this->categories->get_categories_tree();
        $this->design->assign('categories', $categories);
        return $this->design->fetch('seo_patterns.tpl');
    }
}
