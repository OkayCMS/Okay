	{* Список товаров *}

{* Канонический адрес страницы *}
{if $set_canonical}
    {if $category && $brand}
        {$canonical="/catalog/{$category->url}/{$brand->url}" scope=parent}
    {elseif $category}
        {$canonical="/catalog/{$category->url}" scope=parent}
    {elseif $brand}
        {$canonical="/brands/{$brand->url}" scope=parent}
    {elseif $keyword}
        {$canonical="/products?keyword={$keyword|escape}" scope=parent}
    {else}
        {$canonical="/products" scope=parent}
    {/if}
{/if}



{* Заголовок страницы *}
{if $keyword}
    <h1 class="page_title">Поиск {$keyword|escape}</h1>
{elseif $page}
    <h1 class="page_title">{$page->name|escape}</h1>
{else}
    <h1 class="page_title">{$category->name|escape} {$brand->name|escape}<span class="filtered">{$filter_meta->h1|escape}</span></h1>
{/if}


{* Описание страницы (если задана) *}
{$page->body}

{if $current_page_num==1}
    {* Описание категории *}
    {if $category->image || $category->description}
        <div class="cat_description clearfix">
            {if $category->image}
                <div class="cat_img">
                    <img src="{$category->image|resize:400:400:false:$config->resized_categories_dir}" alt="{$category->name|escape}" />
                </div>  
            {/if}
            {$category->annotation}
        </div>
    {/if}
    {* Краткое описание бренда *}
    {$brand->annotation}
{/if}

<!--Каталог товаров-->
{if $products}
    {* Сортировка *}
    {if $products|count>0}
    <div class="sort">
	    Сортировать по
    	<a {if $sort=='position'} class="selected"{/if} href="{furl sort=position page=null}">умолчанию</a>
    	<a {if $sort=='price'}    class="selected"{/if} href="{furl sort=price page=null}">цене</a>
    	<a {if $sort=='name'}     class="selected"{/if} href="{furl sort=name page=null}">названию</a>
    </div>
    {/if}

    <!-- Список товаров-->
    <div id="products_content">
        {include file='products_content.tpl'}  
    </div>

    <div class="shpu_pagination">
        {include file='chpu_pagination.tpl'}
    </div>
    <!-- Список товаров (The End)-->
{else}
	Товары не найдены
{/if}
<!--Каталог товаров (The End)-->
{if $current_page_num==1}
    {$category->description}
    {* Описание бренда *}
    {$brand->description}
{/if}