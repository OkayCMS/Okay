<?php

namespace Integration1C\Export;


abstract class Export
{

    /**
     * @var \Okay()
     */
    protected $okay;

    /**
     * @var \Integration1C\Integration1C()
     */
    protected $integration_1c;

    /**
     * ImportProducts constructor.
     * @param $okay \Okay()
     * @param $integration_1c \Integration1C\Integration1C()
     */
    public function __construct($okay, $integration_1c) {
        $this->okay = $okay;
        $this->integration_1c = $integration_1c;
    }
    
    /**
     * @return string
     */
    abstract public function export();
    
}
