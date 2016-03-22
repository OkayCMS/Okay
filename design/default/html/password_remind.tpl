{* Страница восстановления пароля *}
{* Канонический адрес страницы *}
{$canonical="/user/password_remind" scope=parent}

{* Тайтл страницы *}
{$meta_title = $lang->password_remind_title scope=parent}

<div class="container">
	{* Хлебные крошки *}
	{include file='breadcrumb.tpl'}

	{* Заголовок страницы *}
	<h1 class="m-b-1">
		<span data-language="{$translate_id['password_remind_header']}">{$lang->password_remind_header}</span>
	</h1>

	{if $email_sent}
		{* Подтверждение отправленного письма *}
		<div class="col-lg-4 bg-info p-y-1 h5 m-b-2"><span data-language="{$translate_id['cart_header']}">{$lang->password_remind_on}</span> {$email|escape} <span data-language="{$translate_id['password_remind_letter_sent']}">{$lang->password_remind_letter_sent}</span>.</div>

	{else}
		<form class="col-lg-4 bg-info p-y-1 h5 m-b-2" method="post">
			{* Вывод ошибок формы *}
			{if $error}
				<div class="p-x-1 p-y-05 m-b-1 text-red">
					{if $error == 'user_not_found'}
						<span data-language="{$translate_id['password_remind_user_not_found']}">{$lang->password_remind_user_not_found}</span>
					{else}
						{$error}
					{/if}
				</div>
			{/if}
			<div class="form-group">
				{* E-mail для восстановления *}
				<label class="m-b-0">
					<span data-language="{$translate_id['password_remind_enter_your_email']}">{$lang->password_remind_enter_your_email}</span>
					<input class="form-control m-t-1" type="text" name="email" data-format="email" data-notice="{$lang->form_enter_email}" value="{$email|escape}" data-language="{$translate_id['form_email']}" placeholder="{$lang->form_email}*"/>
				</label>
			</div>
			{* Кнопка отправки формы *}
			<div class="text-xs-right">
				<input type="submit" class="btn btn-warning" data-language="{$translate_id['password_remind_remember']}" value="{$lang->password_remind_remember}"/>
			</div>
		</form>
	{/if}
</div>