{if $deliveries}
    <div id="ajax_deliveries" class="block">
        <div class="block_heading">{$lang->vyberite_sposob_dostavki}:</div>
        <ul id="deliveries">
        	{foreach $deliveries as $delivery}
        	<li>
    			<input onclick="change_payment_method({$delivery->id})" type="radio" name="delivery_id" value="{$delivery->id}" {if $delivery_id==$delivery->id || $delivery@first}checked=""{/if} id="deliveries_{$delivery->id}"/>
    			<label for="deliveries_{$delivery->id}">
    			{$delivery->name}
    			{if $cart->total_price < $delivery->free_from && $delivery->price>0}
    				({$delivery->price|convert}&nbsp;{$currency->sign})
    			{elseif $cart->total_price >= $delivery->free_from}
    				({$lang->besplatno})
    			{/if}
    			</label>

    			<div class="description">
                    {$delivery->description}
    			</div>
        	</li>
        	{/foreach}
        </ul>
        {foreach $deliveries as $delivery}
            {if $delivery->payment_methods} 
                <div class="delivery_payment" id="delivery_payment_{$delivery->id}" style="display:none">
                    <div class="block_heading">{$lang->vyberite_sposob_oplaty}:</div>
                    <ul id="deliveries">
                        {foreach $delivery->payment_methods as $payment_method}
                            <li>
                                <input type="radio" name="payment_method_id" value="{$payment_method->id}" {if $payment_method@first}checked=""{/if} id="payment_{$delivery->id}_{$payment_method->id}"/>
                                {$total_price_with_delivery = $cart->total_price}
                                {if !$delivery->separate_payment && $cart->total_price < $delivery->free_from}
                                    {$total_price_with_delivery = $cart->total_price + $delivery->price}
                                {/if}
                                <label for="payment_{$delivery->id}_{$payment_method->id}">	{$payment_method->name}, к оплате {$total_price_with_delivery|convert:$payment_method->currency_id}&nbsp;{$all_currencies[$payment_method->currency_id]->sign}</label>
                                <div class="description">
                                    {$payment_method->description}
                                </div>
                            </li>
                        {/foreach}
                    </ul>
                </div>
            {/if}
        {/foreach}
    </div>
{/if}