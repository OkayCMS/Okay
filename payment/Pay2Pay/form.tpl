<form action="https://merchant.pay2pay.com/?page=init" method="post">
    <input type="hidden" name="xml"     value="{$xml_encoded|escape}"/>
    <input type="hidden" name="sign"    value="{$sign_encoded|escape}"/>
    <input type="submit" class="button" value="{$lang->form_to_pay}">
</form>
