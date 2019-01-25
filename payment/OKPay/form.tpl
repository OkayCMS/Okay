<form action="https://www.okpay.com/process.html" method="post">
    <input type="hidden" name="ok_receiver"         value="{$settings_pay['okpay_reciever']|escape}" />
    <input type="hidden" name="ok_invoice"          value="{$order->id|escape}" />
    <input type="hidden" name="ok_item_1_name"      value="{$desc|escape}" />
    <input type="hidden" name="ok_item_1_price"     value="{$price|escape}" />
    <input type="hidden" name="ok_currency"         value="{$currency->code|escape}" />
    <input type="hidden" name="ok_return_success"   value="{$return_url|escape}" />
    <input type="hidden" name="ok_return_fail"      value="{$return_url|escape}" />
    <input type="submit" class="button"             value="{$lang->form_to_pay}">
</form>
