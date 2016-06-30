{* Страница заказа *}
{* Тайтл страницы *}
{$meta_title = "`$lang->order_title` `$order->id`" scope=parent}

<div class="container">
	{* Хлебные крошки *}
	{include file='breadcrumb.tpl'}

	{* Заголовок страницы *}
	<div class="h1 m-b-1"><span data-language="{$translate_id['cart_header']}">{$lang->order_header}</span> {$order->id}</div>
	<div class="purchase-list h6">
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
					</div>
				</div>
			</div>
		</div>
		{foreach $purchases as $purchase}
			<div class="purchase-row purchase-main">
				{* Изображение *}
				<div class="purchase-img hidden-md-down">
					{$image = $purchase->product->images|first}
					{if $image}
						<a href="{$lang_link}products/{$purchase->product->url}">
							<img src="{$image->filename|resize:50:50}" alt="{$purchase->product_name|escape}" title="{$purchase->product_name|escape}">
						</a>
					{/if}
				</div>

				{* Название *}
				<div class="purchase-name">
					<a href="{$lang_link}products/{$purchase->product->url}">{$purchase->product_name|escape}</a>
					{$purchase->variant_name|escape}
                    {if $order->paid && $purchase->variant->attachment}
                        <a class="download_attachment" href="{$lang_link}order/{$order->url}/{$purchase->variant->attachment}">скачать файл</a>
                    {/if}
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
								<div class="fn-product-amount fn-is_stock okaycms text-xs-center">
									{* Кол-во товаров *}
									<input disabled class="form-control" type="text" data-id="{$purchase->variant_id}" name="amounts[{$purchase->variant_id}]" value="{$purchase->amount}">
								</div>
							</div>

							{* Общая цена *}
							<div class="purchase-full-price">
								{($purchase->price*$purchase->amount)|convert}&nbsp;{$currency->sign}
							</div>
						</div>
					</div>
				</div>
			</div>
		{/foreach}
	</div>
	{if $order->discount > 0}
		<div class="purchase-list p-t-1-md_down border-t-1-info_md-down">
			<div class="purchase-row purchase-main">
				<div class="purchase-img hidden-md-down"></div>
				<div class="purchase-name hidden-md-down"></div>
				<div class="purchase-price hidden-md-down"></div>
				<div class="purchase-column">
					<div class="purchase-list">
						<div class="purchase-row">
							<div class="purchase-amount text-xs-center">
								<span data-language="{$translate_id['cart_discount']}">{$lang->cart_discount}</span>:
							</div>
							{* Скидка *}
							<div class="purchase-full-price">{$order->discount}%</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	{/if}
	{if $order->coupon_discount > 0}
		<div class="purchase-list p-t-1-md_down border-t-1-info_md-down">
			<div class="purchase-row purchase-main">
				<div class="purchase-img hidden-md-down"></div>
				<div class="purchase-name hidden-md-down"></div>
				<div class="purchase-price hidden-md-down"></div>
				<div class="purchase-column">
					<div class="purchase-list">
						<div class="purchase-row">
							<div class="purchase-amount text-xs-center">
								<span data-language="{$translate_id['cart_coupon']}">{$lang->cart_coupon}</span>:
							</div>
							{* Купон *}
							<div class="purchase-full-price">-{$order->coupon_discount|convert} {$currency->sign}</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	{/if}
	{if !$order->separate_delivery && $order->delivery_price > 0}
		<div class="purchase-list p-t-1-md_down border-t-1-info_md-down">
			<div class="purchase-row purchase-main">
				<div class="purchase-img hidden-md-down"></div>
				<div class="purchase-name hidden-md-down"></div>
				<div class="purchase-price hidden-md-down"></div>
				<div class="purchase-column">
					<div class="purchase-list">
						<div class="purchase-row">
							<div class="purchase-amount text-xs-center">
								<span data-language="{$translate_id['order_delivery']}">{$lang->order_delivery}</span>:
							</div>
							{* Стоимость доставки *}
							<div class="purchase-full-price">{$order->delivery_price|convert} {$currency->sign}</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	{/if}
    {if $order->separate_delivery}
        <div class="purchase-list p-t-1-md_down border-t-1-info_md-down">
            <div class="purchase-row purchase-main">
                <div class="purchase-img hidden-md-down"></div>
                <div class="purchase-name hidden-md-down"></div>
                <div class="purchase-price hidden-md-down"></div>
                <div class="purchase-column">
                    <div class="purchase-list">
                        <div class="purchase-row">
                            <div class="purchase-amount text-xs-center">
                                <span data-language="{$translate_id['order_delivery']}">{$lang->order_delivery}</span>:
                            </div>
                            {* Стоимость доставки *}
                            <div class="purchase-full-price">{$order->delivery_price|convert} {$currency->sign}</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    {/if}
	<div class="purchase-list p-t-1-md_down border-t-1-info_md-down m-b-1">
		<div class="purchase-row purchase-main">
			<div class="purchase-img hidden-md-down"></div>
			<div class="purchase-name hidden-md-down"></div>
			<div class="purchase-price hidden-md-down"></div>
			<div class="purchase-column">
				<div class="purchase-list">
					<div class="purchase-row">
						<div class="purchase-amount text-xs-center">
							<span data-language="{$translate_id['cart_total_price']}">{$lang->cart_total_price}</span>:
						</div>
						{* Стоимость доставки *}
						<div class="purchase-full-price">{$order->total_price|convert} {$currency->sign}</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-lg-6">
			<div class="h5 m-b-1">
				<span data-language="{$translate_id['order_details']}">{$lang->order_details}</span>
			</div>
			{* Детали заказа *}
			<table class="table table-striped">
				<tr>
					<td>
						<span data-language="{$translate_id['order_status']}">{$lang->order_status}</span>
					</td>
					<td>
						{if $order->status == 0}<span data-language="{$translate_id['status_accepted']}">{$lang->status_accepted}</span>{/if}
						{if $order->status == 1}<span data-language="{$translate_id['status_pending']}">{$lang->status_pending}</span>{elseif $order->status == 2}<span data-language="{$translate_id['status_made']}">{$lang->status_made}</span>{/if}
						{if $order->paid == 1}, <span data-language="{$translate_id['status_paid']}">{$lang->status_paid}</span>{else}{/if}
					</td>
				</tr>
				<tr>
					<td>
						<span data-language="{$translate_id['order_date']}">{$lang->order_date}</span>
					</td>
					<td>{$order->date|date} <span data-language="{$translate_id['order_time']}">{$lang->order_time}</span> {$order->date|time}</td>
				</tr>
				<tr>
					<td>
						<span data-language="{$translate_id['order_name']}">{$lang->order_name}</span>
					</td>
					<td>{$order->name|escape}</td>
				</tr>
				<tr>
					<td>
						<span data-language="{$translate_id['order_email']}">{$lang->order_email}</span>
					</td>
					<td>{$order->email|escape}</td>
				</tr>
				{if $order->phone}
					<tr>
						<td>
							<span data-language="{$translate_id['order_phone']}">{$lang->order_phone}</span>
						</td>
						<td>{$order->phone|escape}</td>
					</tr>
				{/if}
				{if $order->address}
					<tr>
						<td>
							<span data-language="{$translate_id['order_address']}">{$lang->order_address}</span>
						</td>
						<td>{$order->address|escape}</td>
					</tr>
				{/if}
				{if $order->comment}
					<tr>
						<td>
							<span data-language="{$translate_id['order_comment']}">{$lang->order_comment}</span>
						</td>
						<td>{$order->comment|escape|nl2br}</td>
					</tr>
				{/if}
			</table>
		</div>
		{if !$order->paid}
			<div class="col-lg-6">
				{* Выбор способа оплаты *}
				<div class="h5 m-b-1">
					<span data-language="{$translate_id['order_payment_details']}">{$lang->order_payment_details}</span>
				</div>
				{if $payment_methods && !$payment_method && $order->total_price>0}
					<form method="post">
						{foreach $payment_methods as $payment_method}
							<div class="m-l-2{if $payment_method@first} active{/if}">
								<label class="font-weight-bold">
									<input type="radio" name="payment_method_id" value="{$payment_method->id}"{if $delivery@first && $payment_method@first} checked{/if} id="payment_{$delivery->id}_{$payment_method->id}"/>
                                    {if $payment_method->image}
                                        <img src="{$payment_method->image|resize:50:50:false:$config->resized_payments_dir}"/>
                                    {/if}
                                    {$total_price_with_delivery = $cart->total_price}
									{if !$delivery->separate_payment && $cart->total_price < $delivery->free_from}
										{$total_price_with_delivery = $cart->total_price + $delivery->price}
									{/if}
									{$payment_method->name} {$lang->cart_deliveries_to_pay} {$order->total_price|convert:$payment_method->currency_id}&nbsp;{$all_currencies[$payment_method->currency_id]->sign}
								</label>
								<div class="m-l-2 payment-description">
									{$payment_method->description}
								</div>
							</div>
						{/foreach}
						<div class="text-xs-right m-b-1">
							<input type="submit" data-language="{$translate_id['cart_checkout']}" value="{$lang->cart_checkout}" name="checkout" class="btn btn-warning">
						</div>
					</form>
				{* Выбраный способ оплаты *}
				{elseif $payment_method}
					<table class="table table-striped m-b-2">
						<tr>
							<td>
								<span data-language="{$translate_id['order_payment']}">{$lang->order_payment}</span>
							</td>
							<td>{$payment_method->name}</td>
						</tr>
						<tr>
							<td class="text-xs-right reset-payment" colspan="2">
								<form method="post">
									<input class="btn btn-success btn-sm" type=submit name='reset_payment_method' data-language="{$translate_id['order_change_payment']}" value='{$lang->order_change_payment}'/>
								</form>
							</td>
						</tr>
						{if $payment_method->description}
							<tr>
								<td colspan="2" class="clear-in">{$payment_method->description}</td>
							</tr>
						{/if}
					</table>
					{* Форма оплаты, генерируется модулем оплаты *}
					{checkout_form order_id=$order->id module=$payment_method->module}
				{/if}
			</div>
		{/if}
	</div>
</div>