{* Список товаров *}
{foreach $products as $product}
	<div class="col-md-4">
		{include file="tiny_products.tpl"}
	</div>
{/foreach}