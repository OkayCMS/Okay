{* Страница с формой обратной связи *}

{* Канонический адрес страницы *}
{$canonical="/{$page->url}" scope=parent}

<h1 class="h1">{$page->name|escape}</h1>

{if $page->body}
<div class="block">
	{$page->body}
</div>
{/if}

<h2 class="block_heading">{$lang->obratnaya_svyaz}</h2>

{if $message_sent}
	{$name|escape}, {$lang->vashe_soobschenie_otpravleno}.
{else}
<form class="form feedback_form" method="post">
	{if $error}
		<div class="message_error">
			{if $error=='captcha'}
				{$lang->neverno_vvedena_kapcha}
			{elseif $error=='empty_name'}
				{$lang->vvedite_imya}
			{elseif $error=='empty_email'}
				{$lang->vvedite_email}
			{elseif $error=='empty_text'}
				{$lang->vvedite_soobschenie}
			{/if}
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

	<label>{$lang->vvedite_soobschenie}</label>
	<textarea data-format=".+" data-notice="{$lang->vvedite_soobschenie}" name="message">{$message|escape}</textarea>

	<input class="button" type="submit" name="feedback" value="{$lang->otpravit}"/>

	<div class="captcha">
		<img src="captcha/image.php?{math equation='rand(10,10000)'}"/>
		<input class="input_captcha" id="comment_captcha" type="text" name="captcha_code" value="" data-format="\d\d\d\d" data-notice="{$lang->vvedite_kapchu}" placeholder="{$lang->vvedite_kapchu}"/>
	</div> 
</form>
{/if}