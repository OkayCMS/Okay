{* Каталог товаров *}
{* Канонический адрес страницы *}
{if $set_canonical}
	{if $category}
		{$canonical="/catalog/{$category->url}" scope=parent}
	{elseif $brand}
		{$canonical="/brands/{$brand->url}" scope=parent}
    {elseif $page->url=='discounted'}
        {$canonical="/discounted" scope=parent}
    {elseif $page->url=='bestsellers'}
        {$canonical="/bestsellers" scope=parent}
	{elseif $keyword}
		{$canonical="/all-products" scope=parent}
	{else}
		{$canonical="/all-products" scope=parent}
	{/if}
{/if}

<div class="container">
	<div class="row">
		{* Фильтр, список категорий и брендов *}
		<div class="col-lg-3">
			{include "features.tpl"}
		</div>

		<div class="col-lg-9">
			{* Хлебные крошки *}
			{include file='breadcrumb.tpl'}

			{* Заголовок страницы *}
			{if $keyword}
				<h1><span data-language="{$translate_id['products_search']}">{$lang->products_search}</span> {$keyword|escape}</h1>
			{elseif $page}
				<h1>
					<span data-page="{$page->id}">{$page->name|escape}</span>
				</h1>
			{else}
				<h1><span data-category="{$category->id}">{if $category->name_h1|escape}{$category->name_h1|escape}{else}{$category->name|escape}{/if}</span> {$brand->name|escape} {$filter_meta->h1|escape}</h1>
			{/if}

			{if $current_page_num == 1}
				{* Краткое описание категории *}
				{$category->annotation}

				{* Краткое описание бренда *}
				{$brand->annotation}
			{/if}
			{if $products}
				{* Сортировка товаров *}
				<div id="fn-products_sort">
					{include file="products_sort.tpl"}
				</div>
			{/if}
				{* Список товаров *}
				<div id="fn-products_content" class="row">
					{include file="products_content.tpl"}
				</div>

			{if $products}
				{* ЧПУ пагинация *}
				<div class="shpu_pagination">
					{include file='chpu_pagination.tpl'}
				</div>
			{/if}
			{* Описание страницы (если задана) *}
			{$page->body}

			{if $current_page_num == 1 && (!$category || !$brand)}
				{* Описание категории *}
				{$category->description}

				{* Описание бренда *}
				{$brand->description}
			{/if}
		</div>
	</div>
</div>