{* Страница регистрации *}

{* Канонический адрес страницы *}
{$canonical="/user/register" scope=parent}

{$meta_title = $lang->registratsiya scope=parent}

<h1 class="h1">{$lang->registratsiya}</h1>

{if $error}
<div class="message_error">
	{if $error == 'empty_name'}{$lang->vvedite_imya}
	{elseif $error == 'empty_email'}{$lang->vvedite_email}
	{elseif $error == 'empty_password'}{$lang->vvedite_parol}
	{elseif $error == 'user_exists'}{$lang->polzovatel_s_takim_email_uzhe_zaregistrirovan}
	{elseif $error == 'captcha'}{$lang->neverno_vvedena_kapcha}
	{else}{$error}{/if}
</div>
{/if}

<form class="register_form" method="post">
	<div class="form_group">
		<label>{$lang->vvedite_imya}</label>
		<input class="form_input" type="text" name="name" data-format=".+" data-notice="{$lang->vvedite_imya}" value="{$name|escape}" maxlength="255" />
	</div>
	
	<div class="form_group">
		<label>{$lang->vvedite_email}</label>
		<input class="form_input" type="text" name="email" data-format="email" data-notice="{$lang->vvedite_email}" value="{$email|escape}" maxlength="255" />
	</div>

	<div class="form_group">
    	<label>{$lang->vvedite_parol}</label>
    	<input class="form_input" type="password" name="password" data-format=".+" data-notice="{$lang->vvedite_parol}" value="" />
	</div>

	<div class="captcha">
		<img src="captcha/image.php?{math equation='rand(10,10000)'}"/>
		<input class="input_captcha" id="comment_captcha" type="text" name="captcha_code" value="" data-format="\d\d\d\d" data-notice="{$lang->vvedite_kapchu}" placeholder="{$lang->vvedite_kapchu}"/>
	</div> 

	<input type="submit" class="button" name="register" value="{$lang->zaregistrirovatsya}">

</form>
