{* Превью товара *}
<div class="fn-product card {if $smarty.get.module=="ComparisonView"}fn-resize m-b-0 border-b-1-primary{/if}">
	<div class="card-block fn-transfer">
		{* Изображение товара *}
		<a class="{if $smarty.get.module=="ComparisonView"}fn-zoom okaycms {/if}card-image m-b-1" href="{if $smarty.get.module=="ComparisonView"}{$product->image->filename|resize:800:600:w}{else}{$lang_link}products/{$product->url}{/if}">
            {if $product->image->filename}
                <img class="fn-img" src="{$product->image->filename|resize:219:172}" alt="{$product->name|escape}" title="{$product->name|escape}"/>
                {if $product->special}
                    <img class="card-spec" src='files/special/{$product->special}' alt='{$product->special}' title="{$product->special}"/>
                {/if}
            {else}
                <img class="fn-img" src="design/{$settings->theme}/images/no_image.png" width="200" height="180" alt="{$product->name|escape}"/>
                {if $product->special}
                    <img class="card-spec" src='files/special/{$product->special}' alt='{$product->special}' title="{$product->special}"/>
                {/if}
            {/if}
		</a>

		{* Название товара *}
		<div class="card-title m-b-1">
			<a data-product="{$product->id}" href="{$lang_link}products/{$product->url}">{$product->name|escape}</a>
		</div>

		<div class="row card-price-block">
			{* Старая цена *}
			<div class="col-xs-6 text-line-through text-red{if !$product->variant->compare_price} hidden-xs-up{/if}">
				<span class="fn-old_price">{$product->variant->compare_price|convert}</span> {$currency->sign|escape}
			</div>

			{* Цена *}
			<div class="{if !$product->variant->compare_price}col-xs-12{else}col-xs-6{/if} h5 font-weight-bold m-b-0">
				<span class="fn-price">{$product->variant->price|convert}</span> {$currency->sign|escape}
			</div>
		</div>
		<form class="fn-variants okaycms" action="/{$lang_link}cart">
			{* Варианты товара *}
			<select name="variant" class="fn-variant okaycms form-control c-select{if $product->variants|count < 2} hidden-xs-up{/if}">
	            {foreach $product->variants as $v}
	                <option value="{$v->id}" data-price="{$v->price|convert}" data-stock="{$v->stock}"{if $v->compare_price > 0} data-cprice="{$v->compare_price|convert}"{/if}{if $v->sku} data-sku="{$v->sku}"{/if}>{if $v->name}{$v->name}{else}{$product->name|escape}{/if}</option>
	            {/foreach}
	        </select>

            {*Вывод предзаказа/нет в наличии в каталоге и на главной*}
            {if $smarty.get.module != "ComparisonView" && $smarty.get.module != "WishlistView"}
                {if !$settings->is_preorder}
                    {* Нет на складе *}
                    <div class="fn-not_preorder m-b-1 {if $product->variant->stock > 0}hidden-xs-up{/if}">
                        <button class="btn btn-danger-outline btn-block disabled" type="button" data-language="{$translate_id['tiny_products_out_of_stock']}">{$lang->tiny_products_out_of_stock}</button>
                    </div>
                {else}
                    {* Предзаказ *}
                    <div class="fn-is_preorder m-b-1 {if $product->variant->stock > 0}hidden-xs-up{/if}">
                        <button class="btn btn-warning-outline btn-block i-preorder" type="submit" data-language="{$translate_id['tiny_products_pre_order']}">{$lang->tiny_products_pre_order}</button>
                    </div>
                {/if}
            {/if}


            {if $smarty.get.module != "ProductsView" && $smarty.get.module !="MainView" && $smarty.get.module !="ProductView" && $smarty.get.module !="BlogView"}
            <a class="btn-comparison-remove {if $smarty.get.module == "ComparisonView"}fn-comparison{else}fn-wishlist{/if} okaycms hidden-md-down selected" href="#" data-id="{$product->id}" title="{if $smarty.get.module == "ComparisonView"}{$lang->tiny_products_remove_comparison}{else}{$lang->tiny_products_remove_favorite}{/if}">&times;</a>
            {/if}
            <div class="input-group">
                {if $smarty.get.module != "ComparisonView"}
                    {* Сравнение *}
                    <div class="input-group-btn text-xs-right">
                        {if !in_array($product->id,$comparison->ids)}
                            <a class="btn-comparison fn-comparison okaycms hidden-md-down" href="#" data-id="{$product->id}" title="{$lang->tiny_products_add_comparison}" data-result-text="{$lang->tiny_products_remove_comparison}" data-language="{$translate_id['tiny_products_add_comparison']}"></a>
                        {else}
                            <a class="btn-comparison fn-comparison okaycms hidden-md-down selected" href="#" data-id="{$product->id}" title="{$lang->tiny_products_remove_comparison}" data-result-text="{$lang->tiny_products_add_comparison}" data-language="{$translate_id['tiny_products_remove_comparison']}"></a>
                        {/if}
                    </div>
                {/if}

                {if $smarty.get.module != "WishlistView"}
                    {* Избранное *}
                    <div class="input-group-btn text-xs-left">
                        {if $product->id|in_array:$wished_products}
                            <a href="#" data-id="{$product->id}" class="btn-favorites fn-wishlist okaycms selected" title="{$lang->tiny_products_remove_favorite}" data-result-text="{$lang->tiny_products_add_favorite}" data-language="{$translate_id['tiny_products_remove_favorite']}"></a>
                        {else}
                            <a href="#" data-id="{$product->id}" class="btn-favorites fn-wishlist okaycms" title="{$lang->tiny_products_add_favorite}" data-result-text="{$lang->tiny_products_remove_favorite}" data-language="{$translate_id['tiny_products_add_favorite']}"></a>
                        {/if}
                    </div>
                {/if}

                {*Вывод предзаказа/нет в наличии в сравнении и избранном*}
                {if $smarty.get.module == "ComparisonView" || $smarty.get.module == "WishlistView"}
                {if !$settings->is_preorder}
                    {* Нет на складе *}
                    <div class="fn-not_preorder {if $product->variant->stock > 0}hidden-xs-up{/if}">
                        <button class="btn btn-danger-outline btn-block disabled" type="button" data-language="{$translate_id['tiny_products_out_of_stock']}">{$lang->tiny_products_out_of_stock}</button>
                    </div>
                {else}
                    {* Предзаказ *}
                    <div class="fn-is_preorder {if $product->variant->stock > 0}hidden-xs-up{/if}">
                        <button class="btn btn-warning-outline btn-block i-preorder" type="submit" data-language="{$translate_id['tiny_products_pre_order']}">{$lang->tiny_products_pre_order}</button>
                    </div>
                {/if}
                {/if}
                {* Кнопка добавления в корзину *}
				<button class="fn-is_stock btn btn-warning btn-block i-add-cart{if $product->variant->stock < 1} hidden-xs-up{/if}" data-language="{$translate_id['tiny_products_add_cart']}" type="submit">{$lang->tiny_products_add_cart}</button>
            </div>
		</form>
    </div>
</div>