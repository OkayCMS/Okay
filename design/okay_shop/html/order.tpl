{* Order page *}

{* The page title *}
{$meta_title = "`$lang->email_order_title` `$order->id`" scope=parent}

{* The page heading *}
<div class="order_notify_v2">
    <div class="o_notify_v2_head">
        {include file="svg.tpl" svgId="success_icon"}
        <span class="o_notify_v2_heading">{$lang->order_greeting} <span data-language="order_success_issued">{$lang->order_success_issued}</span></span>

    </div>
    <div class="o_notify_v2_content">
        <div class="o_notify_v2_content_inner" data-language="order_success_text">
            <p><strong>{$order->name|escape}</strong>, {$lang->order_success_text}
             </p>
        </div>
    </div>
    <div class="o_notify_v2_order_id">
        <div class="o_notify_v2_order_id_box">
            <div data-language="order_number_text">{$lang->order_number_text}</div>
            <span class="o_notify_v2_order_id_bold">№ {$order->id}</span>
        </div>
    </div>
</div>


<table class="purchase">
    <thead class="mobile-hidden">
        <tr>
            <th data-language="cart_head_img">{$lang->cart_head_img}</th>
            <th class="text_left" data-language="cart_head_name">{$lang->cart_head_name}</th>
            <th data-language="cart_head_price">{$lang->cart_head_price}</th>
            <th data-language="cart_head_amoun">{$lang->cart_head_amoun}</th>
            <th data-language="cart_head_total">{$lang->cart_head_total}</th>
        </tr>
    </thead>

    {foreach $purchases as $purchase}
        <tr class="purchase__list--mob">
            {* Product image *}
            <td class="purchase_image">
                <a href="{$lang_link}products/{$purchase->product->url}">
                    {if $purchase->product->image}
                        <img src="{$purchase->product->image->filename|resize:50:50}" alt="{$purchase->product_name|escape}" title="{$purchase->product_name|escape}">
                    {else}
                        <img width="50" height="50" src="design/{$settings->theme}/images/no_image.png" alt="{$purchase->product->name|escape}" title="{$purchase->product->name|escape}">
                    {/if}
                </a>
            </td>

            {* Product name *}
            <td class="text_left purchase__name--wrap purchase__name--wrap_order">
                <a class="purchase_name" href="{$lang_link}products/{$purchase->product->url}">{$purchase->product_name|escape}</a>
                <i>{$purchase->variant_name|escape}</i>
                {if $purchase->variant->stock == 0}<span class="preorder_label">{$lang->product_pre_order}</span>{/if}
                {if $order->paid && $purchase->variant->attachment}
                    <a class="button" href="{$lang_link}order/{$order->url}/{$purchase->variant->attachment}" data-language="order_download_file">{$lang->order_download_file}</a>
                {/if}
            </td>

            {* Price per unit *}
            <td class="purchase_price purchase__price--wrap">
                <span class="nowrap">
                    {($purchase->variant->price)|convert} {$currency->sign|escape} {if $purchase->units}/ {$purchase->units|escape}{/if}</span>
            </td>

            {* Quantity *}
            <td>{$purchase->amount|escape} {$lang->amount_pieces}</td>

            {* Extended price *}
            <td class="purchase_sum">
                <span class="nowrap">{($purchase->price*$purchase->amount)|convert} {$currency->sign|escape}</span>
            </td>
        </tr>
    {/foreach}

    {* Discount *}
    {if $order->discount > 0}
        <tr>
            <td></td>
            <td class="text_left" data-language="cart_discount">{$lang->cart_discount}</td>
            <td></td>
            <td></td>
            <td>{$order->discount}%</td>
        </tr>
    {/if}

    {* Coupon *}
    {if $order->coupon_discount > 0}
        <tr>
            <td></td>
            <td class="text_left">
                <span data-language="cart_coupon">{$lang->cart_coupon}</span>
            </td>
            <td></td>
            <td>{$order->coupon->coupon_percent|escape} %</td>
            <td>{$order->coupon_discount|convert} {$currency->sign|escape}</td>
        </tr>
    {/if}

    {* Delivery price *}
    {if $order->separate_delivery || !$order->separate_delivery && $order->delivery_price > 0}
        <tr>
            <td></td>
            <td class="text_left">
                <span>{$delivery->name|escape}</span>
            </td>
            <td></td>
            <td></td>
            {if !$order->separate_delivery}
                <td>{$order->delivery_price|convert} {$currency->sign|escape}</td>
            {else}
                <td></td>
            {/if}
        </tr>
    {/if}

    {* Total *}
    <tfoot>
        <tr>
            <td colspan="5" class="purchase_total">
                <span data-language="cart_total_price">{$lang->cart_total_price}:</span>
                <span class="total_sum nowrap">{$order->total_price|convert} {$currency->sign|escape}</span>
            </td>
        </tr>
    </tfoot>
