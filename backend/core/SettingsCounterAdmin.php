<?php

require_once('api/Okay.php');

class SettingsCounterAdmin extends Okay {

    /*Настройки счетчиков*/
    public function fetch() {
        if($this->request->method('POST')) {

            if($this->request->post('counters')) {
                foreach($this->request->post('counters') as $n=>$co) {
                    foreach($co as $i=>$c) {
                        if(empty($counters[$i])) {
                            $counters[$i] = new stdClass;
                        }
                        $counters[$i]->$n = $c;
                    }
                }
            }
            $this->settings->counters = $counters;
            $this->design->assign('message_success', 'saved');
        }
        $this->design->assign('counters', $this->settings->counters);
        header('X-XSS-Protection:0');
        return $this->design->fetch('settings_counter.tpl');
    }
}
