<?php

namespace Integration1C\Import;


class ImportOffers extends Import
{

    /**
     * @var array список валют, ключ массива - code
     */
    private $currencies_by_code;

    /**
     * @var array список валют, ключ массива - sign
     */
    private $currencies_by_sign;

    /**
     * @var bool false - на сайте одна валюта, true - много. 
     */
    private $is_multi_currency = false;

    /**
     * @var object основная валюта сайта
     */
    private $base_currency;
    
    public function __construct($okay, $integration_1c) {
        parent::__construct($okay, $integration_1c);
        
        $this->init_currencies();
    }
    
    /**
     * @param string $xml_file Full path to xml file
     * @return string
     */
    public function import($xml_file) {
        
        // Варианты
        $z = new \XMLReader;
        $z->open($xml_file);

        while ($z->read() && $z->name !== 'Предложение');

        // Последний вариант, на котором остановились
        $last_variant_num = 0;
        if (!empty($this->integration_1c->get_from_storage('imported_variant_num'))) {
            $last_variant_num = $this->integration_1c->get_from_storage('imported_variant_num');
        }

        // Номер текущего товара
        $current_variant_num = 0;

        while ($z->name === 'Предложение') {
            if ($current_variant_num >= $last_variant_num) {
                $xml = new \SimpleXMLElement($z->readOuterXML());
                // Варианты
                $this->import_variant($xml);

                $exec_time = microtime(true) - $this->integration_1c->start_time;
                if ($exec_time+1 >= $this->integration_1c->max_exec_time) {
                    
                    // Запоминаем на каком предложении остановились
                    $this->integration_1c->set_to_storage('imported_variant_num', $current_variant_num);

                    $result =  "progress\n";
                    $result .=  "Выгружено ценовых предложений: $current_variant_num\n";
                    return $result;
                }
            }
            $z->next('Предложение');
            $current_variant_num ++;
        }
        $z->close();
        
        $this->integration_1c->set_to_storage('imported_product_num', '');
        return "success\n";
    }

    /**
     * @param $xml_variant \SimpleXMLElement()
     * @return bool
     */
    private function import_variant($xml_variant) {
        $variant = new \stdClass;
        
        //  Id товара и варианта (если есть) по 1С
        @list($product_1c_id, $variant_1c_id) = explode('#', $xml_variant->Ид);
        if (empty($variant_1c_id)) {
            $variant_1c_id = '';
        }
        
        if (empty($product_1c_id)) {
            return false;
        }

        $this->okay->db->query('SELECT v.id FROM __variants v WHERE v.external_id=? AND product_id=(SELECT p.id FROM __products p WHERE p.external_id=? LIMIT 1)', $variant_1c_id, $product_1c_id);
        $variant_id = $this->okay->db->result('id');

        $this->okay->db->query('SELECT p.id FROM __products p WHERE p.external_id=?', $product_1c_id);
        $variant->external_id = $variant_1c_id;
        $variant->product_id = $this->okay->db->result('id');
        if (empty($variant->product_id)) {
            return false;
        }

        if (isset($xml_variant->Цены->Цена->ЦенаЗаЕдиницу)) {
            $variant->price = (float)$xml_variant->Цены->Цена->ЦенаЗаЕдиницу;
        }

        if (isset($xml_variant->ХарактеристикиТовара->ХарактеристикаТовара)) {
            foreach ($xml_variant->ХарактеристикиТовара->ХарактеристикаТовара as $xml_property) {
                $values[] = $xml_property->Значение;
            }
        }
        if (!empty($values)) {
            $variant->name = implode(', ', $values);
        }
        $sku = (string)$xml_variant->Артикул;
        if (!empty($sku)) {
            $variant->sku = $sku;
        }

        $variant_currency = new \stdClass;
        // Конвертируем цену из валюты 1С в базовую валюту магазина
        if (!empty($xml_variant->Цены->Цена->Валюта)) {
            
            $currency_code = (string)$xml_variant->Цены->Цена->Валюта;
            // Ищем валюту по коду или обозначению
            if (isset($this->currencies_by_code[$currency_code])) {
                $variant_currency = $this->currencies_by_code[$currency_code];
            } elseif (isset($this->currencies_by_sign[$currency_code])) {
                $variant_currency = $this->currencies_by_sign[$currency_code];
            }
            
            // Если нашли валюту - конвертируем из нее в базовую
            if ($variant_currency && $variant_currency->rate_from>0 && $variant_currency->rate_to>0 && !$this->is_multi_currency) {
                $variant->price = floatval($variant->price)*$variant_currency->rate_to/$variant_currency->rate_from;
            }
        }

        // Если $stock_from_1c = true берем кол-во из 1с или у нас бесконечное количество товара.
        if ($this->integration_1c->stock_from_1c) {
            $variant->stock = (int)$xml_variant->Количество;
        } else {
            $variant->stock = NULL;
        }
        
        // Устанавливаем валюту товара или оригинал или если пересчитали то базовую (единственную активную)
        $variant->currency_id = ($this->is_multi_currency === true && !empty($variant_currency->id) ? $variant_currency->id : $this->base_currency->id);

        // Устанавливаем единицу измерения
        if (!$variant->units = (string)$xml_variant->БазоваяЕдиница) {
            $variant->units = (string)$xml_variant->Цены->Цена->Единица;
        }

        if (empty($variant_id)) {
            $this->okay->variants->add_variant($variant);
        } else {
            $this->okay->variants->update_variant($variant_id, $variant);
        }
        return true;
    }

    /**
     * Метод инициализирует валюты для импорта
     */
    private function init_currencies() {

        $currency_filter = array();
        if ($this->integration_1c->only_enabled_currencies) {
            $currency_filter['enabled'] = 1;
        }

        foreach ($this->okay->money->get_currencies($currency_filter) as $c) {
            $this->currencies_by_code[$c->code] = $c;
            $this->currencies_by_sign[$c->sign] = $c;
        }

        $this->is_multi_currency = (count($this->currencies_by_code) > 1 ? true : false);
        $this->base_currency = reset($this->currencies_by_code);
    }
}
