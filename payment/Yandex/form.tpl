<form method="post" action="https://money.yandex.ru/quickpay/confirm.xml">
    <input type="hidden" name="receiver"        value="{$settings_pay['yandex_id']}">
    <input type="hidden" name="formcomment"     value="{$desc|escape}">
    <input type="hidden" name="short-dest"      value="{$desc|escape}">
    <input type="hidden" name="targets"         value="{$desc|escape}">
    <input type="hidden" name="comment"         value="{$desc|escape}"/>
    <input type="hidden" name="quickpay-form"   value="shop">
    <input type="hidden" name="sum"             value="{$price|escape}" data-type="number">
    <input type="hidden" name="label"           value="{$order->id|escape}">
    <input type="hidden" name="paymentType"     value="PC">
    <input type="submit" name="submit-button"   value="{$lang->form_to_pay}" class="button">
</form>
