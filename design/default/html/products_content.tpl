{* Список товаров *}
{if $products}
	{foreach $products as $product}
		<div class="col-md-4 col-lg-6 col-xl-4">
			{include file="tiny_products.tpl"}
		</div>
		{if $product@iteration % 3 == 0}<div class="col-xs-12 hidden-sm-down"></div>{/if}
	{/foreach}
{else}
	<span data-language="{$translate_id['products_not_found']}">{$lang->products_not_found}</span>
{/if}