{* Callback form *}
<div class="hidden">
    <form id="fn_callback" class="popup fn_validate_callback" method="post">

        {* The form heading *}
        <div class="popup_heading">
            <span data-language="callback_header">{$lang->callback_header}</span>
        </div>

        {* User's name *}
        <div class="form_group">
            <input class="form_input" type="text" name="name" value="{if $user->name}{$user->name}{else}{$name|escape}{/if}" data-language="form_name" placeholder="{$lang->form_name}*">
        </div>

        {* User's phone *}
        <div class="form_group">
            <input class="form_input" type="text" name="phone" value="{$phone|escape}" data-language="form_phone" placeholder="{$lang->form_phone}*">
        </div>

        {* User's message *}
        <div class="form_group">
            <textarea class="form_textarea" rows="3" name="message" data-language="form_enter_message" placeholder="{$lang->form_enter_message}"></textarea>
        </div>

        {* Submit button *}
        <div class="center">
            <input class="button" type="submit" name="callback" data-language="callback_order" value="{$lang->callback_order}">
        </div>

    </form>
</div>

{* The modal window after submitting *}
{if $call_sent}
    <div class="hidden">
        <div id="fn_callback_sent" class="popup">
            <div class="popup_heading">
                <span data-language="callback_sent_header">{$lang->callback_sent_header}</span>
            </div>

            <div data-language="callback_sent_text">{$lang->callback_sent_text}</div>
        </div>
    </div>
{/if}
