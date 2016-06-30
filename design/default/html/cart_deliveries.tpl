{if $deliveries}
	{* Способ доставки *}
    <div class="border-a-1-info p-a-1 m-b-2">
        <div class="h5 i-delivery m-b-1"><span data-language="{$translate_id['cart_delivery']}">{$lang->cart_delivery}</span></div>
        {foreach $deliveries as $delivery}
            <div class="m-l-2">
                <label class="font-weight-bold{if $delivery@first} active{/if}">
	                <input onclick="change_payment_method({$delivery->id})" type="radio" name="delivery_id" value="{$delivery->id}"{if $delivery_id==$delivery->id || $delivery@first} checked{/if} id="deliveries_{$delivery->id}"/>
                    {if $delivery->image}
                        <img src="{$delivery->image|resize:50:50:false:$config->resized_deliveries_dir}"/>
                    {/if}
	                {$delivery->name}
	                {if $cart->total_price < $delivery->free_from && $delivery->price>0}
	                    ({$delivery->price|convert}&nbsp;{$currency->sign})
	                {elseif $cart->total_price >= $delivery->free_from}
	                    <span data-language="{$translate_id['cart_free']}">({$lang->cart_free})</span>
	                {/if}
                </label>
                <div class="m-l-2 delivery-description">
                    {$delivery->description}
                </div>
            </div>
        {/foreach}
    </div>

	{* Способ оплаты *}
	{foreach $deliveries as $delivery}
		{if $delivery->payment_methods}
			<div class="fn-delivery_payment border-a-1-info p-a-1" id="fn-delivery_payment_{$delivery->id}"{if $delivery@iteration != 1} style="display:none"{/if}>
				<div class="h5 i-payment m-b-1"><span data-language="{$translate_id['cart_payment']}">{$lang->cart_payment}</span></div>
				{foreach $delivery->payment_methods as $payment_method}
					<div class="m-l-2">
						<label class="font-weight-bold{if $payment_method@first} active{/if}">
							<input type="radio" name="payment_method_id" value="{$payment_method->id}"{if $delivery@first && $payment_method@first} checked{/if} id="payment_{$delivery->id}_{$payment_method->id}"/>
                            {if $payment_method->image}
                                <img src="{$payment_method->image|resize:50:50:false:$config->resized_payments_dir}"/>
                            {/if}
							{$total_price_with_delivery = $cart->total_price}
							{if !$delivery->separate_payment && $cart->total_price < $delivery->free_from}
								{$total_price_with_delivery = $cart->total_price + $delivery->price}
							{/if}
							{$payment_method->name} {$lang->cart_deliveries_to_pay} {$total_price_with_delivery|convert:$payment_method->currency_id}&nbsp;{$all_currencies[$payment_method->currency_id]->sign}
						</label>
						<div class="m-l-2 payment-description">
							{$payment_method->description}
						</div>
					</div>
				{/foreach}
			</div>
		{/if}
	{/foreach}
{/if}