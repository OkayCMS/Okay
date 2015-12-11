{capture name=tabs}
    <li class="active"><a href="index.php?module=SettingsAdmin">Настройки</a></li>
    {if in_array('currency', $manager->permissions)}
        <li><a href="index.php?module=CurrencyAdmin">Валюты</a></li>
    {/if}
    {if in_array('delivery', $manager->permissions)}
        <li><a href="index.php?module=DeliveriesAdmin">Доставка</a></li>
    {/if}
    {if in_array('payment', $manager->permissions)}
        <li><a href="index.php?module=PaymentMethodsAdmin">Оплата</a></li>
    {/if}
    {if in_array('managers', $manager->permissions)}
        <li><a href="index.php?module=ManagersAdmin">Менеджеры</a></li>
    {/if}
    {if in_array('languages', $manager->permissions)}
        <li><a href="index.php?module=LanguagesAdmin">Языки</a></li>
    {/if}
    {if in_array('languages', $manager->permissions)}
        <li><a href="index.php?module=TranslationsAdmin">Переводы</a></li>
    {/if}
{/capture}
 
{$meta_title = "Настройки" scope=parent}

{if $message_success}
<div class="message message_success">
	<span class="text">{if $message_success == 'saved'}Настройки сохранены{/if}</span>
	{if $smarty.get.return}
	<a class="button" href="{$smarty.get.return}">Вернуться</a>
	{/if}
</div>
{/if}

{if $message_error}
<div class="message message_error">
	<span class="text">{if $message_error == 'watermark_is_not_writable'}Установите права на запись для файла {$config->watermark_file}{/if}</span>
	<a class="button" href="">Вернуться</a>
</div>
{/if}

