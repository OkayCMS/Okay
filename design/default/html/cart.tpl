{* Шаблон корзины *}
{* Тайтл страницы *}
{$meta_title = $lang->cart_title scope=parent}
{* @END Тайтл страницы *}
<div class="container">
	{* Хлебные крошки *}
	{include file='breadcrumb.tpl'}
	{* @END Хлебные крошки *}
	{* Заголовок страницы *}
	<h1 class="m-b-1"><span data-language="{$translate_id['cart_header']}">{$lang->cart_header}</span></h1>
	{* @END Заголовок страницы *}
	{if $cart->purchases}
		<form method="post" name="cart">
			{* Список покупок *}
			<div id="fn-purchases" class="h6 m-b-2">
				{include file='cart_purchases.tpl'}
			</div>
			{* @END Список покупок *}
			<div class="row">
				{* Форма *}
				<div class="col-lg-5 m-b-2">
					<div class="bg-info p-a-1">
						{* Заголовок формы *}
						<div class="h1 m-b-1 text-xs-center" data-language="{$translate_id['cart_form_header']}">{$lang->cart_form_header}</div>
						{* @END Заголовок формы *}
						{* Вывод ошибок формы *}
						{if $error}
							<div class="p-x-1 p-y-05 bg-danger text-red m-b-1">
								{if $error == 'empty_name'}
									<span data-language="{$translate_id['form_enter_name']}">{$lang->form_enter_name}</span>
								{/if}
								{if $error == 'empty_email'}
									<span data-language="{$translate_id['form_enter_email']}">{$lang->form_enter_email}</span>
								{/if}
								{if $error == 'captcha'}
									<span data-language="{$translate_id['form_error_captcha']}">{$lang->form_error_captcha}</span>
								{/if}
							</div>
						{/if}
						{* @END Вывод ошибок формы *}
						{* Имя клиента *}
						<div class="form-group">
							<input class="form-control" name="name" type="text" value="{$name|escape}" data-format=".+" data-notice="{$lang->form_enter_name}" data-language="{$translate_id['form_name']}" placeholder="{$lang->form_name}*"/>
						</div>
						{* @END Имя клиента *}
						{* Телефон клиента *}
						<div class="form-group">
							<input class="form-control" name="phone" type="text" value="{$phone|escape}" data-language="{$translate_id['form_phone']}" placeholder="{$lang->form_phone}"/>
						</div>
						{* @END Телефон клиента *}
						{* Почта клиента *}
						<div class="form-group">
							<input class="form-control" name="email" type="text" value="{$email|escape}" data-format="email" data-notice="{$lang->form_enter_email}" data-language="{$translate_id['form_email']}" placeholder="{$lang->form_email}*"/>
						</div>
						{* @END Почта клиента *}
						{* Адрес доставки *}
						<div class="form-group">
							<input class="form-control" name="address" type="text" value="{$address|escape}" data-language="{$translate_id['form_address']}" placeholder="{$lang->form_address}"/>
						</div>
						{* @END Адрес доставки *}
						<div class="form-group">
							<textarea class="form-control" name="comment" data-language="{$translate_id['cart_order_comment']}" placeholder="{$lang->cart_order_comment}">{$comment|escape}</textarea>
						</div>
						<div class="row">
							<div class="col-xs-12 form-inline m-b-1-md_down">
								{if $settings->captcha_cart}
									{* Изображение капчи *}
									<div class="form-group">
										<img class="brad-3" src="captcha/image.php?{math equation='rand(10,10000)'}" alt="captcha"/>
									</div>
									{* @END Изображение капчи *}
									{* Поле ввода капчи *}
									<div class="form-group">
										<input class="form-control" type="text" name="captcha_code" value="" data-format="\d\d\d\d\d" data-notice="{$lang->form_enter_captcha}" data-language="{$translate_id['form_enter_captcha']}" placeholder="{$lang->form_enter_captcha}*"/>
									</div>
									{* @END Поле ввода капчи *}
								{/if}
								{* Кнопка отправки формы *}
								<div class="form-group">
									<input class="btn btn-warning m-l-1" type="submit" name="checkout" data-language="{$translate_id['cart_checkout']}" value="{$lang->cart_checkout}"/>
								</div>
								{* @END Кнопка отправки формы *}
							</div>
						</div>
					</div>
				</div>
				{* Форма *}
				{* Доставка *}
				<div class="col-lg-7 m-b-2">
					{include file='cart_deliveries.tpl'}
				</div>
				{* @END Доставка *}
			</div>
		</form>
	{else}
		<div class="m-b-2"><span data-language="{$translate_id['cart_empty']}">{$lang->cart_empty}</span></div>
	{/if}
</div>