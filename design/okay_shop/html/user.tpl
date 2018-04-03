{* Account page *}

{* The page title *}
{$meta_title = $lang->user_title scope=parent}

{* The page heading*}
<h1 class="h1">
    <span data-language="user_header">{$lang->user_header}</span>
</h1>

<div class="block padding">
    <div class="row">
        <div class="col-lg-5">

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
                    {else}
                        {$error}
                    {/if}
                </div>
            {/if}

            <form method="post" class="fn_validate_register">
            
                {* User's name *}
                <div class="form_group">
                    <input class="form_input placeholder_focus" value="{$name|escape}" name="name" type="text" data-language="form_name" />
                    <span class="form_placeholder">{$lang->form_name}*</span>
                </div>

                {* User's email *}
                <div class="form_group">
                    <input class="form_input placeholder_focus" value="{$email|escape}" name="email" type="text" data-language="form_email" />
                    <span class="form_placeholder">{$lang->form_email}*</span>
                </div>

                {* User's phone *}
                <div class="form_group">
                    <input class="form_input placeholder_focus" value="{$phone|escape}" name="phone" type="text" data-language="form_phone" />
                    <span class="form_placeholder">{$lang->form_phone}</span>
                </div>

                {* User's address *}
                <div class="form_group">
                    <input class="form_input placeholder_focus" value="{$address|escape}" name="address" type="text" data-language="form_address" />
                    <span class="form_placeholder">{$lang->form_address}</span>
                </div>

                {* User's password *}
                <div class="form_group">
                    <p class="change_pass" onclick="$('#password').toggle();return false;"><span data-language="user_change_password">{$lang->user_change_password}</span></p>

                    <input class="form_input " id="password" value="" name="password" type="password" style="display:none;" placeholder="{$lang->user_change_password}"/>
                </div>

                <div class="form_group">
                    {* Submit button *}
                    <input type="submit" class="button" name="user_save" data-language="form_save" value="{$lang->form_save}">

                    {* Logout *}
                    <a href="{$lang_link}user/logout" class="button fright" data-language="user_logout">{$lang->user_logout}</a>
                </div>
            </form>
        </div>

        {* Orders history *}
        {if $orders}
            <div class="col-lg-7">
                <table class="table">
                    <thead>
                        <tr>
                            <th>
                                <span data-language="user_number_of_order">{$lang->user_number_of_order}</span>
                            </th>
                            <th>
                                <span data-language="user_order_date">{$lang->user_order_date}</span>
                            </th>
                            <th>
                                <span data-language="user_order_status">{$lang->user_order_status}</span>
                            </th>
                        </tr>
                    </thead>
                    {foreach $orders as $order}
                        <tr>
                            {* Order number *}
                            <td>
                                <a href='{$language->label}/order/{$order->url}'><span data-language="user_order_number">{$lang->user_order_number}</span>{$order->id}</a>
                            </td>

                            {* Order date *}
                            <td>{$order->date|date}</td>

                            {* Order status *}
                            <td>
                                {if $order->paid == 1}
                                    <span data-language="status_paid">{$lang->status_paid}</span>,
                                {/if}
                                {$orders_status[$order->status_id]->name|escape}
                            </td>
                        </tr>
                    {/foreach}
                </table>
            </div>
        {/if}
    </div>
</div>