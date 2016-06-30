{* Страница с формой обратной связи *}
{* Канонический адрес страницы *}
{$canonical="/{$page->url}" scope=parent}

<div class="container">
	{* Хлебные крошки *}
	{include file='breadcrumb.tpl'}

	{* Заголовок страницы *}
	<h1 class="m-b-1">{$page->name|escape}</h1>

	<div class="row">
		{* Тело страницы *}
		{if $page->body}
			<div class="col-lg-6">
				{$page->body}
			</div>
		{/if}

		{* Форма обратной связи *}
		<div class="col-lg-6 m-b-2">
				<form class="bg-info p-a-1" method="post">
					{* Заголовок формы *}
					<div class="h3 text-xs-center" data-language="{$translate_id['feedback_feedback']}">{$lang->feedback_feedback}</div>

					{* Вывод ошибок формы *}
					{if $error}
						<div class="p-x-1 p-y-05 m-b-1 text-red">
							{if $error=='captcha'}
								<span data-language="{$translate_id['form_error_captcha']}">{$lang->form_error_captcha}</span>
							{elseif $error=='empty_name'}
								<span data-language="{$translate_id['form_enter_name']}">{$lang->form_enter_name}</span>
							{elseif $error=='empty_email'}
								<span data-language="{$translate_id['vvedite_email']}">{$lang->vvedite_email}</span>
							{elseif $error=='empty_text'}
								<span data-language="{$translate_id['vvedite_soobschenie']}">{$lang->vvedite_soobschenie}</span>
							{/if}
						</div>
					{/if}

					<div class="row">
						{* Имя отправителя *}
						<div class="col-lg-6 form-group">
							<input class="form-control" data-format=".+" data-notice="{$lang->form_enter_name}" value="{if $user->name}{$user->name}{else}{$name|escape}{/if}" name="name" type="text" data-language="{$translate_id['form_name']}" placeholder="{$lang->form_name}*"/>
						</div>

						{* Почта отправителя *}
						<div class="col-lg-6 form-group">
							<input class="form-control" data-format="email" data-notice="{$lang->form_enter_email}" value="{if $user->email}{$user->email}{else}{$email|escape}{/if}" name="email" type="text" data-language="{$translate_id['form_email']}" placeholder="{$lang->form_email}*"/>
						</div>

					</div>
					{* Текст сообщения *}
					<div class="form-group">
						<textarea class="form-control" rows="3" data-format=".+" data-notice="{$lang->form_enter_message}" name="message" data-language="{$translate_id['form_enter_message']}" placeholder="{$lang->form_enter_message}*">{$message|escape}</textarea>
					</div>
					<div class="row">
						{if $settings->captcha_feedback}
							<div class="col-xs-12 col-lg-6 form-inline m-b-1-md_down">
								{* Изображение капчи *}
								<div class="form-group">
									<img class="brad-3" src="captcha/image.php?{math equation='rand(10,10000)'}" alt="captcha" title="captcha"/>
								</div>

								{* Поле ввода капчи *}
								<div class="form-group">
									<input class="form-control" type="text" name="captcha_code" value="" data-format="\d\d\d\d\d" data-notice="{$lang->form_enter_captcha}" data-language="{$translate_id['form_enter_captcha']}" placeholder="{$lang->form_enter_captcha}*"/>
								</div>
							</div>
						{/if}
						{* Кнопка отправки формы *}
						<div class="col-xs-12 col-lg-6 text-xs-right">
							<input class="btn btn-warning" type="submit" name="feedback" data-language="{$translate_id['form_send']}" value="{$lang->form_send}"/>
						</div>
					</div>
				</form>
		</div>
	</div>
    {if $message_sent}
        <div class="h3 m-b-1 text-success text-center clearfix">{$name|escape}, <span data-language="{$translate_id['feedback_message_sent']}">{$lang->feedback_message_sent}</span>.</div>
    {/if}

	{* yandex карта *}
	<div id="fn-map" class="m-b-2">
        <script type="text/javascript" charset="utf-8" src="https://api-maps.yandex.ru/services/constructor/1.0/js/?sid=33OLs0Ell3u6mHqRQPSPPzVoGoVJGLmo&width=100%&height=400&lang={$lang->yandex_map_lang}&sourceType=constructor"></script>
    </div>
</div>