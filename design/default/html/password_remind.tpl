{* Письмо пользователю для восстановления пароля *}

{* Канонический адрес страницы *}
{$canonical="/user/password_remind" scope=parent}

{if $email_sent}
    <h1 class="block_heading">{$lang->vam_otpravleno_pismo}</h1>
    <p>{$lang->na} {$email|escape} {$lang->otpravleno_pismo_dlya_vosstanovleniya_parolya}.</p>
{else}
    <h1 class="block_heading">{$lang->napominanie_parolya}</h1>
    <form class="form" method="post">
    	{if $error}
        	<div class="message_error">
        		{if $error == 'user_not_found'}{$lang->polzovatel_ne_najden}
        		{else}{$error}{/if}
        	</div>
    	{/if}
    
    	<div class="form_group">
    		<label>{$lang->vvedite_email_kotoryj_vy_ukazyvali_pri_registratsii}</label>
    		<input class="form_input" type="text" name="email" data-format="email" data-notice="{$lang->vvedite_email}" value="{$email|escape}"  maxlength="255"/>
    	</div>
    	<input type="submit" class="button button_submit" value="{$lang->vspomnit}"/>
    </form>
{/if}