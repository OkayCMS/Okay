{* Сравнение товаров *}
{* Тайтл страницы *}
{$meta_title = $lang->comparison_title scope=parent}

<div class="container m-b-2">
	{* Хлебные крошки *}
	{include file='breadcrumb.tpl'}

	{* Заголовок страницы *}
	<h1 class="m-b-1"><span data-language="{$translate_id['comparison_header']}">{$lang->comparison_header}</span></h1>

	{if $comparison->products}
		<div class="row">
			<div class="col-lg-3 p-a-0">
				<div class="p-a-0">
					<div class="fn-product fn-resize border-b-1-primary show-container">
						{* Показать скрыть одинаковые характеристики *}
						{if $comparison->products|count > 1}
							<ul class="fn-show okaycms nav nav-tabs">
								<li class="nav-item">
									<a href="#show_all" class="nav-link active" data-language="{$translate_id['comparison_all']}">{$lang->comparison_all}</a>
								</li>
								<li class="nav-item">
									<a href="#show_dif" class="nav-link unique" data-language="{$translate_id['comparison_unique']}">{$lang->comparison_unique}</a>
								</li>
							</ul>
						{/if}
					</div>
					{* Рейтинг товара *}
					<div class="cprs_rating p-y-05 p-x-05" data-use="cprs_rating">
						<span data-language="{$translate_id['product_rating']}">{$lang->product_rating}</span>
					</div>
					{* Названия характеристик *}
					{if $comparison->features}
						{foreach $comparison->features as $id=>$cf}
							<div class="p-y-05 p-x-05 {if $cf@index % 2 == 0 }bg-info {/if}cprs_feature_{$id} cell{if $cf->not_unique} not_unique{/if}" data-use="cprs_feature_{$id}">
								<span data-feature="{$cf->id}">{$cf->name}</span>
							</div>
						{/foreach}
					{/if}
				</div>
			</div>
			<div class="col-lg-9 row fn-comparison_products okaycms" data-products="3">
				{foreach $comparison->products as $id=>$product}
					<div class="col-lg-4 p-a-0">
						{include file="tiny_products.tpl"}
						{* Рейтинг товара *}
						<div id="product_{$product->id}" class="p-y-05 p-x-05 text-xs-left cprs_rating">
							<span class="rating_starOff">
								<span class="rating_starOn" style="width:{$product->rating*90/5|string_format:'%.0f'}px;"></span>
							</span>
						</div>
						{* Характеристики *}
						{if $product->features}
							{foreach $product->features as $id=>$value}
								<div class="p-y-05 p-x-05 {if $value@index % 2 == 0 }bg-info {/if}cprs_feature_{$id} cell{if $comparison->features.{$id}->not_unique} not_unique{/if}">
									{$value|default:"&mdash;"}
								</div>
							{/foreach}
						{/if}
					</div>
				{/foreach}
			</div>
		</div>
	{else}
		<span data-language="{$translate_id['comparison_empty']}">{$lang->comparison_empty}</span>
	{/if}
</div>