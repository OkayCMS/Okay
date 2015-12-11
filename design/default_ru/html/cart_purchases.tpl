<table id="purchases">
    {foreach $cart->purchases as $purchase}
        <tr>
        	<td class="image">
        		{$image = $purchase->product->images|first}
        		{if $image}
        		<a href="{$lang_link}products/{$purchase->product->url}"><img src="{$image->filename|resize:50:50}" alt="{$product->name|escape}"></a>
        		{/if}
        	</td>
        	
        	<td class="name">
        		<a href="{$lang_link}products/{$purchase->product->url}">{$purchase->product->name|escape}</a>
        		{$purchase->variant->name|escape}			
        	</td>
            
        	<td class="price">
        		{($purchase->variant->price)|convert} {$currency->sign}
        	</td>
            
        	<td class="amount">
                <div id="cart_amount">
        			<span class="minus"> &#8722; </span>
        			<input class="amounts" name="amounts[{$purchase->variant->id}]" value="{$purchase->amount}" onchange="ajax_change_amount(this, {$purchase->variant->id});" max="{$max_stock}" />
        			<span class="plus"> + </span>
                </div> 
        	</td>
            
        	<td class="price">
        		{($purchase->variant->price*$purchase->amount)|convert}&nbsp;{$currency->sign}
        	</td>
        	
        	<td class="remove">
        		<a href="{$lang_link}cart/remove/{$purchase->variant->id}" onclick="ajax_remove(this, {$purchase->variant->id});return false;" title="Удалить из корзины">
        			<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="20" height="20" viewBox="0 0 20 20">
        				<path fill="currentColor" d="M10 18.125c-4.487 0-8.125-3.637-8.125-8.125s3.638-8.125 8.125-8.125 8.125 3.638 8.125 8.125-3.637 8.125-8.125 8.125zM10 3.75c-3.451 0-6.25 2.799-6.25 6.25s2.799 6.25 6.25 6.25c3.452 0 6.25-2.799 6.25-6.25s-2.798-6.25-6.25-6.25zM12.836 12.209l-0.634 0.634c-0.116 0.116-0.305 0.116-0.422 0l-1.794-1.794-1.794 1.794c-0.117 0.116-0.305 0.116-0.422 0l-0.634-0.634c-0.116-0.116-0.116-0.305 0-0.422l1.794-1.793-1.794-1.794c-0.116-0.117-0.116-0.306 0-0.422l0.634-0.633c0.117-0.117 0.305-0.117 0.422 0l1.794 1.794 1.794-1.794c0.117-0.117 0.306-0.117 0.422 0l0.634 0.633c0.116 0.117 0.116 0.306 0 0.422l-1.794 1.794 1.794 1.793c0.116 0.117 0.116 0.306 0 0.422z"></path>
        			</svg>
        		</a>
        	</td>
        			
        </tr>
    {/foreach}
    
    {if $user->discount}
        <tr class="bonus">
        	<td colspan="4" class="name">Скидка</td>
        	<td class="price">
        		{$user->discount}&nbsp;%
        	</td>
        	<td class="remove"></td>
        </tr>
    {/if}
    
    {if $coupon_request}
        <tr class="coupon">
        	<td class="name" colspan="4">
        		{if $coupon_error}
            		<div class="message_error">
            			{if $coupon_error == 'invalid'}Купон недействителен{/if}
            		</div>
        		{/if}
        		<input type="text" name="coupon_code" value="{$cart->coupon->code|escape}" class="coupon_code" placeholder="Код купона"/>
        		{if $cart->coupon->min_order_price>0}(Купон {$cart->coupon->code|escape} действует для заказов от {$cart->coupon->min_order_price|convert} {$currency->sign}){/if}
        		<input class="button" type="button" name="apply_coupon"  value="Применить купон" onclick="ajax_coupon();"/>
        	</td>
        	<td class="price">
        		{if $cart->coupon_discount>0}
        		&minus;{$cart->coupon_discount|convert}&nbsp;{$currency->sign}
        		{/if}
        	</td>
        	<td class="remove"></td>
        </tr>
        
        {literal}
        <script>
        $("input[name='coupon_code']").keypress(function(event){
        	if(event.keyCode == 13){
        		$("input[name='name']").attr('data-format', '');
        		$("input[name='email']").attr('data-format', '');
        		document.cart.submit();
        	}
        });
        </script>
        {/literal}
    {/if}
    
    <tr class="total">
    	<td colspan="6">
		    Итого:
    		<span>{$cart->total_price|convert}&nbsp;{$currency->sign}</span>
    	</td>
    </tr>
</table>