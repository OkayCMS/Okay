{* Шаблон корзины *}

{$meta_title = 'Корзина' scope=parent}

<h1 class="h1">
{if $cart->purchases}В корзине {$cart->total_products} {$cart->total_products|plural:'товар':'товаров':'товара'}
{else}Корзина пуста{/if}
</h1>

{if $cart->purchases}
<form method="post" name="cart">

	{* Список покупок *}
	{include file='cart_purchases.tpl'}

	{* Доставка *}
	{include file='cart_deliveries.tpl'}
	    
	<div class="block_heading">Адрес получателя</div>
		
	<div class="cart_form block">         
		{if $error}
		<div class="message_error">
			{if $error == 'empty_name'}Введите имя{/if}
			{if $error == 'empty_email'}Введите email{/if}
			{if $error == 'captcha'}Капча введена неверно{/if}
		</div>
		{/if}

		<div class="row">
			<div class="column col_6">
				<div class="form_group">
					<label>Введите имя*</label>
					<input class="form_input" name="name" type="text" value="{$name|escape}" data-format=".+" data-notice="Введите имя"/>
				</div>
				<div class="form_group">
					<label>Введите № телефона</label>
					<input class="form_input" name="phone" type="text" value="{$phone|escape}"/>
				</div>
			</div>

			<div class="column col_6">
				<div class="form_group">
					<label>Введите email*</label>
					<input class="form_input" name="email" type="text" value="{$email|escape}" data-format="email" data-notice="Введите email"/>
				</div>
				<div class="form_group">
					<label>Адрес доставки</label>
					<input class="form_input" name="address" type="text" value="{$address|escape}"/>
				</div>
			</div>
		</div>

		<label>Комментарий к заказу</label>
		<textarea name="comment" id="order_comment">{$comment|escape}</textarea>
		
		<div class="captcha">
			<img src="captcha/image.php?{math equation='rand(10,10000)'}" alt='captcha'/>
			<input class="input_captcha" id="comment_captcha" type="text" name="captcha_code" value="" data-format="\d\d\d\d" data-notice="Введите капчу" placeholder="Введите капчу"/>
		</div> 
		
		<input type="submit" name="checkout" class="button" value="Оформить заказ">
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
	Корзина пуста
{/if}