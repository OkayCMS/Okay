<?php

require_once('api/Okay.php');

class MenuAdmin extends Okay {

    public function fetch() {
        $menu = new stdClass();
        $menu_items = array();
        /*Принимаем данные о меню*/
        if($this->request->method('POST')) {
            $menu->id = $this->request->post('id', 'integer');
            $menu->group_id = trim($this->request->post('group_id', 'string'));
            $menu->name = $this->request->post('name');
            $menu->visible = $this->request->post('visible', 'boolean');

            $menu->group_id = preg_replace("/[\s]+/ui", '', $menu->group_id);
            $menu->group_id = strtolower(preg_replace("/[^0-9a-z_]+/ui", '', $menu->group_id));

            if ($this->request->post('menu_items')) {
                foreach ($this->request->post('menu_items') as $field => $values) {
                    foreach ($values as $i => $v) {
                        if (empty($menu_items[$i])) {
                            $menu_items[$i] = new stdClass();
                            $menu_items[$i]->i_tm = $i;
                        }
                        $menu_items[$i]->$field = $v;
                    }
                }
                // сортируем по родителю
                usort($menu_items, function ($item1, $item2) {
                    if ($item1->parent_index == $item2->parent_index) {
                        return $item1->i_tm - $item2->i_tm;
                    }
                    return strcmp($item1->parent_index, $item2->parent_index);
                });
                $tm = array();
                $local = array(trim($this->config->root_url, "/"), trim(preg_replace("~^https?://~", "", $this->config->root_url), "/"));
                foreach ($menu_items as $key => $item) {
                    foreach ($local as $l) {
                        $item->url = preg_replace("~^$l/?~", "", $item->url);
                    }
                    $tm[$item->index] = $item;
                }
                $menu_items = $tm;
            }

            if(($m = $this->menu->get_menu($menu->group_id)) && $m->id!=$menu->id) {
                $this->design->assign('message_error', 'group_id_exists');
                $menu_items = $this->build_tree($menu_items);
            } elseif(empty($menu->group_id)) {
                $this->design->assign('message_error', 'empty_group_id');
                $menu_items = $this->build_tree($menu_items);
            } else {
                /*Добавляем/обновляем меню*/
                if (empty($menu->id)) {
                    $menu->id = $this->menu->add_menu($menu);
                    $this->design->assign('message_success', 'added');
                } else {
                    $this->menu->update_menu($menu->id, $menu);
                    $this->design->assign('message_success', 'updated');
                }
                if ($menu->id) {
                    $menu_items_ids = array();
                    if(is_array($menu_items)) {
                        foreach ($menu_items as $i=>$item) {
                            if ($item->parent_index > 0) {
                                if (!isset($menu_items[$item->parent_index]->id)) {
                                    unset($menu_items[$i]);
                                    continue;
                                }
                                $item->parent_id = $menu_items[$item->parent_index]->id;
                            } else {
                                $item->parent_id = 0;
                            }

                            $item->menu_id = $menu->id;
                            unset($item->index);
                            unset($item->parent_index);
                            unset($item->i_tm);
                            if (empty($item->id)) {
                                $item->id = $this->menu->add_menu_item($item);
                            } else {
                                $this->menu->update_menu_item($item->id, $item);
                            }
                            if ($item->id) {
                                $menu_items_ids[] = $item->id;
                            }
                        }
                    }

                    // удаляем не переданные элементы меню
                    $this->db->query("SELECT id FROM __menu_items WHERE menu_id=?", $menu->id);
                    foreach ($this->db->results('id') as $current_id) {
                        if (!in_array($current_id, $menu_items_ids)) {
                            $this->menu->delete_menu_item($current_id);
                        }
                    }

                    // Отсортировать  элементы меню
                    asort($menu_items_ids);
                    $i = 0;
                    foreach($menu_items_ids as $menu_item_id) {
                        $this->menu->update_menu_item($menu_items_ids[$i], array('position'=>$menu_item_id));
                        $i++;
                    }

                    $menu_items = $this->menu->get_menu_items_tree((int)$menu->id);
                }
                $menu = $this->menu->get_menu($menu->id);
            }
        } else {
            /*Отображение меню*/
            $id = $this->request->get('id', 'integer');
            if(!empty($id)) {
                $menu = $this->menu->get_menu((int)$id);
                if (!empty($menu->id)) {
                    $menu_items = $this->menu->get_menu_items_tree((int)$menu->id);
                }
            } else {
                $menu->visible = 1;
            }
        }

        $this->design->assign('menu', $menu);
        $this->design->assign('menu_items', $menu_items);
        return $this->design->fetch('menu.tpl');
    }

    private function build_tree($items) {
        $tree = new stdClass();
        $tree->submenus = array();

        // Указатели на узлы дерева
        $pointers = array();
        $pointers[0] = &$tree;

        $finish = false;
        // Не кончаем, пока не кончатся элементы, или пока ниодну из оставшихся некуда приткнуть
        while (!empty($items) && !$finish) {
            $flag = false;
            // Проходим все выбранные элементы
            foreach ($items as $k => $item) {
                if (isset($pointers[$item->parent_index])) {
                    // В дерево элементов меню (через указатель) добавляем текущий элемент
                    $pointers[$item->index] = $pointers[$item->parent_index]->submenus[] = $item;

                    // Убираем использованный элемент из массива
                    unset($items[$k]);
                    $flag = true;
                }
            }
            if (!$flag) $finish = true;
        }
        unset($pointers[0]);
        return $tree->submenus;
    }

}
