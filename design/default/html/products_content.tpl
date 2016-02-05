{* Список товаров *}
{foreach $products as $product}
	<div class="col-md-4 col-lg-6 col-xl-4">
		{include file="tiny_products.tpl"}
	</div>
	{if $product@iteration % 2 == 0}<div class="col-xs-12 hidden-md-down hidden-xl-up"></div>{/if}
	{if $product@iteration % 3 == 0}<div class="col-xs-12 hidden-sm-down hidden-md-up"></div>{/if}
{/foreach}