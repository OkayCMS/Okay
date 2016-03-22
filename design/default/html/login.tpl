{* Страница входа пользователя *}
{* Канонический адрес страницы *}
{$canonical="/user/login" scope=parent}

{* Тайтл страницы *}
{$meta_title = $lang->login_title scope=parent}

<div class="container">
	{* Хлебные крошки *}
	{include file='breadcrumb.tpl'}

	{* Заголовок страницы *}
	<h1 class="m-b-1"><span data-language="{$translate_id['login_enter']}">{$lang->login_enter}</span></h1>

	<div class="col-lg-4 p-y-1 bg-info m-b-2">
		{* Вывод ошибок *}
		{if $error}
			<div class="p-x-1 p-y-05 text-red m-b-1">
				{if $error == 'login_incorrect'}
					<span data-language="{$translate_id['login_error_pass']}">{$lang->login_error_pass}</span>
				{elseif $error == 'user_disabled'}
					<span data-language="{$translate_id['login_pass_not_active']}">{$lang->login_pass_not_active}</span>
				{else}
					{$error}
				{/if}
			</div>
		{/if}
		{* @END Вывод ошибок *}
		<form method="post">
			{* Почта пользователя *}
			<div class="form-group">
				<input class="form-control" type="text" name="email" data-format="email" data-notice="{$lang->form_enter_email}" value="{$email|escape}" data-language="{$translate_id['form_email']}" placeholder="{$lang->form_email}*"/>
			</div>

			<div class="form-group input-group">
				{* Пароль пользователя *}
				<input class="form-control" type="password" name="password" data-format=".+" data-notice="{$lang->form_enter_password}" value="" data-language="{$translate_id['form_password']}" placeholder="{$lang->form_password}*"/>

				{* Ссылка на восстановление пароля *}
				<div class="input-group-btn">
					<a class="btn btn-primary" href="{$lang_link}user/password_remind" data-language="{$translate_id['login_remind']}">{$lang->login_remind}</a>
				</div>
			</div>
			{* Кнопка отправки формы *}
			<div class="clearfix">
				<a href="{$lang_link}user/register" class="btn btn-success" data-language="{$translate_id['login_registration']}">{$lang->login_registration}</a>
				<input type="submit" class="btn btn-warning pull-xs-right" name="login" data-language="{$translate_id['login_sign_in']}" value="{$lang->login_sign_in}">
			</div>
		</form>
	</div>
</div>