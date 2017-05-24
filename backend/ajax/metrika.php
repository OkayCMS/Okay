<?php

 
class  MetrikaAjax extends Okay {

    /*Работа с отчетами из Я.Метрика*/
    private $yandex_metrika_token;
    private $yandex_metrika_app_id;
    private $yandex_metrika_counter_id;
    private $url_api     = "https://api-metrika.yandex.ru/";

    public function __construct() {
        parent::__construct();
        $this->yandex_metrika_token = $this->settings->yandex_metrika_token;
        $this->yandex_metrika_app_id = $this->settings->yandex_metrika_app_id;
        $this->yandex_metrika_counter_id = $this->settings->yandex_metrika_counter_id;
    }
    
    public function fetch() {
        $today = date("Ymd");
        $start = isset($_GET['periodfor']) ? $_GET['periodfor'] :  date("Ymd");
        return $this->get_traffic($start, $today);
    }
    
    private function get_traffic($date1, $date2) {
        if ($date1 == $date2) {
            $group = "hours";
        } else {
            $group = "days";
        }
        return $this->get_data(
                $this->url_api.
                "stat/v1/data?id=".
                $this->yandex_metrika_counter_id.
                "&preset=traffic&group=".$group.
                "&metrics=ym:s:users,ym:s:visits,ys:s:pageviews",
                "ym:s:bounceRate,ym:s:newUsers".
                "&pretty=1".
                "&date1=".$date1.
                "&date2=".$date2.
                "&oauth_token=".
                $this->yandex_metrika_token
        );
    }
    
    private function get_data($url) {
        if($url) {
            $ch = curl_init();
            curl_setopt($ch, CURLOPT_URL, $url);
            curl_setopt($ch, CURLOPT_HEADER, 0);
            curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
            curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 30);
            curl_setopt($ch, CURLOPT_TIMEOUT, 30);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
            $json = curl_exec($ch);
            curl_close($ch);
            return $json;
        }
        return false;
    }
}

 
$export_ajax = new MetrikaAjax();
$data = $export_ajax->fetch();
if($data) {
    header('Content-Type: application/json; charset=utf8');
    header("Cache-Control: must-revalidate");
    header("Pragma: no-cache");
    header("Expires: -1");
    $jsonp_callback = isset($_GET['callback']) ? $_GET['callback'] : null;
    print $jsonp_callback ? "$jsonp_callback($data)" : $data;
}