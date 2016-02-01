<!DOCTYPE html>
<html>
<head>
	{* Полный базовый адрес *}
	<base href="{$config->root_url}/"/>

	{* Тайтл страницы *}
	<title>{$meta_title|escape}{$filter_meta->title|escape}</title>

	{* Метатеги *}
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<meta name="description" content="{$meta_description|escape}{$filter_meta->description|escape}"/>
	<meta name="keywords" content="{$meta_keywords|escape}{$filter_meta->keywords|escape}"/>
	{if $module == 'ProductsView' && $set_canonical}
		<meta name="robots" content="noindex,nofollow"/>
	{else}
    	<meta name="robots" content="index,follow"/>
	{/if}
	<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0"/>
    <meta name="generator" content="OkayCMS {$config->version}"/>

	{* Изображения товара и поста для соц. сетей *}
	{if $module == 'ProductView'}
		<meta property="og:url" content="{$config->root_url}{if $lang_link}/{str_replace('/', '', $lang_link)}{/if}{$canonical}"/>
		<meta property="og:type" content="article"/>
		<meta property="og:title" content="{$product->name|escape}"/>
		<meta property="og:image" content="{$product->image->filename|resize:330:300}"/>
		<meta property="og:description" content='{$product->annotation}'/>
		<link rel="image_src" href="{$product->image->filename|resize:330:300}"/>
	{elseif $module == 'BlogView'}
		<meta property="og:url" content="{$config->root_url}{if $lang_link}/{str_replace('/', '', $lang_link)}{/if}{$canonical}"/>
		<meta property="og:type" content="article"/>
		<meta property="og:title" content="{$post->name|escape}"/>
		<meta property="og:image" content="{$post->image|resize:400:300:false:$config->resized_blog_dir}"/>
		<meta property="og:description" content='{$post->annotation}'/>
		<link rel="image_src" href="{$post->image|resize:400:300:false:$config->resized_blog_dir}"/>
	{/if}

	{* Канонический адрес страницы *}
	{if isset($canonical)}
        <link rel="canonical" href="{$config->root_url}{if $lang_link}/{str_replace('/', '', $lang_link)}{/if}{$canonical}"/>
    {/if}

	{* Языковый атрибут *}
    {foreach $languages as $l}
		{if $l->enabled}
            <link rel="alternate" hreflang="{$l->label}" href="{$config->root_url}/{$l->url}"/>
		{/if}
	{/foreach}

	{* Иконка сайта *}
	<link href="design/{$settings->theme}/images/favicon.png" type="image/x-icon" rel="icon"/>
	<link href="design/{$settings->theme}/images/favicon.png" type="image/x-icon" rel="shortcut icon"/>

	{* JQuery *}
	<script src="design/{$settings->theme}/js/jquery-2.1.4.min.js"></script>

	{* JQuery UI *}
	{* Библиотека с "Slider", "Transfer Effect" *}
	<script src="design/{$settings->theme}/js/jquery-ui.min.js"></script>

	{* Fancybox *}
	<script src="design/{$settings->theme}/js/jquery.fancybox.min.js"></script>

	{* Autocomplete *}
	<script src="design/{$settings->theme}/js/jquery.autocomplete-min.js"></script>

	{* slick slider *}
	<script src="design/{$settings->theme}/js/slick.min.js"></script>

	{* Контакты, подключение библиотеки для Yandex карт *}
	{if $smarty.get.module == 'FeedbackView'}
		<script src="//api-maps.yandex.ru/2.1/?lang={$language->label}_{if $language->label == "ru"}RU{elseif $language->label == "en"}US{elseif $language->label == "uk"}UA{/if}"></script>
	{/if}

	{* Карточка товаров, поделиться в соц. сетях *}
	{if $smarty.get.module == 'ProductView'}
		<script type="text/javascript" src="//yastatic.net/es5-shims/0.0.2/es5-shims.min.js"></script>
		<script type="text/javascript" src="//yastatic.net/share2/share.js"></script>
	{/if}

	{* Стили *}
	<link href="design/{$settings->theme|escape}/css/bootstrap.css" rel="stylesheet"/>
	<script src="design/{$settings->theme|escape}/js/bootstrap.min.js"></script>

	{* Okay *}
	{include file="scripts.tpl"}
	<script src="design/{$settings->theme}/js/okay.js"></script>

	{* Всплывающие подсказки для администратора *}
	{if $smarty.session.admin == 'admin'}
		<script src ="design/{$settings->theme}/js/admintooltip.js"></script>
	{/if}

	{* js-проверка форм *}
	<script src="design/{$settings->theme}/js/baloon.js"></script>
