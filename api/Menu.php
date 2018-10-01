<?php

require_once('Okay.php');

class Menu extends Okay {

    // Список указателей на элементы меню в дереве элементов меню (ключ = id элемента меню)
    private $all_menu_items;
    // Дерево элементов меню
    private $menu_items_tree;
    const MENU_VAR_PREFIX = "menu_";

    private function init_menu_items() {
        $menu_items = $this->menu_items_tree = $this->all_menu_items = array();
        $lang_sql = $this->languages->get_query(array('object'=>'menu_item', 'px'=>'it'));
        // Выбираем все элементы меню
        $query = $this->db->placehold("SELECT 
                it.id,
                it.menu_id,
                it.parent_id,
                it.url,
                it.is_target_blank,
                it.visible,
                it.position,
                $lang_sql->fields
            FROM __menu_items it
            $lang_sql->join
            ORDER BY it.parent_id, it.position
        ");
        $this->db->query($query);
        foreach ($this->db->results() as $item) {
            if (!isset($menu_items[$item->menu_id]))  {
                $menu_items[$item->menu_id] = array();
            }
            $menu_items[$item->menu_id][] = $item;
        }

        foreach ($menu_items as $menu_id => $items) {
            // Дерево элементов меню
            $tree = new stdClass();
            $tree->submenus = array();

            // Указатели на узлы дерева
            $pointers = array();
            $pointers[0] = &$tree;
            $pointers[0]->path = array();
            $pointers[0]->level = 0;

            $finish = false;
            // Не кончаем, пока не кончатся элементы, или пока ниодну из оставшихся некуда приткнуть
            while (!empty($items) && !$finish) {
                $flag = false;
                // Проходим все выбранные элементы
                foreach ($items as $k => $item) {
                    if (isset($pointers[$item->parent_id])) {
                        // В дерево элементов меню (через указатель) добавляем текущий элемент
                        $pointers[$item->id] = $pointers[$item->parent_id]->submenus[] = $item;

                        // Путь к текущему элементу
                        $curr = $pointers[$item->id];
                        $pointers[$item->id]->path = array_merge((array)$pointers[$item->parent_id]->path, array($curr));

                        // Уровень вложенности элементов
                        $pointers[$item->id]->level = 1 + $pointers[$item->parent_id]->level;

                        // Убираем использованный элемент из массива
                        unset($items[$k]);
                        $flag = true;
                    }
                }
                if (!$flag) $finish = true;
            }

            // Для каждого элемента id всех его деток узнаем
            $ids = array_reverse(array_keys($pointers));
            foreach ($ids as $id) {
                if ($id > 0) {
                    $pointers[$id]->children[] = $id;

                    if (isset($pointers[$pointers[$id]->parent_id]->children)) {
                        $pointers[$pointers[$id]->parent_id]->children = array_merge($pointers[$id]->children, $pointers[$pointers[$id]->parent_id]->children);
                    } else {
                        $pointers[$pointers[$id]->parent_id]->children = $pointers[$id]->children;
                    }
                }
            }
            unset($pointers[0]);
            unset($ids);
            $this->menu_items_tree[$menu_id] = $tree->submenus;
            $this->all_menu_items = $this->all_menu_items+$pointers;
        }
    }

    public function get_menu_items_tree($menu_id = 0) {
        if (!isset($this->menu_items_tree)) {
            $this->init_menu_items();
        }
        if ($menu_id > 0) {
            if (!isset($this->menu_items_tree[$menu_id])) {
                return array();
            }
            return $this->menu_items_tree[$menu_id];
        }
        return $this->menu_items_tree;
    }

    public function get_menu_items() {
        if (!isset($this->menu_items_tree)) {
            $this->init_menu_items();
        }
        return $this->all_menu_items;
    }

    public function add_menu_item($menu_item) {
        $menu_item = (object)$menu_item;
        $result = $this->languages->get_description($menu_item, 'menu_item');

        $this->db->query("INSERT INTO __menu_items SET ?%", $menu_item);
        $id = $this->db->insert_id();
        $this->db->query("UPDATE __menu_items SET position=id WHERE id=?", $id);

        if(!empty($result->description)) {
            $this->languages->action_description($id, $result->description, 'menu_item');
        }

        unset($this->menu_items_tree);
        unset($this->all_menu_items);
        return $id;
    }

    public function update_menu_item($id, $menu_item) {
        $menu_item = (object)$menu_item;
        $result = $this->languages->get_description($menu_item, 'menu_item');

        $query = $this->db->placehold("UPDATE __menu_items SET ?% WHERE id=? LIMIT 1", $menu_item, (int)$id);
        $this->db->query($query);

        if(!empty($result->description)) {
            $this->languages->action_description($id, $result->description, 'menu_item', $this->languages->lang_id());
        }

        unset($this->menu_items_tree);
        unset($this->all_menu_items);
        return (int)$id;
    }

    public function delete_menu_item($id) {
        if(!empty($id)) {
            $id = (int)$id;
            $query = $this->db->placehold("DELETE FROM __menu_items WHERE id=? LIMIT 1", $id);
            if($this->db->query($query)) {
                $this->db->query("DELETE FROM __lang_menu_items where menu_item_id=?", $id);
                return true;
            }
        }
        return false;
    }

    /*Выбираем все меню*/
    public function get_menus($filter = array()) {
        $visible_filter = '';

        if(isset($filter['visible'])) {
            $visible_filter = $this->db->placehold('AND visible = ?', (int)$filter['visible']);
        }

        $query = "SELECT * FROM __menu WHERE 1 $visible_filter ORDER BY position";

        $this->db->query($query);
        $menus = $this->db->results();
        if (!empty($menus)) {
            foreach ($menus as $menu) {
                $menu->var = '{$'.Menu::MENU_VAR_PREFIX.$menu->group_id."}";
            }
        }
        return $menus;
    }

    /*Выбираем определенное меню*/
    public function get_menu($id, $visible = false) {
        if (empty($id)) {
            return false;
        }

        $is_visible = '';
        if($visible) {
            $is_visible = 'AND visible=1';
        }

        if(is_int($id)) {
            $menu_id_filter = $this->db->placehold('AND id=? ', $id);
        } else {
            $menu_id_filter = $this->db->placehold('AND group_id=? ', $id);
        }

        $query = $this->db->placehold("SELECT * FROM __menu WHERE 1 $menu_id_filter $is_visible LIMIT 1");
        $this->db->query($query);
        $menu = $this->db->result();
        if (!empty($menu)) {
            $menu->var = '{$'.Menu::MENU_VAR_PREFIX.$menu->group_id."}";
        }
        return $menu;
    }

    /*Обновляем меню*/
    public function update_menu($id, $menu) {
        $query = $this->db->placehold("UPDATE __menu SET ?% WHERE id in (?@) LIMIT ?", $menu, (array)$id, count((array)$id));
        if($this->db->query($query)) {
            return $id;
        } else {
            return false;
        }
    }

    /*Добавляем меню*/
    public function add_menu($menu) {
        $menu = (array) $menu;

        if($this->db->query("INSERT INTO __menu SET ?%", $menu)) {
            $id = $this->db->insert_id();
            $this->db->query("UPDATE __menu SET position=id WHERE id=?", $id);
            return $id;
        } else {
            return false;
        }
    }

    /*Удаляем меню*/
    public function delete_menu($id) {
        $id = (int)$id;
        if(!empty($id)) {
            $this->db->query("SELECT id FROM __menu_items where menu_id=?", $id);
            $menu_items_ids = $this->db->results('id');
            if (!empty($menu_items_ids)) {
                foreach ($menu_items_ids as $bi_id) {
                    $this->delete_menu_item($bi_id);
                }
            }

            $query = $this->db->placehold("DELETE FROM __menu WHERE id=? LIMIT 1", $id);
            if($this->db->query($query)) {
                return true;
            }
        }
        return false;
    }

}
