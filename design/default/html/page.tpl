{* Шаблон текстовой страницы *}
{* Канонический адрес страницы *}
{$canonical="/{$page->url}" scope=parent}
<div class="container">
	{* Хлебные крошки *}
	{include file='breadcrumb.tpl'}

	{* Заголовок страницы *}
	<h1 class="m-b-1"><span data-page="{$page->id}">{$page->header|escape}</span></h1>

	{* Тело страницы *}
	{$page->body}
</div>