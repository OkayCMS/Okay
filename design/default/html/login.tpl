{* Страница входа пользователя *}

{* Канонический адрес страницы *}
{$canonical="/user/login" scope=parent}

{$meta_title = $lang->vhod scope=parent}
   
<h1 class="h1">{$lang->vhod}</h1>

{if $error}
<div class="message_error">
	{if $error == 'login_incorrect'}{$lang->nevernyj_login_ili_parol}
	{elseif $error == 'user_disabled'}{$lang->vash_akkaunt_esche_ne_aktivirovan}
	{else}{$error}{/if}
</div>
{/if}

<form class="form login_form" method="post">
	<div class="form_group">
		<label>{$lang->vvedite_email}</label>
		<input class="form_input" type="text" name="email" data-format="email" data-notice="{$lang->vvedite_email}" value="{$email|escape}" maxlength="255" />
	</div>

	<div class="form_group">
    	<label>{$lang->parol} (<a href="{$lang_link}user/password_remind">{$lang->napomnit}</a>)</label>
    	<input class="form_input" type="password" name="password" data-format=".+" data-notice="{$lang->vvedite_parol}" value="" />
    </div>

	<input type="submit" class="button" name="login" value="{$lang->vojti}">
</form>