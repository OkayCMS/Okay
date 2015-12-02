{if $order->paid}
{$subject = "Заказ №`$order->id` оплачен" scope=parent}
{else}
{$subject = "Новый заказ №`$order->id`" scope=parent}
{/if}
<h1 style="text-align: center;font: 18px;background: #41ade2;color: #fff;padding: 5px; width: 800px;">
	<a href="{$config->root_url}/backend/index.php?module=OrderAdmin&id={$order->id}">Заказ №{$order->id}</a>
	на сумму {$order->total_price|convert:$main_currency->id}&nbsp;{$main_currency->sign}
	{if $order->paid == 1}
        оплачен
    {else}
        еще не оплачен
    {/if},
	{if $order->status == 0}
        ждет обработки
    {elseif $order->status == 1}
        в обработке
    {elseif $order->status == 2}
        выполнен
    {/if}
</h1>

<table cellpadding="6" cellspacing="0" style="border-collapse: collapse; border: 2px solid #41ade2;">
    <tr style="border-bottom: 2px solid #41ade2;">
        <td style=" width:300px;float: left;;padding: 5px;">
            Статус
        </td>
        <td style=" width:300px;float: left;;padding: 5px;border-left: 1px solid #41ade2;">
            {if $order->status == 0}
                ждет обработки
            {elseif $order->status == 1}
                в обработке
            {elseif $order->status == 2}
                выполнен
            {elseif $order->status == 3}
                отменен
            {/if}
        </td>
    </tr>
    <tr style="border-bottom: 2px solid #41ade2;">
        <td style=" width:300px;float: left;;padding: 5px;">
            Оплата
        </td>
        <td style=" width:300px;float: left;;padding: 5px;border-left: 1px solid #41ade2;">
            {if $order->paid == 1}
                <span style="color: green;">оплачен</span>
            {else}
                не оплачен
            {/if}
        </td>
    </tr>
    {if $order->name}
        <tr style="border-bottom: 2px solid #41ade2;">
            <td style=" width:300px;float: left;;padding: 5px;">
                Имя, фамилия
            </td>
            <td style=" width:300px;float: left;;padding: 5px;border-left: 1px solid #41ade2;">
                {$order->name|escape}
                {if $user}
                (<a href="{$config->root_url}/backend/index.php?module=UserAdmin&id={$user->id}">
                    зарегистрированный пользователь
                </a>)
                {/if}

            </td>
        </tr>
    {/if}
    {if $order->email}
        <tr style="border-bottom: 2px solid #41ade2;">
            <td style=" width:300px;float: left;;padding: 5px;">
                Email
            </td>
            <td style=" width:300px;float: left;;padding: 5px;border-left: 1px solid #41ade2;">
                {$order->email|escape}
            </td>
        </tr>
    {/if}
    {if $order->phone}
        <tr style="border-bottom: 2px solid #41ade2;">
            <td style=" width:300px;float: left;;padding: 5px;">
                Телефон
            </td>
            <td style=" width:300px;float: left;;padding: 5px;border-left: 1px solid #41ade2;">
                {$order->phone|escape}
            </td>
        </tr>
    {/if}
    {if $order->address}
        <tr style="border-bottom: 2px solid #41ade2;">
            <td style=" width:300px;float: left;;padding: 5px;">
                Адрес доставки
            </td>
            <td style=" width:300px;float: left;;padding: 5px;border-left: 1px solid #41ade2;">
                {$order->address|escape}
            </td>
        </tr>
    {/if}
    {if $order->comment}
        <tr style="border-bottom: 2px solid #41ade2;">
            <td style=" width:300px;float: left;;padding: 5px;">
                Комментарий
            </td>
            <td style=" width:300px;float: left;;padding: 5px;border-left: 1px solid #41ade2;">
                {$order->comment|escape|nl2br}
            </td>
        </tr>
    {/if}
    <tr style="border-bottom: 2px solid #41ade2;">
        <td style=" width:300px;float: left;;padding: 5px;">
            Дата
        </td>
        <td style=" width:300px;float: left;;padding: 5px;border-left: 1px solid #41ade2;">
            {$order->date|date} {$order->date|time}
        </td>
    </tr>
</table>

<h1 style="float: left;font: 18px;background: #41ade2;color: #fff;padding: 5px;margin-top: 15px;width: 800px;">Заказ покупателя:</h1>

<table cellpadding="6" cellspacing="0" style="border-collapse: collapse; border: 2px solid #2c6f95">

    {foreach $purchases as $purchase}
        <tr style="border-bottom:2px solid #2c6f95">
            <td align="center" style="padding:6px; width:100px; background-color:#ffffff; ;font-family:arial;">
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
                        <span style="color: green;">Скачать {$purchase->variant->attachment}</span>
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
                Скидка
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
                Купон {$order->coupon_code}
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
            Итого
        </td>
        <td align="right" style="padding:6px; text-align:right; width:150px; background-color:#ffffff; ;font-family:arial;font-weight:bold;">
            {$order->total_price|convert:$currency->id}&nbsp;{$currency->sign}
        </td>
    </tr>
</table>

<div style="float: left;width: 800px; border: 2px dashed #41ade2; text-align: center;margin-top: 10px;padding: 5px">
    Приятной работы с <a href='http://okay-cms.com'>Okay</a>!
</div>