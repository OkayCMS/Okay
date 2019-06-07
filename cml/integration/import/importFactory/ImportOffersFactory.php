<?php

namespace Integration1C\Import\ImportFactory;


class ImportOffersFactory implements ImportFactoryInterface
{
    
    /**
     * @param $okay \Okay
     * @param $integration_1c \Integration1C\Integration1C
     * @return \Integration1C\Import\ImportOffers
     */
    public function create_import($okay, $integration_1c) {
        return new \Integration1C\Import\ImportOffers($okay, $integration_1c);
    }
}