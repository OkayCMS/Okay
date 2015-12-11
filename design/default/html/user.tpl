{* Шаблон страницы зарегистрированного пользователя *}

<h1 class="block_heading">{$user->name|escape}</h1>

<form class="form" method="post">
	{if $error}
	<div class="message_error">
		{if $error == 'empty_name'}{$lang->vvedite_imya}
		{elseif $error == 'empty_email'}{$lang->vvedite_email}
		{elseif $error == 'empty_password'}{$lang->vvedite_parol}
		{elseif $error == 'user_exists'}{$lang->polzovatel_s_takim_email_uzhe_zaregistrirovan}
		{else}{$error}{/if}
	</div>
	{/if}

	<div class="form_group">
		<label>{$lang->vvedite_imya}</label>
		<input class="form_input" data-format=".+" data-notice="{$lang->vvedite_imya}" value="{$name|escape}" name="name" maxlength="255" type="text"/>
	</div>
 	
 	<div class="form_group">
		<label>{$lang->vvedite_email}</label>
		<input class="form_input" data-format="email" data-notice="{$lang->vvedite_email}" value="{$email|escape}" name="email" maxlength="255" type="text"/>
	</div>

	<div class="form_group">
		<label><a href='#' onclick="$('#password').show();return false;">{$lang->izmenit_parol}</a></label>
		<input class="form_input" id="password" value="" name="password" type="password" style="display:none;"/>
	</div>
	
	<input type="submit" class="button" value="{$lang->sohranit}">
</form>

{if $orders}
<p></p>
<div class="h2">{$lang->vashi_zakazy}</div>
<ul id="orders_history">
{foreach $orders as $order}
	<li>
	{$order->date|date} <a href='{$language->label}/order/{$order->url}'>{$lang->zakaz_nomer}{$order->id}</a>
	{if $order->paid == 1}{$lang->oplachen},{/if}
	{if $order->status == 0}{$lang->zhdet_obrabotki}{elseif $order->status == 1}{$lang->v_obrabotke}{elseif $order->status == 2}{$lang->vypolnen}{/if}
	</li>
{/foreach}
</ul>
{/if}