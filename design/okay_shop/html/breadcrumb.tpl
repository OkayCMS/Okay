{* Breadcrumb navigation *}
{if $module != "MainView"}
    <ol class="breadcrumbs">

        {* The link to the homepage *}
        <li itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb">
            <a itemprop="url" href="{if !empty($lang_link)}{$lang_link}{else}{$config->root_url}{/if}" data-language="breadcrumb_home">
                <span itemprop="title">{$lang->breadcrumb_home}</span>
            </a>
        </li>

        {* Categories page *}
        {if $smarty.get.module == "ProductsView"}
            {if $category && !$keyword}
                {foreach from=$category->path item=cat}
                    {if !$cat@last}
                        {if $cat->visible}
                            <li itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb">
                                <a itemprop="url" href="{$lang_link}catalog/{$cat->url}">
                                    <span itemprop="title">{$cat->name|escape}</span>
                                </a>
                            </li>
                        {/if}
                    {else}
                        <li>{$cat->name|escape}</li>
                    {/if}
                {/foreach}
            {elseif $brand}
                <li itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb">
                    <a itemprop="url" href="{$lang_link}brands" data-language="breadcrumb_brands">
                        <span itemprop="title">{$lang->breadcrumb_brands}</span>
                    </a>
                </li>
                <li>{$brand->name|escape}</li>
            {elseif $keyword}
                <li data-language="breadcrumb_search">{$lang->breadcrumb_search}</li>
            {else}
                <li>{$page->name|escape}</li>
            {/if}

        {* Brand list page *}
        {elseif $smarty.get.module == "BrandsView"}
            <li>{$page->name|escape}</li>

        {* Product page *}
        {elseif $smarty.get.module == "ProductView"}
            {foreach from=$category->path item=cat}
                {if $cat->visible}
                    <li itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb">
                        <a itemprop="url" href="{$lang_link}catalog/{$cat->url}">
                            <span itemprop="title">{$cat->name|escape}</span>
                        </a>
                    </li>
                {/if}
            {/foreach}
            <li>{$product->name|escape}</li>

        {* Page *}
        {elseif $smarty.get.module == "FeedbackView" || $smarty.get.module == "PageView"}
            <li>{$page->name|escape}</li>

        {* Cart page *}
        {elseif $smarty.get.module == "CartView"}
            <li data-language="breadcrumb_cart">{$lang->breadcrumb_cart}</li>

        {* Order page *}
        {elseif $smarty.get.module == "OrderView"}
            <li data-language="breadcrumb_order">{$lang->breadcrumb_order} {$order->id}</li>

        {* Password remind page *}
        {elseif $smarty.get.module == "LoginView" && $smarty.get.action == "password_remind"}
            <li data-language="breadcrumbs_password_remind">{$lang->breadcrumbs_password_remind}</li>

        {* Login page *}
        {elseif $smarty.get.module == "LoginView"}
            <li data-language="breadcrumbs_enter">{$lang->breadcrumbs_enter}</li>

        {* Register page *}
        {elseif $smarty.get.module == "RegisterView"}
            <li data-language="breadcrumbs_registration">{$lang->breadcrumbs_registration}</li>

        {* User account page *}
        {elseif $smarty.get.module == "UserView"}
            <li data-language="breadcrumbs_user">{$lang->breadcrumbs_user}</li>

        {* Blog page *}
        {elseif $smarty.get.module == "BlogView"}
            {if $smarty.get.url}
                <li itemscope="" itemtype="http://data-vocabulary.org/Breadcrumb">
                    <a itemprop="url" href="{$lang_link}{$type_post}" data-language="breadcrumbs_blog">
                        <span itemprop="title">
                            {if $type_post == "news"}
                                {$lang->main_news}
                            {else}
                                {$lang->breadcrumbs_blog}
                            {/if}
                        </span>
                    </a>
                </li>
                <li>
                    {$post->name|escape}
                </li>
            {else}
                <li data-language="breadcrumbs_blog">
                    {if $type_post == "news"}
                        {$lang->main_news}
                    {else}
                        {$lang->breadcrumbs_blog}
                    {/if}
                </li>
            {/if}
        {elseif $smarty.get.module == 'ComparisonView'}
            <li data-language="breadcrumb_comparison">{$lang->breadcrumb_comparison}</li>
        {elseif $smarty.get.module == 'WishlistView'}
            <li data-language="breadcrumb_wishlist">{$lang->breadcrumb_wishlist}</li>
        {/if}
    </ol>
{/if}
