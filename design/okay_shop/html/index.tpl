<!DOCTYPE html>
<html {if $language->href_lang}lang="{$language->href_lang|escape}"{/if} prefix="og: http://ogp.me/ns#">
<head>
    {* Full base address *}
    <base href="{$config->root_url}/">

    {* Meta data *}
    {include "head.tpl"}
    
    {* Favicon *}
    <link href="design/{$settings->theme}/images/favicon.png" type="image/x-icon" rel="icon">
    <link href="design/{$settings->theme}/images/favicon.png" type="image/x-icon" rel="shortcut icon">

    {* JQuery *}
    <script>ut_tracker.start('parsing:page');</script>
    <script>ut_tracker.start('parsing:head:js');</script>
    <script src="design/{$settings->theme}/js/jquery-3.3.1.min.js{if $js_version}?v={$js_version}{/if}"></script>

    {* JQuery migrate*}
    {if $module == "ProductsView"}
    <script src="design/{$settings->theme}/js/jquery-migrate-3.0.1.min.js{if $js_version}?v={$js_version}{/if}"></script>
    {/if}
    {* Slick slider *}
    <script src="design/{$settings->theme}/js/slick.min.js{if $js_version}?v={$js_version}{/if}"></script>

    {* Match height *}
    <script src="design/{$settings->theme}/js/jquery.matchHeight-min.js{if $js_version}?v={$js_version}{/if}"></script>
    <script>ut_tracker.end('parsing:head:js');</script>

    {* Fonts *}
    <script>ut_tracker.start('parsing:head:fonts');</script>
    <link href="//fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i&amp;subset=cyrillic" rel="stylesheet">
    <script>ut_tracker.end('parsing:head:fonts');</script>

    {* CSS *}
    <script>ut_tracker.start('parsing:head:css');</script>
    <link href="design/{$settings->theme|escape}/css/libs.css{if $css_version}?v={$css_version}{/if}" rel="stylesheet">
    <link href="design/{$settings->theme|escape}/css/style.css{if $css_version}?v={$css_version}{/if}" rel="stylesheet">
    <link href="design/{$settings->theme|escape}/css/responsive.css{if $css_version}?v={$css_version}{/if}" rel="stylesheet">
    <script>ut_tracker.end('parsing:head:css');</script>

    {if $counters['head']}
        <script>ut_tracker.start('parsing:head:counters');</script>
        {foreach $counters['head'] as $counter}
            {$counter->code}
        {/foreach}
        <script>ut_tracker.end('parsing:head:counters');</script>
    {/if}

</head>

<body>

{if $counters['body_top']}
    <script>ut_tracker.start('parsing:body_top:counters');</script>
    {foreach $counters['body_top'] as $counter}
        {$counter->code}
    {/foreach}
    <script>ut_tracker.end('parsing:body_top:counters');</script>
{/if}

