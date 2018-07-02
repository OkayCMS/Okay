{* Подключаем формы всех модулей оплаты *}
{* Все переменные берутся в модуле оплаты и потом подключаются в tpl *}
{* payment_module - название модуля оплаты(по сути папка модуля оплаты) *}
{if $payment_module == "Interkassa"}
    {* Способ оплаты Interkassa *}
    <div class="row">
        <form class="col-lg-7" name="payment" method="post" action="https://sci.interkassa.com/" accept-charset="UTF-8">
            <input type="hidden" name="ik_co_id" value="{$settings_pay['ik_co_id']|escape}">
            <input type="hidden" name="ik_pm_no" value="{$order->id|escape}">
            <input type="hidden" name="ik_cur"   value="{$payment_currency->code|escape}">
            <input type="hidden" name="ik_am"    value="{$price|escape}">
            <input type="hidden" name="ik_desc"  value="{$desc|escape}">
            <input type="hidden" name="ik_suc_u" value="{$success_url|escape}">
            <input type="hidden" name="ik_ia_u"  value="{$callback_url|escape}">
            <input type="submit" name="process"  value="{$lang->form_to_pay}" class="button">
        </form>
    </div>
{elseif $payment_module == "Liqpay"}
    {* Способ оплаты Liqpay *}
    <div class="row">
        <form class="col-lg-7" method="post" action="https://www.liqpay.ua/api/pay">
            <input type="hidden" name="public_key"  value="{$public_key|escape}"/>
            <input type="hidden" name="amount"      value="{$price|escape}"/>
            <input type="hidden" name="currency"    value="{$payment_currency->code|escape}"/>
            <input type="hidden" name="description" value="{$desc|escape}"/>
            <input type="hidden" name="order_id"    value="{$liqpay_order_id|escape}"/>
            <input type="hidden" name="result_url"  value="{$result_url|escape}"/>
            <input type="hidden" name="server_url"  value="{$server_url|escape}"/>
            <input type="hidden" name="type"        value="buy"/>
            <input type="hidden" name="signature"   value="{$sign|escape}"/>
            <input type="submit" class="button" value="{$lang->form_to_pay}">
        </form>
    </div>
{elseif $payment_module == "OKPay"}
    {* Способ оплаты OKPay *}
    <div class="row">
        <form class="col-lg-7" action="https://www.okpay.com/process.html" method="post">
            <input type="hidden" name="ok_receiver"       value="{$settings_pay['okpay_reciever']|escape}" />
            <input type="hidden" name="ok_invoice"        value="{$order->id|escape}" />
            <input type="hidden" name="ok_item_1_name"    value="{$desc|escape}" />
            <input type="hidden" name="ok_item_1_price"   value="{$price|escape}" />
            <input type="hidden" name="ok_currency"       value="{$currency->code|escape}" />
            <input type="hidden" name="ok_return_success" value="{$return_url|escape}" />
            <input type="hidden" name="ok_return_fail"    value="{$return_url|escape}" />
            <input type="submit" class="button" value="{$lang->form_to_pay}">
        </form>
    </div>
{elseif $payment_module == "Pay2Pay"}
    {* Способ оплаты Pay2Pay *}
    <div class="row">
        <form class="col-lg-7" action="https://merchant.pay2pay.com/?page=init" method="post">
            <input type="hidden" name="xml"  value="{$xml_encoded|escape}"/>
            <input type="hidden" name="sign" value="{$sign_encoded|escape}"/>
            <input type="submit" class="button" value="{$lang->form_to_pay}">
        </form>
    </div>
{elseif $payment_module == "Payanyway"}
    {* Способ оплаты Payanyway *}
    <div class="row">
        <form class="col-lg-7" action="{$url}" method="post">
            <input type="hidden" name="payment_system"     value="{$payment_system[0]|escape}">
            <input type="hidden" name="MNT_ID"             value="{$payment_settings['MNT_ID']|escape}">
            <input type="hidden" name="MNT_TRANSACTION_ID" value="{$order->id|escape}">
            <input type="hidden" name="MNT_AMOUNT"         value="{$price|escape}">
            <input type="hidden" name="MNT_CURRENCY_CODE"  value="{$currency_code|escape}">
            <input type="hidden" name="MNT_SIGNATURE"      value="{$signature|escape}">
            <input type="hidden" name="MNT_SUCCESS_URL"    value="{$success_url|escape}">
            <input type="hidden" name="MNT_FAIL_URL"       value="{$fail_url|escape}">
            <input type="submit" class="button" value="{$lang->form_to_pay}">
        </form>
    </div>
{elseif $payment_module == "Paypal"}
    {* Способ оплаты Paypal *}
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
{elseif $payment_module == "Platon"}
    {* Способ оплаты Platon *}
    <div class="row">
        <form class="col-lg-7" action="https://secure.platononline.com/webpaygw/pcc.php?a=auth" method="post">
            <input type="hidden" name="key"   value="{$settings_pay['platon_key']|escape}"/>
            <input type="hidden" name="order" value="{$order->id|escape}"/>
            <input type="hidden" name="data"  value="{$data|escape}"/>
            <input type="hidden" name="url"   value="{$return_url|escape}"/>
            <input type="hidden" name="sign"  value="{$sign|escape}"/>
            <input type="submit" class="button" value="{$lang->form_to_pay}">
        </form>
    </div>
{elseif $payment_module == "Qiwi"}
    {* Способ оплаты Qiwi *}
    <div class="row">
        <form class="clearfix" action='https://w.qiwi.com/order/external/create.action'>
            <input type="hidden" name="from"       value="{$login|escape}">
            <input type="hidden" name="summ"       value="{$price|escape}">
            <input type="hidden" name="txn_id"     value="{$inv_id|escape}">
            <input type="hidden" name="currency"   value="{$payment_currency->code|escape}">
            <input type="hidden" name="comm"       value="{$inv_desc|escape}">
            <input type="hidden" name="successUrl" value="{$success_url|escape}">
            <input type="hidden" name="failUrl"    value="{$fail_url|escape}">
            <div class="form_group col-xs-12">
                <input class="form_input" type="text" name="to" value="{$phone|escape}" placeholder="{$message}"/>
            </div>
            <div class="form_group col-lg-7">
                <input type="submit" class="button" value="{$lang->form_to_pay}">
            </div>
        </form>
    </div>
{elseif $payment_module == "Receipt"}
    {* Способ оплаты Квитанция *}
    <div class="row">
        <form class="col-lg-7" action="payment/Receipt/callback.php" method="post">
            <input type="hidden" name="recipient"             value="{$payment_settings['recipient']|escape}">
            <input type="hidden" name="inn"                   value="{$payment_settings['inn']|escape}">
            <input type="hidden" name="account"               value="{$payment_settings['account']|escape}">
            <input type="hidden" name="bank"                  value="{$payment_settings['bank']|escape}">
            <input type="hidden" name="bik"                   value="{$payment_settings['bik']|escape}">
            <input type="hidden" name="correspondent_account" value="{$payment_settings['correspondent_account']|escape}">
            <input type="hidden" name="banknote"              value="{$payment_settings['banknote']|escape}">
            <input type="hidden" name="pence"                 value="{$payment_settings['pense']|escape}">
            <input type="hidden" name="order_id"              value="{$order->id|escape}">
            <input type="hidden" name="amount"                value="{$amount|escape}">
            <div class="form_group">
                <input class="form_input" type="text" name="name" value="" placeholder="{$lang->receipt_name}*" required="">
            </div>
            <div class="form_group">
                <input class="form_input" type="text" name="address" value="" placeholder="{$lang->receipt_address}*" required="">
            </div>
            <input class="button" type="submit" value="{$lang->form_to_pay}">
        </form>
    </div>
{elseif $payment_module == "Robokassa"}
    {* Способ оплаты Robokassa *}
    <div class="row">
        <form class="col-lg-7" accept-charset="cp1251" action="https://merchant.roboxchange.com/Index.aspx" method="post">
            <input type="hidden" value="{$mrh_login|escape}" name="MrchLogin">
            <input type="hidden" value="{$price|escape}"     name="OutSum">
            <input type="hidden" value="{$inv_id|escape}"    name="InvId">
            <input type="hidden" value="{$receipt|escape}"   name="Receipt">
            <input type="hidden" value="{$inv_desc|escape}"  name="Desc">
            <input type="hidden" value="{$crc|escape}"       name="SignatureValue">
            <input type="hidden" value="{$in_curr|escape}"   name="IncCurrLabel">
            <input type="hidden" value="{$culture|escape}"   name="Culture">
            <input type="submit" value="{$lang->form_to_pay}" class="button">
        </form>
    </div>
{elseif $payment_module == "Webmoney"}
    {* Способ оплаты Webmoney *}
    <div class="row">
        <form class="col-lg-7" accept-charset="cp1251" method="POST" action="https://merchant.webmoney.ru/lmi/payment.asp">
            <input type="hidden" value="{$amount|escape}" name="LMI_PAYMENT_AMOUNT">
            <input type="hidden" value="{base64_encode("Оплата заказа "+$order->id+"")}" name="LMI_PAYMENT_DESC_BASE64">
            <input type="hidden" value="{$order->id|escape}" name="LMI_PAYMENT_NO">
            <input type="hidden" value="{$payment_settings['purse']|escape}" name="LMI_PAYEE_PURSE">
            <input type="hidden" value="0" name="LMI_SIM_MODE">
            <input type="hidden" value="{$success_url|escape}" name="LMI_SUCCESS_URL">
            <input type="hidden" value="{$fail_url|escape}" name="LMI_FAIL_URL">
            <input type="submit" value="{$lang->form_to_pay}" class="button">
        </form>
    </div>
{elseif $payment_module == "Yandex"}
    {* Способ оплаты Yandex *}
    <div class="row">
        <form class="col-lg-7" method="post" action="https://money.yandex.ru/quickpay/confirm.xml">
            <input name="receiver" type="hidden" value="{$settings_pay['yandex_id']}">
            <input name="formcomment" type="hidden" value="{$desc|escape}">
            <input type="hidden" name="short-dest"    value="{$desc|escape}">
            <input name="targets" type="hidden" value="{$desc|escape}">
            <input type="hidden" name="comment"       value="{$desc|escape}"/>
            <input type="hidden" name="quickpay-form" value="shop">
            <input type="hidden" name="sum"           value="{$price|escape}" data-type="number">
            <input type="hidden" name="label"         value="{$order->id|escape}">
            <input name="paymentType" type="hidden" value="PC">
            <input type="submit" name="submit-button" value="{$lang->form_to_pay}" class="button">
        </form>
    </div>
{/if}