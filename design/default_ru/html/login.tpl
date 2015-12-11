{* Страница входа пользователя *}

{* Канонический адрес страницы *}
{$canonical="/user/login" scope=parent}

{$meta_title = 'Вход' scope=parent}
   
<h1 class="h1">Вход</h1>

{if $error}
<div class="message_error">
	{if $error == 'login_incorrect'}Неверный логин или пароль
	{elseif $error == 'user_disabled'}Ваш аккаунт еще не активирован
	{else}{$error}{/if}
</div>
{/if}

<form class="form login_form" method="post">
	<div class="form_group">
		<label>Введите email</label>
		<input class="form_input" type="text" name="email" data-format="email" data-notice="Введите email" value="{$email|escape}" maxlength="255" />
	</div>

	<div class="form_group">
    	<label>Пароль (<a href="{$lang_link}user/password_remind">напомнить</a>)</label>
    	<input class="form_input" type="password" name="password" data-format=".+" data-notice="Введите пароль" value="" />
    </div>

	<input type="submit" class="button" name="login" value="Войти">
</form>