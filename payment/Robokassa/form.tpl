<form accept-charset="cp1251" action="https://merchant.roboxchange.com/Index.aspx" method="post">
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
