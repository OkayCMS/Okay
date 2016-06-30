{* Страница личного кабинета *}
{* Тайтл страницы *}
{$meta_title = $lang->user_title scope=parent}

<div class="container">
	{* Хлебные крошки *}
	{include file='breadcrumb.tpl'}

	{* Заголовок страницы *}
	<h1 class="m-b-1">
		<span data-language="{$translate_id['user_header']}">{$lang->user_header}</span>
	</h1>

	<div class="row m-b-2">
		<div class="col-lg-5">
			<form class="p-a-1 bg-info" method="post">
				{* Вывод ошибок *}
				{if $error}
					<div class="p-x-1 p-y-05 text-red m-b-1">
						{if $error == 'empty_name'}
							<span data-language="{$translate_id['form_enter_name']}">{$lang->form_enter_name}</span>
						{elseif $error == 'empty_email'}
							<span data-language="{$translate_id['form_enter_email']}">{$lang->form_enter_email}</span>
						{elseif $error == 'empty_password'}
							<span data-language="{$translate_id['form_enter_password']}">{$lang->form_enter_password}</span>
						{elseif $error == 'user_exists'}
							<span data-language="{$translate_id['register_user_registered']}">{$lang->register_user_registered}</span>
						{else}
							{$error}
						{/if}
					</div>
				{/if}

				{* Имя пользователя *}
				<div class="form-group">
					<input class="form-control" data-format=".+" data-notice="{$lang->form_enter_name}" value="{$name|escape}" name="name" type="text" data-language="{$translate_id['form_name']}" placeholder="{$lang->form_name}*"/>
				</div>

				{* Почта пользователя *}
				<div class="form-group">
					<input class="form-control" data-format="email" data-notice="{$lang->form_enter_email}" value="{$email|escape}" name="email" type="text" data-language="{$translate_id['form_email']}" placeholder="{$lang->form_email}*"/>
				</div>

                <div class="form-group">
                    <input class="form-control" value="{$phone|escape}" name="phone" type="text" data-language="{$translate_id['form_phone']}" placeholder="{$lang->form_phone}"/>
                </div>
                <div class="form-group">
                    <input class="form-control" value="{$address|escape}" name="address" type="text" data-language="{$translate_id['form_address']}" placeholder="{$lang->form_address}"/>
                </div>

				{* Пароль пользователя *}
				<div class="input-group m-b-1">
				<span class="input-group-btn">
					<button class="btn btn-success" type="button" onclick="$('#password').toggle();return false;" data-language="{$translate_id['user_change_password']}">{$lang->user_change_password}</button>
				</span>
					<input class="form-control" id="password" value="" name="password" type="password" style="display:none;"/>
				</div>

				{* Кнопка отправки формы *}
				<div class="clearfix">
					<input type="submit" class="btn btn-warning" data-language="{$translate_id['form_save']}" value="{$lang->form_save}">
					<a href="{$lang_link}user/logout" class="btn btn-danger pull-xs-right" data-language="{$translate_id['user_logout']}">{$lang->user_logout}</a>
				</div>
			</form>
		</div>
		{* История заказов *}
		{if $orders}
			<div class="col-lg-7 m-t-1-md_down">
				<table class="table bg-info">
					<thead>
						<tr>
							<th>
								<span data-language="{$translate_id['user_number_of_order']}">{$lang->user_number_of_order}</span>
							</th>
							<th>
								<span data-language="{$translate_id['user_order_date']}">{$lang->user_order_date}</span>
							</th>
							<th>
								<span data-language="{$translate_id['user_order_status']}">{$lang->user_order_status}</span>
							</th>
						</tr>
					</thead>
					{foreach $orders as $order}
						<tr>
							{* Номер заказа *}
							<td>
								<a href='{$language->label}/order/{$order->url}'><span data-language="{$translate_id['user_order_number']}">{$lang->user_order_number}</span>{$order->id}</a>
							</td>

							{* Дата заказа *}
							<td>{$order->date|date}</td>

							{* Статус заказа *}
							<td>
								{if $order->paid == 1}
									<span data-language="{$translate_id['status_paid']}">{$lang->status_paid}</span>,
								{/if}
								{if $order->status == 0}
									<span data-language="{$translate_id['status_pending']}">{$lang->status_pending}</span>
								{elseif $order->status == 1}
									<span data-language="{$translate_id['status_processing']}">{$lang->status_processing}</span>
								{elseif $order->status == 2}
									<span data-language="{$translate_id['status_made']}">{$lang->status_made}</span>
								{/if}
							</td>
						</tr>
					{/foreach}
				</table>
			</div>
		{/if}
	</div>
</div>