{* Feedback page *}
{* The canonical address of the page *}
{$canonical="/{$page->url}" scope=parent}

<div class="wrap_block clearfix">

    {* Page body *}
    {if $page->description}
        <div class="col-lg-6 no_padding">
            {* The page heading *}
            <h1 class="h1">{$page->name|escape}</h1>

            <div class="block padding">
                {$page->description}
            </div>
        </div>
    {/if}

    {if $message_sent}
        <div class="message_success">
            <b>{$name|escape},</b> <span data-language="feedback_message_sent">{$lang->feedback_message_sent}.</span>
        </div>
    {else}
        <div class="col-lg-6 no_padding">
            {* Feedback form *}
            <form method="post" class="fn_validate_feedback">

                {* Form heading *}
                <div class="h1" data-language="feedback_feedback">{$lang->feedback_feedback}</div>

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
                        <input class="form_input" value="{if $user->name}{$user->name}{else}{$name|escape}{/if}" name="name" type="text" data-language="form_name" placeholder="{$lang->form_name}*"/>
                    </div>

                    {* User's email *}
                    <div class="form_group">
                        <input class="form_input" value="{if $user->email}{$user->email}{else}{$email|escape}{/if}" name="email" type="text" data-language="form_email" placeholder="{$lang->form_email}*"/>
                    </div>

                    {* User's message *}
                    <div class="form_group">
                        <textarea class="form_textarea" rows="3" name="message" data-language="form_enter_message" placeholder="{$lang->form_enter_message}*">{$message|escape}</textarea>
                    </div>

                    {* Captcha *}
                    {if $settings->captcha_feedback}
                        {get_captcha var="captcha_feedback"}
                        <div class="captcha form_group">
                            <div class="secret_number">{$captcha_feedback[0]|escape} + ? =  {$captcha_feedback[1]|escape}</div>
                            <input class="form_input input_captcha" type="text" name="captcha_code" value="" data-language="form_enter_captcha" placeholder="{$lang->form_enter_captcha}*"/>
                        </div>
                    {/if}

                    {* Submit button *}
                    <input class="button" type="submit" name="feedback" data-language="form_send" value="{$lang->form_send}"/>
                </div>
            </form>
        </div>
    {/if}
</div>

{* Yandex map *}
<div class="ya_map">
    <iframe src="https://www.google.com/maps/embed?pb=!1m14!1m8!1m3!1d2241.7081645541616!2d37.5206056!3d55.8156667!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x0%3A0x944fd88cf96de197!2sOkayCMS!5e0!3m2!1sru!2sua!4v1495180474127" width="100%" height="450" frameborder="0" style="border:0;" allowfullscreen></iframe><br>
</div>

