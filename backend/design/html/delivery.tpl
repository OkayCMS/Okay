{* Вкладки *}
{capture name=tabs}
	{if in_array('settings', $manager->permissions)}
        <li>
            <a href="index.php?module=SettingsAdmin">Настройки</a>
        </li>
    {/if}
	{if in_array('currency', $manager->permissions)}
        <li>
            <a href="index.php?module=CurrencyAdmin">Валюты</a>
        </li>
    {/if}
	<li class="active">
        <a href="index.php?module=DeliveriesAdmin">Доставка</a>
    </li>
	{if in_array('payment', $manager->permissions)}
        <li>
            <a href="index.php?module=PaymentMethodsAdmin">Оплата</a>
        </li>
    {/if}
	{if in_array('managers', $manager->permissions)}
        <li>
            <a href="index.php?module=ManagersAdmin">Менеджеры</a>
        </li>
    {/if}
    {if in_array('languages', $manager->permissions)}
        <li>
            <a href="index.php?module=LanguagesAdmin">Языки</a>
        </li>
    {/if}
    {if in_array('languages', $manager->permissions)}
        <li>
            <a href="index.php?module=TranslationsAdmin">Переводы</a>
        </li>
    {/if}
{/capture}

{if $delivery->id}
    {$meta_title = $delivery->name scope=parent}
{else}
    {$meta_title = 'Новый способ доставки' scope=parent}
{/if}
{* Подключаем Tiny MCE *}
{include file='tinymce_init.tpl'}

{literal}
<script>
    $(window).on("load", function() {

        // Удаление изображений
        $(".images a.delete").click(function () {
            $("input[name='delete_image']").val('1');
            $(this).closest("ul").fadeOut(200, function () {
                $(this).remove();
            });
            return false;
        });
    });
</script>
{/literal}

{if $languages}{include file='include_languages.tpl'}{/if}

{if $message_success}
    <!-- Системное сообщение -->
    <div class="message message_success">
        <span class="text">{if $message_success == 'added'}Способ доставки добавлен{elseif $message_success == 'updated'}Способ доставки изменен{/if}</span>
        {if $smarty.get.return}
        <a class="button" href="{$smarty.get.return}">Вернуться</a>
        {/if}
    </div>
    <!-- Системное сообщение (The End)-->
{/if}

{if $message_error}
    <!-- Системное сообщение -->
    <div class="message message_error">
        <span class="text">{if $message_error=='empty_name'}Введите название{else}{$message_error}{/if}</span>
        <a class="button" href="">Вернуться</a>
    </div>
    <!-- Системное сообщение (The End)-->
{/if}


<!-- Основная форма -->
<form method=post id=product enctype="multipart/form-data">
    <input type=hidden name="session_id" value="{$smarty.session.id}">
    <input type="hidden" name="lang_id" value="{$lang_id}" />
	<div id="name">
		<input class="name" name=name type="text" value="{$delivery->name|escape}"/> 
		<input name=id type="hidden" value="{$delivery->id}"/> 
		<div class="checkbox">
			<input name=enabled value='1' type="checkbox" id="active_checkbox" {if $delivery->enabled}checked{/if}/>
            <label class="visible_icon" for="active_checkbox">Активен</label>
		</div>
	</div> 

	<!-- Левая колонка свойств товара -->
	<div id="column_left">
		<!-- Параметры страницы -->
		<div class="block layer">
			<h2>Стоимость доставки</h2>
			<ul>
				<li><label class=property>Стоимость</label><input name="price" class="okay_small_inp" type="text" value="{$delivery->price}" /> {$currency->sign}</li>
				<li><label class=property>Бесплатна от</label><input name="free_from" class="okay_small_inp" type="text" value="{$delivery->free_from}" /> {$currency->sign}</li>
				<li><label class=property for="separate_payment">Оплачивается отдельно</label><input id="separate_payment" name="separate_payment" type="checkbox" value="1" {if $delivery->separate_payment}checked=""{/if} /></li>
			</ul>
		</div>
		<!-- Параметры страницы (The End)-->

	</div>
	<!-- Левая колонка свойств товара (The End)--> 
	
	<!-- Левая колонка свойств товара -->
	<div id="column_right">
        <div class="block layer images">
            <h2>Изображение</h2>
            <input class='upload_image' name="image" type="file"/>
            <input type="hidden" name="delete_image" value=""/>
            {if $delivery->image}
                <ul>
                    <li>
                        <a href='#' class="delete"></a>
                        <img src="{$delivery->image|resize:100:100:false:$config->resized_deliveries_dir}" alt="" />
                    </li>
                </ul>
            {/if}
        </div>

		<div class="block layer">
		<h2>Возможные способы оплаты</h2>
		<ul>
		{foreach $payment_methods as $payment_method}
			<li>
			<input type=checkbox name="delivery_payments[]" id="payment_{$payment_method->id}" value='{$payment_method->id}' {if in_array($payment_method->id, $delivery_payments)}checked{/if}> <label for="payment_{$payment_method->id}">{$payment_method->name}</label><br>
			</li>
		{/foreach}
		</ul>		
		</div>
	</div>
	<!-- Левая колонка свойств товара (The End)--> 
	
	<!-- Описагние товара -->
	<div class="block layer">
		<h2>Описание</h2>
		<textarea name="description" class="editor_small">{$delivery->description|escape}</textarea>
	</div>
	<!-- Описание товара (The End)-->
	<input class="button_green button_save" type="submit" name="" value="Сохранить" />
	
</form>
<!-- Основная форма (The End) -->

