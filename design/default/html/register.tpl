{* Страница регистрации *}
{* Канонический адрес страницы *}
{$canonical="/user/register" scope=parent}

{* Тайтл страницы *}
{$meta_title = $lang->register_title scope=parent}

<div class="container">
	{* Хлебные крошки *}
	{include file='breadcrumb.tpl'}

	{* Заголовок страницы *}
	<h1 class="m-b-1">
		<span data-language="{$translate_id['register_header']}">{$lang->register_header}</span>
	</h1>

	<div class="col-lg-4 p-y-1 bg-info m-b-2">
		{* Вывод ошибок *}
		{if $error}
			<div class="p-x-1 p-y-05 text-red m-b-1">
				{if $error == 'empty_name'}
					<span data-language="{$translate_id['form_enter_name']}">{$lang->form_enter_name}</span>
				{elseif $error == 'empty_email'}
					<span data-language="{$translate_id['form_enter_email']}">{$lang->form_enter_email}</span>
				{elseif $error == 'empty_password'}
					<span data-language="{$translate_id['form_enter_password']}">{$lang->form_enter_password}</span>
				{elseif $error == 'user_exists'}
					<span data-language="{$translate_id['register_user_registered']}">{$lang->register_user_registered}</span>
				{elseif $error == 'captcha'}
					<span data-language="{$translate_id['form_error_captcha']}">{$lang->form_error_captcha}</span>
				{else}
					{$error}
				{/if}
			</div>
		{/if}
		<form method="post">
			{* Имя пользователя *}
			<div class="form-group">
				<input class="form-control" type="text" name="name" data-format=".+" data-notice="{$lang->form_enter_name}" value="{$name|escape}" data-language="{$translate_id['form_name']}" placeholder="{$lang->form_name}*"/>
			</div>
			{* Почта пользователя *}
			<div class="form-group">
				<input class="form-control" type="text" name="email" data-format="email" data-notice="{$lang->form_enter_email}" value="{$email|escape}" data-language="{$translate_id['form_email']}" placeholder="{$lang->form_email}*"/>
			</div>

            <div class="form-group">
                <input class="form-control" type="text" name="phone" value="{$phone|escape}" data-language="{$translate_id['form_phone']}" placeholder="{$lang->form_phone}"/>
            </div>
            <div class="form-group">
                <input class="form-control" type="text" name="address" value="{$address|escape}" data-language="{$translate_id['form_address']}" placeholder="{$lang->form_address}"/>
            </div>

			{* Пароль пользователя *}
			<div class="form-group">
				<input class="form-control" type="password" name="password" data-format=".+" data-notice="{$lang->form_enter_password}" value="" data-language="{$translate_id['form_password']}" placeholder="{$lang->form_password}*"/>
			</div>

			{if $settings->captcha_register}
				<div class="row">
					<div class="col-xs-12 col-lg-9 form-inline m-b-1">
						{* Поле ввода капчи *}
						<div class="form-group">
							<input class="form-control" type="text" name="captcha_code" value="" data-format="\d\d\d\d\d" data-notice="{$lang->form_enter_captcha}" data-language="{$translate_id['form_enter_captcha']}" placeholder="{$lang->form_enter_captcha}*"/>
						</div>

						{* Изображение капчи *}
						<div class="form-group">
							<img class="brad-3" src="captcha/image.php?{math equation='rand(10,10000)'}" alt="captcha"/>
						</div>
					</div>
				</div>
			{/if}
			{* Кнопка отправки формы *}
			<div>
				<input type="submit" class="btn btn-warning" name="register" data-language="{$translate_id['register_create_account']}" value="{$lang->register_create_account}">
			</div>
		</form>
	</div>
</div>