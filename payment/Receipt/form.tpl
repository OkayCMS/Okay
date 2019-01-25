<form action="payment/Receipt/callback.php" method="post">
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
