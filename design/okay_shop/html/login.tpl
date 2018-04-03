{* Login page *}

{* The canonical address of the page *}
{$canonical="/user/login" scope=parent}

{* The page title *}
{$meta_title = $lang->login_title scope=parent}

{* The page heading *}
<h1 class="h1"><span data-language="login_enter">{$lang->login_enter}</span></h1>

<div class="block padding">
    <div class="row">
        <div class="col-md-6">
            {* Form error messages *}
            {if $error}
                <div class="message_error">
                    {if $error == 'login_incorrect'}
                        <span data-language="login_error_pass">{$lang->login_error_pass}</span>
                    {elseif $error == 'user_disabled'}
                        <span data-language="login_pass_not_active">{$lang->login_pass_not_active}</span>
                    {else}
                        {$error|escape}
                    {/if}
                </div>
            {/if}

            <form method="post" class="clearfix fn_validate_login">

                <div class="form_group">
                    {* User's email *}
                    <input class="form_input placeholder_focus" type="text" name="email" value="{$email|escape}" data-language="form_email" />
                    <span class="form_placeholder">{$lang->form_email}*</span>
                </div>

                <div class="form_group">
                    {* User's password *}
                    <input class="form_input placeholder_focus" type="password" name="password" data-notice="{$lang->form_enter_password}" value="" data-language="form_password"/>
                    <span class="form_placeholder">{$lang->form_password}*</span>
                </div>

                
                <div class="form_group clearfix">
                    {* Submit button *}
                    <input type="submit" class="button" name="login" data-language="login_sign_in" value="{$lang->login_sign_in}">

                    {*  Remind password link *}
                    <a class="password_remind" href="{$lang_link}user/password_remind" data-language="login_remind">{$lang->login_remind}</a>
                </div>    
            </form>
        </div>

        <div class="col-md-6">
            <div class="form_group">
                <span data-language="login_text">{$lang->login_text}</span>
            </div>

            {* Link to registration *}
            <a href="{$lang_link}user/register" class="button" data-language="login_registration">{$lang->login_registration}</a>
        </div>
    </div>
</div>
