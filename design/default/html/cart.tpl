{* Шаблон корзины *}

{$meta_title = $lang->korzina scope=parent}

<h1 class="h1">
{if $cart->purchases}{$lang->v_korzine} {$cart->total_products} {$cart->total_products|plural:$lang->tovar:$lang->tovarov:$lang->tovara}
{else}{$lang->cartinfo_empty}{/if}
</h1>

{if $cart->purchases}
<form method="post" name="cart">

	{* Список покупок *}
	{include file='cart_purchases.tpl'}

	{* Доставка *}
	{include file='cart_deliveries.tpl'}
	    
	<div class="block_heading">{$lang->adres_poluchatelya}</div>
		
	<div class="cart_form block">         
		{if $error}
		<div class="message_error">
			{if $error == 'empty_name'}{$lang->vvedite_imya}{/if}
			{if $error == 'empty_email'}{$lang->vvedite_email}{/if}
			{if $error == 'captcha'}{$lang->kapcha_vvedena_neverno}{/if}
		</div>
		{/if}

		<div class="row">
			<div class="column col_6">
				<div class="form_group">
					<label>{$lang->vvedite_imya}*</label>
					<input class="form_input" name="name" type="text" value="{$name|escape}" data-format=".+" data-notice="{$lang->vvedite_imya}"/>
				</div>
				<div class="form_group">
					<label>{$lang->vvedite_nomer_telefona}</label>
					<input class="form_input" name="phone" type="text" value="{$phone|escape}"/>
				</div>
			</div>

			<div class="column col_6">
				<div class="form_group">
					<label>{$lang->vvedite_email}*</label>
					<input class="form_input" name="email" type="text" value="{$email|escape}" data-format="email" data-notice="{$lang->vvedite_email}"/>
				</div>
				<div class="form_group">
					<label>{$lang->adres_dostavki}</label>
					<input class="form_input" name="address" type="text" value="{$address|escape}"/>
				</div>
			</div>
		</div>

		<label>{$lang->kommentarij_k_zakazu}</label>
		<textarea name="comment" id="order_comment">{$comment|escape}</textarea>
		
		<div class="captcha">
			<img src="captcha/image.php?{math equation='rand(10,10000)'}" alt='captcha'/>
			<input class="input_captcha" id="comment_captcha" type="text" name="captcha_code" value="" data-format="\d\d\d\d" data-notice="{$lang->vvedite_kapchu}" placeholder="{$lang->vvedite_kapchu}"/>
		</div> 
		
		<input type="submit" name="checkout" class="button" value="{$lang->oformit_zakaz}">
	</div>
   
</form>

<script>
    $(document).ready(function() {
        $('[name="delivery_id"]').first().click();
    });
    
    function change_payment_method($id) {
        $("#delivery_payment_"+$id+" [name='payment_method_id']").first().attr('checked','checked');
        $(".delivery_payment").css("display","none");
        $("#delivery_payment_"+$id).css("display","block");
    }
</script>

{else}
	{$lang->cartinfo_empty}
{/if}