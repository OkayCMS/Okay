<?php

namespace Integration1C\Export;


class ExportOrders extends Export
{

    public function __construct($okay, $integration_1c) {
        parent::__construct($okay, $integration_1c);
    }
    
    public function export() {
        $no_spaces = '<?xml version="1.0" encoding="utf-8"?>
        <КоммерческаяИнформация ВерсияСхемы="2.04" ДатаФормирования="' . date('Y-m-d') . '"></КоммерческаяИнформация>';
        $xml = new \SimpleXMLElement($no_spaces);

        $orders = $this->okay->orders->get_orders(array('modified_since'=>$this->okay->settings->last_1c_orders_export_date));
        foreach($orders as $order) {
            $date = new \DateTime($order->date);

            $doc = $xml->addChild ("Документ");
            $doc->addChild ( "Ид", $order->id);
            $doc->addChild ( "Номер", $order->id);
            $doc->addChild ( "Дата", $date->format('Y-m-d'));
            $doc->addChild ( "ХозОперация", "Заказ товара" );
            $doc->addChild ( "Роль", "Продавец" );
            $doc->addChild ( "Валюта", "грн" );//Вводится в зависимости от валюты в 1С // todo валюта сайта и 1С
            $doc->addChild ( "Курс", "1" );
            $doc->addChild ( "Сумма", $order->total_price);
            $doc->addChild ( "Время",  $date->format('H:i:s'));
            $doc->addChild ( "Комментарий", $order->comment. 'Адрес доставки: '.$order->address);

            // Контрагенты
            $k1 = $doc->addChild ( 'Контрагенты' );
            $k1_1 = $k1->addChild ( 'Контрагент' );
            $k1_2 = $k1_1->addChild ( "Ид", $order->name);
            $k1_2 = $k1_1->addChild ( "Наименование", $order->name);
            $k1_2 = $k1_1->addChild ( "Роль", "Покупатель" );
            $k1_2 = $k1_1->addChild ( "ПолноеНаименование", $order->name );

            //Представители
            $p1_1 = $k1_1->addChild ( 'Представители' );
            $p1_2 = $p1_1->addChild ( 'Представитель' );
            $p1_3 = $p1_2->addChild ( 'Контрагент' );
            $p1_4 = $p1_3->addChild ( "Отношение", "Контактное лицо" );
            $p1_4 = $p1_3->addChild ( "Ид", $order->name );
            $p1_4 = $p1_3->addChild ( "Наименование", $order->name);

            // Доп параметры
            $addr = $k1_1->addChild ('АдресРегистрации');
            $addr->addChild ( 'Представление', $order->address );
            $addrField = $addr->addChild ( 'АдресноеПоле' );
            $addrField->addChild ( 'Тип', 'Страна' );
            $addrField->addChild ( 'Значение', 'УКРАИНА' );// Для России значение РОССИЯ
            $addrField = $addr->addChild ( 'АдресноеПоле' );
            $addrField->addChild ( 'Тип', 'Регион' );
            $addrField->addChild ( 'Значение', $order->address );

            $contacts = $k1_1->addChild ( 'Контакты' );
            $cont = $contacts->addChild ( 'Контакт' );
            $cont->addChild ( 'Тип', 'ТелефонРабочий' );
            $cont->addChild ( 'Значение', $order->phone );
            $cont = $contacts->addChild ( 'Контакт' );
            $cont->addChild ( 'Тип', 'Почта' );
            $cont->addChild ( 'Значение', $order->email );


            $purchases = $this->okay->orders->get_purchases(array('order_id'=>intval($order->id)));

            $t1 = $doc->addChild ( 'Товары' );
            foreach($purchases as $purchase) {
                if(!empty($purchase->product_id) && !empty($purchase->variant_id)) {
                    $this->okay->db->query('SELECT external_id FROM __products WHERE id=?', $purchase->product_id);
                    $id_p = $this->okay->db->result('external_id');
                    $this->okay->db->query('SELECT external_id FROM __variants WHERE id=?', $purchase->variant_id);
                    $id_v = $this->okay->db->result('external_id');

                    // Если нет внешнего ключа товара - указываем наш id
                    if(!empty($id_p)) {
                        $id = $id_p;
                    } else {
                        $this->okay->db->query('UPDATE __products SET external_id=id WHERE id=?', $purchase->product_id);
                        $id = $purchase->product_id;
                    }

                    // Если нет внешнего ключа варианта - указываем наш id
                    if(!empty($id_v)) {
                        $id = $id.'#'.$id_v;
                    } else {
                        $this->okay->db->query('UPDATE __variants SET external_id=id WHERE id=?', $purchase->variant_id);
                        $id = $id.'#'.$purchase->variant_id;
                    }

                    $t1_1 = $t1->addChild ( 'Товар' );

                    if($id) {
                        $t1_2 = $t1_1->addChild ( "Ид", $id);
                    }

                    $t1_2 = $t1_1->addChild ( "Артикул", $purchase->sku);

                    $name = $purchase->product_name;
                    if($purchase->variant_name) {
                        $name .= " $purchase->variant_name $id";
                    }
                    $t1_2 = $t1_1->addChild ( "Наименование", $name);
                    $t1_2 = $t1_1->addChild ( "ЦенаЗаЕдиницу", $purchase->price*(100-$order->discount)/100);
                    $t1_2 = $t1_1->addChild ( "Количество", $purchase->amount );
                    $t1_2 = $t1_1->addChild ( "Сумма", $purchase->amount*$purchase->price*(100-$order->discount)/100);


                    $t1_2 = $t1_1->addChild ( "Скидки" );
                    $t1_3 = $t1_2->addChild ( "Скидка" );
                    $t1_4 = $t1_3->addChild ( "Сумма", $purchase->amount*$purchase->price*(100-$order->discount)/100);
                    $t1_4 = $t1_3->addChild ( "УчтеноВСумме", "false" );


                    $t1_2 = $t1_1->addChild ( "ЗначенияРеквизитов" );
                    $t1_3 = $t1_2->addChild ( "ЗначениеРеквизита" );
                    $t1_4 = $t1_3->addChild ( "Наименование", "ВидНоменклатуры" );
                    $t1_4 = $t1_3->addChild ( "Значение", "Товар" );

                    //$t1_2 = $t1_1->addChild ( "ЗначенияРеквизитов" );
                    $t1_3 = $t1_2->addChild ( "ЗначениеРеквизита" );
                    $t1_4 = $t1_3->addChild ( "Наименование", "ТипНоменклатуры" );
                    $t1_4 = $t1_3->addChild ( "Значение", "Товар" );
                }
            }

            // Доставка
            if($order->delivery_price>0 && !$order->separate_delivery) {
                $t1 = $t1->addChild ( 'Товар' );
                $t1->addChild ( "Ид", 'ORDER_DELIVERY');
                $t1->addChild ( "Наименование", 'Доставка');
                $t1->addChild ( "ЦенаЗаЕдиницу", $order->delivery_price);
                $t1->addChild ( "Количество", 1 );
                $t1->addChild ( "Сумма", $order->delivery_price);
                $t1_2 = $t1->addChild ( "ЗначенияРеквизитов" );
                $t1_3 = $t1_2->addChild ( "ЗначениеРеквизита" );
                $t1_4 = $t1_3->addChild ( "Наименование", "ВидНоменклатуры" );
                $t1_4 = $t1_3->addChild ( "Значение", "Услуга" );

                //$t1_2 = $t1->addChild ( "ЗначенияРеквизитов" );
                $t1_3 = $t1_2->addChild ( "ЗначениеРеквизита" );
                $t1_4 = $t1_3->addChild ( "Наименование", "ТипНоменклатуры" );
                $t1_4 = $t1_3->addChild ( "Значение", "Услуга" );
            }

            // Способ оплаты и доставки
            $s1_2 = $doc->addChild ( "ЗначенияРеквизитов");

            $payment_method = $this->okay->payment->get_payment_method($order->payment_method_id);
            $delivery = $this->okay->delivery->get_delivery($order->delivery_id);

            if($payment_method) {
                $s1_3 = $s1_2->addChild ( "ЗначениеРеквизита");
                $s1_3->addChild ( "Наименование", "Метод оплаты" );
                $s1_3->addChild ( "Значение", $payment_method->name );
            }
            if($delivery) {
                $s1_3 = $s1_2->addChild ( "ЗначениеРеквизита");
                $s1_3->addChild ( "Наименование", "Способ доставки" );
                $s1_3->addChild ( "Значение", $delivery->name);
            }
            $s1_3 = $s1_2->addChild ( "ЗначениеРеквизита");
            $s1_3->addChild ( "Наименование", "Заказ оплачен" );
            $s1_3->addChild ( "Значение", $order->paid?'true':'false' );


            // Статус
            if($order->status == 0) {
                $s1_3 = $s1_2->addChild ( "ЗначениеРеквизита" );
                $s1_3->addChild ( "Наименование", "Статус заказа" );
                $s1_3->addChild ( "Значение", "Новый" );
            }
            if($order->status == 1) {
                $s1_3 = $s1_2->addChild ( "ЗначениеРеквизита" );
                $s1_3->addChild ( "Наименование", "Статус заказа" );
                $s1_3->addChild ( "Значение", "[N] Принят" );
            }
            if($order->status == 2) {
                $s1_3 = $s1_2->addChild ( "ЗначениеРеквизита" );
                $s1_3->addChild ( "Наименование", "Статус заказа" );
                $s1_3->addChild ( "Значение", "[F] Доставлен" );
            }
            if($order->status == 3) {
                $s1_3 = $s1_2->addChild ( "ЗначениеРеквизита" );
                $s1_3->addChild ( "Наименование", "Отменен" );
                $s1_3->addChild ( "Значение", "true" );
            }
        }
        
        return $xml->asXML();
    }
}