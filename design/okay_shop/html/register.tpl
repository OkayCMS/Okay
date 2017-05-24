{* Registration page *}

{* The canonical address of the page *}
{$canonical="/user/register" scope=parent}

{* The page title *}
{$meta_title = $lang->register_title scope=parent}

{* The page heading *}
<h1 class="h1">
    <span data-language="register_header">{$lang->register_header}</span>
</h1>

<div class="padding block clearfix">
    <div class="col-md-8 col-lg-6 col-xl-5 no_padding">
        {* Form error messages *}
        {if $error}
            <div class="message_error">
                {if $error == 'empty_name'}
                    <span data-language="form_enter_name">{$lang->form_enter_name}</span>
                {elseif $error == 'empty_email'}
                    <span data-language="form_enter_email">{$lang->form_enter_email}</span>
                {elseif $error == 'empty_password'}
                    <span data-language="form_enter_password">{$lang->form_enter_password}</span>
                {elseif $error == 'user_exists'}
                    <span data-language="register_user_registered">{$lang->register_user_registered}</span>
                {elseif $error == 'captcha'}
                    <span data-language="form_error_captcha">{$lang->form_error_captcha}</span>
                {else}
                    {$error}
                {/if}
            </div>
        {/if}

        <form method="post" class="fn_validate_register">

            {* User's  name *}
            <div class="form_group">
                <input class="form_input" type="text" name="name" value="{$name|escape}" data-language="form_name" placeholder="{$lang->form_name}*"/>
            </div>

            {* User's  email *}
            <div class="form_group">
                <input class="form_input" type="text" name="email" value="{$email|escape}" data-language="form_email" placeholder="{$lang->form_email}*"/>
            </div>

            {* User's  phone *}
            <div class="form_group">
                <input class="form_input" type="text" name="phone" value="{$phone|escape}" data-language="form_phone" placeholder="{$lang->form_phone}"/>
            </div>

            {* User's  address *}
            <div class="form_group">
                <input class="form_input" type="text" name="address" value="{$address|escape}" data-language="form_address" placeholder="{$lang->form_address}"/>
            </div>

            {* User's  password *}
            <div class="form_group">
                <input class="form_input" type="password" name="password" value="" data-language="form_enter_password" placeholder="{$lang->form_enter_password}*"/>
            </div>

            {if $settings->captcha_register}
                {get_captcha var="captcha_register"}
                <div class="captcha">
                    <div class="secret_number">{$captcha_register[0]|escape} + ? =  {$captcha_register[1]|escape}</div>
                    <input class="form_input input_captcha" type="text" name="captcha_code" value="" data-language="form_enter_captcha" placeholder="{$lang->form_enter_captcha}*">
                </div>
            {/if}

            {* Submit button *}
            <input type="submit" class="button md-right" name="register" data-language="register_create_account" value="{$lang->register_create_account}">
        </form>
    </div>
</div>
