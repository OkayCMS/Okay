ALTER TABLE `ok_banners` DROP `description`;

ALTER TABLE `ok_settings` ADD UNIQUE `param` (`param`);

INSERT INTO `ok_settings` (`param`, `value`) VALUES
('recaptcha_scores',	'a:3:{s:7:\"product\";d:0.5;s:4:\"cart\";d:0.69999999999999996;s:5:\"other\";d:0.20000000000000001;}');

ALTER TABLE `ok_orders_status` ADD `status_1c` enum('new','accepted','to_delete', 'not_use') NULL DEFAULT 'not_use';
