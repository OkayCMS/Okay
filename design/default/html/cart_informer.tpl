{* Информер корзины (отдаётся аяксом) *}
{if $cart->total_products > 0}
	<a href="{$lang_link}cart" class="i-cart btn-block link-black pull-xs-right pull-lg-none">
		<span class="h5 font-weight-bold btn-block" data-language="{$translate_id['index_cart']}">{$lang->index_cart}</span>
		<span class="btn-block">{$cart->total_products} {$cart->total_products|plural:$lang->count_products_item:$lang->count_products_goods:$lang->count_products_of_goods}</span>
	</a>
{else}
	<div class="i-cart pull-xs-right pull-lg-none">
		<span class="h5 font-weight-bold btn-block" data-language="{$translate_id['index_cart']}">{$lang->index_cart}</span>
		<span class="btn-block" data-language="{$translate_id['index_empty_cart']}">{$lang->index_empty_cart}</span>
	</div>
{/if}