<form method=post id=product enctype="multipart/form-data">
<input type=hidden name="session_id" value="{$smarty.session.id}">

		<div class="block">
			<h2>Настройки сайта</h2>
			<ul>
				<li><label class=property>Имя сайта</label><input name="site_name" class="okay_inp" type="text" value="{$settings->site_name|escape}" /></li>
				<li><label class=property>Имя компании</label><input name="company_name" class="okay_inp" type="text" value="{$settings->company_name|escape}" /></li>
				<li><label class=property>Формат даты</label><input name="date_format" class="okay_inp" type="text" value="{$settings->date_format|escape}" /></li>
				<li><label class=property>Email для восстановления пароля</label><input name="admin_email" class="okay_inp" type="text" value="{$settings->admin_email|escape}" /></li>
			</ul>
		</div>
		<div class="block layer">
			<h2>Оповещения</h2>
			<ul>
				<li><label class=property>Оповещение о заказах</label><input name="order_email" class="okay_inp" type="text" value="{$settings->order_email|escape}" /></li>
				<li><label class=property>Оповещение о комментариях</label><input name="comment_email" class="okay_inp" type="text" value="{$settings->comment_email|escape}" /></li>
				<li><label class=property>Обратный адрес оповещений</label><input name="notify_from_email" class="okay_inp" type="text" value="{$settings->notify_from_email|escape}" /></li>
			</ul>
		</div>

		<div class="block layer">
			<h2>Формат цены</h2>
			<ul>
				<li><label class=property>Разделитель копеек</label>
					<select name="decimals_point" class="okay_inp">
						<option value='.' {if $settings->decimals_point == '.'}selected{/if}>точка: 12.45 {$currency->sign|escape}</option>
						<option value=',' {if $settings->decimals_point == ','}selected{/if}>запятая: 12,45 {$currency->sign|escape}</option>
					</select>
				</li>
				<li><label class=property>Разделитель тысяч</label>
					<select name="thousands_separator" class="okay_inp">
						<option value='' {if $settings->thousands_separator == ''}selected{/if}>без разделителя: 1245678 {$currency->sign|escape}</option>
						<option value=' ' {if $settings->thousands_separator == ' '}selected{/if}>пробел: 1 245 678 {$currency->sign|escape}</option>
						<option value=',' {if $settings->thousands_separator == ','}selected{/if}>запятая: 1,245,678 {$currency->sign|escape}</option>
					</select>
				</li>
			</ul>
		</div>

		<div class="block layer">
			<h2>Настройки каталога</h2>
			<ul>
				<li><label class=property>Товаров на странице сайта</label><input name="products_num" class="okay_inp" type="text" value="{$settings->products_num|escape}" /></li>
				<li><label class=property>Товаров на странице админки</label><input name="products_num_admin" class="okay_inp" type="text" value="{$settings->products_num_admin|escape}" /></li>
				<li><label class=property>Максимум товаров в заказе</label><input name="max_order_amount" class="okay_inp" type="text" value="{$settings->max_order_amount|escape}" /></li>
				<li><label class=property>Единицы измерения товаров</label><input name="units" class="okay_inp" type="text" value="{$settings->units|escape}" /></li>
                <li><label class="property">Максимальное количество товаров в папке сравнения</label><input name="comparison_count" class="okay_inp" type="text" value="{$settings->comparison_count|escape}" /></li>
                <li>
                    <label class="property">Если нет в наличии</label>
                    <select name="is_preorder">
                        <option value="0" {if $settings->is_preorder == 0} selected=""{/if}>Нет на складе</option>
                        <option value="1" {if $settings->is_preorder == 1} selected=""{/if}>Предзаказ</option>
                    </select>
                </li>
			</ul>
		</div>
		<div class="block layer">
			<h2>Изображения товаров</h2>
			<ul>
				<li><label class=property>Водяной знак</label>
				<input name="watermark_file" class="okay_inp" type="file" />

				<img style='display:block; border:1px solid #d0d0d0; margin:10px 0 10px 0;' src="{$config->root_url}/{$config->watermark_file}?{math equation='rand(10,10000)'}">
				</li>
				<li><label class=property>Горизонтальное положение водяного знака</label><input name="watermark_offset_x" class="okay_inp" type="text" value="{$settings->watermark_offset_x|escape}" /> %</li>
				<li><label class=property>Вертикальное положение водяного знака</label><input name="watermark_offset_y" class="okay_inp" type="text" value="{$settings->watermark_offset_y|escape}" /> %</li>
				<li><label class=property>Прозрачность знака (больше &mdash; прозрачней)</label><input name="watermark_transparency" class="okay_inp" type="text" value="{$settings->watermark_transparency|escape}" /> %</li>
				<li><label class=property>Резкость изображений (рекомендуется 20%)</label><input name="images_sharpen" class="okay_inp" type="text" value="{$settings->images_sharpen|escape}" /> %</li>
			</ul>
		</div>
        
        <div class="block layer">
			<h2>Настройки экспорта в яндекс</h2>
			<ul class="yandex_list">
				<li>
                    <label class="property" for="yandex_export_not_in_stock">Экспортировать со статусом "под заказ", товары отсутствующие на складе</label>
                    <input id="yandex_export_not_in_stock" name="yandex_export_not_in_stock" class="okay_inp" type="checkbox" {if $settings->yandex_export_not_in_stock}checked=""{/if} />
                </li>
				<li>
                    <label class="property" for="yandex_available_for_retail_store">Можно купить в розничном магазине</label>
                    <input id="yandex_available_for_retail_store" name="yandex_available_for_retail_store" class="okay_inp" type="checkbox" {if $settings->yandex_available_for_retail_store}checked=""{/if} />
                </li>
				<li>
                    <label class="property" for="yandex_available_for_reservation">Можно зарезервировать выбранный товар и забрать его самостоятельно.</label>
                    <input id="yandex_available_for_reservation" name="yandex_available_for_reservation" class="okay_inp" type="checkbox" {if $settings->yandex_available_for_reservation}checked=""{/if} />
                </li>
                <li>
                    <label for="yandex_short_description" class="property">Выводить в ЯндекМаркет краткое или полное описание товара(0-краткое, 1-полное)</label>
                    <input id="yandex_short_description" name="yandex_short_description" class="okay_inp" type="checkbox" {if $settings->yandex_short_description}checked=""{/if} />
                </li>
                <li>
                    <label class="property" for="yandex_has_manufacturer_warranty">У товаров есть гарантия производителя</label>
                    <input id="yandex_has_manufacturer_warranty" name="yandex_has_manufacturer_warranty" class="okay_inp" type="checkbox" {if $settings->yandex_has_manufacturer_warranty}checked=""{/if} />
                </li>
                <li>
                    <label class="property" for="yandex_has_seller_warranty">У товаров есть гарантия продавца</label>
                    <input id="yandex_has_seller_warranty" name="yandex_has_seller_warranty" class="okay_inp" type="checkbox" {if $settings->yandex_has_seller_warranty}checked=""{/if} />
                </li>
                <li>
                    <label class="property" for="yandex_sales_notes">sales notes</label>
                    <input id="yandex_sales_notes" name="yandex_sales_notes" class="okay_inp" type="text" value="{$settings->yandex_sales_notes}" />
                </li>
			</ul>
		</div>
		<input class="button_green button_save" type="submit" name="save" value="Сохранить" />
</form>
