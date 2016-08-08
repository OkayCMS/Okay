{* Шаблон письма пользователю о заказе *}

{$subject = "`$lang->email_order_order` №`$order->id`" scope=parent}
<h1 style="text-align: center;font: 18px;background: #41ade2;color: #fff;padding: 5px; width: 800px;">
    <a href="{$config->root_url}/{$lang_link}order/{$order->url}" style="color: #fff!important;">{$lang->email_order_title} {$order->id}</a>
    {$lang->email_order_on_total} {$order->total_price|convert:$currency->id}&nbsp;{$currency->sign}
    {if $order->paid == 1}
    {$lang->email_order_paid}
    {else}
    {$lang->email_order_not_paid}
    {/if},
    {if $order->status == 0}
        {$lang->email_order_status_0}
    {elseif $order->status == 1}
        {$lang->email_order_status_1}
    {elseif $order->status == 2}
        {$lang->email_order_status_2}
    {elseif $order->status == 3}
        {$lang->email_order_status_3}
    {/if}
</h1>
<table cellpadding="6" cellspacing="0" style="border-collapse: collapse; border: 2px solid #41ade2; width: 100%">
	<tr style="border-bottom: 2px solid #41ade2;">
		<td style=" width:300px;float: left;;padding: 5px;">
			{$lang->email_order_status}
		</td>
		<td style=" width:300px;float: left;;padding: 5px;border-left: 1px solid #41ade2;">
            {if $order->status == 0}
                {$lang->email_order_status_0}
            {elseif $order->status == 1}
                {$lang->email_order_status_1}
            {elseif $order->status == 2}
                {$lang->email_order_status_2}
            {elseif $order->status == 3}
                {$lang->email_order_status_3}
            {/if}
		</td>
	</tr>
	<tr style="border-bottom: 2px solid #41ade2;">
		<td style=" width:300px;float: left;;padding: 5px;">
			{$lang->email_order_payment}
		</td>
		<td style=" width:300px;float: left;;padding: 5px;border-left: 1px solid #41ade2;">
			{if $order->paid == 1}
			<span style="color: green;">{$lang->email_order_paid}</span>
			{else}
                {$lang->email_order_not_paid}
			{/if}
		</td>
	</tr>
	{if $order->name}
	<tr style="border-bottom: 2px solid #41ade2;">
		<td style=" width:300px;float: left;;padding: 5px;">
			{$lang->email_order_name}
		</td>
		<td style=" width:300px;float: left;;padding: 5px;border-left: 1px solid #41ade2;">
			{$order->name|escape}
		</td>
	</tr>
	{/if}
	{if $order->email}
	<tr style="border-bottom: 2px solid #41ade2;">
		<td style=" width:300px;float: left;;padding: 5px;">
			{$lang->email_order_email}
		</td>
		<td style=" width:300px;float: left;;padding: 5px;border-left: 1px solid #41ade2;">
			{$order->email|escape}
		</td>
	</tr>
	{/if}
	{if $order->phone}
	<tr style="border-bottom: 2px solid #41ade2;">
		<td style=" width:300px;float: left;;padding: 5px;">
			{$lang->email_order_phone}
		</td>
		<td style=" width:300px;float: left;;padding: 5px;border-left: 1px solid #41ade2;">
			{$order->phone|escape}
		</td>
	</tr>
	{/if}
	{if $order->address}
	<tr style="border-bottom: 2px solid #41ade2;">
		<td style=" width:300px;float: left;;padding: 5px;">
			{$lang->email_order_address}
		</td>
		<td style=" width:300px;float: left;;padding: 5px;border-left: 1px solid #41ade2;">
			{$order->address|escape}
		</td>
	</tr>
	{/if}
	{if $order->comment}
	<tr style="border-bottom: 2px solid #41ade2;">
		<td style=" width:300px;float: left;;padding: 5px;">
			{$lang->email_order_comment}
		</td>
		<td style=" width:300px;float: left;;padding: 5px;border-left: 1px solid #41ade2;">
			{$order->comment|escape|nl2br}
		</td>
	</tr>
	{/if}
	<tr style="border-bottom: 2px solid #41ade2;">
		<td style=" width:300px;float: left;;padding: 5px;">
			{$lang->email_order_date}
		</td>
		<td style=" width:300px;float: left;;padding: 5px;border-left: 1px solid #41ade2;">
			{$order->date|date} {$order->date|time}
		</td>
	</tr>
