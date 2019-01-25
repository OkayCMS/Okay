<form name="payment" method="post" action="https://sci.interkassa.com/" accept-charset="UTF-8">
    <input type="hidden" name="ik_co_id" value="{$settings_pay['ik_co_id']|escape}">
    <input type="hidden" name="ik_pm_no" value="{$order->id|escape}">
    <input type="hidden" name="ik_cur"   value="{$payment_currency->code|escape}">
    <input type="hidden" name="ik_am"    value="{$price|escape}">
    <input type="hidden" name="ik_desc"  value="{$desc|escape}">
    <input type="hidden" name="ik_suc_u" value="{$success_url|escape}">
    <input type="hidden" name="ik_ia_u"  value="{$callback_url|escape}">
    <input type="submit" name="process"  value="{$lang->form_to_pay}" class="button">
</form>
