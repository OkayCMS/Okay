<div class="purchase-list">
	<div class="purchase-row purchase-main bg-info hidden-md-down">
		{* Изображение *}
		<div class="purchase-img hidden-md-down text-lg-center">
			<span data-language="{$translate_id['cart_head_img']}">{$lang->cart_head_img}</span>
		</div>

		{* Название *}
		<div class="purchase-name">
			<span data-language="{$translate_id['cart_head_name']}">{$lang->cart_head_name}</span>
		</div>

		{* Цена за ед. *}
		<div class="purchase-price hidden-md-down">
			<span data-language="{$translate_id['cart_head_price']}">{$lang->cart_head_price}</span>
		</div>

		<div class="purchase-column">
			<div class="purchase-list">
				<div class="purchase-row">
					{* Количество *}
					<div class="purchase-amount text-lg-center">
						<span data-language="{$translate_id['cart_head_amoun']}">{$lang->cart_head_amoun}</span>
					</div>

					{* Общая цена *}
					<div class="purchase-full-price">
						<span data-language="{$translate_id['cart_head_total']}">{$lang->cart_head_total}</span>
					</div>

					{* Кнопка удаления *}
					<div class="purchase-remove"></div>

				</div>
			</div>
		</div>
	</div>
	{foreach $cart->purchases as $purchase}
		<div class="purchase-row purchase-main">
			{* Изображение *}
			<div class="purchase-img hidden-md-down">
				{$image = $purchase->product->images|first}
                <a href="{$lang_link}products/{$purchase->product->url}">
                    {if $image}
                        <img src="{$image->filename|resize:50:50}" alt="{$purchase->product->name|escape}" title="{$purchase->product->name|escape}">
                    {else}
                        <img width="50" height="50" src="design/{$settings->theme}/images/no_image.png" alt="{$purchase->product->name|escape}" title="{$purchase->product->name|escape}"/>
                    {/if}
                </a>
			</div>

			{* Название *}
			<div class="purchase-name">
				<a href="{$lang_link}products/{$purchase->product->url}">{$purchase->product->name|escape}</a>
				{$purchase->variant->name|escape}
                {if $purchase->variant->stock == 0}
                    <label class="btn-warning cart_preorder">
                        {$lang->product_pre_order}
                    </label>
                {/if}
			</div>

			{* Цена за ед. *}
			<div class="purchase-price hidden-md-down">
				{($purchase->variant->price)|convert} {$currency->sign}
			</div>

			<div class="purchase-column">
				<div class="purchase-list">
					<div class="purchase-row">
						{* Количество *}
						<div class="purchase-amount">
							<div class="fn-product-amount{if $settings->is_preorder} fn-is_preorder{/if} okaycms text-xs-center text-md-left">
								{* Кол-во товаров *}
								<span class="minus">&minus;</span>
								<input class="form-control" type="text" data-id="{$purchase->variant->id}" name="amounts[{$purchase->variant->id}]" value="{$purchase->amount}" onblur="ajax_change_amount(this, {$purchase->variant->id});" data-max="{$purchase->variant->stock}">
								<span class="plus">&plus;</span>
							</div>
						</div>

						{* Общая цена *}
						<div class="purchase-full-price">
							{($purchase->variant->price*$purchase->amount)|convert}&nbsp;{$currency->sign}
						</div>

						{* Кнопка удаления *}
						<div class="purchase-remove">
							<a href="{$lang_link}cart/remove/{$purchase->variant->id}" onclick="ajax_remove({$purchase->variant->id});return false;" title="{$lang->cart_remove}">
								<img src="design/{$settings->theme}/images/remove.png" alt="{$lang->cart_purchases_remove}" title="{$lang->cart_purchases_remove}">
							</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	{/foreach}
</div>
{if $user->discount}
	<div class="purchase-list p-t-1-md_down border-t-1-info_md-down">
		<div class="purchase-row purchase-main">
			<div class="purchase-img hidden-md-down"></div>
			<div class="purchase-name hidden-md-down"></div>
			<div class="purchase-price hidden-md-down"></div>
			<div class="purchase-column">
				<div class="purchase-list">
					<div class="purchase-row">
						<div class="purchase-amount">
							<span data-language="{$translate_id['cart_discount']}">{$lang->cart_discount}</span>:
						</div>
						{* Скидка *}
						<div class="purchase-full-price">{$user->discount}%</div>
						<div class="purchase-remove hidden-md-down"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
{/if}
{if $coupon_request}
	{* Ошибка купона *}
	{if $coupon_error}
		<div class="p-x-1 p-y-05 text-red m-t-1">
			{if $coupon_error == 'invalid'}
				{$lang->cart_coupon_error}
			{/if}
		</div>
	{/if}
	{if $cart->coupon->min_order_price > 0}
		<div class="p-x-1 p-y-05 text-red m-t-1">
			{$lang->cart_coupon} {$cart->coupon->code|escape} {$lang->cart_coupon_min} {$cart->coupon->min_order_price|convert} {$currency->sign}
		</div>
	{/if}

	<div class="purchase-list">
		<div class="purchase-row purchase-main">
			<div class="purchase-img border-b-1-info_md-down">
				<span data-language="{$translate_id['cart_coupon']}">{$lang->cart_coupon}</span>
			</div>
			<div class="purchase-name border-b-1-info_md-down form-inline">
				{* Купон *}
				<div class="form-group">
					<input type="text" name="coupon_code" value="{$cart->coupon->code|escape}" class="fn-coupon okaycms form-control"/>
				</div>

				<div class="form-group p-l-2">
					<input class="fn-sub-coupon okaycms btn btn-success" type="button" value="{$lang->cart_purchases_coupon_apply}">
				</div>
			</div>
			<div class="purchase-price hidden-md-down"></div>
			<div class="purchase-column">
				<div class="purchase-list">
					<div class="purchase-row">
						<div class="purchase-amount p-y-1-md_down">
							{if $cart->coupon_discount > 0}
								<span data-language="{$translate_id['cart_coupon']}">{$lang->cart_coupon}</span>:
							{/if}
						</div>
						{* Итоговая цена *}
						<div class="purchase-full-price p-y-1-md_down">
							{if $cart->coupon_discount > 0}
								-{$cart->coupon_discount|convert} {$currency->sign}
							{/if}
						</div>
						<div class="purchase-remove hidden-md-down"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
{/if}
<div class="purchase-list p-t-1-md_down border-t-1-info_md-down">
	<div class="purchase-row purchase-main">
		<div class="purchase-img hidden-md-down"></div>
		<div class="purchase-name hidden-md-down"></div>
		<div class="purchase-price hidden-md-down"></div>
		<div class="purchase-column">
			<div class="purchase-list">
				<div class="purchase-row">
					<div class="purchase-amount font-weight-bold p-y-1-md_down">
						<span data-language="{$translate_id['cart_total_price']}">{$lang->cart_total_price}</span>:
					</div>
					{* Итоговая цена *}
					<div class="purchase-full-price font-weight-bold p-y-1-md_down">{$cart->total_price|convert} {$currency->sign}</div>
					<div class="purchase-remove hidden-md-down"></div>
				</div>
			</div>
		</div>
	</div>
</div>