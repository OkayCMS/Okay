{* Письмо восстановления пароля *}
	
{$subject = 'Новый пароль' scope=parent}
<html>
	<body>
		<p>{$user->name|escape}, на сайте <a href='{$config->root_url}/{$lang_link}'>{$settings->site_name}</a> был сделан запрос на восстановление вашего пароля.</p>
		<p>Вы можете изменить пароль, перейдя по следующей ссылке:</p>
		<p><a href='{$config->root_url}/{$lang_link}user/password_remind/{$code}'>Изменить пароль</a></p>
		<p>Эта ссылка действует в течение нескольких минут.</p>
		<p>Если это письмо пришло вам по ошибке, проигнорируйте его.</p>
	</body>
</html>

