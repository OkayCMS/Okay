{* Форма обратного звонка *}
<div class="hidden-xs-up">
	<form id="fn-callback" class="bg-info p-a-1" method="post">
		{* Заголовок формы *}
		<div class="h3 m-b-1 text-xs-center" data-language="{$translate_id['callback_header']}">{$lang->callback_header}</div>

        {* Вывод ошибок *}
        {if $call_error}
            <div class="p-x-1 p-y-05 text-red m-b-1">
                {if $call_error == 'empty_name'}
                    <span data-language="{$translate_id['form_enter_name']}">{$lang->form_enter_name}</span>
                {elseif $call_error == 'empty_phone'}
                    <span data-language="{$translate_id['form_enter_phone']}">{$lang->form_enter_phone}</span>
                {elseif $call_error == 'empty_comment'}
                    <span data-language="{$translate_id['form_enter_message']}">{$lang->form_enter_message}</span>
                {else}
                    {$call_error}
                {/if}
            </div>
        {/if}

		{* Имя клиента *}
		<div class="form-group">
			<input class="form-control" type="text" name="name" data-format=".+" data-notice="{$lang->form_enter_name}" value="{if $user->name}{$user->name|escape}{else}{$name|escape}{/if}" data-language="{$translate_id['form_name']}" placeholder="{$lang->form_name}*"/>
		</div>

		{* Телефон клиента *}
		<div class="form-group">
			<input class="form-control" type="text" name="phone" data-format=".+" data-notice="{$lang->form_enter_phone}" value="{if $user->phone}{$user->phone|escape}{else}{$phone|escape}{/if}" data-language="{$translate_id['form_phone']}" placeholder="{$lang->form_phone}*"/>
		</div>

        <div class="form-group">
            <textarea class="form-control" rows="3" name="message" data-language="{$translate_id['form_enter_message']}" placeholder="{$lang->form_enter_message}*"></textarea>
        </div>

		{* Кнопка отправки формы *}
		<div class="text-xs-center">
			<input class="btn btn-warning" type="submit" name="callback" data-language="{$translate_id['callback_order']}" value="{$lang->callback_order}"/>
		</div>

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
