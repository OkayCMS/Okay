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

                if ($this->request->post('template_type') == 'default') {
                    $default_products_seo_pattern = (object)$this->settings->default_products_seo_pattern;
                    $default_products_seo_pattern->name = $this->backend_translations->seo_patterns_all_categories;
                    $this->design->assign("category", $default_products_seo_pattern);
                    $result->success = true;
                } else {
                    $category = $this->categories->get_category($this->request->post("category_id", "integer"));
                    if (!empty($category->id)) {
                        $this->design->assign('features', $this->features->get_features(array('category_id' => $category->id)));
                        $this->design->assign("category", $category);
                        $result->success = true;
                    } else {
                        $result->success = false;
                    }
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
                if ($this->request->post('template_type') == 'default') {
                    $default_products_seo_pattern['auto_meta_title']    = $this->request->post('auto_meta_title');
                    $default_products_seo_pattern['auto_meta_keywords'] = $this->request->post('auto_meta_keywords');
                    $default_products_seo_pattern['auto_meta_desc']     = $this->request->post('auto_meta_desc');
                    $default_products_seo_pattern['auto_description']   = $this->request->post('auto_description');

                    $this->settings->update('default_products_seo_pattern', $default_products_seo_pattern);
                    $default_products_seo_pattern = (object)$default_products_seo_pattern;
                    $default_products_seo_pattern->name = $this->backend_translations->seo_patterns_all_categories;
                    $this->design->assign("category", $default_products_seo_pattern);
                    $result->success = true;
                } else {

                    $category_id = $this->request->post("category_id", "integer");
                    if ($category = $this->categories->get_category($category_id)) {
                        $category->auto_meta_title      = $this->request->post('auto_meta_title');
                        $category->auto_meta_keywords   = $this->request->post('auto_meta_keywords');
                        $category->auto_meta_desc       = $this->request->post('auto_meta_desc');
                        $category->auto_description     = $this->request->post('auto_description');

                        $this->categories->update_category($category->id, $category);
                        $this->design->assign("category", $category);
                        $result->success = true;
                    } else {
                        $result->success = false;
                    }
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
