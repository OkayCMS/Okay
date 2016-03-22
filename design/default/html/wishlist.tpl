{* Тайтл страницы *}
{$meta_title = $lang->wishlist_title scope=parent}
{* @END Тайтл страницы *}
<div class="container">
	{* Хлебные крошки *}
	{include file='breadcrumb.tpl'}
	{* @END Хлебные крошки *}
	{* Заголовок страницы *}
	<h1 class="m-b-1">
		<span data-language="{$translate_id['wishlist_header']}">{$lang->wishlist_header}</span>
	</h1>
	{* @END Заголовок страницы *}
	{* Тело страницы *}
	{$page->body}
	{* @END Тело страницы *}
	{if $wished_products|count}
		<div class="row fn-wishlist-page">
			{* Список избранных товаров *}
			{foreach $wished_products as $product}
				<div class="col-md-4 col-lg-3">
					{include "tiny_products.tpl"}
				</div>
			{/foreach}
			{* @END Список избранных товаров *}
		</div>
	{else}
		<div class="m-b-1">
			<span data-language="{$translate_id['wishlist_empty']}">{$lang->wishlist_empty}</span>
		</div>
	{/if}
</div>