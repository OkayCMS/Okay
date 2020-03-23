{* Breadcrumb navigation *}
{$level = 1}
{if $module != "MainView"}
    <ol itemscope itemtype="https://schema.org/BreadcrumbList" class="breadcrumbs">

        {* The link to the homepage *}
        <li itemprop="itemListElement" itemscope
            itemtype="https://schema.org/ListItem">
            <a itemprop="item" href="{if !empty($lang_link)}{$lang_link}{else}{$config->root_url}{/if}" data-language="breadcrumb_home">
                <span itemprop="name">{$lang->breadcrumb_home}</span>
            </a>
            <meta itemprop="position" content="{$level++}" />
        </li>

        {* Categories page *}
        {if $smarty.get.module == "ProductsView"}
            {if $category && !$keyword}
                {foreach from=$category->path item=cat}
                    {if !$cat@last}
                        {if $cat->visible}
                            <li itemprop="itemListElement" itemscope
                                itemtype="https://schema.org/ListItem">
                                <a itemprop="item" href="{$lang_link}catalog/{$cat->url}">
                                    <span itemprop="name">{$cat->name|escape}</span>
                                </a>
                                <meta itemprop="position" content="{$level++}" />
                            </li>
                        {/if}
                    {else}
                        <li itemprop="itemListElement" itemscope
                            itemtype="https://schema.org/ListItem">
                            <span itemprop="name">{$cat->name|escape}</span>
                            <meta itemprop="position" content="{$level++}" />
                        </li>
                    {/if}
                {/foreach}
            {elseif $brand}
                <li itemprop="itemListElement" itemscope
                    itemtype="https://schema.org/ListItem">
                    <a itemprop="item" href="{$lang_link}brands" data-language="breadcrumb_brands">
                        <span itemprop="name">{$lang->breadcrumb_brands}</span>
                    </a>
                    <meta itemprop="position" content="{$level++}" />
                </li>
                <li itemprop="itemListElement" itemscope itemtype="https://schema.org/ListItem">
                    <span itemprop="name">{$brand->name|escape}</span>
                    <meta itemprop="position" content="{$level++}" />
                </li>
            {elseif $keyword}
                <li itemprop="itemListElement" itemscope
                    itemtype="https://schema.org/ListItem" data-language="breadcrumb_search">
                    <span itemprop="name">{$lang->breadcrumb_search}</span>
                    <meta itemprop="position" content="{$level++}" />
                </li>
            {else}
                <li itemprop="itemListElement" itemscope
                    itemtype="https://schema.org/ListItem">
                    <span itemprop="name">{$page->name|escape}</span>
                    <meta itemprop="position" content="{$level++}" />
                </li>
            {/if}

        {* Brand list page *}
        {elseif $smarty.get.module == "BrandsView"}
            <li itemprop="itemListElement" itemscope
                itemtype="https://schema.org/ListItem">
                <span itemprop="name">{$page->name|escape}</span>
                <meta itemprop="position" content="{$level++}" />
            </li>

        {* Product page *}
        {elseif $smarty.get.module == "ProductView"}
            {foreach from=$category->path item=cat}
                {if $cat->visible}
                    <li itemprop="itemListElement" itemscope
                        itemtype="https://schema.org/ListItem">
                        <a itemprop="item" href="{$lang_link}catalog/{$cat->url}">
                            <span itemprop="name">{$cat->name|escape}</span>
                        </a>
                        <meta itemprop="position" content="{$level++}" />
                    </li>
                {/if}
            {/foreach}
            <li itemprop="itemListElement" itemscope
                itemtype="https://schema.org/ListItem">
                <span itemprop="name">{$product->name|escape}</span>
                <meta itemprop="position" content="{$level++}" />
            </li>

        {* Page *}
        {elseif $smarty.get.module == "FeedbackView" || $smarty.get.module == "PageView"}
            <li itemprop="itemListElement" itemscope
                itemtype="https://schema.org/ListItem">
                <span itemprop="name">{$page->name|escape}</span>
                <meta itemprop="position" content="{$level++}" />
            </li>

        {* Cart page *}
        {elseif $smarty.get.module == "CartView"}
            <li itemprop="itemListElement" itemscope
                itemtype="https://schema.org/ListItem">
                <span itemprop="name" data-language="breadcrumb_cart">{$lang->breadcrumb_cart}</span>
                <meta itemprop="position" content="{$level++}" />
            </li>

        {* Order page *}
        {elseif $smarty.get.module == "OrderView"}
            <li itemprop="itemListElement" itemscope
                itemtype="https://schema.org/ListItem" data-language="breadcrumb_order">
                <span itemprop="name">{$lang->breadcrumb_order} {$order->id}</span>
                <meta itemprop="position" content="{$level++}" />
            </li>

        {* Password remind page *}
        {elseif $smarty.get.module == "LoginView" && $smarty.get.action == "password_remind"}
            <li itemprop="itemListElement" itemscope
                itemtype="https://schema.org/ListItem" data-language="breadcrumbs_password_remind">
                <span itemprop="name">{$lang->breadcrumbs_password_remind}</span>
                <meta itemprop="position" content="{$level++}" />
            </li>

        {* Login page *}
        {elseif $smarty.get.module == "LoginView"}
            <li itemprop="itemListElement" itemscope
                itemtype="https://schema.org/ListItem" data-language="breadcrumbs_enter">
                <span itemprop="name">{$lang->breadcrumbs_enter}</span>
                <meta itemprop="position" content="{$level++}" />
            </li>

        {* Register page *}
        {elseif $smarty.get.module == "RegisterView"}
            <li itemprop="itemListElement" itemscope
                itemtype="https://schema.org/ListItem" data-language="breadcrumbs_registration">
                <span itemprop="name">{$lang->breadcrumbs_registration}</span>
                <meta itemprop="position" content="{$level++}" />
            </li>

        {* User account page *}
        {elseif $smarty.get.module == "UserView"}
            <li itemprop="itemListElement" itemscope
                itemtype="https://schema.org/ListItem" data-language="breadcrumbs_user">
                <span itemprop="name">{$lang->breadcrumbs_user}</span>
                <meta itemprop="position" content="{$level++}" />
            </li>

        {* Blog page *}
        {elseif $smarty.get.module == "BlogView"}
            {if $smarty.get.url}
                <li itemprop="itemListElement" itemscope
                    itemtype="https://schema.org/ListItem">
                    <a itemprop="item" href="{$lang_link}{$type_post}" data-language="breadcrumbs_blog">
                        <span itemprop="name">
                            {if $type_post == "news"}
                                {$lang->main_news}
                            {else}
                                {$lang->breadcrumbs_blog}
                            {/if}
                        </span>
                    </a>
                    <meta itemprop="position" content="{$level++}" />
                </li>
                <li itemprop="itemListElement" itemscope
                    itemtype="https://schema.org/ListItem">
                    <span itemprop="name">{$post->name|escape}</span>
                    <meta itemprop="position" content="{$level++}" />
                </li>
            {else}
                <li itemprop="itemListElement" itemscope
                    itemtype="https://schema.org/ListItem" data-language="breadcrumbs_blog">
                    <span itemprop="name">
                    {if $type_post == "news"}
                        {$lang->main_news}
                    {else}
                        {$lang->breadcrumbs_blog}
                    {/if}
                    </span>
                    <meta itemprop="position" content="{$level++}" />
                </li>
            {/if}
        {elseif $smarty.get.module == 'ComparisonView'}
            <li itemprop="itemListElement" itemscope
                itemtype="https://schema.org/ListItem" data-language="breadcrumb_comparison">
                <span itemprop="name">{$lang->breadcrumb_comparison}</span>
                <meta itemprop="position" content="{$level++}" />
            </li>
        {elseif $smarty.get.module == 'WishlistView'}
            <li itemprop="itemListElement" itemscope
                itemtype="https://schema.org/ListItem" data-language="breadcrumb_wishlist">
                <span itemprop="name">{$lang->breadcrumb_wishlist}</span>
                <meta itemprop="position" content="{$level++}" />
            </li>
        {/if}
    </ol>
{/if}