<header class="header">
    <nav class="top_nav">
        <div class="container">
            {* Main menu toggle button*}
            <div class="fn_menu_switch menu_switch md-hidden"></div>

            {* Main menu *}
            {*<ul class="menu mobile-hidden">
                {foreach $pages as $p}
                    {if $p->menu_id == 1}
                        <li class="menu_item">
                            <a class="menu_link" data-page="{$p->id}" href="{$lang_link}{$p->url}">{$p->name|escape}</a>
                        </li>
                    {/if}
                {/foreach}
            </ul>*}
            {$menu_header}

            {* Top info block *}
            <ul class="informers">

                {* Wishlist informer *}
                <li id="wishlist" class="informer">
                    {include file="wishlist_informer.tpl"}
                </li>

                {* Comparison informer *}
                <li id="comparison" class="informer">
                    {include "comparison_informer.tpl"}
                </li>

                <li class="informer md-hidden">
                    {if $user}
                        {* User account *}
                        <a class="account_informer" href="{$lang_link}user"></a>
                    {else}
                        {* Login *}
                        <a class="account_informer" href="javascript:;" onclick="document.location.href = '{$lang_link}user/login'" title="{$lang->index_login}"></a>
                    {/if}
                </li>

                {* Languages *}
                {if $languages|count > 1}
                    {$cnt = 0}
                    {foreach $languages as $ln}
                        {if $ln->enabled}
                            {$cnt = $cnt+1}
                        {/if}
                    {/foreach}
                    {if $cnt>1}
                        <li class="informer languages">
                            <div class="fn_switch lang_switch">
                                <i class="angle_icon tablet-hidden"></i>
                                <span class="informer_name tablet-hidden">{$language->current_name}</span>
                                <span class="informer_name lg-hidden">{$language->label}</span>
                            </div>
                            <div class="dropdown">
                                {foreach $languages as $l}
                                    {if $l->enabled}
                                        <a class="dropdown_item{if $language->id == $l->id} active{/if}"
                                           href="{preg_replace('/^(.+)\/$/', '$1', $l->url)}">
                                            <span class="tablet-hidden">{$l->current_name}</span>
                                            <span class="lg-hidden">{$l->label}</span>
                                        </a>
                                    {/if}
                                {/foreach}
                            </div>
                        </li>
                    {/if}
                {/if}

                {* Currencies *}
                {if $currencies|count > 1}
                    <li class="informer currencies">
                        <div class="fn_switch cur_switch">
                            <i class="angle_icon tablet-hidden"></i>
                            <span class="informer_name tablet-hidden">{$currency->name}</span>
                            <span class="informer_name lg-hidden">{$currency->sign}</span>
                        </div>
                        <div class="dropdown">
                            {foreach $currencies as $c}
                                {if $c->enabled}
                                    <a class="dropdown_item{if $currency->id== $c->id} active{/if}" href="#" onClick="change_currency({$c->id}); return false;">
                                        <span class="tablet-hidden">{$c->name}</span>
                                        <span class="lg-hidden">{$c->sign}</span>
                                    </a>
                                {/if}
                            {/foreach}
                        </div>
                    </li>
                {/if}
            </ul>
        </div>
    </nav>

    <div class="container">

        {* Logo *}
        <a class="logo" href="{if $smarty.get.module=='MainView'}javascript:;{else}{$lang_link}{/if}">
            <img src="design/{$settings->theme|escape}/images/{$settings->site_logo}" alt="{$settings->site_name|escape}"/>
        </a>
        {*Если вам нужно загружать разные логотипы на разных языках, закомментируйте код выше, и пользуйтесь кодом ниже*}
        {*<a class="logo" href="{$lang_link}">
            <img src="design/{$settings->theme|escape}/images/logo{if $language->label}_{$language->label}{/if}.png" alt="{$settings->site_name|escape}"/>
        </a>*}

        <div class="account mobile-hidden">
            {if $user}
                {* User account *}
                <a class="account_link" href="{$lang_link}user">
                    <span class="small-hidden" data-language="index_account">{$lang->index_account}</span>
                    <span class="account_name small-hidden">{$user->name|escape}</span>
                </a>
            {else}
                {* Login *}
                <a class="account_link" href="javascript:;" onclick="document.location.href = '{$lang_link}user/login'" title="{$lang->index_login}">
                    <span class="small-hidden" data-language="index_account">{$lang->index_account}</span>
                    <span class="account_name small-hidden" data-language="index_login">{$lang->index_login}</span>
                </a>
            {/if}
        </div>

        {* Shop opening hours *}
        <div class="times">
            <div class="times_inner">
                <span class="times_text" data-language="index_we_open">{$lang->index_we_open}</span>
                <div><span data-language="company_open_hours">{$lang->company_open_hours}</span></div>
            </div>
        </div>

        {* Phones *}
        <div class="phones">
            <div class="phones_inner">
                <div><a href="tel:{$lang->company_phone_1}" data-language="company_phone_1" >{$lang->company_phone_1}</a></div>
                <div><a href="tel:{$lang->company_phone_2}" data-language="company_phone_2" >{$lang->company_phone_2}</a></div>
            </div>
        </div>

        {* Callback *}
        <a class="fn_callback callback" href="#fn_callback" data-language="index_back_call"><span>{$lang->index_back_call}</span></a>

    </div>

    <div class="header_bottom">
        <div class="container">
            {* Cart informer*}
            <div id="cart_informer">
                {include file='cart_informer.tpl'}
            </div>

            {* Search form *}
            <form id="fn_search" class="search" action="{$lang_link}all-products">
                <input class="fn_search search_input" type="text" name="keyword" value="{$keyword|escape}" data-language="index_search" placeholder="{$lang->index_search}"/>
                <button class="search_button" type="submit">{include file="svg.tpl" svgId="search_icon"}</button>
            </form>

            <div class="categories">
                {* Catalog heading *}
                <div class="categories_heading fn_switch">
                    {include file="svg.tpl" svgId="menu_icon"}
                    <span class="small-hidden" data-language="index_categories">{$lang->index_categories}</span>
                </div>

                {include file="categories.tpl"}
            </div>
        </div>
    </div>
