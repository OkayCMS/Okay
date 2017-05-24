<?php

require_once('api/Okay.php');

class OrderSettingsAdmin extends Okay {

    public function fetch() {

        /*Статусы заказов*/
        if($this->request->post('status')) {
            // Сортировка
            if($this->request->post('positions')){
                $positions = $this->request->post('positions');
                $ids = array_keys($positions);
                sort($positions);
                foreach($positions as $i=>$position) {
                    $this->orderstatus->update_status($ids[$i], array('position'=>$position));
                }
            }

            /*Создание статуса*/
            if($this->request->post('new_name')){
                $new_status = array();
                $new_params = array();
                $new_status = $this->request->post('new_name');
                $new_params = $this->request->post('new_is_close');

                foreach ($new_status as $id=>$value) {
                    if(!empty($value)) {
                        $new_stat = new stdClass();
                        $new_stat->name = $value;
                        $new_stat->is_close = $new_params[$id];
                        $this->orderstatus->add_status($new_stat);
                    }
                }
            }

            /*Обновление статуса*/
            if($this->request->post('name')) {
                $current_status = array();
                $is_close = array();
                $ids_status = array();
                $current_status = $this->request->post('name');
                $is_close = $this->request->post('is_close');
                $ids_status = $this->request->post('id');
                foreach ($current_status as $id=>$value) {
                    $update_status = new stdClass();
                    $update_status->name = $value;
                    $update_status->is_close = $is_close[$id];
                    $this->orderstatus->update_status($id,$update_status);
                }
            }

            // Действия с выбранными
            $ids = $this->request->post('check');
            if(is_array($ids)) {
                switch($this->request->post('action')) {
                    case 'delete': {
                        /*Удалить статус*/
                        foreach($ids as $id) {
                            $result[$id][] = $this->orderstatus->delete_status($id);
                        }
                        $this->design->assign("error_status", $result);
                        break;
                    }
                }
            }
        }
        // Отображение
        $orders_status = $this->orderstatus->get_status();
        $this->design->assign('orders_status', $orders_status);

        /*Метки заказов*/
        if($this->request->post('labels')) {
            // Сортировка
            if($this->request->post('positions')){
                $positions = $this->request->post('positions');
                $ids = array_keys($positions);
                sort($positions);
                foreach($positions as $i=>$position) {
                    $this->orderlabels->update_label($ids[$i], array('position'=>$position));
                }
            }

            /*Добавление метки*/
            if($this->request->post('new_name')){
                $new_labels = array();
                $new_colors = array();
                $new_labels = $this->request->post('new_name');
                $new_colors = $this->request->post('new_color');
                foreach ($new_labels as $id=>$value) {
                    if(!empty($value)) {
                        $new_label = new stdClass();
                        $new_label->name = $value;
                        $new_label->color = $new_colors[$id];
                        $this->orderlabels->add_label($new_label);
                    }
                }
            }

            /*Обновление метки*/
            if($this->request->post('name')) {
                $current_labels = array();
                $colors = array();
                $ids = array();
                $current_labels = $this->request->post('name');
                $colors = $this->request->post('color');
                $ids = $this->request->post('id');
                foreach ($current_labels as $id=>$value) {
                    $update_label = new stdClass();
                    $update_label->name = $value;
                    $update_label->color = $colors[$id];
                    $this->orderlabels->update_label($ids[$id],$update_label);
                }
            }

            // Действия с выбранными
            $ids = $this->request->post('check');
            if(is_array($ids)) {
                switch($this->request->post('action')) {
                    case 'delete': {
                        /*Удалить метку*/
                        foreach($ids as $id) {
                            $this->orderlabels->delete_label($id);
                        }
                        break;
                    }
                }
            }
        }
        // Отображение
        $labels = $this->orderlabels->get_labels();
        $this->design->assign('labels', $labels);

        return $this->design->fetch('order_settings.tpl');
    }

}
?>
