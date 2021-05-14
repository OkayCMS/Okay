ALTER TABLE `ok_orders` ADD `surname` VARCHAR(255)  CHARACTER SET utf8  COLLATE utf8_general_ci  NOT NULL  DEFAULT ''  AFTER `name`;
ALTER TABLE `ok_users` ADD `surname` VARCHAR(255)  CHARACTER SET utf8  COLLATE utf8_general_ci  NOT NULL  DEFAULT ''  AFTER `name`;

RENAME TABLE `ok_options_aliases_values` TO `ok_features_values_aliases_values`;