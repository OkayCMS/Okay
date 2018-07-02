{* Feedback page *}
{* The canonical address of the page *}
{$canonical="/{$page->url}" scope=parent}

<div class="wrap_block clearfix">

    {* Page body *}
    {if $page->description}
        <div class="col-lg-6 no_padding">
            {* The page heading *}
            <h1 class="h1">{if $page->name_h1|escape}{$page->name_h1|escape}{else}{$page->name|escape}{/if}</h1>

            <div class="block padding">
                {$page->description}
            </div>
        </div>
    {/if}

    <div class="col-lg-6 no_padding">
        {* Form heading *}
        <div class="h1" data-language="feedback_feedback">{$lang->feedback_feedback}</div>
        {if $message_sent}
            <div class="block padding">
                <div class="message_success">
                    <b>{$name|escape},</b> <span data-language="feedback_message_sent">{$lang->feedback_message_sent}.</span>
                </div>
            </div>
        {else}
            {* Feedback form *}
            <form id="captcha_id" method="post" class="fn_validate_feedback">
                <div class="block padding">
                    {* Form error messages *}
                    {if $error}
                        <div class="message_error">
                            {if $error=='captcha'}
                                <span data-language="form_error_captcha">{$lang->form_error_captcha}</span>
                            {elseif $error=='empty_name'}
                                <span data-language="form_enter_name">{$lang->form_enter_name}</span>
                            {elseif $error=='empty_email'}
                                <span data-language="form_enter_email">{$lang->form_enter_email}</span>
                            {elseif $error=='empty_text'}
                                <span data-language="form_enter_message">{$lang->form_enter_message}</span>
                            {/if}
                        </div>
                    {/if}

                    {* User's name *}
                    <div class="form_group">
                        <input class="form_input placeholder_focus" value="{if $user->name}{$user->name|escape}{else}{$name|escape}{/if}" name="name" type="text" data-language="form_name"/>
                        <span class="form_placeholder">{$lang->form_name}*</span>
                    </div>

                    {* User's email *}
                    <div class="form_group">
                        <input class="form_input placeholder_focus" value="{if $user->email}{$user->email|escape}{else}{$email|escape}{/if}" name="email" type="text" data-language="form_email"/>
                        <span class="form_placeholder">{$lang->form_email}*</span>
                    </div>

                    {* User's message *}
                    <div class="form_group">
                        <textarea class="form_textarea placeholder_focus" rows="3" name="message" data-language="form_enter_message">{$message|escape}</textarea>
                        <span class="form_placeholder">{$lang->form_enter_message}*</span>
                    </div>

                    {* Captcha *}
                    {if $settings->captcha_feedback}
                        {if $settings->captcha_type == "v2"}
                            <div class="captcha row" style="">
                                <div id="recaptcha1"></div>
                            </div>
                        {elseif $settings->captcha_type == "default"}
                            {get_captcha var="captcha_feedback"}
                            <div class="captcha form_group">
                                <div class="secret_number">{$captcha_feedback[0]|escape} + ? =  {$captcha_feedback[1]|escape}</div>
                                <span class="form_captcha">
                                    <input class="form_input input_captcha placeholder_focus" type="text" name="captcha_code" value="" data-language="form_enter_captcha"/>
                                    <span class="form_placeholder">{$lang->form_enter_captcha}*</span>
                                </span>
                            </div>
                        {/if}
                    {/if}
                    <input type="hidden" name="feedback" value="1">

                    {* Submit button *}
                    <input class="button g-recaptcha" type="submit" name="feedback" data-language="form_send" {if $settings->captcha_type == "invisible"}data-sitekey="{$settings->public_recaptcha_invisible}" data-badge='bottomleft' data-callback="onSubmit"{/if} value="{$lang->form_send}"/>
                </div>
            </form>
        {/if}
    </div>
</div>

{* Map *}
{if $settings->iframe_map_code}
<div class="ya_map">
    {$settings->iframe_map_code}
</div>
{/if}

