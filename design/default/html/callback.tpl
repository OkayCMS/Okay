{* Форма обратного звонка *}
<div class="hidden-xs-up">
	<form id="fn-callback" class="bg-info p-a-1" method="post">
		{* Заголовок формы *}
		<div class="h3 m-b-1 text-xs-center" data-language="{$translate_id['callback_header']}">{$lang->callback_header}</div>
		{* @END Заголовок формы *}
		{* Имя клиента *}
		<div class="form-group">
			<input class="form-control" type="text" name="name" data-format=".+" data-notice="{$lang->form_enter_name}" value="{$name|escape}" data-language="{$translate_id['form_name']}" placeholder="{$lang->form_name}*"/>
		</div>
		{* @END Имя клиента *}
		{* Телефон клиента *}
		<div class="form-group">
			<input class="form-control" type="text" name="phone" data-format=".+" data-notice="{$lang->form_enter_phone}" value="{$phone|escape}" data-language="{$translate_id['form_phone']}" placeholder="{$lang->form_phone}*"/>
		</div>
		{* Телефон клиента *}
		{* Кнопка отправки формы *}
		<div class="text-xs-center">
			<input class="btn btn-warning" type="submit" name="callback" data-language="{$translate_id['callback_order']}" value="{$lang->callback_order}"/>
		</div>
		{* Кнопка отправки формы *}
	</form>
</div>
{* Модальное окно после отправки заявки *}
{if $call_sent}
	<div class="hidden-xs-up">
		<div id="fn-callback-sent" class="bg-info p-a-1">
			<div class="h4 m-b-1 text-xs-center" data-language="{$translate_id['callback_sent_header']}">{$lang->callback_sent_header}</div>
			<div data-language="{$translate_id['callback_sent_text']}">{$lang->callback_sent_text}</div>
		</div>
	</div>
{/if}
{* @END Модальное окно после отправки заявки *}