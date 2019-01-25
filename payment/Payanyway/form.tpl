<form action="{$url}" method="post">
    <input type="hidden" name="payment_system"      value="{$payment_system[0]|escape}">
    <input type="hidden" name="MNT_ID"              value="{$payment_settings["MNT_ID"]|escape}">
    <input type="hidden" name="MNT_TRANSACTION_ID"  value="{$order->id|escape}">
    <input type="hidden" name="MNT_AMOUNT"          value="{$price|escape}">
    <input type="hidden" name="MNT_CURRENCY_CODE"   value="{$currency_code|escape}">
    <input type="hidden" name="MNT_SIGNATURE"       value="{$signature|escape}">
    <input type="hidden" name="MNT_SUCCESS_URL"     value="{$success_url|escape}">
    <input type="hidden" name="MNT_FAIL_URL"        value="{$fail_url|escape}">

    {if $payment_system[0] !== "payanyway"}
        <input type=hidden name=followup            value="true">
        <input type=hidden name=javascriptEnabled   value="true">
    {/if}
    {if !empty($payment_system[2])}
        <input type=hidden name=paymentSystem.unitId value="{$payment_system[2]|escape}">
    {/if}

    {if isset($payment_system[4])}
        {*for old version*}
        {if !empty($payment_system[4])}
            <input type=hidden name=paymentSystem.accountId value="{$payment_system[4]|escape}">
        {/if}
    {else}
        {*new version*}
        {if !empty($payment_system[3])}
            <input type=hidden name=paymentSystem.accountId value="{$payment_system[3]|escape}">
        {/if}
    {/if}

    {if $payment_system[0] == "post"}
        <div class="form_group">
            <label class="label_block">Индекс отправителя</label>
            <input class="form_input" type=text name="additionalParameters.mailofrussiaSenderIndex" value="">
        </div>
        <div class="form_group">
            <label class="label_block">Регион (или город федерального значения) отправителя</label>
            <input class="form_input" type=text name="additionalParameters.mailofrussiaSenderRegion" value="">
        </div>
        <div class="form_group">
            <label class="label_block">Адрес отправителя</label>
            <input class="form_input" type=text name="additionalParameters.mailofrussiaSenderAddress" value="">
        </div>
        <div class="form_group">
            <label class="label_block">Имя отправителя</label>
            <input class="form_input" type=text name="additionalParameters.mailofrussiaSenderName" value="">
        </div>
    {elseif $payment_system[0] == "webmoney"}
        <div class="form_group">
            <label class="label_block">Источник оплаты</label>
            <select name="paymentSystem.accountId" class="form_select">
                <option value="2">WMR</option>
                <option value="3">WMZ</option>
                <option value="4">WME</option>
            </select>
        </div>
    {elseif $payment_system[0] == "moneymail"}
        <div class="form_group">
            <label class="label_block">E-mail в MoneyMail</label>
            <input class="form_input" type="text" name="additionalParameters.buyerEmail" data-format="email" data-notice="Введите email" value="">
        </div>
    {elseif $payment_system[0] == "euroset"}
        <div class="form_group">
            <label class="label_block">Номер телефона</label>
            <input class="form_input" type="text" name="additionalParameters.rapidaPhone" data-format="{literal}(\+)(7)(\d){10,20}{/literal}" data-notice="Введите номер телефона в формате +71234567890" value="">
        </div>
    {elseif $payment_system[0] == "dengimail"}
        <div class="form_group">
            <label class="label_block">E-mail в системе Деньги@Mail.Ru</label>
            <input class="form_input" type="text" name="additionalParameters.dmrBuyerEmail" data-format="email" data-notice="Введите email" value="">
        </div>
    {elseif $payment_system[0] == "alfaclick"}
        <div class="form_group">
            <label class="label_block">Логин в интернет-банке</label>
            <input class="form_input" type="text" name="additionalParameters.alfaIdClient" value="">
        </div>
        <div class="form_group">
            <label class="label_block">Назначение платежа</label>
            <input class="form_input" type="text" name="additionalParameters.alfaPaymentPurpose" value="PayAnyWay invoice">
        </div>
    {elseif $payment_system[0] == "mts"}
        <div class="form_group">
            <label class="label_block">Номер телефона</label>
            <input class="form_input" type="text" name="additionalParameters.smsmsPhone" data-format="{literal}(7)(\d){10}{/literal}" data-notice="Введите номер телефона в формате: 71234567890" value="">
        </div>
    {elseif $payment_system[0] == "qiwi"}
        <div class="form_group">
            <label class="label_block">Номер телефона</label>
            <input class="form_input" type="text" name="additionalParameters.qiwiUser" value="" data-format="{literal}(\d){10}{/literal}" data-notice="Номер телефона вводится без \"8\"">
        </div>
        <div class="form_group">
            <label class="label_block">Комментарий</label>
            <input class="form_input" type="text" name="additionalParameters.qiwiComment" value="">
        </div>
    {/if}

    <input type="submit" class="button" value="{$lang->form_to_pay}">
</form>
