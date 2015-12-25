<!DOCTYPE html>
{*
	Общий вид страницы
	Этот шаблон отвечает за общий вид страниц без центрального блока.
*}
<html>
<head>
	<base href="{$config->root_url}/"/>
	<title>{$meta_title|escape}{$filter_meta->title|escape}</title>
	
	{* Метатеги *}
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="description" content="{$meta_description|escape}{$filter_meta->description|escape}" />
	<meta name="keywords"    content="{$meta_keywords|escape}{$filter_meta->keywords|escape}" />
    <meta name="robots" content="index,follow"/>
	<meta name="viewport" content="width=1170"/>
    <meta name="generator" content="OkayCMS {$config->version}" />
	
	{* Канонический адрес страницы *}
	{if isset($canonical)}<link rel="canonical" href="{$config->root_url}{if $lang_link}/{str_replace('/', '', $lang_link)}{/if}{$canonical}"/>{/if}
    {foreach $languages as $l}
		{if $l->enabled}
            <link rel="alternate" hreflang="{$l->label}" href="{$config->root_url}/{$l->url}" />
		{/if}
	{/foreach}
	
	{* Стили *}
	<link rel="stylesheet" href="js/fancybox/jquery.fancybox.css" type="text/css" media="screen" />
    <link href="design/{$settings->theme|escape}/css/style.css" rel="stylesheet" type="text/css" media="screen"/>

	<link href="design/{$settings->theme|escape}/images/favicon.png" rel="icon"          type="image/x-icon"/>
	<link href="design/{$settings->theme|escape}/images/favicon.png" rel="shortcut icon" type="image/x-icon"/>


	
	{* JQuery *}
	<script src="design/{$settings->theme}/js/jquery-2.1.4.min.js"></script>
    <script src="design/{$settings->theme}/js/jquery-ui.min.js"></script>
    <script src="design/{$settings->theme}/js/jquery-migrate-1.2.1.min.js"></script>

	{* Okay *}
	<script src="design/{$settings->theme}/js/custom.js"></script>
	<script src="design/{$settings->theme}/js/okay.js"></script>

	{* Выравнивание по высоте *}
	<script src="design/{$settings->theme}/js/jquery.matchHeight.js"></script>

	{* Fancybox *}
	<script type="text/javascript" src="js/fancybox/jquery.fancybox.pack.js"></script>


	
	{* Всплывающие подсказки для администратора *}
	{if $smarty.session.admin == 'admin'}
	<script src ="js/admintooltip/admintooltip.js" type="text/javascript"></script>
	<link   href="js/admintooltip/css/admintooltip.css" rel="stylesheet" type="text/css" /> 
	{/if}
	
	{* js-проверка форм *}
	<script src="js/baloon/js/baloon.js" type="text/javascript"></script>
	<link   href="js/baloon/css/baloon.css" rel="stylesheet" type="text/css" />

    <link href="js/slick/slick.css" rel="stylesheet" type="text/css" media="screen"/>
    <link href="js/slick/slick-theme.css" rel="stylesheet" type="text/css" media="screen"/>
    <script src="js/slick/slick.min.js"></script>
	

	{* Автозаполнитель поиска *}
	{literal}
	<script src="js/autocomplete/jquery.autocomplete-min.js" type="text/javascript"></script>
	<style>
		.autocomplete-suggestions{
		background-color: #ffffff;
		overflow: hidden;
		border: 1px solid #e0e0e0;
		overflow-y: auto;
		}
		.autocomplete-suggestions .autocomplete-suggestion{cursor: default;}
		.autocomplete-suggestions .selected { background:#F0F0F0; }
		.autocomplete-suggestions div { padding:2px 5px; white-space:nowrap; }
		.autocomplete-suggestions strong { font-weight:normal; color:#3399FF; }
	</style>	
	<script>
	$(function() {
		//  Автозаполнитель поиска
		$(".input_search").autocomplete({
			serviceUrl:'ajax/search_products.php',
			minChars:1,
			noCache: false, 
			onSelect:
				function(suggestion){
					 $(".input_search").closest('form').submit();
				},
			formatResult:
				function(suggestion, currentValue){
					var reEscape = new RegExp('(\\' + ['/', '.', '*', '+', '?', '|', '(', ')', '[', ']', '{', '}', '\\'].join('|\\') + ')', 'g');
					var pattern = '(' + currentValue.replace(reEscape, '\\$1') + ')';
	  				return (suggestion.data.image?"<img align=absmiddle src='"+suggestion.data.image+"'> ":'') +"<a href="+suggestion.lang+"products/"+suggestion.data.url+'>'+suggestion.value.replace(new RegExp(pattern, 'gi'),  '<strong>$1<\/strong>')+'<\/a>';
                }
		});
	});
	</script>
	{/literal}
		
	<script>
    var lang_id = {if $language->id}{$language->id}{else}0{/if};
	</script>
    
    {if $module=='ProductView'}
		<script src="design/{$settings->theme}/js/rate.js"></script>
        {literal}
            <script>
                $(function() {
                    $('.product_rating').rater({ postHref: 'ajax/rating.php' }); 
                });
            </script>
        {/literal}
    {/if}
    
    <!-- Предзаказ -->
    <script>
        var is_preorder = {$settings->is_preorder},
            max_order_amount = {$settings->max_order_amount};
    </script>
 
</head>
<body  {if $module == 'MainView'}class="home"{/if}>
	<header>
		<div id="header_top">
			<div class="container">
				<!-- Меню -->
				<ul id="menu">
					{foreach $pages as $p}
						{* Выводим только страницы из первого меню *}
						{if $p->menu_id == 1}
						<li {if $page && $page->id == $p->id}class="selected"{/if}>
							<a data-page="{$p->id}" href="{$lang_link}{$p->url}">{$p->name|escape}</a>
						</li>
						{/if}
					{/foreach}
				</ul>
				<!-- Меню (The End) -->

				<div id="user_block">
					<!-- Обратный звонок -->
					<div class="call_wrap">
						<a class="callback_link" href="#callback_form">Обратный звонок</a>
					</div>
					<!-- Обратный звонок (The End)-->
					
					<!-- Информер Избранное -->
					<div id="wishlist">{include file="wishlist_informer.tpl"}</div>
					<!-- Информер Избранное (The End)-->

					<!-- Логин и регистрация -->
					<div id="account">
						{if $user}
							<a id="username" href="{$lang_link}user">{$user->name}</a>
							<a id="logout" href="{$lang_link}user/logout">Выйти</a>
						{else}
							<a id="register" href="{$lang_link}user/register">Регистрация</a>
							<a id="login" href="{$lang_link}user/login">Вход</a>
						{/if}
					</div>
					<!-- Логин и регистрация (The End)-->

					<!-- Выбор валюты -->
					{* Выбор валюты только если их больше одной *}
					{if $currencies|count>1}
					<div id="currencies">
						<div class="current drop"><span>{$currency->sign|escape}</span></div>
						<ul class="dropdown">
							{foreach $currencies as $c}
							{if $c->enabled} 
							<li class="{if $c->id==$currency->id}selected{/if}"><a href='{url currency_id=$c->id}'>{$c->sign|escape}</a></li>
							{/if}
							{/foreach}
						</ul>
					</div> 
					{/if}
					<!-- Выбор валюты (The End) -->	

					<!-- Выбор языка -->	
		            {*if $languages}
		            <div id="languages">
		            	<div class="current drop"><span>{$language->label}</span></div>
		            	<ul class="dropdown">
			                {foreach $languages as $l}
						    {if $l->enabled}    
						    	<li class="language {if $language->id==$l->id}selected{/if}"><a href="{$l->url}" {if $language->id == $l->id}class="lang-active"{/if}>{$l->label}</a></li>
						    {/if}
			                {/foreach}
		                </ul>
	                </div>
		            {/if*}
		            <!-- Выбор языка (The End) -->	
				</div>
			</div>
		</div>

		<div class="container">
			<div id="header_center" class="clearfix">
				<!-- Логотип-->
				<div id="logo">
					<a href="{$lang_link}">
						<img src="design/{$settings->theme|escape}/images/logo{if $language->label}_{$language->label}{/if}.png" title="{$settings->site_name|escape}" alt="{$settings->site_name|escape}"/>
					</a>
				</div>
				<!-- Логотип (The End) -->
	     		
	     		<!-- Телефоны -->
				<div id="top_contact">
					<span class="phone">+7(915) 12-34-56</span>
					<span class="phone">+7(915) 65-43-21</span>
				</div>	
				<!-- Телефоны (The End) -->

				<!-- Корзина -->
				<div id="cart_informer">
					{* Обновляемая аяксом корзина должна быть в отдельном файле *}
					{include file='cart_informer.tpl'}
				</div>
				<!-- Корзина (The End)-->

				<!-- Поиск-->
				<div id="search">
					<form action="{$lang_link}all-products">
						<input class="input_search" type="text" name="keyword" value="{$keyword|escape}" placeholder="Поиск товара"/>
						<button class="button_search" type="submit"></button>
					</form>
				</div>
				<!-- Поиск (The End)-->
			</div>
		</div>
	</header>

	{if $module == 'MainView'}
		<!-- Баннеры -->
		<div id="main_banner">
	        {get_banner var=banner1 group=1}
			{if $banner1->items}
				<div class="banner banner1">
					{foreach $banner1->items as $bi}
						<div>
							{if $bi->url}
								<a href="{$bi->url}" target="_blank">
							{/if}
							{if $bi->image}
								<img src="{$config->banners_images_dir}{$bi->image}" alt="{$bi->alt}" title="{$bi->title}"/>
							{else}
								{$bi->description}
							{/if}
							{if $bi->url}
								</a>
							{/if}
						</div>
					{/foreach}
				</div>
			{/if}
		</div>
		<!-- Баннеры (The End) -->

		<!-- Блок преимущества -->	
		<div id="advantages">
			<div class="container">
				<div class="row">
					<div class="advantage_1 column col_4">
						<div class="a_icon"></div>
						<span class="advantage_name">Бесплатная доставка</span>
						<p>Бесплатная доставка за заказ свыше 1000 руб</p>
					</div>
					<div class="advantage_2 column col_4">
						<div class="a_icon"></div>
						<span class="advantage_name">Субботние скидки</span>
						<p>Экономьте до 30% на субботних распродажах</p>
					</div>
					<div class="advantage_3 column col_4">
						<div class="a_icon"></div>
						<span class="advantage_name">Подарок за заказ</span>
						<p>Получайте подарок за заказ свыше 3000руб</p>
					</div>
				</div>
			</div>
		</div>
		<!-- Блок преимущества (The End) -->
	{/if}

	{include file='path.tpl'}
	
	<!-- Вся страница --> 
	<div id="main" class="container">
			<div class="row">	
				<!-- Левый сайдбар -->	
				<div id="left" class="column col_3">
					{include file='sidebar.tpl'}
            	</div>
            	<!-- Левый сайдбар (The End)-->	

				<!-- Основная часть --> 
				<div id="content" class="column col_9">
					{$content}
	         	</div>
         	</div>

         	{if $module == 'MainView'}
         	<div class="row">
         		<div class="column col_12">
		         	{* Тело страницы *}
					{if $page->body}
    					<div class="block text_block">
    						{* Заголовок страницы *}
    						<div class="h1">{$page->header}</div>
    						{$page->body}
    					</div>
					{/if}

	         		<!-- Меню блога -->
					{* Выбираем в переменную $last_posts последние записи *}
					{get_posts var=last_posts limit=5}
					{if $last_posts}
					<div id="blog_menu" class="block">
						<ul class="row">
						{foreach $last_posts as $post}
							<li class="column col_4" data-post="{$post->id}">
								<div class="block_heading">
								<a href="{$lang_link}blog/{$post->url}">{$post->name|escape}</a>
								</div>
								{if $post->image}
								<div class="post_img">
									<a href="{$lang_link}blog/{$post->url}">
					            		<img src="{$post->image|resize:140:140:false:$config->resized_blog_dir}" />
									</a>
				        		</div>
				        		{/if}
								
								<span class="post_date">{$post->date|date}</span> 
								<div class="text_container">
									{$post->annotation}
								</div>
							</li>
						{/foreach}
						</ul>
					</div>
					{/if}
					<!-- Меню блога  (The End) --> 

		         	<!-- Все бренды -->
					{* Выбираем в переменную $all_brands все бренды *}
					{get_brands var=all_brands}
					{if $all_brands}
					<div class="block no_bottom">
						<div class="block_heading">Бренды</div>
						<div id="all_brands">	
							{foreach $all_brands as $b}	
								{if $b->image}
								<a href="{$lang_link}brands/{$b->url}"><img src="{$b->image|resize:100:100:false:$config->resized_brands_dir}" alt="{$b->name|escape}"></a>
								{else}
								<a href="{$lang_link}brands/{$b->url}">{$b->name}</a>
								{/if}
							{/foreach}
						</div>
					</div>
					{/if}
					<!-- Все бренды (The End)-->
				</div>
			</div>
			{/if}			
	</div>
	<!-- Вся страница (The End)--> 
	 
	<!-- Футер -->
	<footer id="footer">
		<div class="container">
			<!-- Подписка на емейл рассылку -->
			<div id="subscribe_container">
				<span class="subscribe_heading">Хотите подписаться на нашу рассылку?</span>
	            <form method="post">
	                <input type="hidden" name="subscribe" value="1" />
	                <input class="subscribe_input" type="text" name="subscribe_email" value="" data-format="email" data-notice="Введите email" placeholder="Введите email"/>
	                <input class="button" type="submit" value="Подписаться"/>

	                {if $subscribe_error}
    	            	<div class="message_error">
    	            		{if $subscribe_error == 'email_exist'}Вы уже подписаны{/if}
    	            		{if $subscribe_error == 'empty_email'}Введите email{/if}
    	            	</div>
	            	{/if}
	                {if $subscribe_success}
    	                <script>

    	                    $(function() {
    	                        alert('Вы были успешно подписаны');
    	                    });
    	                </script>
	                {/if}

	            </form>
            </div>
            <!-- Подписка на емейл рассылку The End) -->

            <div id="footer_center">
	            <!-- Меню в футере-->
				<ul id="footer_menu">
					{foreach $pages as $p}
						{* Выводим только страницы из первого меню *}
						{if $p->menu_id == 1}
    						<li {if $page && $page->id == $p->id}class="selected"{/if}>
    							<a data-page="{$p->id}" href="{$lang_link}{$p->url}">{$p->name|escape}</a>
    						</li>
						{/if}
					{/foreach}
				</ul>
				<!-- Меню в футере(The End) -->

				<!-- Платежные системы-->
				<div id="payments">
					<div class="payment_1"></div>
					<div class="payment_2"></div>
					<div class="payment_3"></div>
					<div class="payment_4"></div>
				</div>
				<!-- Платежные системы(The End) -->
			</div>

			<div id="copyright">
				<span>Okay &copy; 2015</span> 
				<a href="http://okay-cms.com" target="_blank">E-commerce software by Okay</a>
			</div>	
		</div>
	</footer>
	<!-- Футер (The End)--> 

	{include file='callback.tpl'}
</body>
</html>