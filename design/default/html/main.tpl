{* Главная страница магазина *}

{* Для того чтобы обернуть центральный блок в шаблон, отличный от index.tpl *}
{* Укажите нужный шаблон строкой ниже. Это работает и для других модулей *}
{$wrapper = 'index.tpl' scope=parent}

{* Канонический адрес страницы *}
{$canonical="" scope=parent}

{* Рекомендуемые товары *}
<div id="featured_products" class="block">
	
	{get_featured_products var=featured_products limit=3}
	{if $featured_products}
	<!-- Список товаров-->
	<div class="h1">{$lang->rekomenduemye_tovary}</div>
	<ul class="products row">
		{foreach $featured_products as $product}
			{include "product_list.tpl"}
		{/foreach}
	</ul>
	{/if}

</div>

{* Новинки *}
<div id="new_products" class="block">
	{get_new_products var=new_products limit=3}
	{if $new_products}
	<div class="h1">{$lang->novinki}</div>
	<!-- Список товаров-->
	<ul class="products row">
		{foreach $new_products as $product}
			{include "product_list.tpl"}
		{/foreach}
	</ul>
	{/if}	
</div>

{* Акционные товары *}
<div id="discounted_products"  class="block">
	{get_discounted_products var=discounted_products limit=3}
	{if $discounted_products}
	<div class="h1">{$lang->aktsionnye_tovary}</div>
	<!-- Список товаров-->
	<ul class="products row">
		{foreach $discounted_products as $product}
			{include "product_list.tpl"}
		{/foreach}		
	</ul>
	{/if}
</div>


