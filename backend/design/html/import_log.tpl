{* Вкладки *}
{capture name=tabs}
    <li>
        <a href="index.php?module=ImportAdmin">Импорт</a>
    </li>
    {if in_array('export', $manager->permissions)}
        <li>
            <a href="index.php?module=ExportAdmin">Экспорт</a>
        </li>
    {/if}
    {if in_array('import', $manager->permissions)}
        <li>
            <a href="index.php?module=MultiImportAdmin">Импорт переводов</a>
        </li>
    {/if}
    {if in_array('export', $manager->permissions)}
        <li>
            <a href="index.php?module=MultiExportAdmin">Экспорт переводов</a>
        </li>
    {/if}
    <li class="active">
        <a href="index.php?module=ImportLogAdmin">Лог импорта</a>
    </li>
{/capture}
{* Title *}
{$meta_title='Лог импорта товаров' scope=parent}

{* Поиск *}
<form method="get">
    <div id="search">
        <input type="hidden" name="module" value="ImportLogAdmin">
        <input class="search" type="text" name="keyword" value="{$keyword|escape}" />
        <input class="search_button" type="submit" value=""/>
    </div>
</form>

{* Заголовок *}
<div id="header">
    {if $logs_count}
        {if $keyword}
            <h1>{$logs_count|plural:'Найден':'Найдено':'Найдено'} {$logs_count} {$logs_count|plural:'товар':'товаров':'товара'}</h1>
        {else}
            <h1>{$logs_count} {$logs_count|plural:'товар':'товаров':'товара'}</h1>
        {/if}
    {else}
        <h1>Лог пуст</h1>
    {/if}
</div>

<div id="main_list">

    {if $logs}
        {include file='pagination.tpl'}
        <div class="limit_show">
            <span>Показывать по: </span>
            <select onchange="location = this.value;">
                <option value="{url limit=25}" {if $current_limit == 25}selected{/if}>25</option>
                <option value="{url limit=50}" {if $current_limit == 50}selected{/if}>50</option>
                <option value="{url limit=100}" {if $current_limit == 100}selected{/if}>100</option>
                <option value="{url limit=200}" {if $current_limit == 200}selected{/if}>200</option>
                <option value="{url limit=500}" {if $current_limit == 500}selected{/if}>500</option>
            </select>
        </div>

        {* Основная форма *}
        <form id="list_form" method="post">
            <input type="hidden" name="session_id" value="{$smarty.session.id}">
            <div id="list" class="catalog">
                {foreach $logs as $log}
                    <div class="row">
                        <div class="import_result cell">
                            <span class="status {$log->status}" title="{$log->status}"></span>
                        </div>
                        <div class="image cell">
                            {$image = $log->product->images|@first}
                            {if $image}
                                <a href="{url module=ProductAdmin id=$log->product_id return=$smarty.server.REQUEST_URI}" target="_blank">
                                    <img src="{$image->filename|escape|resize:35:35}"/>
                                </a>
                            {else}
                                <img height="35" width="35" src="design/images/no_image.png"/>
                            {/if}
                        </div>
                        <div class="name product_name cell">
                            <a href="{url module=ProductAdmin id=$log->product_id return=$smarty.server.REQUEST_URI}" target="_blank">{$log->product_name|escape}</a>
                            {if $log->variant_name}<span>({$log->variant_name|escape})</span>{/if}
                        </div>
                        <div class="icons cell products">
                        </div>
                        <div class="clear"></div>
                    </div>
                {/foreach}
            </div>
        </form>

        {*Пагинация*}
        {include file='pagination.tpl'}
        {*Пагинация END*}
        <div class="limit_show">
            <span>Показывать по: </span>
            <select onchange="location = this.value;">
                <option value="{url limit=25}" {if $current_limit == 25}selected{/if}>25</option>
                <option value="{url limit=50}" {if $current_limit == 50}selected{/if}>50</option>
                <option value="{url limit=100}" {if $current_limit == 100}selected{/if}>100</option>
                <option value="{url limit=200}" {if $current_limit == 200}selected{/if}>200</option>
                <option value="{url limit=500}" {if $current_limit == 500}selected{/if}>500</option>
            </select>
        </div>
    {/if}
</div>

{*Меню*}
<div id="right_menu">
    {*Фильтр*}
    <ul class="filter_right">
        <li {if !$filter}class="selected"{/if}>
            <a href="{url keyword=null page=null limit=null filter=null}">Все</a>
        </li>
        <li {if $filter=='added'}class="selected"{/if}>
            <a href="{url keyword=null page=null limit=null filter='added'}">Добавлены</a>
        </li>
        <li {if $filter=='updated'}class="selected"{/if}>
            <a href="{url keyword=null page=null limit=null filter='updated'}">Обновлены</a>
        </li>
    </ul>
    {*Фильтр END*}
</div>
{*Меню END*}