</table>

<h1 style="font: 18px;background: #41ade2;color: #fff;padding: 5px;margin-top: 15px;width: 100%;clear: both">{$lang->email_order_purchases}</h1>

<table cellpadding="6" cellspacing="0" style="border-collapse: collapse; border: 2px solid #2c6f95;width: 100%">

	{foreach $purchases as $purchase}
	<tr style="border-bottom:2px solid #2c6f95">
		<td align="center" style="padding:6px; width:100px; background-color:#ffffff;font-family:arial;">
			{$image = $purchase->product->images[0]}
			<a href="{$config->root_url}/{$lang_link}products/{$purchase->product->url}">
                <img border="0" src="{$image->filename|resize:50:50}">
            </a>
		</td>
		<td style="padding:6px; width:300px; padding:6px; background-color:#41ade2; ;font-family:arial;">
			<a href="{$config->root_url}/{$lang_link}products/{$purchase->product->url}" style="color: #fff!important;">
                {$purchase->product_name}
            </a>
			{$purchase->variant_name}
			{if $order->paid && $purchase->variant->attachment}
			<br>
			<a href="{$config->root_url}/{$lang_link}order/{$order->url}/{$purchase->variant->attachment}" style="color: #fff!important;">
                <span style="color: green;">{$lang->email_order_download} {$purchase->variant->attachment}</span>
            </a>
			{/if}
		</td>
		<td align=left style="padding:6px; text-align:right; width:150px; background-color:#ffffff; ;font-family:arial;">
			{$purchase->amount} {$settings->units} &times; {$purchase->price|convert:$currency->id}&nbsp;{$currency->sign}
		</td>
	</tr>
	{/foreach}
	
	{if $order->discount}
	<tr>
		<td style="padding:6px; width:100px;background-color:#ffffff; ;font-family:arial;"></td>
		<td style="padding:6px; background-color:#41ade2; ;font-family:arial;">
			{$lang->email_order_discount}
		</td>
		<td align=left style="padding:6px; text-align:right; width:150px; background-color:#ffffff; ;font-family:arial;">
			{$order->discount}&nbsp;%
		</td>
	</tr>
	{/if}

	{if $order->coupon_discount>0}
	<tr>
		<td style="padding:6px; width:100px; background-color:#ffffff; ;font-family:arial;"></td>
		<td style="padding:6px; background-color:#41ade2; ;font-family:arial;">
		    {$lang->email_order_coupon}	{$order->coupon_code}
		</td>
		<td align=left style="padding:6px; text-align:right; width:150px; background-color:#ffffff; ;font-family:arial;">
			&minus;{$order->coupon_discount}&nbsp;{$currency->sign}
		</td>
	</tr>
	{/if}

	{if $delivery && !$order->separate_delivery}
	<tr>
		<td style="padding:6px; width:100px; background-color:#ffffff; ;font-family:arial;"></td>
		<td style="padding:6px; background-color:#41ade2; ;font-family:arial;">
			{$delivery->name}
		</td>
		<td align="right" style="padding:6px; text-align:right; width:150px; background-color:#ffffff; ;font-family:arial;">
			{$order->delivery_price|convert:$currency->id}&nbsp;{$currency->sign}
		</td>
	</tr>
	{/if}
	
	<tr>
		<td style="padding:6px; width:100px; background-color:#ffffff; ;font-family:arial;"></td>
		<td style="padding:6px; background-color:#41ade2; ;font-family:arial;font-weight:bold;">
			{$lang->email_order_total}
		</td>
		<td align="right" style="padding:6px; text-align:right; width:150px; background-color:#ffffff; ;font-family:arial;font-weight:bold;">
			{$order->total_price|convert:$currency->id}&nbsp;{$currency->sign}
		</td>
	</tr>
</table>

<div style="float: left;width: 800px; border: 2px dashed #41ade2; text-align: center;margin-top: 10px;padding: 5px">
    {$lang->email_order_info}<br>
    <a href="{$config->root_url}/{$lang_link}order/{$order->url}">
        {$config->root_url}/{$lang_link}order/{$order->url}
    </a>
</div>