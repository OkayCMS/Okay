{* Страница товара *}

{* Канонический адрес страницы *}
{$canonical="/products/{$product->url}" scope=parent}
<div class="product">

	<h1 class="h1" data-product="{$product->id}">{$product->name|escape}</h1>
	
	<div class="row">
		<div id="product_images" class="column col_5">
			
			<!-- Большое фото -->
			<div class="image">
				<!-- Промо изображения -->
				<div class="relProd">
	                {if $product->special}	
	                    <img class="specialStarMain" alt='{$product->sp_img}' title='{$product->sp_img}'  src='files/special/{$product->special}'/>
	                {/if}
	            </div>
	           	<!-- END Промо изображения -->

				{if $product->image}
					<a href="{$product->image->filename|resize:800:600:w}" class="zoom" rel="group"><img src="{$product->image->filename|resize:300:300}" alt="{$product->product->name|escape}" /></a>
				{else}
					<img src="design/{$settings->theme|escape}/images/no_image.png" alt="{$product->name|escape}" />
				{/if}
			</div>
			<!-- Большое фото (The End)-->

			<!-- Дополнительные фото продукта -->
			{if $product->images|count>1}
			<div class="images">
				{* cut удаляет первую фотографию, если нужно начать 2-й - пишем cut:2 и тд *}
				{foreach $product->images|cut as $i=>$image}
					<a href="{$image->filename|resize:800:600:w}" class="zoom" rel="group"><img src="{$image->filename|resize:95:95}" alt="{$product->name|escape}" /></a>
				{/foreach}
			</div>
			{/if}
			<!-- Дополнительные фото продукта (The End)-->
		</div>	

		<div id="product_info" class="column col_7">
			{if $product->variant->sku}
				<div class="sku">{$lang->artikul}: <span>{$product->variant->sku}</span></div>
			{/if}

			<!-- Рейтинг товара -->
	        <div id="product_{$product->id}" class="product_rating">
				<span class="rating_starOff">
					<span class="rating_starOn" style="width:{$product->rating*90/5|string_format:'%.0f'}px;"></span>
				</span>
			</div>
            
			<!-- Описание товара -->
			{if $product->annotation}
				<div class="annotation">  
					{$product->annotation}
				</div>
			{/if}

			{if $product->variants|count > 0}
			<!-- Выбор варианта товара -->
			<form class="variants" action="/{$lang_link}cart">
				<div class="price_container">
		            <span class="old_price{if !$product->variant->compare_price} hidden{/if}"><span>{$product->variant->compare_price|convert}</span>{$currency->sign|escape}</span>
		            <span class="price">
		                <span>{$product->variant->price|convert}</span> 
		                {$currency->sign|escape}
		            </span>
	            </div>

	            <div id="product_amount">
                    <span class="minus">&#8722;</span>                                
                    <input class="amount_input" type="text" name="amount" value="1" data-max="{$product->variant->stock}">
                    <span class="plus">+</span>
                </div>
                
                {if $product->variants|count == 1}<span>{$product->variant->name}</span>{/if}
				<select name="variant" class="select_variant{if $product->variants|count == 1} hidden{/if}">
    	            {foreach $product->variants as $v}
    	                <option value="{$v->id}" data-price="{$v->price|convert}" data-stock="{$v->stock}" {if $v->compare_price > 0}data-cprice="{$v->compare_price|convert}"{/if} {if $v->sku}data-sku="{$v->sku}"{/if}>{$v->name}</option>
    	            {/foreach}
	        	</select>

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
	</div>

	<div class="tabs clearfix">
		<nav class="tab_navigation">
			{if $product->body}
				<a href="#tab1">{$lang->opisanie}</a>
			{/if}
			{if $product->features}
				<a href="#tab2">{$lang->harakteristiki}</a>
			{/if}
			<a href="#tab3">{$lang->otzyvy}</a>
		</nav>
	 	<div class="tab_container">
		 	{if $product->body}	
		 		<div id="tab1" class="tab">{$product->body}</div>
	 		{/if}
	 		<!-- Характеристики товара -->
	 		{if $product->features}
	 			<div id="tab2" class="tab">
					<ul class="features">
    					{foreach $product->features as $f}
    					<li>
    						<label>{$f->name}</label>
    						<span>{$f->value}</span>
    					</li>
    					{/foreach}
					</ul>
	 			</div>
			{/if}
			<!-- Характеристики товара (The End)-->
			<!-- Комментарии -->
			<div id="tab3" class="tab">
				<div id="comments">
					{if $comments}
					<!-- Список с комментариями -->
					<ul class="comment_list">
						{foreach $comments as $comment}
						<a name="comment_{$comment->id}"></a>
						<li>
							<!-- Имя и дата комментария-->
							<div class="comment_header">	
								<span class="comment_name">{$comment->name|escape}</span> <i>{$comment->date|date}, {$comment->date|time}</i>
								{if !$comment->approved}<strong>{$lang->ozhidaet_moderatsii}</strong>{/if}
							</div>
							<!-- Имя и дата комментария (The End)-->
							
							<!-- Комментарий -->
							{$comment->text|escape|nl2br}
							<!-- Комментарий (The End)-->
						</li>
						{/foreach}
					</ul>
					<!-- Список с комментариями (The End)-->
					{else}
					<p>
						{$lang->poka_net_kommentariev}
					</p>
					{/if}
					
					<!--Форма отправления комментария-->	
					<form class="form comment_form" method="post">
						<div class="comment_form_title">{$lang->napisat_kommentarij}</div>
						{if $error}
							<div class="message_error">
								{if $error=='captcha'}
									{$lang->neverno_vvedena_kapcha}
								{elseif $error=='empty_name'}
									{$lang->vvedite_imya}
								{elseif $error=='empty_comment'}
									{$lang->vvedite_kommentarij}
								{/if}
							</div>
						{/if}

						<div class="form_group">
							<input class="form_input" type="text" id="comment_name" name="name" value="{$comment_name}" data-format=".+" data-notice="{$lang->vvedite_imya}" placeholder="Имя"/>
						</div>
						<textarea class="comment_textarea" id="comment_text" name="text" data-format=".+" data-notice="{$lang->vvedite_kommentarij}" placeholder="{$lang->vvedite_kommentarij}">{$comment_text}</textarea>

						<div class="captcha">
							<img src="captcha/image.php?{math equation='rand(10,10000)'}" alt='captcha'/>
							<input class="input_captcha" id="comment_captcha" type="text" name="captcha_code" value="" data-format="\d\d\d\d" data-notice="{$lang->vvedite_kapchu}" placeholder="{$lang->vvedite_kapchu}"/>
						</div> 
						<input class="button" type="submit" name="comment" value="{$lang->otpravit}"/>
					</form>
					<!--Форма отправления комментария (The End)-->
				</div>
			</div>
			<!-- Комментарии (The End) -->
		 </div>
	</div>
</div>

{* Связанные товары *}
{if $related_products}
<div id="related" class="clearfix">
	<div class="block_heading">{$lang->sovetuem_posmotret}</div>
	<!-- Подключаем список товаров и передаем переменную со связанными-->

    <ul id="test" class="products row">
        {foreach $related_products as $product}
            {include "product_list.tpl"}
        {/foreach}
    </ul>

</div>
{/if}