</head>
<body>
<div class="border-b-1-info">
	<div class="container">
		{* Кнопка меню для моб. *}
		<button class="i-mob-menu" data-target="#mob-menu" data-toggle="collapse" type="button" aria-expanded="false">
			&#9776;
		</button>
		{* @END Кнопка меню для моб. *}
		{* Меню сайта *}
		<ul id="mob-menu" class="nav nav-inline pull-xs-left nav-mob collapse">
			{foreach $pages as $p}
				{if $p->menu_id == 1}
					<li class="nav-item">
						<a class="nav-link" data-page="{$p->id}" href="{$lang_link}{$p->url}">{$p->name|escape}</a>
					</li>
				{/if}
			{/foreach}
		</ul>
		{* @END Меню сайта *}
		<ul class="nav nav-inline pull-xs-right">
			{* Выбор языка *}
			{if $languages|count > 1}
				<li class="nav-item">
					<div class="btn-group">
						<a data-languages="true" class="nav-link link-black i-lang" href="#" data-toggle="dropdown" aria-haspopup="true"
						   aria-expanded="false"><span class="lang-label">{$language->label}</span><span
									class="lang-name">{$language->name}</span></a>
						<div class="dropdown-menu">
							{foreach $languages as $l}
								{if $l->enabled}
									<a class="dropdown-item{if $language->id == $l->id} active{/if}"
									   href="{$l->url}"><span class="lang-label">{$l->label}</span><span
												class="lang-name">{$l->name}</span></a>
								{/if}
							{/foreach}
						</div>
					</div>
				</li>
			{/if}
			{* @END Выбор языка *}
			{* Информер сравнения *}
			<li id="comparison" class="nav-item hidden-md-down">
				{include "comparison_informer.tpl"}
			</li>
			{* Информер сравнения *}
			{* Информер избранного *}
			<li id="wishlist" class="nav-item">
				{include file="wishlist_informer.tpl"}
			</li>
			{* Информер избранного *}
			{if $user}
				{* Личный кабинет *}
				<li class="nav-item">
					<a class="nav-link link-black i-user" href="{$lang_link}user">{$user->name}</a>
				</li>
				{* @END Личный кабинет *}
			{else}
				{* Вход *}
				<li class="nav-item">
					<a class="nav-link link-black i-user" href="{$lang_link}user/login"><span data-language="{$translate_id['index_login']}">{$lang->index_login}</span></a>
				</li>
				{* @END Вход *}
			{/if}
		</ul>
	</div>
</div>

