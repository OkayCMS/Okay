{* Шаблон страницы зарегистрированного пользователя *}

<h1 class="block_heading">{$user->name|escape}</h1>

<form class="form" method="post">
	{if $error}
	<div class="message_error">
		{if $error == 'empty_name'}Введите имя
		{elseif $error == 'empty_email'}Введите email
		{elseif $error == 'empty_password'}Введите пароль
		{elseif $error == 'user_exists'}Пользователь с таким email уже зарегистрирован
		{else}{$error}{/if}
	</div>
	{/if}

	<div class="form_group">
		<label>Введите имя</label>
		<input class="form_input" data-format=".+" data-notice="Введите имя" value="{$name|escape}" name="name" maxlength="255" type="text"/>
	</div>
 	
 	<div class="form_group">
		<label>Введите email</label>
		<input class="form_input" data-format="email" data-notice="Введите email" value="{$email|escape}" name="email" maxlength="255" type="text"/>
	</div>

	<div class="form_group">
		<label><a href='#' onclick="$('#password').show();return false;">Изменить пароль</a></label>
		<input class="form_input" id="password" value="" name="password" type="password" style="display:none;"/>
	</div>
	
	<input type="submit" class="button" value="Сохранить">
</form>

{if $orders}
<p></p>
<div class="h2">Ваши заказы</div>
<ul id="orders_history">
{foreach $orders as $order}
	<li>
	{$order->date|date} <a href='{$language->label}/order/{$order->url}'>Заказ №{$order->id}</a>
	{if $order->paid == 1}оплачен,{/if}
	{if $order->status == 0}ждет обработки{elseif $order->status == 1}в обработке{elseif $order->status == 2}выполнен{/if}
	</li>
{/foreach}
</ul>
{/if}