</header>

{* Тело сайта *}
<div id="fn_content" class="main">
    {* Banners *}
    {if $is_mobile === false && $is_tablet === false}
        {get_banner var=banner_group1 group='group1'}
        {if $banner_group1->items}
            <div class="fn_banner_group1 banners container">
                {foreach $banner_group1->items as $bi}
                    <div>
                        {if $bi->url}
                        <a href="{$bi->url}" target="_blank">
                            {/if}
                            {if $bi->image}
                                <img src="{$bi->image|resize:1170:390:false:$config->resized_banners_images_dir}" alt="{$bi->alt}" title="{$bi->title}"/>
                            {/if}
                            {if $bi->url}
                        </a>
                        {/if}
                    </div>
                {/foreach}
            </div>
        {/if}
    {/if}
    {if $module == "MainView" || $page->url == '404'}
        <div class="fn_ajax_content">
            {$content}
        </div>
    {else}
        <div class="container">
            {include file='breadcrumb.tpl'}
            <div class="fn_ajax_content">
                {$content}
            </div>
        </div>
    {/if}
</div>

<div class="to_top"></div>

{* Footer *}
<footer class="footer">
    <div class="footer_top">
        <div class="container">
            <span class="payments_text tablet-hidden" data-language="index_payments">{$lang->index_payments}</span>
            <div class="footer_payment">
                <img src="design/{$settings->theme}/images/payments.png" alt="visa" title="visa">
            </div>
        </div>
    </div>
    <div class="footer_bottom">
        <div class="container">
            <div class="row">
                <div class="foot col-sm-6 col-lg-4">

                    {* Subscribing *}
                    <div id="subscribe_container">
                        <div class="h3">
                            <span data-language="subscribe_heading">{$lang->subscribe_heading}</span>
                        </div>

                        <form class="subscribe_form fn_validate_subscribe" method="post">
                            <input type="hidden" name="subscribe" value="1"/>

                            <input class="subscribe_input" type="email" name="subscribe_email" value="" data-format="email" placeholder="{$lang->form_email}"/>

                            <button class="subscribe_button" type="submit"><span data-language="subscribe_button">{$lang->subscribe_button}</span></button>

                            {if $subscribe_error}
                                <div id="subscribe_error" class="popup">
                                    {if $subscribe_error == 'email_exist'}
                                        <span data-language="subscribe_already">{$lang->index_subscribe_already}</span>
                                    {/if}
                                    {if $subscribe_error == 'empty_email'}
                                        <span data-language="form_enter_email">{$lang->form_enter_email}</span>
                                    {/if}
                                </div>
                            {/if}

                            {if $subscribe_success}
                                <div id="fn_subscribe_sent" class="popup">
                                    <span data-language="subscribe_sent">{$lang->index_subscribe_sent}</span>
                                </div>
                            {/if}
                        </form>

                        <div class="subscribe_promotext">
                            <span data-language="subscribe_promotext">{$lang->subscribe_promotext}</span>
                        </div>
                    </div>

                    {* Social buttons *}
                    <div class="h3">
                        <span data-language="index_in_networks">{$lang->index_in_networks}</span>
                    </div>

                    <div class="foot_social">
                        <a class="fb" href="https://facebook.com/okaycms" target="_blank" title="Facebook"></a>
                        <a class="vk" href="https://vk.com/club72497645" target="_blank" title="В контакте"></a>
                        <a class="ok" href="{preg_replace('/^(.+)\/$/', '$1', $lang_link)}#" target="_blank" title="Одноклассники"></a>
                        <a class="tw" href="https://twitter.com/okaycms" target="_blank" title="Twitter"></a>
                        <a class="ins" href="{preg_replace('/^(.+)\/$/', '$1', $lang_link)}#" target="_blank"  title="Instagram"></a>
                    </div>

                </div>

                {* Main menu *}
                <div class="foot col-sm-6 col-lg-2">
                    <div class="h3">
                        <span data-language="index_about_store">{$lang->index_about_store}</span>
                    </div>

                    <div class="foot_menu">
                        {*foreach $pages as $p}
                            {if $p->menu_id == 1}
                                <div class="foot_item">
                                    <a href="{$lang_link}{$p->url}">{$p->name|escape}</a>
                                </div>
                            {/if}
                        {/foreach*}
                        {$menu_footer}
                    </div>
                </div>

                {* Categories menu *}
                <div class="foot col-sm-6 col-lg-3">
                    <div class="h3">
                        <span data-language="index_categories">{$lang->index_categories}</span>
                    </div>

                    <div class="foot_menu">
                        {foreach $categories as $c}
                            {if $c->visible}
                                <div class="foot_item">
                                    <a  href="{$lang_link}catalog/{$c->url}">{$c->name|escape}</a>
                                </div>
                            {/if}
                        {/foreach}
                    </div>
                </div>

                {* Contacts *}
                <div class="foot col-sm-6 col-lg-3">
                    <div class="h3">
                        <span data-language="index_contacts">{$lang->index_contacts}</span>
                    </div>

                    <div class="footer_contacts">
                        <div class="foot_item">
                            <a href="tel:{$lang->company_phone_1}" data-language="company_phone_1" >{$lang->company_phone_1}</a>
                        </div>
                        <div class="foot_item">
                            <a href="tel:{$lang->company_phone_2}" data-language="company_phone_2" >{$lang->company_phone_2}</a>
                        </div>
                        <div class="foot_item">
                            <span data-language="company_email">{$lang->company_email}</span>
                        </div>
                    </div>
                </div>

            </div>

            {* Copyright *}
            <div class="copyright">
                <span>© {$smarty.now|date_format:"%Y"}</span>
                <a href="https://okay-cms.com" target="_blank">
                    <span data-language="index_copyright">{$lang->index_copyright}</span>
                </a>
            </div>
        </div>
    </div>
