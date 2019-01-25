<?php

require_once('api/Okay.php');

class SettingsFeedAdmin extends Okay {

    /*Настройки выгрузки в яндекс*/
    public function fetch() {
        if($this->request->method('POST')) {
            $this->settings->yandex_export_not_in_stock = $this->request->post('yandex_export_not_in_stock', 'boolean');
            $this->settings->yandex_available_for_retail_store = $this->request->post('yandex_available_for_retail_store', 'boolean');
            $this->settings->yandex_available_for_reservation = $this->request->post('yandex_available_for_reservation', 'boolean');
            $this->settings->yandex_short_description = $this->request->post('yandex_short_description', 'boolean');
            $this->settings->yandex_has_manufacturer_warranty = $this->request->post('yandex_has_manufacturer_warranty', 'boolean');
            $this->settings->yandex_has_seller_warranty = $this->request->post('yandex_has_seller_warranty', 'boolean');
            $this->settings->yandex_no_export_without_price = $this->request->post('yandex_no_export_without_price', 'boolean');
            $this->settings->yandex_sales_notes = $this->request->post('yandex_sales_notes');
            $this->design->assign('message_success', 'saved');
        }

        return $this->design->fetch('settings_feed.tpl');
    }

}
