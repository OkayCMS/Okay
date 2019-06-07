<?php

namespace Integration1C\Import;


abstract class Import
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
     * @param string $xml_file Full path to xml file
     * @return string
     */
    abstract public function import($xml_file);
    
}
