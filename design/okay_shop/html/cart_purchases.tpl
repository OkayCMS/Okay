<table class="purchase">
    <thead class="mobile-hidden">
        <tr>
            <th data-language="cart_head_img">{$lang->cart_head_img}</th>
            <th class="text_left" data-language="cart_head_name">{$lang->cart_head_name}</th>
            <th data-language="cart_head_price">{$lang->cart_head_price}</th>
            <th data-language="cart_head_amoun">{$lang->cart_head_amoun}</th>
            <th data-language="cart_head_total">{$lang->cart_head_total}</th>
            <th></th>
        </tr>
    </thead>

    {foreach $cart->purchases as $purchase}
        <tr class="purchase__list--mob">
            {* Product image *}
            <td class="purchase_image">
                <a href="{$lang_link}products/{$purchase->product->url}">
                    {if $purchase->product->image}
                        <img src="{$purchase->product->image->filename|resize:50:50}" alt="{$purchase->product->name|escape}" title="{$purchase->product->name|escape}">
                    {else}
                        <img width="50" height="50" src="design/{$settings->theme}/images/no_image.png" alt="{$purchase->product->name|escape}" title="{$purchase->product->name|escape}">
                    {/if}
                </a>
            </td>

            {* Product name *}
            <td class="text_left purchase__name--wrap">
                <a class="purchase_name" href="{$lang_link}products/{$purchase->product->url}">{$purchase->product->name|escape}</a>
                <i>{$purchase->variant->name|escape}</i>
                {if $purchase->variant->stock == 0}<span class="preorder_label">{$lang->product_pre_order}</span>{/if}
            </td>

            {* Price per unit *}
            <td class="purchase__price--wrap">
                <span class="nowrap">{($purchase->variant->price)|convert} {$currency->sign} {if $purchase->variant->units}/ {$purchase->variant->units|escape}{/if}</span>
            </td>

            {* Quantity *}
            <td class="purchase_amount">
                <div class="fn_product_amount{if $settings->is_preorder} fn_is_preorder{/if} amount">
                    <span class="minus">&minus;</span>
                    <input class="input_amount" type="text" data-id="{$purchase->variant->id}" name="amounts[{$purchase->variant->id}]" value="{$purchase->amount}" onblur="ajax_change_amount(this, {$purchase->variant->id});" data-max="{$purchase->variant->stock}">
                    <span class="plus">&plus;</span>
                </div>
            </td>

            {* Extended price *}
            <td class="purchase_sum">
                <span class="nowrap">{($purchase->variant->price*$purchase->amount)|convert} {$currency->sign}</span>
            </td>

            {* Remove button *}
            <td class="purchase_remove">
                <a href="{$lang_link}cart/remove/{$purchase->variant->id}" onclick="ajax_remove({$purchase->variant->id});return false;" title="{$lang->cart_remove}">
                    {include file='svg.tpl' svgId='remove_icon'}
                </a>
            </td>
        </tr>
    {/foreach}

    {* Discount *}
    {if $user->discount}
        <tr>
            <td></td>
            <td class="text_left" data-language="cart_discount">{$lang->cart_discount}</td>
            <td></td>
            <td></td>
            <td>{$user->discount}%</td>
            <td></td>
        </tr>
    {/if}

    {* Coupon *}
    {if $coupon_request}
        {if $cart->coupon_discount > 0}
            <tr>
                <td></td>
                <td class="text_left" data-language="cart_coupon">{$lang->cart_coupon}</td>
                <td></td>
                <td>{$cart->coupon->coupon_percent|escape} %</td>
                <td>&minus; {$cart->coupon_discount|convert} {$currency->sign|escape}</td>
                <td></td>
            </tr>
        {/if}
    {/if}

    <tfoot>
        <tr>
            {if $coupon_request}
                <td colspan="3" class="coupon text_left">
                {* Coupon *}

                    {* Coupon error messages *}
                    {if $coupon_error}
                        <div class="message_error">
                            {if $coupon_error == 'invalid'}
                                {$lang->cart_coupon_error}
                            {/if}
                        </div>
                    {/if}
                    {if $cart->coupon->min_order_price > 0}
                        <div class="message_success">
                            {$lang->cart_coupon} {$cart->coupon->code|escape} {$lang->cart_coupon_min} {$cart->coupon->min_order_price|convert} {$currency->sign|escape}
                        </div>
                    {/if}

                    {* Coupon field *}
                    <input class="fn_coupon input_coupon" type="text" name="coupon_code" value="{$cart->coupon->code|escape}" placeholder="{$lang->cart_coupon}">

                    <input class="coupon_button fn_sub_coupon" type="button" value="{$lang->cart_purchases_coupon_apply}">
                </td>
            {/if}

            <td {if $coupon_request}colspan="2"{else}colspan="5"{/if} class="purchase_total">
                {* Total *}
                <span data-language="cart_total_price">{$lang->cart_total_price}:</span>
                <span class="total_sum nowrap">{$cart->total_price|convert} {$currency->sign|escape}</span>
            </td>

            <td></td>
        </tr>
    </tfoot>
</table>
