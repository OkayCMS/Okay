<!-- Товар-->
<li class="product column col_4">
	<div class="inner">
		<!-- Фото товара -->
		<div class="image">
			<a href="{$lang_link}products/{$product->url}">
				{if $product->image}
	                <img src="{$product->image->filename|resize:200:200}" alt="{$product->name|escape}"/>
				{else}
	                <img src="design/{$settings->theme|escape}/images/no_image.png" alt="{$product->name|escape}"/>
	            {/if}

				<!-- Промо изображения -->
				<div class="relProd">
					{if $product->special}
						<img class="specialStarMain" alt='{$product->sp_img}' title='{$product->sp_img}'  src='files/special/{$product->special}'/>
					{/if}
				</div>
				<!-- END Промо изображения -->
			</a>
        </div>
		<!-- Фото товара (The End) -->

		<!-- Название товара -->
		<a class="product_name" data-product="{$product->id}" href="{$lang_link}products/{$product->url}">{$product->name|escape}</a>
		<!-- Название товара (The End) -->
		
		{if $product->variants|count > 0}
		<!-- Выбор варианта товара -->
		<form class="variants" action="/{$lang_link}cart">
			<select name="variant" class="sel_variant hidden">
	            {foreach $product->variants as $v}
	                <option value="{$v->id}" data-price="{$v->price|convert}" data-stock="{$v->stock}" {if $v->compare_price > 0}data-cprice="{$v->compare_price|convert}"{/if} {if $v->sku}data-sku="{$v->sku}"{/if}>{$v->name}</option>
	            {/foreach}
	        </select>
            
			<div class="price_container">
	            <span class="old_price{if !$product->variant->compare_price} hidden{/if}"><span>{$product->variant->compare_price|convert}</span>{$currency->sign|escape}</span>
	            <span class="price">
	                <span>{$product->variant->price|convert}</span> 
	                {$currency->sign|escape}
	            </span>
            </div>

			<!-- Рейтинг товара -->
            <div  class="product_rating">
				<span class="rating_starOff">
					<span class="rating_starOn" style="width:{$product->rating*90/5|string_format:'%.0f'}px;"></span>
				</span>
			</div>

			<div class="button_container">
				<button type="submit" class="button" data-in_cart="{$lang->v_korzinu}" data-preorder="{$lang->predzakaz}" data-result-text="{$lang->dobavleno}" {if $product->variant->stock == 0 && !$settings->is_preorder} style="display: none;"{/if}>{if $product->variant->stock > 0}{$lang->v_korzinu}{else}{$lang->predzakaz}{/if}</button>
			 	<!--Избранное-->
		        <div class="wishlist">
		            {if $product->id|in_array:$wished_products}
		                <a href="#" rel="{$product->id}" class="wishlist selected" data-result-text="<span>{$lang->v_izbrannoe}</span>"><span>{$lang->iz_izbrannogo}</span></a>
		        	{else}
		                <a href="#" rel="{$product->id}" class="wishlist" data-result-text="<span>{$lang->iz_izbrannogo}</span>"><span>{$lang->v_izbrannoe}</span></a>
		        	{/if}
		        </div>
		        <!-- Сравнение -->
		        <div class="compare">
					<a href="#" data-add="<span>{$lang->v_sravnenie}</span>" data-delete="<span>{$lang->iz_sravneniya}</span>" data-id="{$product->id}" class="comparison_button{if !in_array($product->id,$comparison->ids)} add{/if}"><span>{if in_array($product->id,$comparison->ids)}{$lang->iz_sravneniya}{else}{$lang->v_sravnenie}{/if}</span></a>
				</div>
			</div>
			<p class="not_in_stock" {if $product->variant->stock > 0} style="display: none;"{/if}>{$lang->net_na_sklade}</p>
		</form>
		<!-- Выбор варианта товара (The End) -->
		{else}
			{$lang->net_v_nalichii}
		{/if}
    </div>
</li>
<!-- Товар (The End)-->