<div class="container m-y-1">
	<div class="row">
		{* Логотип сайта *}
		<div class="col-xs-6 col-lg-3 text-md-right p-r-0-md_down">
			<a href="{$lang_link}">
				<img class="img-fluid" src="design/{$settings->theme|escape}/images/logo{if $language->label}_{$language->label}{/if}.png" alt="{$settings->site_name|escape}"/>
			</a>
		</div>
		{* @END Логотип сайта *}
		{* Информер корзины *}
		<div id="cart_informer" class="col-xs-6 col-lg-2 pull-lg-right">
			{include file='cart_informer.tpl'}
		</div>
		{* @END Информер корзины *}
		{* Форма поиска *}
		<div class="col-xs-12 col-lg-3 m-y-1-md_down">
			<form id="fn-search" class="input-group" action="{$lang_link}all-products">
				<input class="fn-search okaycms form-control" type="text" name="keyword" value="{$keyword|escape}" data-language="{$translate_id['index_search']}" placeholder="{$lang->index_search}"/>
				<span class="input-group-btn">
					<button class="i-search" type="submit"></button>
				</span>
			</form>
		</div>
		{* @END Форма поиска *}
		{* Телефоны *}
		<div class="col-xs-8 col-lg-2 p-l-0 p-l-1-md_down">
			<div class="i-phone h5 font-weight-bold">
				<div><a class="link-black" href="tel:08003215476">0 800 321-54-76</a></div>
				<div><a class="link-black" href="tel:08003215476">0 800 321-54-76</a></div>
			</div>
		</div>
		{* @END Телефоны *}
		{* Обратный звонок *}
		<div class="col-xs-4 col-lg-2 p-l-0-md_down">
			<a class="btn btn-sm btn-block btn-warning font-weight-bold i-callback fn-callback okaycms" href="#fn-callback" data-language="{$translate_id['index_back_call']}">{$lang->index_back_call}</a>
		</div>
		{* @END Обратный звонок *}
	</div>
</div>
{* Категории товаров *}
{function name=categories_tree}
	{if $categories}
		{* Первая итерация *}
		{if $level == 1}
			<div class="container p-x-0_md-down m-b-1">
				<div class="border-b-1-white hidden-lg-up">
					<button class="text-sm-center btn btn-block brad-0 btn-primary dropdown-toggle" type="button" data-toggle="collapse" data-target="#catalog" aria-expanded="false" aria-controls="catalog">{$lang->index_catalog}</button>
					</div>
				<nav class="navbar navbar-dark bg-primary">
					<ul id="catalog" class="nav navbar-nav collapse">
		{* Последующие итерации *}
		{else}
			<ul id="{$parent_id}" class="navbar-sub collapse{if $two_col} two-col{/if}">
		{/if}
						{foreach $categories as $c}
							{if $c->visible}
								{if $c->subcategories && $level == 1}
									<li class="nav-item">
									<button class="btn-category-collapse collapsed" type="button" data-toggle="collapse" data-target="#{$c->id}" aria-expanded="false" aria-controls="{$c->id}"></button>
										<a class="nav-link" href="{$lang_link}catalog/{$c->url}" data-category="{$c->id}">{$c->name|escape}</a>
										{if $c->subcategories|count > 1}
											{categories_tree categories=$c->subcategories level=$level + 1 parent_id=$c->id two_col=true}
										{else}
											{categories_tree categories=$c->subcategories level=$level + 1 parent_id=$c->id}
										{/if}
									</li>
								{else}
									<li class="nav-item">
										<a class="nav-link" href="{$lang_link}catalog/{$c->url}" data-category="{$c->id}">{$c->name|escape}</a>
									</li>
								{/if}
							{/if}
						{/foreach}
		{* Первая итерация *}
		{if $level == 1}
					</ul>
				</nav>
			</div>
		{* Последующие итерации *}
		{else}
			</ul>
		{/if}

	{/if}
{/function}
{categories_tree categories=$categories level=1}
{* @END Категории товаров *}
{* Баннер *}
{get_banner var=banner1 group=1}
{if $banner1->items}
	<div class="container hidden-md-down">
		<div class="fn-slick-banner okaycms slick-banner">
			{foreach $banner1->items as $bi}
				<div>
					{if $bi->url}
						<a href="{$bi->url}" target="_blank">
					{/if}
					{if $bi->image}
						<img src="{$config->banners_images_dir}{$bi->image}" alt="{$bi->alt}" title="{$bi->title}"/>
					{/if}
					<span class="slick-name">
						{$bi->name}
					</span>
					{if $bi->description}
						<span class="slick-description">
							{$bi->description}
						</span>
					{/if}
					{if $bi->url}
						</a>
					{/if}
				</div>
			{/foreach}
		</div>
	</div>
{/if}
{* Баннер *}
{* Тело сайта *}
<div id="fn-content">
	{$content}
