<form method="post" action="https://www.liqpay.ua/api/pay">
    <input type="hidden" name="public_key"  value="{$public_key|escape}"/>
    <input type="hidden" name="amount"      value="{$price|escape}"/>
    <input type="hidden" name="currency"    value="{$payment_currency->code|escape}"/>
    <input type="hidden" name="description" value="{$desc|escape}"/>
    <input type="hidden" name="order_id"    value="{$liqpay_order_id|escape}"/>
    <input type="hidden" name="result_url"  value="{$result_url|escape}"/>
    <input type="hidden" name="server_url"  value="{$server_url|escape}"/>
    <input type="hidden" name="type"        value="buy"/>
    <input type="hidden" name="signature"   value="{$sign|escape}"/>
    <input type="submit" class="button"     value="{$lang->form_to_pay}">
</form>
