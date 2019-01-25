<?php

require_once('Okay.php');

class Import extends Okay {

    /*Соответствие полей в базе и имён колонок в файле*/
    public $columns_names = array(
        'category'=>         array('category', 'категория'),
        'brand'=>            array('brand', 'бренд'),
        'name'=>             array('product', 'name', 'товар', 'название', 'наименование'),
        'variant'=>          array('variant', 'вариант'),
        'sku'=>              array('sku', 'артикул'),
        'price'=>            array('price', 'цена'),
        'compare_price'=>    array('compare price', 'old price', 'старая цена'),
        'currency'=>         array('currency_id', 'currency', 'currency id', 'ID валюты'),
        'weight'=>           array('weight', 'вес варианта'),
        'stock'=>            array('stock', 'склад', 'на складе'),
        'units'=>            array('units', 'ед. изм.'),
        'visible'=>          array('visible', 'published', 'видим'),
        'featured'=>         array('featured', 'hit', 'хит', 'рекомендуемый'),
        'meta_title'=>       array('meta title', 'заголовок страницы'),
        'meta_keywords'=>    array('meta keywords', 'ключевые слова'),
        'meta_description'=> array('meta description', 'описание страницы'),
        'annotation'=>       array('annotation', 'аннотация', 'краткое описание'),
        'description'=>      array('description', 'описание'),
        'images'=>           array('images', 'изображения'),
        'url'=>              array('url', 'адрес')

    );

    // Соответствие имени колонки и поля в базе
    protected $internal_columns_names;

    protected $import_files_dir      = 'backend/files/import/'; // Временная папка
    protected $import_file           = 'import.csv';            // Временный файл
    protected $category_delimiter    = ',,';                    // Разделитель каегорий в файле
    protected $subcategory_delimiter = '/';                     // Разделитель подкаегорий в файле
    protected $values_delimiter      = ',,';                    // Разделитель значений свойства в товаре
    protected $column_delimiter      = ';';
    protected $products_count        = 100;
    protected $columns               = array();
    protected $locale                = 'ru_RU.UTF-8';
    protected $values_ids            = array();

    // Фозвращает внутреннее название колонки по названию колонки в файле
    private function internal_column_name($name) {
        $name = trim($name);
        $name = str_replace('/', '', $name);
        $name = str_replace('\/', '', $name);
        foreach($this->columns_names as $i=>$names) {
            foreach($names as $n) {
                if(!empty($name) && preg_match("/^".preg_quote($name)."$/ui", $n)) {
                    return $i;
                }
            }
        }
        return false;
    }

    // Заменяем имена колонок из файла на внутренние имена колонок
    protected function init_internal_columns($fields = array()) {
        if (isset($this->internal_columns_names)) {
            return true;
        }
        if (empty($this->columns)) {
            return false;
        }
        if (!empty($fields)) {
            foreach ($fields as $csv=>$inner) {
                if (isset($this->columns_names[$inner]) && !in_array(mb_strtolower($csv), array_map("mb_strtolower", $this->columns_names[$inner]))) {
                    $this->columns_names[$inner][] = $csv;
                }
            }
        }
        $this->internal_columns_names = array();
        foreach($this->columns as &$column) {
            if($internal_name = $this->internal_column_name($column)) {
                $this->internal_columns_names[$column] = $internal_name;
                $column = $internal_name;
            }
        }
        return true;
    }

    // Определяем колонки из первой строки файла
    protected function init_columns() {
        $f = fopen($this->import_files_dir.$this->import_file, 'r');
        $this->columns = fgetcsv($f, null, $this->column_delimiter);
        fclose($f);
    }

}