<?php

require_once('api/Okay.php');

class RobotsAdmin extends Okay {

    public function fetch() {
        if($this->request->post()){
            $robots_data = $this->request->post('robots');
            $this->get_robots($robots_data,'write');
        }

        /*Обновление файла*/
        $robots_txt = $this->get_robots('','read');
        $this->design->assign('robots_txt', $robots_txt);
        $perms = is_writable('robots.txt');
        if(!$perms) {
            $this->design->assign('message_error','write_error');
        }
        return $this->design->fetch('robots.tpl');
    }

    /*Чтение/Запись файла*/
    private function get_robots($data,$type){
        if ($type == 'write') {
            $perms = is_writable('robots.txt');
            if ($perms) {
                file_put_contents('robots.txt', strip_tags($data), LOCK_EX);
                $this->design->assign('message_success', 'updated');
            } else {
                $this->design->assign('message_error','write_error');
            }
        } elseif ($type='read') {
            $robots = file_get_contents("robots.txt");
            return $robots;
        }
    }

}
