<?php
require_once('api/Okay.php');
$okay = new Okay();
$info = $okay->supportinfo->get_info();
$result = array('success'=>0, 'error'=>'empty_local_info');
if ($info) {
    $data = $okay->request->post();
    $data = json_decode($data);
    $result = pre_check_data($data);
    if ($result['success']) {
        $result = array('success'=>0);
        switch ($data->action) {
            // module keys
            case 'new_keys': {
                $__temp_key = $data->temp_key;
                $info->temp_time = strtotime($info->temp_time);
                if (empty($info->temp_key) || empty($info->temp_time) || $info->temp_time+300 < time()) {
                    $okay->supportinfo->update_info(array('temp_key'=>null, 'temp_time'=>null));
                    $result['error'] = 'rule_1';
                    break;
                }
                if ($info->temp_key != $data->temp_key) {
                    $result['error'] = 'rule_2';
                    break;
                }
                $okay->supportinfo->update_info(array(
                    'private_key'=>$data->private_key,
                    'public_key'=>$data->public_key,
                    'new_messages'=>max(0, intval($data->new_messages)),
                    'balance'=>max(0, intval($data->balance)),
                    'temp_key'=>null,
                    'temp_time'=>null
                ));
                $result['success'] = 1;
                break;
            }
            case 'receive_info': {
                if (empty($data->key) || empty($info->public_key) || $data->key != $info->public_key) {
                    $result['error'] = 'wrong_key';
                    break;
                }
                $okay->supportinfo->update_info(array(
                    'balance' => intval($data->balance),
                    'new_messages' => $info->new_messages + intval($data->new_messages)
                ));
                $result['success'] = 1;
                break;
            }
        }
    }
}
header("Content-type: application/json; charset=UTF-8");
header("Cache-Control: must-revalidate");
header("Pragma: no-cache");
header("Expires: -1");
print json_encode($result);
exit;

function pre_check_data($data) {
    $result = array('success'=>0, 'error'=>'unknown_error');
    if (empty($data)) {
        $result['error'] = 'empty_data';
    } elseif (!is_object($data)) {
        $result['error'] = 'invalid_data';
    } elseif (!isset($data->action) || empty($data->action)) {
        $result['error'] = 'empty_action';
    } else {
        $result['success'] = 1;
        unset($result['error']);
    }
    return $result;
}
?>