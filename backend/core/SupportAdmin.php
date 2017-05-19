<?php

require_once('api/Okay.php');

class SupportAdmin extends Okay {

    public function fetch() {
        $error = '';
        if ($this->request->method('post') && $this->request->post('get_new_keys')) {
            $result = $this->support->get_new_keys();
            if (is_null($result) || (empty($result) && $result!==false)) {
                $error = 'unknown_error';
            } elseif ($result === false) {
                $error = 'request_has_already_sent';
            } elseif (!$result->success) {
                $error = $result->error ? $result->error : 'unknown_error';
            }
        }

        $support_info = $this->supportinfo->get_info();
        if ($error) {
            $this->design->assign('message_error', $error);
        } elseif (in_array($_SERVER['REMOTE_ADDR'], array('127.0.0.1', '0:0:0:0:0:0:0:1'))) {
            $this->design->assign('message_error', 'localhost');
        } elseif (empty($support_info->public_key)) {
            $this->design->assign('message_error', 'empty_key');
        } else {
            // Обработка действий
            /*if ($this->request->method('post')) {
                // Действия с выбранными
                $ids = $this->request->post('check');
                if (is_array($ids)) {
                    switch ($this->request->post('action')) {
                        case 'close': {
                            // TODO close topic
                            break;
                        }
                    }
                }
            }*/

            $filter = array();
            $filter['page'] = max(1, $this->request->get('page', 'integer'));
            $filter['limit'] = 100;

            // Поиск
            $keyword = $this->request->get('keyword', 'string');
            if (!empty($keyword)) {
                $filter['keyword'] = $keyword;
                $this->design->assign('keyword', $keyword);
            }

            $result = $this->support->get_topics($filter);
            if (!$result) {
                $this->design->assign('message_error', 'unknown_error');
            } elseif (!$result->success) {
                $this->design->assign('message_error', $result->error ? $result->error : 'unknown_error');
            } else {
                $this->design->assign('topics_count', $result->topics_count);
                $this->design->assign('pages_count', ceil($result->topics_count / $filter['limit']));
                $this->design->assign('current_page', $filter['page']);
                $this->design->assign('topics', (array)$result->topics);
            }
        }
        return $this->design->fetch('support.tpl');
    }

}
