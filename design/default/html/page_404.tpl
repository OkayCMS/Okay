{* Шаблон текстовой страницы 404 *}
<div class="container">
    {* Хлебные крошки *}
    {include file='breadcrumb.tpl'}

    {* Заголовок страницы *}
    <h1 class="m-b-1"><span data-page="{$page->id}">{$page->header|escape}</span></h1>

    {* Тело страницы *}
    <div>
        {$page->body}
    </div>
</div>