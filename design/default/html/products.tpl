{* Каталог товаров *}
{* Канонический адрес страницы *}
{if $set_canonical}
	{if $category && $brand}
		{$canonical="/catalog/{$category->url}/{$brand->url}" scope=parent}
	{elseif $category}
		{$canonical="/catalog/{$category->url}" scope=parent}
	{elseif $brand}
		{$canonical="/brands/{$brand->url}" scope=parent}
	{elseif $keyword}
		{$canonical="/products?keyword={$keyword|escape}" scope=parent}
	{else}
		{$canonical="/products" scope=parent}
	{/if}
{/if}
{* @END Канонический адрес страницы *}
<div class="container">
	<div class="row">
		{* Фильт, список категорий и брендов *}
		<div class="col-lg-3">
			{include "features.tpl"}
		</div>
		{* @END Фильт, список категорий и брендов *}
		<div class="col-lg-9">
			{* Хлебные крошки *}
			{include file='breadcrumb.tpl'}
			{* @END Хлебные крошки *}
			{* Заголовок страницы *}
			{if $keyword}
				<h1><span data-language="{$translate_id['products_search']}">{$lang->products_search}</span> {$keyword|escape}</h1>
			{elseif $page}
				<h1>
					<span data-page="{$page->id}">{$page->name|escape}</span>
				</h1>
			{else}
				<h1><span data-category="{$category->id}">{$category->name|escape}</span> {$brand->name|escape} {$filter_meta->h1|escape}</h1>
			{/if}
			{* @END Заголовок страницы *}
			{if $current_page_num == 1}
				{* Краткое описание категории *}
				{$category->annotation}
				{* @END Краткое описание категории *}
				{* Краткое описание бренда *}
				{$brand->annotation}
				{* @END Краткое описание бренда *}
			{/if}
			{if $products}
				{* Сортировка товаров *}
				{if $products|count > 0}
					<div class="sort">
						<span data-language="{$translate_id['products_sort_by']}">{$lang->products_sort_by}</span>:
						<a {if $sort=='position'} class="active_up"{/if} href="{furl sort=position page=null}" data-language="{$translate_id['products_by_default']}">{$lang->products_by_default}</a>
						<a {if $sort=='price'} class="active_up" {elseif $sort=='price_asc'}class="active_down"{/if} {if $sort=='price'}href="{furl sort=price_asc page=null}" {else}href="{furl sort=price page=null}"{/if} data-language="{$translate_id['products_by_price']}">{$lang->products_by_price}</a>
						<a {if $sort=='name'} class="active_up" {elseif $sort=='name_desc'}class="active_down"{/if} {if $sort=='name'}href="{furl sort=name_desc page=null}" {else}href="{furl sort=name page=null}{/if}" data-language="{$translate_id['products_by_name']}">{$lang->products_by_name}</a>
					</div>
				{/if}
				{* @END Сортировка товаров *}
				{* Список товаров *}
				<div id="fn-products_content" class="row">
					{include file="products_content.tpl"}
				</div>
				{* @END Список товаров *}
				{* ЧПУ пагинация *}
				<div class="shpu_pagination">
					{include file='chpu_pagination.tpl'}
				</div>
				{* ЧПУ пагинация *}
			{else}
				<span data-language="{$translate_id['products_not_found']}">{$lang->products_not_found}</span>
			{/if}
			{* Описание страницы (если задана) *}
			{$page->body}
			{* @END Описание страницы (если задана) *}
			{if $current_page_num == 1}
				{* Описание категории *}
				{$category->description}
				{* @END Описание категории *}
				{* Описание бренда *}
				{$brand->description}
				{* @END Описание бренда *}
			{/if}
		</div>
	</div>
</div>