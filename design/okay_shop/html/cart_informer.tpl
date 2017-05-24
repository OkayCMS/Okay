{* Cart informer (given by Ajax) *}
{if $cart->total_products > 0}
    <a href="{$lang_link}cart" class="cart_info">
        <span class="cart_counter">{$cart->total_products}</span>
        <span class="cart_title" data-language="index_cart">{$lang->index_cart}</span>
         <span class="cart_total">{($cart->total_price)|convert} {$currency->sign|escape}</span>
    </a>
{else}
    <div class="cart_info">
        <span class="cart_counter">{$cart->total_products}</span>
        <span class="cart_title" data-language="index_cart">{$lang->index_cart}</span>
        <span class="cart_total">{($cart->total_price)|convert} {$currency->sign|escape}</span>
    </div>
{/if}
