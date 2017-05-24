{if $deliveries}
    {* Delivery *}
    <div class="h2">
        <span data-language="cart_delivery">{$lang->cart_delivery}</span>
    </div>

    <div class="delivery padding block">
        {foreach $deliveries as $delivery}
            <div class="delivery_item">

                <label class="delivery_label{if $delivery@first} active{/if}" for="deliveries_{$delivery->id}">

                    <input class="input_delivery" id="deliveries_{$delivery->id}" onclick="change_payment_method({$delivery->id})" type="radio" name="delivery_id" value="{$delivery->id}" {if $delivery_id==$delivery->id || $delivery@first} checked{/if} />

                    <span class="delivery_name">
                        {if $delivery->image}
                            <img src="{$delivery->image|resize:50:50:false:$config->resized_deliveries_dir}" />
                        {/if}

                        {$delivery->name|escape}

                        {if $cart->total_price < $delivery->free_from && $delivery->price>0 && !$delivery->separate_payment}
                            <span class="nowrap">({$delivery->price|convert} {$currency->sign|escape})</span>
                        {elseif $delivery->separate_payment}
                            <span data-language="cart_free">({$lang->cart_paid_separate})</span>
                        {elseif $cart->total_price >= $delivery->free_from && !$delivery->separate_payment}
                            <span data-language="cart_free">({$lang->cart_free})</span>
                        {/if}
                    </span>
                </label>

                <div class="delivery_description">
                    {$delivery->description}
                </div>
            </div>
        {/foreach}
    </div>
    
    
    {* Payment methods *}
    {foreach $deliveries as $delivery}
        {if $delivery->payment_methods}
            <div class="fn_delivery_payment" id="fn_delivery_payment_{$delivery->id}"{if $delivery@iteration != 1} style="display:none"{/if}>

                <div class="h2"><span data-language="cart_payment">{$lang->cart_payment}</span></div>

                <div class="delivery block padding">
                    {foreach $delivery->payment_methods as $payment_method}
                        <div class="delivery_item">

                            <label class="delivery_label{if $payment_method@first} active{/if}" for="payment_{$delivery->id}_{$payment_method->id}">

                                <input class="input_delivery" id="payment_{$delivery->id}_{$payment_method->id}" type="radio" name="payment_method_id" value="{$payment_method->id}"{if $delivery@first && $payment_method@first} checked{/if} />

                                <span class="delivery_name">
                                    {if $payment_method->image}
                                        <img src="{$payment_method->image|resize:50:50:false:$config->resized_payments_dir}" />
                                    {/if}

                                    {$total_price_with_delivery = $cart->total_price}
                                    {if !$delivery->separate_payment && $cart->total_price < $delivery->free_from}
                                        {$total_price_with_delivery = $cart->total_price + $delivery->price}
                                    {/if}

                                    {$payment_method->name|escape} {$lang->cart_deliveries_to_pay}
                                    <span class="nowrap">{$total_price_with_delivery|convert:$payment_method->currency_id} {$all_currencies[$payment_method->currency_id]->sign|escape}</span>
                                </span>
                            </label>
                            <div class="delivery_description">
                                {$payment_method->description}
                            </div>
                        </div>
                    {/foreach}
                </div>
            </div>
        {/if}
    {/foreach}    
{/if}
