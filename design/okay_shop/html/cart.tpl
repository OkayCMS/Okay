{* The cart page template *}

{* The page title *}
{$meta_title = $lang->cart_title scope=parent}

{if $cart->purchases}
    {* Cart form *}
    <form method="post" name="cart" class="fn_validate_cart">
        {* The page heading *}
        <h1 class="h2"><span data-language="cart_header">{$lang->cart_header}</span></h1>

        {* The list of products in the cart *}
        <div id="fn_purchases">
            {include file='cart_purchases.tpl'}
        </div>

        {* Delivery and Payment *}
        <div id="fn_ajax_deliveries">
            {include file='cart_deliveries.tpl'}
        </div>
        
        {* The form heading *}
        <div class="h2" data-language="cart_form_header">{$lang->cart_form_header}</div>

        <div class="block padding"> 
            {* Form error messages *}
            {if $error}
                <div class="message_error">
                    {if $error == 'empty_name'}
                        <span data-language="form_enter_name">{$lang->form_enter_name}</span>
                    {/if}
                    {if $error == 'empty_email'}
                        <span data-language="form_enter_email">{$lang->form_enter_email}</span>
                    {/if}
                    {if $error == 'captcha'}
                        <span data-language="form_error_captcha">{$lang->form_error_captcha}</span>
                    {/if}
                    {if $error == 'empty_phone'}
                        <span data-language="form_error_phone">{$lang->form_error_phone}</span>
                    {/if}
                </div>
            {/if}

            <div class="row">
                {* User's name *}
                <div class="form_group col-sm-6">
                    <input class="form_input" name="name" type="text" value="{$name|escape}" data-language="form_name" placeholder="{$lang->form_name}*">
                </div>

                {* User's phone *}
                <div class="form_group col-sm-6">
                    <input class="form_input" name="phone" type="text" value="{$phone|escape}" data-language="form_phone" placeholder="{$lang->form_phone}">
                </div>
            </div>

            <div class="row">
                {* User's email *}
                <div class="form_group col-sm-6">
                    <input class="form_input" name="email" type="text" value="{$email|escape}" data-language="form_email" placeholder="{$lang->form_email}*">
                </div>

                {* User's address *}
                <div class="form_group col-sm-6">
                    <input class="form_input" name="address" type="text" value="{$address|escape}" data-language="form_address" placeholder="{$lang->form_address}">
                </div>
            </div>

            {* User's message *}
            <div class="form_group">
                <textarea class="form_textarea" rows="5" name="comment" data-language="cart_order_comment" placeholder="{$lang->cart_order_comment}">{$comment|escape}</textarea>
            </div>

            {* Captcha *}
            {if $settings->captcha_cart}
                {get_captcha var="captcha_cart"}
                <div class="captcha">
                    <div class="secret_number">{$captcha_cart[0]|escape} + ? =  {$captcha_cart[1]|escape}</div>
                    <input class="form_input input_captcha" type="text" name="captcha_code" value="" data-language="form_enter_captcha" placeholder="{$lang->form_enter_captcha}*">
                </div>
            {/if}

            {* Submit button *}
            <input class="button" type="submit" name="checkout" data-language="cart_checkout" value="{$lang->cart_checkout}">
        </div>    
    </form>

{else}
    <div class="block"> 
        {* The page heading *}
        <h1 class="h1"><span data-language="cart_header">{$lang->cart_header}</span></h1>

        <p class="block padding" data-language="cart_empty">{$lang->cart_empty}</p>
    </div>
{/if}

