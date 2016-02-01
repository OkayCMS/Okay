{* Шаблон текстовой страницы *}
{* Канонический адрес страницы *}
{$canonical="/{$page->url}" scope=parent}
{* @END Канонический адрес страницы *}
<div class="container">
	{* Хлебные крошки *}
	{include file='breadcrumb.tpl'}
	{* @END Хлебные крошки *}
	{* Заголовок страницы *}
	<h1 class="m-b-1"><span data-page="{$page->id}">{$page->header|escape}</span></h1>
	{* @END Заголовок страницы *}
	{* Тело страницы *}
	{$page->body}
	{* @END Тело страницы *}
</div>