<form class="clearfix" action='https://w.qiwi.com/order/external/create.action'>
    <input type="hidden" name="from"        value="{$login|escape}">
    <input type="hidden" name="summ"        value="{$price|escape}">
    <input type="hidden" name="txn_id"      value="{$inv_id|escape}">
    <input type="hidden" name="currency"    value="{$payment_currency->code|escape}">
    <input type="hidden" name="comm"        value="{$inv_desc|escape}">
    <input type="hidden" name="successUrl"  value="{$success_url|escape}">
    <input type="hidden" name="failUrl"     value="{$fail_url|escape}">
    <div class="form_group">
        <input class="form_input" type="text" name="to" value="{$phone|escape}" placeholder="{$message}"/>
    </div>
    <input type="submit" class="button"     value="{$lang->form_to_pay}">
</form>