</div>
{* @END Тело сайта *}
{* Футер сайта *}
<div class="bg-blue p-y-1">
	<div class="container">
		<div class="row text-white">
			{* Меню сайта *}
			<div class="col-xs-6 col-lg-3 l-h-1_7 m-b-1-md_down">
				<div class="h5">
					<span data-language="{$translate_id['index_about_store']}">{$lang->index_about_store}</span>
				</div>
				{foreach $pages as $p}
					{* Выводим только страницы из первого меню *}
					{if $p->menu_id == 1}
						<div class="p-l-1">
							<a class="link-white" href="{$lang_link}{$p->url}">{$p->name|escape}</a>
						</div>
					{/if}
				{/foreach}
			</div>
			{* @END Меню сайта *}
			{* Каталог *}
			<div class="col-xs-6 col-lg-3 l-h-1_7 m-b-1-md_down">
				<div class="h5">
					<span data-language="{$translate_id['login_enter']}">{$lang->index_catalog}</span>
				</div>
				{foreach $categories as $c}
					<div class="p-l-1">
						<a class="link-white" href="{$lang_link}catalog/{$c->url}">{$c->name|escape}</a>
					</div>
				{/foreach}
			</div>
			{* @END Каталог *}
			{* Контакты *}
			<div class="col-xs-6 col-lg-3 l-h-1_7">
				<div class="h5">
					<span data-language="{$translate_id['index_contacts']}">{$lang->index_contacts}</span>
				</div>
				<div class="p-l-1" data-language="{$translate_id['index_contacts_body']}">{$lang->index_contacts_body}</div>
			</div>
			{* @END Контакты *}
			{* Соц. сети *}
			<div class="col-xs-6 col-lg-3">
				<div class="h5">
					<span data-language="{$translate_id['index_in_networks']}">{$lang->index_in_networks}</span>
				</div>
				<div>
					<a class="i-soc i-fb" href="{$lang_link}#" target="_blank"></a>
					<a class="i-soc i-vk" href="{$lang_link}#" target="_blank"></a>
					<a class="i-soc i-tw" href="{$lang_link}#" target="_blank"></a>
				</div>
				{* Подписка на емейл рассылку *}
				<div id="subscribe_container">
					<div class="subscribe-title">{$lang->index_subscribe}</div>
					<form method="post">
						<input type="hidden" name="subscribe" value="1"/>
						<input class="form-control subscribe-control form-control-sm" type="text" name="subscribe_email" value="" data-format="email" data-notice="{$lang->form_enter_email}" placeholder="{$lang->form_email}"/>
						<input class="btn btn-warning btn-block" type="submit" value="{$lang->index_to_subscribe}"/>
						{if $subscribe_error}
							<div id="subscribe_error" class="p-x-1 p-y-05 bg-danger text-white m-t-1">
								{if $subscribe_error == 'email_exist'}
									<span data-language="{$translate_id['index_subscribe_sent']}">{$lang->index_subscribe_already}</span>
								{/if}
								{if $subscribe_error == 'empty_email'}
									<span data-language="{$translate_id['form_enter_email']}">{$lang->form_enter_email}</span>
								{/if}
							</div>
						{/if}
						{if $subscribe_success}
							<div class="hidden-xs-up">
								<div id="fn-subscribe-sent" class="bg-info p-a-1">
									<div data-language="{$translate_id['index_subscribe_sent']}">{$lang->index_subscribe_sent}</div>
								</div>
							</div>
						{/if}
					</form>
				</div>
				{* @END Подписка на емейл рассылку *}
			</div>
			{* Соц. сети *}
		</div>
	</div>
</div>
{* @END Футер сайта *}
{* Копирайт *}
<div class="container p-y-1">
	<a class="link-black" href="http://okay-cms.com" target="_blank">© 2015. <span data-language="{$translate_id['index_copyright']}">{$lang->index_copyright}</span></a>
</div>
{* @END Копирайт *}
{* Форма обратного звонка *}
{include file='callback.tpl'}
{* Форма обратного звонка *}
</body>
</html>