{* The Categories page *}

{* The canonical address of the page *}
{if $set_canonical || $self_canonical}
    {if $category}
        {$canonical="/catalog/{$category->url}" scope=parent}
    {elseif $brand}
        {$canonical="/brands/{$brand->url}" scope=parent}
    {elseif $page->url=='discounted'}
        {$canonical="/discounted" scope=parent}
    {elseif $page->url=='bestsellers'}
        {$canonical="/bestsellers" scope=parent}
    {elseif $keyword}
        {$canonical="/all-products" scope=parent}
    {else}
        {$canonical="/all-products" scope=parent}
    {/if}
{/if}

{* Sidebar with filters *}
<div class="sidebar">
    <div class="fn_selected_features">
        {include 'selected_features.tpl'}
    </div>

    <div class="sidebar_top fn_features">
    {include file='features.tpl'}
    </div>
</div>

<div class="products_container">
    {* The page heading *}
    {if $keyword}
        <h1 class="h1"><span data-language="products_search">{$lang->products_search}</span> {$keyword|escape}</h1>
    {elseif $page}
        <h1 class="h1">
            <span data-page="{$page->id}">{if $page->name_h1|escape}{$page->name_h1|escape}{else}{$page->name|escape}{/if}</span>
        </h1>
    {elseif $seo_filter_pattern->h1}
        <h1 class="h1">{$seo_filter_pattern->h1|escape}</h1>
    {else}
        <h1 class="h1"><span data-category="{$category->id}">{if $category->name_h1|escape}{$category->name_h1|escape}{else}{$category->name|escape}{/if}</span> {$brand->name|escape} {$filter_meta->h1|escape}</h1>
    {/if}

    {if $current_page_num == 1 && ($category->annotation || $brand->annotation) && !$is_filter_page && !$smarty.get.page && !$smarty.get.sort}
        <div class="block padding">
            {* Краткое описание категории *}
            {$category->annotation}

            {* Краткое описание бренда *}
            {$brand->annotation}
        </div>
    {/if}


    
    {if $products}
        {* Product Sorting *}
        <div class="fn_products_sort">
            {include file="products_sort.tpl"}
        </div>
    {/if}

    {* Product list *}
    <div id="fn_products_content" class="fn_categories products clearfix">
        {include file="products_content.tpl"}
    </div>

    {if $products}
        {* Friendly URLs Pagination *}
        <div class="fn_pagination">
            {include file='chpu_pagination.tpl'}
        </div>
    {/if}
    
    {if $current_page_num == 1 && $page->description}
        <div class="block padding">
            {$page->description}
        </div>
    {/if}

    {if $current_page_num == 1}
        {*SEO шаблон описания страницы фильтра*}
        {if $seo_filter_pattern->description}
            <div class="block padding">
                {$seo_filter_pattern->description}
            </div>
        {elseif (!$category || !$brand) && ($category->description || $brand->description) && !$is_filter_page && !$smarty.get.page && !$smarty.get.sort}
            <div class="block padding">
                {* Описание категории *}
                {$category->description}

                {* Описание бренда *}
                {$brand->description}
            </div>
        {/if}
    {/if}

</div>

{* Sidebar with browsed products *}
<div class="sidebar sidebar_bottom block">
    {* Browsed products *}
    {get_browsed_products var=browsed_products limit=4}
    {if $browsed_products}
        <div class="h2">{$lang->features_browsed}</div>
        <div class="browsed clearfix">
            {foreach $browsed_products as $browsed_product}
                <div class="browsed_item col-xs-6 col-sm-3 col-lg-6">
                    <a href="{$lang_link}products/{$browsed_product->url}">
                        {if $browsed_product->image->filename}
                            <img src="{$browsed_product->image->filename|resize:50:50}" alt="{$browsed_product->name|escape}" title="{$browsed_product->name|escape}">
                        {else}
                            <img width="50" height="50" src="design/{$settings->theme}/images/no_image.png" alt="{$browsed_product->name|escape}" title="{$browsed_product->name|escape}"/>
                        {/if}
                    </a>
                </div>
            {/foreach}
        </div>
    {/if}
</div>
