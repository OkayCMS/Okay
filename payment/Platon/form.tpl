<form action="https://secure.platononline.com/webpaygw/pcc.php?a=auth" method="post">
    <input type="hidden" name="key"     value="{$settings_pay['platon_key']|escape}"/>
    <input type="hidden" name="order"   value="{$order->id|escape}"/>
    <input type="hidden" name="data"    value="{$data|escape}"/>
    <input type="hidden" name="url"     value="{$return_url|escape}"/>
    <input type="hidden" name="sign"    value="{$sign|escape}"/>
    <input type="submit" class="button" value="{$lang->form_to_pay}">
</form>
