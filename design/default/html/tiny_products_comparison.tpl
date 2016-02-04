{* Превью товара *}
<div class="fn-product fn-resize card fixed border-b-1-primary">
	<div class="card-block fn-transfer">
		{* Изображение товара *}
		<a class="fn-zoom okaycms card-image m-b-1" href="{$cp->image->filename|resize:800:600:w}">
			{if $product->image->filename}
                <img class="fn-img" src="{$cp->image->filename|resize:219:172}" alt="{$cp->name|escape}"/>
                {if $cp->special}
                    <img class="card-spec" src='files/special/{$cp->special}' alt='{$cp->sp_img}'/>
                {/if}
            {else}
                <img class="fn-img" src="design/{$settings->theme}/images/no_image.png" alt="{$product->name|escape}"/>
                {if $product->special}
                    <img class="card-spec" src='files/special/{$product->special}' alt='{$product->sp_img}'/>
                {/if}
            {/if}
		</a>
		{* @END Изображение товара *}
		{* Название товара *}
		<div class="card-title m-b-1">
			<a data-product="{$cp->id}" href="{$lang_link}products/{$cp->url}">{$cp->name|escape}</a>
		</div>
		{* @END Название товара *}
		<div class="row card-price-block">
			{* Старая цена *}
			<div class="col-xs-6 text-line-through text-red{if !$cp->variant->compare_price} hidden-xs-up{/if}">
				<span class="fn-old_price">{$cp->variant->compare_price|convert}</span> {$currency->sign|escape}
			</div>
			{* @END Старая цена *}
			{* Цена *}
			<div class="{if !$cp->variant->compare_price}col-xs-12{else}col-xs-6{/if} h5 font-weight-bold m-b-0">
				<span class="fn-price">{$cp->variant->price|convert}</span> {$currency->sign|escape}
			</div>
			{* @END Цена *}
		</div>
		<form class="fn-variants okaycms" action="/{$lang_link}cart">
			{* Варианты товара *}
			<select name="variant" class="fn-variant okaycms form-control c-select{if $cp->variants|count < 2} hidden-xs-up{/if}">
	            {foreach $cp->variants as $v}
	                <option value="{$v->id}" data-price="{$v->price|convert}" data-stock="{$v->stock}"{if $v->compare_price > 0} data-cprice="{$v->compare_price|convert}"{/if}{if $v->sku} data-sku="{$v->sku}"{/if}{if $v@first} selected{/if}>{if $v->name}{$v->name}{else}{$cp->name|escape}{/if}</option>
	            {/foreach}
	        </select>
			{* @END Варианты товара *}
			{* Сравнение *}
			<a class="btn-comparison-remove fn-comparison okaycms hidden-md-down" href="#" data-id="{$cp->id}" title="{$lang->tiny_products_remove_comparison}" data-result-text="{$lang->tiny_products_add_comparison}">&times;</a>
			{* @END Сравнение *}
			<div class="input-group">
				{* Избранное *}
				<div class="input-group-btn text-xs-left">
					{if $cp->id|in_array:$wished_products}
						<a href="#" data-id="{$cp->id}" class="btn-favorites fn-wishlist okaycms selected" title="{$lang->tiny_products_remove_favorite}" data-result-text="{$lang->tiny_products_add_favorite}"></a>
					{else}
						<a href="#" data-id="{$cp->id}" class="btn-favorites fn-wishlist okaycms" title="{$lang->tiny_products_add_favorite}" data-result-text="{$lang->tiny_products_remove_favorite}"></a>
					{/if}
				</div>
				{* @END Избранное *}
				{* Кнопка добавления в корзину *}
				<button class="fn-is_stock btn btn-warning btn-block i-add-cart{if $cp->variant->stock < 1} hidden-xs-up{/if}" type="submit">{$lang->tiny_products_add_cart}</button>
				{* @END Кнопка добавления в корзину *}
				{* Нет на складе *}
				<span class="fn-not_preorder{if $cp->variant->stock > 0 || $cp->variant->stock == 0 && $settings->is_preorder} hidden-xs-up{/if}">
					<button class="btn btn-danger-outline btn-block disabled h5 m-y-0" type="button">{$lang->tiny_products_out_of_stock}</button>
				</span>
				{* @END Нет на складе *}
				{* Предзаказ *}
				<span class="fn-is_preorder{if $cp->variant->stock > 0 || $cp->variant->stock == 0 && !$settings->is_preorder} hidden-xs-up{/if}">
					<button class="btn btn-warning-outline btn-block i-preorder" type="submit">{$lang->tiny_products_pre_order}</button>
				</span>
				{* @END Предзаказ *}
			</div>
		</form>
    </div>
</div>