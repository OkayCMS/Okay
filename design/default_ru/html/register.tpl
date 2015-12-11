{* Страница регистрации *}

{* Канонический адрес страницы *}
{$canonical="/user/register" scope=parent}

{$meta_title = 'Регистрация' scope=parent}

<h1 class="h1">Регистрация</h1>

{if $error}
<div class="message_error">
	{if $error == 'empty_name'}Введите имя
	{elseif $error == 'empty_email'}Введите email
	{elseif $error == 'empty_password'}Введите пароль
	{elseif $error == 'user_exists'}Пользователь с таким email уже зарегистрирован
	{elseif $error == 'captcha'}Неверно введена капча
	{else}{$error}{/if}
</div>
{/if}

<form class="register_form" method="post">
	<div class="form_group">
		<label>Введите имя</label>
		<input class="form_input" type="text" name="name" data-format=".+" data-notice="Введите имя" value="{$name|escape}" maxlength="255" />
	</div>
	
	<div class="form_group">
		<label>Введите email</label>
		<input class="form_input" type="text" name="email" data-format="email" data-notice="Введите email" value="{$email|escape}" maxlength="255" />
	</div>

	<div class="form_group">
    	<label>Введите пароль</label>
    	<input class="form_input" type="password" name="password" data-format=".+" data-notice="Введите пароль" value="" />
	</div>

	<div class="captcha">
		<img src="captcha/image.php?{math equation='rand(10,10000)'}"/>
		<input class="input_captcha" id="comment_captcha" type="text" name="captcha_code" value="" data-format="\d\d\d\d" data-notice="Введите капчу" placeholder="Введите капчу"/>
	</div> 

	<input type="submit" class="button" name="register" value="Зарегистрироваться">

</form>
