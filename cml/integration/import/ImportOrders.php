<?php

namespace Integration1C\Import;


class ImportOrders extends Import
{

    public function __construct($okay, $integration_1c) {
        parent::__construct($okay, $integration_1c);
    }

    /**
     * @param string $xml_file Full path to xml file
     * @return string
     */
    public function import($xml_file) {

        $xml = \simplexml_load_file($xml_file);
        
        $orders_statuses = array();
        foreach ($this->okay->orderstatus->get_status() as $s) {
            $orders_statuses[$s->status_1c] = $s;
        }
        
        // Если никакой статус не отметили для новых, возьмем первый в списке
        if (!isset($orders_statuses['new'])) {
            $orders_statuses['new'] = reset($orders_statuses);
        }
        
        foreach($xml->Документ as $xml_order) {
            $order = new \stdClass();

            $order->status_id = 0;
            
            $order->id     = (int)$xml_order->Номер;
            $existed_order = $this->okay->orders->get_order($order->id);

            $order->date = $xml_order->Дата.' '.$xml_order->Время;
            $order->name = $xml_order->Контрагенты->Контрагент->Наименование;

            $accepted = false;
            $to_delete = false;
            if(isset($xml_order->ЗначенияРеквизитов->ЗначениеРеквизита)) {
                foreach ($xml_order->ЗначенияРеквизитов->ЗначениеРеквизита as $r) {
                    switch ($r->Наименование) {
                        case 'Проведен':
                            $accepted = ($r->Значение == 'true');
                            break;
                        case 'ПометкаУдаления':
                            $to_delete = ($r->Значение == 'true');
                            break;
                    }
                }
            }

            // Выставляем id нужного статуса
            if ($to_delete === true) {
                $order->status_id = $orders_statuses['to_delete']->id;
            } elseif ($accepted === true) {
                $order->status_id = $orders_statuses['accepted']->id;
            } elseif ($accepted === false) {
                $order->status_id = $orders_statuses['new']->id;
            }

            if ($existed_order) {
                $this->okay->orders->update_order($order->id, $order);
            } else {
                $order->id = $this->okay->orders->add_order($order);
            }

            if (empty($order->id)) {
                return "error: empty order_id\n";
            }
            
            $purchases_ids = array();
            // Товары
            foreach ($xml_order->Товары->Товар as $xml_product) {
                $purchase = null;
                //  Id товара и варианта (если есть) по 1С
                $product_1c_id = $variant_1c_id = '';
                @list($product_1c_id, $variant_1c_id) = explode('#', (string)$xml_product->Ид);
                if(empty($product_1c_id)) {
                    $product_1c_id = '';
                }
                if(empty($variant_1c_id)) {
                    $variant_1c_id = '';
                }

                // Ищем товар
                $this->okay->db->query('SELECT id FROM __products WHERE external_id=?', $product_1c_id);
                $product_id = $this->okay->db->result('id');

                $variant_id = null;
                // Если прилетел ID варианта из 1С, ищем вариант по нему
                if ($variant_1c_id) {
                    $this->okay->db->query('SELECT id FROM __variants WHERE external_id=? AND product_id=?', $variant_1c_id, $product_id);
                    $variant_id = $this->okay->db->result('id');
                // или попробуем поискать по артикулу
                } elseif ($sku = (string)$xml_product->Артикул) {
                    $this->okay->db->query('SELECT id FROM __variants WHERE sku=? AND product_id=?', $sku, $product_id);
                    $variant_id = $this->okay->db->result('id');
                // последняя попытка, это если у товара всего один вариант, вероятнее всего он нужен
                } else {
                    $this->okay->db->query('SELECT id FROM __variants WHERE product_id=?', $product_id);
                    $variant_ids = $this->okay->db->results('id');
                    if (count($variant_ids) == 1) {
                        $variant_id = reset($variant_ids);
                    }
                }
                
                $purchase = new \stdClass;
                $purchase->order_id     = $order->id;
                $purchase->product_id   = $product_id;
                $purchase->variant_id   = $variant_id;
                $purchase->sku          = (string)$xml_product->Артикул;
                $purchase->product_name = (string)$xml_product->Наименование;
                $purchase->amount       = (int)$xml_product->Количество;
                $purchase->price        = (float)$xml_product->ЦенаЗаЕдиницу;

                if (isset($xml_product->Скидки->Скидка)) {
                    $discount = $xml_product->Скидки->Скидка->Процент;
                    $purchase->price = $purchase->price*(100-$discount)/100;
                }
                
                if (!empty($variant_id)) {
                    $this->okay->db->query("SELECT id FROM __purchases WHERE order_id=? AND product_id=? AND variant_id=?", $order->id, $product_id, $variant_id);
                    $purchase_id = $this->okay->db->result('id');
                    if (!empty($purchase_id)) {
                        $purchase_id = $this->okay->orders->update_purchase($purchase_id, $purchase);
                    } else {
                        $purchase_id = $this->okay->orders->add_purchase($purchase);
                    }
                    $purchases_ids[] = $purchase_id;
                }
            }
            
            // Удалим покупки, которых нет в файле
            foreach ($this->okay->orders->get_purchases(array('order_id'=>intval($order->id))) as $purchase) {
                if (!in_array($purchase->id, $purchases_ids)) {
                    $this->okay->orders->delete_purchase($purchase->id);
                }
            }

            $this->okay->db->query('UPDATE __orders SET discount=0, total_price=? WHERE id=? LIMIT 1', $xml_order->Сумма, $order->id);
        }
        
        return "success\n";
    }
}
