<?php
class MetrikaAjax extends Okay
{

    private $yandex_metrika_token;
    private $yandex_metrika_counter_id;
    private $url_api 	= 'https://api-metrika.yandex.ru/stat/v1/data';

    public function __construct()
    {
        parent::__construct();
        $this->yandex_metrika_token = $this->settings->yandex_metrika_token;
        $this->yandex_metrika_counter_id = $this->settings->yandex_metrika_counter_id;
    }

    public function fetch()
    {
        $today = date("Ymd");
        $start = isset($_GET['periodfor']) ? $_GET['periodfor'] :  $today;
        $json  = $this->get_json($start, $today);
        return $json;
    }

    private function get_json($date1, $date2)
    {
        if ($date1 == $date2) {
            $group = "hours";
        } else {
            $group = "days";
        }

        $params = [
            'ids'         => $this->yandex_metrika_counter_id,
            'oauth_token' => $this->yandex_metrika_token,
            'metrics'     => 'ym:s:users,ym:s:visits,ym:s:pageviews,ym:s:bounceRate,ym:s:newUsers',
            'dimensions'  => 'ym:s:date',
            'date1'       => $date1,
            'date2'       => $date2,
            'sort'        => 'ym:s:date',
        ];

        $request_url = $this->url_api . '?' . http_build_query($params);
        return file_get_contents($request_url);
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