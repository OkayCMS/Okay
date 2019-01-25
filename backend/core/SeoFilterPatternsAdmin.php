<?php

require_once('api/Okay.php');

class SeoFilterPatternsAdmin extends Okay {

    public function fetch() {
        $this->design->set_templates_dir('backend/design/html');
        $this->design->set_compiled_dir('backend/design/compiled');

        if($this->request->post("ajax")){

            $result = new stdClass();
            if($this->request->post("action") == "get_features") {
                $category_id = $this->request->post("category_id", "integer");
                $result->features = $this->features->get_features(array('category_id'=>$category_id, 'in_filter'=>1));
                $result->success = true;
            }
            /*Получение SEO шаблонов*/
            if($this->request->post("action") == "get") {

                $category = $this->categories->get_category($this->request->post("category_id", "integer"));
                if (!empty($category->id)) {
                    $features_ids = array();
                    foreach ($this->seo_filter_patterns->get_patterns(array('category_id'=>$category->id)) as $p) {
                        $patterns[$p->id] = $p;
                        if ($p->feature_id) {
                            $features_ids[] = $p->feature_id;
                        }
                    }

                    $features_ids = array_unique($features_ids);
                    foreach ($this->features->get_features(array('id'=>$features_ids)) as $f) {
                        $features[$f->id] = $f;
                    }

                    foreach ($patterns as $p) {
                        if ($p->feature_id && isset($features[$p->feature_id])) {
                            $p->feature = $features[$p->feature_id];
                        }
                    }
                    $this->design->assign('patterns', $patterns);
                    $this->design->assign("category", $category);
                    $features_aliases = $this->features_aliases->get_features_aliases();
                    $this->design->assign("features_aliases", $features_aliases);
                    $result->success = true;
                } else {
                    $result->success = false;
                }
                $result->tpl = $this->design->fetch("seo_filter_patterns_ajax.tpl");

            }

            /*Обновление шаблона данных категории*/
            if($this->request->post("action") == "set") {

                $this->settings->max_filter_brands          = $this->request->post('max_filter_brands', 'integer', 1);
                $this->settings->max_filter_filter          = $this->request->post('max_filter_filter', 'integer', 1);
                $this->settings->max_filter_features_values = $this->request->post('max_filter_features_values', 'integer', 1);
                $this->settings->max_filter_features        = $this->request->post('max_filter_features', 'integer', 1);
                $this->settings->max_filter_depth           = $this->request->post('max_filter_depth', 'integer', 1);

                $result->success = true;
                
                $category = new stdClass();
                $category->id = $this->request->post("category_id", "integer");
                if ($category = $this->categories->get_category($category->id)) {
                    $seo_filter_patterns = $this->request->post('seo_filter_patterns');
                    $patterns = array();
                    if(is_array($seo_filter_patterns)) {

                        foreach($this->request->post('seo_filter_patterns') as $n=>$pa) {
                            foreach($pa as $i=>$p) {
                                if(empty($patterns[$i])) {
                                    $patterns[$i] = new stdClass;
                                }
                                $patterns[$i]->$n = $p;
                                if ($n == 'id') {
                                    $patterns_ids[] = $p;
                                }
                            }
                        }
                    }
                    
                    // Удалим паттерны которые не запостили
                    $current_patterns = $this->seo_filter_patterns->get_patterns(array('category_id' => $category->id));
                    foreach ($current_patterns as $current_pattern) {
                        if (!in_array($current_pattern->id, $patterns_ids)) {
                            $this->seo_filter_patterns->delete_pattern($current_pattern->id);
                        }
                    }

                    if ($patterns) {
                        foreach ($patterns as $pattern) {
                            if (!$pattern->feature_id) {
                                $pattern->feature_id = null;
                            }
                            if(!empty($pattern->id)) {
                                $this->seo_filter_patterns->update_pattern($pattern->id, $pattern);
                            } else {
                                $pattern->category_id = $category->id;
                                $pattern->id = $this->seo_filter_patterns->add_pattern($pattern);
                            }
                        }
                    }

                    unset($patterns);
                    $features_ids = array();
                    foreach ($this->seo_filter_patterns->get_patterns(array('category_id'=>$category->id)) as $p) {
                        $patterns[$p->id] = $p;
                        if ($p->feature_id) {
                            $features_ids[] = $p->feature_id;
                        }
                    }

                    $features_ids = array_unique($features_ids);
                    foreach ($this->features->get_features(array('id'=>$features_ids)) as $f) {
                        $features[$f->id] = $f;
                    }

                    foreach ($patterns as $p) {
                        if ($p->feature_id && isset($features[$p->feature_id])) {
                            $p->feature = $features[$p->feature_id];
                        }
                    }
                    $this->design->assign('patterns', $patterns);
                    $this->design->assign("category", $category);
                    $features_aliases = $this->features_aliases->get_features_aliases();
                    $this->design->assign("features_aliases", $features_aliases);
                    $result->tpl = $this->design->fetch("seo_filter_patterns_ajax.tpl");
                }
            }

            if ($result) {
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
        return $this->design->fetch('seo_filter_patterns.tpl');
    }
}