</footer>


{* Форма обратного звонка *}
{include file='callback.tpl'}

<script>ut_tracker.start('parsing:body_bottom:css');</script>
{* Fancybox *}
<link href="design/{$settings->theme|escape}/css/jquery.fancybox.min.css{if $css_version}?v={$css_version}{/if}" rel="stylesheet">
{if $smarty.get.module == 'ProductView' || $smarty.get.module == "BlogView"}
    <link href="design/{$settings->theme|escape}/css/font-awesome.min.css{if $css_version}?v={$css_version}{/if}" rel="stylesheet">
    <link href="design/{$settings->theme|escape}/css/jssocials.css{if $css_version}?v={$css_version}{/if}" rel="stylesheet">
    <link href="design/{$settings->theme|escape}/css/jssocials-theme-flat.css{if $css_version}?v={$css_version}{/if}" rel="stylesheet">
{/if}
<script>ut_tracker.end('parsing:body_bottom:css');</script>

{*template scripts*}
{* JQuery UI *}
{* Библиотека с "Slider", "Transfer Effect" *}
<script>ut_tracker.start('parsing:body_bottom:js');</script>
<script src="design/{$settings->theme}/js/jquery-ui.min.js{if $js_version}?v={$js_version}{/if}"></script>

{* Библиотека touch-punch *}
<script src="design/{$settings->theme}/js/ui.touch-punch.min.js{if $js_version}?v={$js_version}{/if}"></script>

{* Fancybox *}
<script src="design/{$settings->theme|escape}/js/jquery.fancybox.min.js{if $js_version}?v={$js_version}{/if}" defer></script>

{* Autocomplete *}
<script src="design/{$settings->theme}/js/jquery.autocomplete-min.js{if $js_version}?v={$js_version}{/if}" defer></script>

{$admintooltip}

{*JQuery Validation*}
<script src="design/{$settings->theme}/js/jquery.validate.min.js{if $js_version}?v={$js_version}{/if}" ></script>
<script src="design/{$settings->theme}/js/additional-methods.min.js{if $js_version}?v={$js_version}{/if}"></script>

{* Social share buttons *}
{if $smarty.get.module == 'ProductView' || $smarty.get.module == "BlogView"}
    <script src="design/{$settings->theme|escape}/js/jssocials.min.js{if $js_version}?v={$js_version}{/if}" ></script>
{/if}

{* Okay *}
{include file="scripts.tpl"}
<script src="design/{$settings->theme}/js/okay.js{if $js_version}?v={$js_version}{/if}"></script>
{*template scripts*}
<script>ut_tracker.end('parsing:body_bottom:js');</script>

{if $counters['body_bottom']}
    <script>ut_tracker.start('parsing:body_bottom:counters');</script>
    {foreach $counters['body_bottom'] as $counter}
        {$counter->code}
    {/foreach}
    <script>ut_tracker.end('parsing:body_bottom:counters');</script>
{/if}

</body>
</html>
