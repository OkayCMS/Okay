<?php

namespace Integration1C\Export\ExportFactory;


class ExportOrdersFactory implements ExportFactoryInterface
{
    
    /**
     * @param $okay \Okay
     * @param $integration_1c \Integration1C\Integration1C
     * @return \Integration1C\Export\ExportOrders
     */
    public function create_export($okay, $integration_1c) {
        return new \Integration1C\Export\ExportOrders($okay, $integration_1c);
    }
}