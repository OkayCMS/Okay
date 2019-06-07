<?php

namespace Integration1C\Import\ImportFactory;


class ImportOrdersFactory implements ImportFactoryInterface
{
    
    /**
     * @param $okay \Okay
     * @param $integration_1c \Integration1C\Integration1C
     * @return \Integration1C\Import\ImportOrders
     */
    public function create_import($okay, $integration_1c) {
        return new \Integration1C\Import\ImportOrders($okay, $integration_1c);
    }
}