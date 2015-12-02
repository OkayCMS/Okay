{* Шаблон корзины *}

{$meta_title = $lang->papka_sravneniya scope=parent}

<h1 class="h1">
	{if $comparison->products}{$lang->v_papke_sravneniya} {$comparison->products|count} {$comparison->products|count|plural:$lang->tovar:$lang->tovarov:$lang->tovara}
	{else}{$lang->papka_sravneniya_pusta}{/if}
</h1>

{if $comparison->products}
{strip}
	<div class="comparison_content">
		<div class="comparison_features">
			<div class="cprs_image cell" data-use="cprs_image"></div>
			{if $comparison->products|count>1}
				<div class="cprs_show_options">
					<a href="#show_all" class="comparison_options_show active"><span>{$lang->vse}</span></a>
					<a href="#show_dif" class="comparison_options_show unique"><span>{$lang->tolko_otlichiya}</span></a>
				</div>
			{/if}

			<div class="cprs_name cell" data-use="cprs_name">{$lang->nazvanie}</div>
			<div class="cprs_variant cell" data-use="cprs_variant">{$lang->varianty}</div>
			<div class="cprs_description cell" data-use="cprs_description">{$lang->opisanie}</div>
			{if $comparison->features}
				{foreach $comparison->features as $id=>$cf}
					<div class="cprs_feature cprs_feature_{$id} cell{if $cf->not_unique} not_unique{/if}" data-use="cprs_feature_{$id}">{$cf->name}</div>
				{/foreach}
			{/if}
		</div>

		<div class="comparison_products" data-products="2">
			<div class="comparison_slider">
				{foreach $comparison->products as $id=>$cp}
					<div class="comparison_product">
						<div class="cprs_image cell">
							<a href="#" class="comparison_button" data-id="{$cp->id}">{$lang->udalit_iz_sravneniya}</a>
							<a class="big_image fancy_zoom" href="{$cp->image->filename|resize:600:800:w}" rel="cp_{$cp->id}">
								{if $cp->image}
									<img src="{$cp->image->filename|resize:195:195}" alt="{$cp->name|escape}">
								{/if}
							</a>
							{if $cp->images|count>1}
								{foreach $cp->images|cut as $image}
									<a class="small_image fancy_zoom" href="{$image->filename|resize:600:800:w}" rel="cp_{$cp->id}">
										<img src="{$image->filename|resize:50:50}" alt="{$cp->name|escape}">
									</a>
								{/foreach}
							{/if}
						</div>

						<div class="cprs_name cell">
							<a href="{$lang_link}products/{$cp->url|escape}">{$cp->name|escape}</a>
						</div>

						<div class="cprs_variant cell">
							{if $cp->variants}
								<form class="variants" action="/cart">
                                    <div class="price_container">
                    		            <span class="old_price{if !$cp->variant->compare_price} hidden{/if}"><span>{$cp->variant->compare_price|convert}</span>{$currency->sign|escape}</span>
                    		            <span class="price">
                    		                <span>{$cp->variant->price|convert}</span>
                    		                {$currency->sign|escape}
                    		            </span>
                    	            </div>

                                    {if $cp->variants|count == 1}<span>{$cp->variant->name}</span>{/if}
									<select name="variant" class="select_variant{if $cp->variants|count == 1} hidden{/if}">
                    		            {foreach $cp->variants as $v}
                    		                <option value="{$v->id}" data-price="{$v->price|convert}" data-stock="{$v->stock}" {if $v->compare_price > 0}data-cprice="{$v->compare_price|convert}"{/if} {if $v->sku}data-sku="{$v->sku}"{/if}>{$v->name}</option>
                    		            {/foreach}
                    		        </select>
                                    <div class="button_container">
                                        <button type="submit" class="button" data-in_cart="{$lang->v_korzinu}" data-preorder="{$lang->predzakaz}" data-result-text="{$lang->dobavleno}" {if $cp->variant->stock == 0 && !$settings->is_preorder} style="display: none;"{/if}>{if $cp->variant->stock > 0}{$lang->v_korzinu}{else}{$lang->predzakaz}{/if}</button>
                                    </div>
                                    <p class="not_in_stock" {if $cp->variant->stock > 0} style="display: none;"{/if}>{$lang->net_na_sklade}</p>
								</form>
							{else}
								{$lang->net_v_nalichii}
							{/if}
							<div class="clear"></div>
						</div>

						<div class="cprs_description cell">{$cp->annotation}</div>

						{if $cp->features}
							{foreach $cp->features as $id=>$value}
								<div class="cprs_feature cprs_feature_{$id} cell{if $comparison->features.{$id}->not_unique} not_unique{/if}">
									{$value|default:"&mdash;"}
								</div>
							{/foreach}
						{/if}
					</div>
				{/foreach}
			</div>
            {if $comparison->products|count > 2}
                <div class="comparison_nav">
                    <div class="comparison_prev"></div>
                    <div class="comparison_next"></div>
                </div>
            {/if}
		</div>
		<div class="clear"></div>
	</div>
{/strip}
{/if}

{literal}
<script type="text/javascript" src="js/fancybox/jquery.fancybox.pack.js"></script>
<link rel="stylesheet" href="js/fancybox/jquery.fancybox.css" type="text/css" media="screen" />
{/literal}