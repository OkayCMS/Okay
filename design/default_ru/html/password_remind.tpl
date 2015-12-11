{* Письмо пользователю для восстановления пароля *}

{* Канонический адрес страницы *}
{$canonical="/user/password_remind" scope=parent}

{if $email_sent}
    <h1 class="block_heading">Вам отправлено письмо</h1>
    <p>На {$email|escape} отправлено письмо для восстановления пароля.</p>
{else}
    <h1 class="block_heading">Напоминание пароля</h1>
    <form class="form" method="post">
    	{if $error}
        	<div class="message_error">
        		{if $error == 'user_not_found'}Пользователь не найден
        		{else}{$error}{/if}
        	</div>
    	{/if}
    
    	<div class="form_group">
    		<label>Введите email, который вы указывали при регистрации</label>
    		<input class="form_input" type="text" name="email" data-format="email" data-notice="Введите email" value="{$email|escape}"  maxlength="255"/>
    	</div>
    	<input type="submit" class="button button_submit" value="Вспомнить"/>
    </form>
{/if}