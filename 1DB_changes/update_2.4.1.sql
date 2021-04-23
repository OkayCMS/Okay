ALTER TABLE `ok_orders` ADD `surname` VARCHAR(255)  CHARACTER SET utf8  COLLATE utf8_general_ci  NOT NULL  DEFAULT ''  AFTER `name`;
ALTER TABLE `ok_users` ADD `surname` VARCHAR(255)  CHARACTER SET utf8  COLLATE utf8_general_ci  NOT NULL  DEFAULT ''  AFTER `name`;

ALTER TABLE `ok_variants` ADD `cost` DECIMAL(14,2)  NOT NULL  DEFAULT '0.00'  AFTER `weight`;
ALTER TABLE `ok_variants` ADD `compare_cost` DECIMAL(14,2)  NULL  DEFAULT NULL  AFTER `price`;
UPDATE `ok_variants` SET `cost` = `price`, `compare_cost` = `compare_price`;
UPDATE ok_variants v LEFT JOIN ok_currencies c ON c.id=v.currency_id SET v.price = v.price*c.rate_to/c.rate_from, v.compare_price = v.compare_price*c.rate_to/c.rate_from;