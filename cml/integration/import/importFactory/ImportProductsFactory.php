<?php

namespace Integration1C\Import\ImportFactory;


class ImportProductsFactory implements ImportFactoryInterface
{
    
    /**
     * @param $okay \Okay
     * @param $integration_1c \Integration1C\Integration1C
     * @return \Integration1C\Import\ImportProducts
     */
    public function create_import($okay, $integration_1c) {
        return new \Integration1C\Import\ImportProducts($okay, $integration_1c);
    }
}