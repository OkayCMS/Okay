<form accept-charset="cp1251" method="POST" action="https://merchant.webmoney.ru/lmi/payment.asp">
    <input type="hidden" name="LMI_PAYMENT_AMOUNT"      value="{$amount|escape}" >
    <input type="hidden" name="LMI_PAYMENT_DESC_BASE64" value="{base64_encode("Оплата заказа "+$order->id+"")}" >
    <input type="hidden" name="LMI_PAYMENT_NO"          value="{$order->id|escape}" >
    <input type="hidden" name="LMI_PAYEE_PURSE"         value="{$payment_settings['purse']|escape}" >
    <input type="hidden" name="LMI_SIM_MODE"            value="0" >
    <input type="hidden" name="LMI_SUCCESS_URL"         value="{$success_url|escape}" >
    <input type="hidden" name="LMI_FAIL_URL"            value="{$fail_url|escape}" >
    <input type="submit" value="{$lang->form_to_pay}"   class="button" >
</form>
