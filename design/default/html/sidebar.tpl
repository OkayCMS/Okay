<nav id="catalog_menu" class="block">
	<span class="block_heading">{$lang->katalog_tovarov}</span>

	<!-- Меню каталога -->	
	{* Рекурсивная функция вывода дерева категорий *}
	{function name=categories_tree}
	{if $categories}
	<ul>
	{foreach $categories as $c}
		{* Показываем только видимые категории *}
		{if $c->visible}
			{if $c->children|count > 1}
				<li class="parent {if $category->id == $c->id} opened{/if}">
					<a {if $category->id == $c->id}class="selected"{/if} href="{$lang_link}catalog/{$c->url}" data-category="{$c->id}">{$c->name|escape}</a>
					<span class="switch {if $category->id == $c->id} active{/if}"></span>
					<div class="submenu">{categories_tree categories=$c->subcategories}</div>
				</li>
			{else}
				<li>
					<a {if $category->id == $c->id}class="selected"{/if} href="{$lang_link}catalog/{$c->url}" data-category="{$c->id}">{$c->name|escape}</a>
				</li>
			{/if}
		{/if}
	{/foreach}
	</ul>
	{/if}
	{/function}
	{categories_tree categories=$categories}
	<!-- Меню каталога (The End)-->		
</nav>

<!-- Фильтры -->
{if $module == 'ProductsView'}
	
	{include "features.tpl"}
	
{/if}			
<!-- Фильтры (The End) -->		

<!-- Просмотренные товары -->
{get_browsed_products var=browsed_products limit=9}
{if $browsed_products}
<div class="block">
	<div class="block_heading">{$lang->vy_prosmatrivali}</div>
	<ul id="browsed_products">
	{foreach $browsed_products as $browsed_product}
		<li>
		<a href="{$lang_link}products/{$browsed_product->url}"><img src="{$browsed_product->image->filename|resize:60:60}" alt="{$browsed_product->name|escape}" title="{$browsed_product->name|escape}"></a>
		</li>
	{/foreach}
	</ul>
</div>
{/if}
<!-- Просмотренные товары (The End)-->



{* Сравнение *}
<div id="comparison_anim" class="block_heading">{$lang->papka_sravneniya}</div>
<div id="comparison_informer" class="block">
	{include "comparison_informer.tpl"}
</div>
