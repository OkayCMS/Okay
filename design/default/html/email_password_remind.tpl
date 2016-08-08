{* Письмо восстановления пароля *}
	
{$subject = {$lang->email_password_subject} scope=parent}
<html>
	<body>
		<p>{$user->name|escape} {$lang->email_password_on_site}<a href='{$config->root_url}/{$lang_link}'>{$settings->site_name}</a> {$lang->email_password_was_reply}</p>
		<p>{$lang->email_password_change_pass}</p>
		<p><a href='{$config->root_url}/{$lang_link}user/password_remind/{$code}'>{$lang->email_password_change_link}</a></p>
		{$lang->email_password_text}
	</body>
</html>

