{if $order->paid}
    {$subject = "`$btr->email_order` `$order->id` `$btr->email_paid`" scope=parent}
{else}
    {$subject = "`$btr->email_new_order` `$order->id`" scope=parent}
{/if}

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /><style type="text/css">
        /*<![CDATA[*/
        div, p, a, li, td, span {
            -webkit-text-size-adjust:none;
        }
        @media only screen and (max-width: 600px) {
            *[class="gmail-fix"] {
                display: none !important;
            }
        }
        /*]]>*/
    </style>
</head>
<body style="margin: 0">
<div style="padding: 15px 5px; background-color: rgb(239, 239, 239); background: rgb(239, 239, 239) url({$config->root_url}/design/{$settings->theme}/images/email_pattern.png); background-repeat: repeat; padding-left: 0px !important; padding-right: 0px !important;height: 100%">
    <table width="600" border="0" cellspacing="0" cellpadding="0" align="center" style="margin: 0 auto">
        <tbody>
        <tr>
            <td style="border: 0; height: 5px" border="0"></td>
        </tr>
        <tr>
            <td border="0" valign="top" align="left" style="border: 0">
                <div style="border-width: 0px; border-style: solid; border-radius: 0px; border-color: rgb(204, 204, 204)">
                    <!-- CONTENT BEGIN  -->
                    <div>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding: 5px; background-color: rgb(255, 255, 255); background: rgb(255, 255, 255) no-repeat; border-top-left-radius: 0px; border-top-right-radius: 0px; overflow: hidden">
                            <tbody>
                            <tr>
                                <td border="0" valign="top" width="1%" align="left" style="border: 0">
                                    <div>
                                        <div style="text-align: left"><a><img src="{$config->root_url}/design/{$settings->theme}/images/{$settings->site_logo}" width="200" align="left" style="border: 0; display: block; margin: 0 auto" /></a></div>
                                    </div>
                                </td>

                                <td border="0" valign="middle" align="left" style="border: 0">
                                    <div>
                                        <div style="text-align: left; font-family: 'Trebuchet MS'; font-size: 14px; color: rgb(51, 51, 51); line-height: normal">
                                            <div style="text-align: right;">
                                                <span style="font-size:18px;">
                                                    <span style="font-family:trebuchet ms,helvetica,sans-serif;">
                                                        <span style="color:#333333;">
                                                            <strong>{$btr->email_new_order|escape} {$order->id}</strong>
                                                        </span>
                                                    </span>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                    <div style="height: 30px; width: 100%; background: transparent;"></div>
                    <div>
                        <table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding: 5px;background: rgb(255, 255, 255)">
                            <tbody>
                            <tr>
                                <td border="0" valign="top" align="left" style="border: 0">
                                    <div>
                                        <div style="text-align: left; font-family: 'Trebuchet MS'; font-size: 14px; color: rgb(51, 51, 51); line-height: 1.5">
                                            <span style="font-family:trebuchet ms,helvetica,sans-serif;">
                                                <span style="font-size:14px;">{$btr->email_inform|escape} <strong>{$order->id}</strong> {$btr->email_from|escape} <strong>{$order->date|date}:{$order->date|time}</strong>.</span></span><br />
                                            <br />
                                            <table border="0" cellpadding="3" cellspacing="0" style="font-family: 'Trebuchet MS'; font-size: 14px; color: rgb(51, 51, 51); line-height: 1.5; width:100%; border-collapse: collapse">
                                                <tbody>
                                                <tr>
                                                    <td style="background-color:#38c0f3;border-bottom: 1px solid #fff;"><span style="font-size:14px;"><span style="font-family:trebuchet ms,helvetica,sans-serif;"><span style="color:#ffffff;"><strong>{$btr->email_status|escape}</strong></span></span></span></td>
                                                    <td style="border: 1px solid #38c0f3;"><span style="font-size:14px;">&nbsp; {$order_status->name|escape}</span></td>
                                                </tr>
                                                <tr>
                                                    <td style="background-color:#38c0f3;border-bottom: 1px solid #38c0f3">
                                                        <span style="font-size:14px;"><span style="font-family:trebuchet ms,helvetica,sans-serif;"><span style="color:#ffffff;"><strong>{$btr->email_payment_status}</strong></span></span></span>
                                                    </td>
                                                    <td style="border: 1px solid #38c0f3;">
                                                        <span style="font-size:14px;">
                                                             {if $order->paid == 1}
                                                                 {$btr->email_paid|escape}
                                                             {else}
                                                                 {$btr->email_not_paid|escape}
                                                             {/if}
                                                        </span>
                                                    </td>
                                                </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                        <div style="height: 30px; width: 100%; background: transparent;"></div>
                        <div>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding: 5px;background: rgb(255, 255, 255)">
                                <tbody>
                                <tr>
                                    <td border="0" valign="top" align="left" style="border: 0">
                                        <div>
                                            <div style="text-align: left; font-family: 'Trebuchet MS'; font-size: 14px; color: rgb(51, 51, 51); line-height: 1.5"><span style="font-family:trebuchet ms,helvetica,sans-serif;"><span style="font-size: 18px;">{$btr->email_details_order|escape}</span></span><br />
                                                <br />
                                                <table border="0" cellpadding="3" cellspacing="0" style="font-family: 'Trebuchet MS'; font-size: 14px; color: rgb(51, 51, 51); line-height: 1.5; width:100%; border-collapse: collapse">
                                                    <tbody>
                                                    <tr>
                                                        <td style="background-color:#38c0f3; border-bottom: 1px solid #fff;"><span style="font-size:14px;"><span style="color:#ffffff;"><strong><span style="font-family:trebuchet ms,helvetica,sans-serif;">{$btr->email_order_name}</span></strong></span></span></td>
                                                        <td style="border: 1px solid #38c0f3;"><span style="font-size:14px;">{$order->name|escape}</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td style="background-color:#38c0f3;border-bottom: 1px solid #fff;"><span style="font-size:14px;"><span style="color:#ffffff;"><strong><span style="font-family:trebuchet ms,helvetica,sans-serif;">{$btr->email_order_email}</span></strong></span></span></td>
                                                        <td style="border: 1px solid #38c0f3;"><span style="font-size:14px;">{$order->email|escape}</span></td>
                                                    </tr>
                                                    <tr>
                                                        <td style="background-color:#38c0f3;border-bottom: 1px solid #fff;"><span style="font-size:14px;"><span style="color:#ffffff;"><strong><span style="font-family:trebuchet ms,helvetica,sans-serif;">{$btr->email_order_phone}</span></strong></span></span></td>
                                                        <td style="border: 1px solid #38c0f3;">{$order->phone|escape}</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="background-color:#38c0f3;border-bottom: 1px solid #fff;"><span style="font-size:14px;"><span style="color:#ffffff;"><strong><span style="font-family:trebuchet ms,helvetica,sans-serif;">{$btr->email_order_address}</span></strong></span></span></td>
                                                        <td style="border: 1px solid #38c0f3;">{$order->address|escape}</td>
                                                    </tr>
                                                    <tr>
                                                        <td style="background-color:#38c0f3;border-bottom: 1px solid #38c0f3"><span style="font-size:14px;"><span style="color:#ffffff;"><strong><span style="font-family:trebuchet ms,helvetica,sans-serif;">{$btr->email_order_comment}</span></strong></span></span></td>
                                                        <td style="border: 1px solid #38c0f3;">{$order->comment|escape|nl2br}</td>
                                                    </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <div style="height: 30px; width: 100%; background: transparent;"></div>
                        <div>
                            <table style="padding: 5px;background: rgb(255, 255, 255); border-collapse: separate;" width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tbody>
                                <tr>
                                    <td style="padding-bottom: 15px;">
                                        <div>
                                            <div style="font-family: 'Trebuchet MS'; font-size: 16px; color: rgb(51, 51, 51); font-weight: normal; text-align: left; font-style: normal; line-height: normal; text-transform: none">
                                                <span style="font-family:trebuchet ms,helvetica,sans-serif;">
                                                    <span style="font-size:18px;">{$btr->email_order_purchases}</span>
                                                </span>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td style=" padding-bottom: 15px;">
                                        <div>
                                            <div style="text-align: left; font-family: 'Trebuchet MS'; font-size: 14px; color: rgb(51, 51, 51); line-height: 1.5">
                                                <table width="100%" style="padding: 5px;font-family: 'Trebuchet MS'; font-size: 14px; color: rgb(51, 51, 51); line-height: 1.5">
                                                    <tbody>
                                                    {foreach $purchases as $purchase}
                                                        <tr>
                                                            <td valign="middle">
                                                                <a href="{$config->root_url}/{$lang_link}products/{$purchase->product->url}">
                                                                    {if $purchase->product->image}
                                                                        <img align="middle" src="{$purchase->product->image->filename|resize:70:70}" />
                                                                    {else}
                                                                        <img width="70" height="70" src="{$config->root_url}/backend/design/images/no_image.png" alt="{$purchase->product->name|escape}" title="{$purchase->product->name|escape}">
                                                                    {/if}
                                                                </a>
                                                            </td>

                                                            <td valign="middle">
                                                                <a href="{$config->root_url}/{$lang_link}products/{$purchase->product->url}" style="font-family: 'Trebuchet MS'; font-size: 14px; color: rgb(29, 103, 164); text-decoration: underline">{$purchase->product_name|escape}</a><br />
                                                                <span style="font-family:verdana,geneva,sans-serif;"><em><span style="color: rgb(128, 128, 128); font-size: 11px;">{$purchase->variant_name|escape}</span></em></span>
                                                                {if $purchase->variant->stock == 0}{$lang->product_pre_order}{/if}
                                                                {if $order->paid && $purchase->variant->attachment}
                                                                    <div style="font-family:verdana,geneva,sans-serif;">
                                                                        <a href="{$config->root_url}/{$lang_link}order/{$order->url}/{$purchase->variant->attachment}">
                                                                            <em><span style="color: rgb(128, 128, 128); font-size: 11px;">{$btr->email_order_download} {$purchase->variant->attachment}</span></em>
                                                                        </a>
                                                                    </div>
                                                                {/if}
                                                            </td>
                                                            <td style=";padding-right:10px;white-space:nowrap" valign="middle">{$purchase->amount} {if $purchase->units}{$purchase->units|escape}{else}{$settings->units|escape}{/if}</td>
                                                            <td align="right" nowrap="nowrap" valign="middle">
                                                                <b>{$purchase->price|convert:$currency->id}&nbsp;{$currency->sign|escape}</b>
                                                            </td>
                                                        </tr>
                                                    {/foreach}
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                <div style="border-bottom: 1px solid #ddd"></div>
                                <tr>
                                    <td style=" padding-bottom: 15px;">
                                        <div>
                                            <div style="text-align: left; font-family: 'Trebuchet MS'; font-size: 14px; color: rgb(51, 51, 51); line-height: 1.5">
                                                <table cellpadding="4" cellspacing="0" width="100%" style="padding: 5px;font-family: 'Trebuchet MS'; font-size: 14px; color: rgb(51, 51, 51); line-height: 1.5">
                                                    <tbody>
                                                    {if $order->discount}
                                                        <tr>
                                                            <td style="padding-right: 10px; white-space: nowrap; text-align: right;" valign="middle">{$btr->email_order_discount}</td>
                                                            <td align="right" nowrap="nowrap" valign="middle">{$order->discount}&nbsp;%</td>
                                                        </tr>
                                                    {/if}
                                                    {if $order->coupon_discount>0}
                                                        <tr>
                                                            <td style="padding-right: 10px; white-space: nowrap; text-align: right;" valign="middle">{$btr->email_order_coupon} {$order->coupon_code}</td>
                                                            <td align="right" nowrap="nowrap" valign="middle">&minus;{$order->coupon_discount}&nbsp;{$currency->sign}</td>
                                                        </tr>
                                                    {/if}
                                                    {if $order->separate_delivery || !$order->separate_delivery && $order->delivery_price > 0}
                                                        <tr>
                                                            <td style="padding-right: 10px; white-space: nowrap; text-align: right;" valign="middle">{$delivery->name|escape}</td>
                                                            {if !$order->separate_delivery}
                                                                <td align="right" nowrap="nowrap" valign="middle">{$order->delivery_price|convert:$currency->id}&nbsp;{$currency->sign}</td>
                                                            {else}
                                                                <td></td>
                                                            {/if}
                                                        </tr>
                                                    {/if}
                                                    <tr>
                                                        <td style="padding-right: 10px; white-space: nowrap; text-align: right;" valign="middle"><span style="font-size:16px;"><strong>{$btr->email_order_total}</strong></span></td>
                                                        <td align="right" nowrap="nowrap" valign="middle"><b><span style="font-size:16px;">{$order->total_price|convert:$currency->id}&nbsp;{$currency->sign}</span></b></td>
                                                    </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <div>
                            <table width="100%" cellpadding="0" cellspacing="0" border="0" style="padding: 5px; background: rgb(255, 255, 255)">
                                <tbody>
                                <tr>
                                    <td align="center" valign="top" border="0" style="border: 0">
                                        <div>
                                            <div style="text-align: center; font-family: 'Trebuchet MS'; font-size: 14px; color: rgb(51, 51, 51); line-height: 1.5">
                                                <span style="font-family:trebuchet ms,helvetica,sans-serif;">
                                                    <span style="border-style: solid; border-color: rgb(234, 182, 9); background-color: rgb(234, 182, 9); border-width: 0px 0px 0px 0px; display: inline-block; border-radius: 29px">
                                                        <a href="{$config->root_url}/backend/index.php?module=OrderAdmin&id={$order->id}" style="font-family: 'Trebuchet MS'; font-size: 14px; color: rgb(29, 103, 164); text-decoration: underline; border-style: solid; border-width: 8px 25px 8px 25px; display: inline-block; border-radius: 28px; border-color: rgb(242, 189, 11); background: rgb(242, 189, 11); font-size: 16px; font-family: 'Lucida Sans Unicode', 'Lucida Grande'; font-weight: bold; color: rgb(255, 255, 255); text-decoration: none">
                                                            <span style="font-family:trebuchet ms,helvetica,sans-serif;"> {$btr->email_order_info} &gt;</span>
                                                        </a>
                                                    </span>
                                                </span>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <!-- CONTENT END  -->
                </div>
            </td>
        </tr>
        </tbody>
    </table>
</div>
</body>
</html>