</table>

<div class="wrap_block clearfix">
    <div class="col-lg-6 no_padding">
        <div class="h2">
            <span data-language="order_details">{$lang->order_details}</span>
        </div>
        {* Order details *}
        <div class="block padding">
            <table class="order_details">
                <tr>
                    <td>
                        <span data-language="user_order_status">{$lang->user_order_status}</span>
                    </td>
                    <td>
                        {$order_status->name|escape}
                        {if $order->paid == 1}
                            , <span data-language="status_paid">{$lang->status_paid}</span>
                        {/if}
                    </td>
                </tr>
                <tr>
                    <td>
                        <span data-language="order_date">{$lang->order_date}</span>
                    </td>
                    <td>{$order->date|date} <span data-language="order_time">{$lang->order_time}</span> {$order->date|time}</td>
                </tr>
                <tr>
                    <td>
                        <span data-language="order_name">{$lang->order_name}</span>
                    </td>
                    <td>{$order->name|escape}</td>
                </tr>
                <tr>
                    <td>
                        <span data-language="order_email">{$lang->order_email}</span>
                    </td>
                    <td>{$order->email|escape}</td>
                </tr>
                {if $order->phone}
                    <tr>
                        <td>
                            <span data-language="order_phone">{$lang->order_phone}</span>
                        </td>
                        <td>{$order->phone|escape}</td>
                    </tr>
                {/if}
                {if $order->address}
                    <tr>
                        <td>
                            <span data-language="order_address">{$lang->order_address}</span>
                        </td>
                        <td>{$order->address|escape}</td>
                    </tr>
                {/if}
                {if $order->comment}
                    <tr>
                        <td>
                            <span data-language="order_comment">{$lang->order_comment}</span>
                        </td>
                        <td>{$order->comment|escape|nl2br}</td>
                    </tr>
                {/if}
                {if $delivery}
                    <tr>
                        <td>
                            <span data-language="order_delivery">{$lang->order_delivery}</span>
                        </td>
                        <td>{$delivery->name|escape}</td>
                    </tr>
                {/if}
            </table>
        </div>
    </div>

    <div class="col-lg-6 no_padding">
        {if !$order->paid}
            {* Payments *}
            <div class="h2">
                <span data-language="order_payment_details">{$lang->order_payment_details}</span>
            </div>

            {if $payment_methods && !$payment_method && $order->total_price>0}
                <div class="delivery padding block">
                    <form method="post">
                        {foreach $payment_methods as $payment_method}
                            <div class="delivery_item">
                                <label class="delivery_label{if $payment_method@first} active{/if}">
                                    <input class="input_delivery"  type="radio" name="payment_method_id" value="{$payment_method->id}" {if $delivery@first && $payment_method@first} checked{/if} id="payment_{$delivery->id}_{$payment_method->id}">

                                    <span class="delivery_name">
                                        {if $payment_method->image}
                                            <img src="{$payment_method->image|resize:50:50:false:$config->resized_payments_dir}"/>
                                        {/if}
                                        {$total_price_with_delivery = $cart->total_price}
                                        {if !$delivery->separate_payment && $cart->total_price < $delivery->free_from}
                                            {$total_price_with_delivery = $cart->total_price + $delivery->price}
                                        {/if}
                                    
                                        {$payment_method->name|escape} {$lang->cart_deliveries_to_pay} <span class="nowrap">{$order->total_price|convert:$payment_method->currency_id} {$all_currencies[$payment_method->currency_id]->sign}</span>
                                    </span>
                                </label>
                                <div class="delivery_description">
                                    {$payment_method->description}
                                </div>
                            </div>
                        {/foreach}

                        <input type="submit" data-language="cart_checkout" value="{$lang->cart_checkout}" name="checkout" class="button">
                    </form>
                </div>
            {elseif $payment_method}
                {* Selected payment *}
                <div class="padding block clearfix">
                    <div class="method">
                        <span data-language="order_payment">{$lang->order_payment}</span>
                        <span class="method_name">{$payment_method->name|escape}</span>

                        <form class="method_form" method="post">
                            <input class="button" type=submit name='reset_payment_method' data-language="order_change_payment" value='{$lang->order_change_payment}'/>
                        </form>

                        {if $payment_method->description}
                            <div class="method_description">
                                {$payment_method->description}
                            </div>
                        {/if}
                    </div>

                    {*Payment form is generated by payment module*}
                    {*payment's form HTML code is in the /payment/ModuleName/form.tpl*}
                    {checkout_form order_id=$order->id module=$payment_method->module}
                </div>                
            {/if}
        {/if}
    </div>
</div>