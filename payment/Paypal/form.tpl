<form method="post" action="{$paypal_url}">
    <input type="hidden" name="charset"       value="utf-8">
    <input type="hidden" name="currency_code" value="{$currency->code|escape}">
    <input type="hidden" name="invoice"       value="{$order->id|escape}">
    <input type="hidden" name="business"      value="{$payment_settings['business']|escape}">
    <input type="hidden" name="cmd"           value="_cart">
    <input type="hidden" name="upload"        value="1">
    <input type="hidden" name="rm"            value="2">
    <input type="hidden" name="notify_url"    value="{$ipn_url|escape}">
    <input type="hidden" name="return"        value="{$success_url|escape}">
    <input type="hidden" name="cancel_return" value="{$fail_url|escape}">
    {if $order->discount > 0}
        <input type="hidden" name="discount_rate_cart"   value="{$order->discount|escape}">
    {/if}
    {if $order->coupon_discount > 0}
        <input type="hidden" name="discount_amount_cart" value="{$coupon_discount|escape}">
    {/if}
    {assign var="i" value=1}
    {foreach $purchases as $purchase}
        {assign var="price" value=$purchase->price|convert:$payment_method->currency_id:false}
        <input type="hidden" name="item_name_{$i}" value="{$purchase->product_name|escape} {$purchase->variant_name|escape}">
        <input type="hidden" name="amount_{$i}"    value="{number_format($price, 2, '.', '')}">
        <input type="hidden" name="quantity_{$i}"  value="{$purchase->amount|escape}">
        {$i=$i+1}
    {/foreach}
    {$delivery_price = 0}
    {if $order->delivery_id && !$order->separate_delivery && $order->delivery_price>0}
        {$delivery_price = $order->delivery_price|convert:$payment_method->currency_id:false}
        {$delivery_price = number_format($delivery_price, 2, '.', '')}
        <input type="hidden" name="shipping_1" value="{$delivery_price}">
    {/if}
    <input type="image" src="https://www.paypalobjects.com/en_US/i/btn/btn_xpressCheckout.gif" value="{$lang->form_to_pay}">
</form>
