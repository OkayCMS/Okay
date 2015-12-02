<!-- Хлебные крошки /-->
{if $module != "MainView"}
<div id="breadcrumbs">
    <div class="container">
        <div id="path">
            <a href="{$lang_link}">{$lang->glavnaya}</a>
            {* Крошки для каталога и категорий *}
            {if $module == "ProductsView"}
                {if $category}
                    {foreach from=$category->path item=cat}
                        &rsaquo; <a href="{$lang_link}catalog/{$cat->url}">{$cat->name|escape}</a>
                    {/foreach}
                    {if $brand}
                        &rsaquo; <a href="{$lang_link}catalog/{$cat->url}/{$brand->url}">{$brand->name|escape}</a>
                    {/if}
                {elseif $brand}
                    &rsaquo; <a href="{$lang_link}brands/{$brand->url}">{$brand->name|escape}</a>
                {elseif $keyword}
                    &rsaquo; <span>{$lang->poisk}</span>
                {else}
                    &rsaquo; <a href="{$lang_link}all-products">{$page->name|escape}</a>
                {/if}
            {* @END Крошки для каталога и категорий *}
            {* Крошки для карточки товара *}
            {elseif $module == "ProductView"}
                {foreach from=$category->path item=cat}
                    &rsaquo; <a href="{$lang_link}catalog/{$cat->url}">{$cat->name|escape}</a>
                {/foreach}
                {if $brand}
                    &rsaquo; <a href="{$lang_link}catalog/{$cat->url}/{$brand->url}">{$brand->name|escape}</a>
                {/if}
                &rsaquo; <a href="{$lang_link}products/{$product->url}">{$product->name|escape}</a>
            {* @END Крошки для карточки товара *}
            {* Крошки для контактов и статей *}
            {elseif $module == "FeedbackView" || $module == "PageView"}
                &rsaquo; <a href="{$lang_link}{$page->url}">{$page->name|escape}</a>
            {* @END Крошки для контактов и статей *}
            {* Крошки для корзины *}
            {elseif $module == "CartView"}
                &rsaquo; <a href="{$lang_link}cart">{$lang->korzina}</a>
            {* @END Крошки для корзины *}
            {* Крошки для "Восстановление пароля" *}
            {elseif $module == "LoginView" && $smarty.get.action == "password_remind"}
                &rsaquo; <a href="{$lang_link}user/password_remind">{$lang->vosstanovlenie_parolya}</a>
            {* @END Крошки для "Восстановление пароля" *}
            {* Крошки для "Вход пользователя" *}
            {elseif $module == "LoginView"}
                &rsaquo; <a href="{$lang_link}user/login">{$lang->vhod}</a>
            {* @END Крошки для "Вход пользователя" *}
            {* Крошки для "Регистрация пользователя" *}
            {elseif $module == "RegisterView"}
                &rsaquo; <a href="{$lang_link}user/register">{$lang->registratsiya}</a>
            {* @END Крошки для "Регистрация пользователя" *}
            {* Крошки для блога *}
            {elseif $module == "BlogView"}
                &rsaquo; <a href="{$lang_link}blog">{$lang->breadcrumbs_blog}</a>
                {if $smarty.get.url}
                    &rsaquo; <a href="{$lang_link}blog/{$post->url}">{$post->name}</a>
                {/if}
            {/if}
            {* @END Крошки для блога *}
        </div>
     </div>
</div>
{/if}
<!-- Хлебные крошки #End /-->
