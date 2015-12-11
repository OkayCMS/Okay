{* Информер корзины (отдаётся аяксом) *}

{if $cart->total_products>0}
	<a class="cart_info" href="{$lang_link}cart/"><span>{$cart->total_products} {$cart->total_products|plural:'товар':'товаров':'товара'}</span></a>
{else}
	<span class="cart_info"><span>Корзина пуста</span></span>
{/if}