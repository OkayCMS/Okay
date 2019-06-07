<!DOCTYPE html>
{*Печать заказа*}
{$wrapper='' scope=parent}
<html>
<head>
    <base href="{$config->root_url}/"/>
    <title>{$btr->general_order_number|escape} {$order->id}</title>
    {* Метатеги *}
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="description" content="{$meta_description|escape}" />
    <style>
    body {
        width: 1000px;
        height: 1414px;
        /* to centre page on screen*/
        margin-left: auto;
        margin-right: auto;
        border: 1px solid black;

        font-family: Trebuchet MS, times, arial, sans-serif;        
        font-size: 10pt;
        color: black;
        background-color: white;         
    }
    
    div#header{
        margin-left: 50px;
        margin-top: 50px;
        height: 150px;
        width: 500px;
        float: left;
    }
    div#company{
        margin-right: 50px;
        margin-top: 50px;
        height: 150px;
        width: 400px;
        float: right;
        text-align: right;
    }
    div#customer{
        margin-right: 50px;
        height: 200px;
        width: 300px;
        float: right;
    }
    div#customer table{
        margin-bottom: 20px;
        font-size: 20px;
    }
    div#map{
        margin-left: 50px;
        height: 400px;
        width: 500px;
        float: left;
    }
    div#purchases{
        margin-left: 50px;
        margin-bottom: 20px;
        min-height: 600px;
        width: 100%;
        float: left;
        
    }
    div#purchases table{
        width: 900px;
        border-collapse:collapse
    }
    div#purchases table th
    {
        font-weight: normal;
        text-align: left;
        font-size: 25px;
    }
    div#purchases td, div#purchases th
    {
        font-size: 18px;
        padding-top: 10px;
        padding-bottom: 10px;
        margin: 0;        
    }
    div#purchases td
    {
        border-top: 1px solid black;     
    }
 
    div#total{
        float: right;
        margin-right: 50px;
        height: 100px;
        width: 500px;
        text-align: right;
    }
    div#total table{
        width: 500px;
        float: right;
        border-collapse:collapse
    }
    div#total th
    {
        font-weight: normal;
        text-align: left;
        font-size: 22px;
        border-top: 1px solid black;     
    }
    div#total td
    {
        text-align: right;
        border-top: 1px solid black;     
        font-size: 18px;
        padding-top: 10px;
        padding-bottom: 10px;
        margin: 0;        
    }
    div#total .total
    {
        font-size: 30px;
    }
    h1{
        margin: 0;
        font-weight: normal;
        font-size: 40px;
    }
    h2{
        margin: 0;
        font-weight: normal;
        font-size: 24px;
    }
    p
    {
        margin: 0;
        font-size: 20px;
    }
    div#purchases td.align_right, div#purchases th.align_right
    {
        text-align: right;
    }
    </style>    
</head>

<body _onload="window.print();">

<div id="header">
    <h1>{$btr->general_order_number|escape} {$order->id}</h1>
    <p>{$btr->order_print_from|escape} {$order->date|date}</p>
</div>

<div id="company">
    <h2>{$settings->site_name|escape}</h2>
    <p>{$config->root_url}</p>
</div>

{*Информация о клиенте*}
<div id="customer">
    <h2>{$btr->order_print_recipient|escape}</h2>
    <table>
        <tr>
            <td>{$order->name|escape}</td>
        </tr>    
        <tr>
            <td>{$order->phone|escape}</td>
        </tr>    
        <tr>
            <td>{$order->email|escape}</td>
        </tr>    
        <tr>
            <td>{$order->address|escape}</td>
        </tr>    
        <tr>
            <td><i>{$order->comment|escape|nl2br}</i></td>
        </tr>
    </table>
    

    {if $order->note}
    <table>        
        <tr>
            <td><h2><i>{$btr->order_note|escape}</i></h2><i>{$order->note|escape|nl2br}</i></td>
        </tr>
    </table>
    {/if}

</div>

<div id="map">
    <iframe width="550" height="370" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="http://maps.google.com/maps?ie=UTF8&iwloc=near&hl=ru&t=m&z=16&mrt=loc&geocode=&q={$order->address|escape|urlencode}&output=embed"></iframe>
</div>

{*Информация о заказе*}
<div id="purchases">
    <table>
        <tr>
            <th>{$btr->order_print_product|escape}</th>
            <th class="align_right">{$btr->general_price|escape}</th>
            <th class="align_right">{$btr->general_amt|escape}</th>
            <th class="align_right">{$btr->order_print_total|escape}</th>
        </tr>
        {foreach $purchases as $purchase}
        <tr>
            <td>
                <span class=view_purchase>
                    {$purchase->product_name|escape} {$purchase->variant_name|escape} {if $purchase->sku} ({$btr->general_sku|escape} {$purchase->sku|escape}){/if}
                </span>
            </td>
            <td class="align_right">
                <span class=view_purchase>{$purchase->price}</span> {$currency->sign|escape}
            </td>
            <td class="align_right">            
                <span class=view_purchase>
                    {$purchase->amount} {if $purchase->units}{$purchase->units|escape}{else}{$settings->units|escape}{/if}
                </span>
            </td>
            <td class="align_right">
                <span class=view_purchase>{$purchase->price*$purchase->amount}</span> {$currency->sign|escape}
            </td>
        </tr>
        {/foreach}
        {* Если стоимость доставки входит в сумму заказа *}
        {if $order->delivery_price>0}
        <tr>
            <td colspan=3>{$delivery->name|escape}{if $order->separate_delivery} ({$btr->general_paid_separately|escape}){/if}</td>
            <td class="align_right">{$order->delivery_price|convert:$currency->id}&nbsp;{$currency->sign|escape}</td>
        </tr>
        {/if}
        
    </table>
</div>


<div id="total">
    <table>
        {if $order->discount>0}
        <tr>
            <th>{$btr->general_discount|escape}</th>
            <td>{$order->discount} %</td>
        </tr>
        {/if}
        {if $order->coupon_discount>0}
        <tr>
            <th>{$btr->general_coupon|escape} {if $order->coupon_code} ({$order->coupon_code}){/if}</th>
            <td>{$order->coupon_discount}&nbsp;{$currency->sign|escape}</td>
        </tr>
        {/if}
        <tr>
            <th>{$btr->general_total|escape}</th>
            <td class="total">{$order->total_price|convert:$currency->id}&nbsp;{$currency->sign|escape}</td>
        </tr>
        {if $delivery}
        <tr>
            <td colspan="2">{$btr->order_print_delivery|escape} {$delivery->name}</td>
        </tr>
        {/if}
        {if $payment_method}
        <tr>
            <td colspan="2">{$btr->order_print_payment|escape} {$payment_method->name}</td>
        </tr>
        <tr>
            <th>{$btr->order_to_pay|escape}</th>
            <td class="total">{$order->total_price|convert:$payment_method->currency_id}&nbsp;{$payment_currency->sign}</td>
        </tr>
        {/if}
    </table>
</div>

</body>
</html>

