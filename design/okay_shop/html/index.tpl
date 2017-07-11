<!DOCTYPE html>
<html {if $language->href_lang}lang="{$language->href_lang|escape}"{/if} prefix="og: http://ogp.me/ns#">
<head>
    {* Full base address *}
    <base href="{$config->root_url}/">

    {* Title *}
    <title>{$meta_title|escape}{$filter_meta->title|escape}</title>

    {* Meta tags *}
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

    {if (!empty($meta_description) || !empty($meta_keywords) || !empty($filter_meta->description) || !empty($filter_meta->keywords)) && !$smarty.get.page}
        <meta name="description" content="{$meta_description|escape}{$filter_meta->description|escape}">
        <meta name="keywords" content="{$meta_keywords|escape}{$filter_meta->keywords|escape}">
    {/if}

    {if $module == 'ProductsView'}
        {if $set_canonical}
            <meta name="robots" content="noindex,nofollow">
        {elseif $smarty.get.page || $smarty.get.sort}
            <meta name="robots" content="noindex,follow">
        {elseif isset($smarty.get.keyword)}
            <meta name="robots" content="noindex,follow">
        {else}
            <meta name="robots" content="index,follow">
        {/if}
    {elseif $smarty.get.module == "RegisterView" || $smarty.get.module == "LoginView" || $smarty.get.module == "UserView" || $smarty.get.module == "CartView"}
        <meta name="robots" content="noindex,follow">
    {elseif $smarty.get.module == "OrderView"}
        <meta name="robots" content="noindex,nofollow">
    {else}
        <meta name="robots" content="index,follow">
    {/if}

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <meta name="generator" content="OkayCMS {$config->version}">

    {if $settings->g_webmaster}
        <meta name="google-site-verification" content="{$settings->g_webmaster}">
    {/if}

    {if $settings->y_webmaster}
        <meta name='yandex-verification' content="{$settings->y_webmaster}">
    {/if}

    {* rel prev next для блога *}
    {if $smarty.get.module == "BlogView" && $total_pages_num > 1}
        {if $current_page_num == $total_pages_num}
            {if $current_page_num == 2}
                <link rel="prev" href="{url page=null}"/>
            {else}
                <link rel="prev" href="{url page=$current_page_num-1}"/>
            {/if}
        {elseif $current_page_num == 1}
            <link rel="next" href="{url page=2}"/>
        {else}
            {if $current_page_num == 2}
                <link rel="prev" href="{url page=null}"/>
            {else}
                <link rel="prev" href="{url page=$current_page_num-1}"/>
            {/if}
            <link rel="next" href="{url page=$current_page_num+1}"/>
        {/if}
    {/if}

    {* rel prev next для каталога товаров *}
    {$rel_prev_next}

    {* Product image/Post image for social networks *}
    {if $module == 'ProductView'}
        <meta property="og:url" content="{$config->root_url}{if $lang_link}/{str_replace('/', '', $lang_link)}{/if}{$canonical}">
        <meta property="og:type" content="article">
        <meta property="og:title" content="{$product->name|escape}">
        <meta property="og:description" content='{$product->annotation|strip_tags}'>
        <meta property="og:image" content="{$product->image->filename|resize:330:300}">
        <link rel="image_src" href="{$product->image->filename|resize:330:300}">
        {*twitter*}
        <meta name="twitter:card" content="summary">
        <meta name="twitter:title" content="{$product->name|escape}">
        <meta name="twitter:description" content="{$product->annotation|strip_tags}">
        <meta name="twitter:image" content="{$product->image->filename|resize:330:300}">
    {elseif $module == 'BlogView'}
        <meta property="og:url" content="{$config->root_url}{if $lang_link}/{str_replace('/', '', $lang_link)}{/if}{$canonical}">
        <meta property="og:type" content="article">
        <meta property="og:title" content="{$post->name|escape}">
        {if $post->image}
            <meta property="og:image" content="{$post->image|resize:400:300:false:$config->resized_blog_dir}">
            <link rel="image_src" href="{$post->image|resize:400:300:false:$config->resized_blog_dir}">
        {else}
            <meta property="og:image" content="{$config->root_url}/design/{$settings->theme}/images/{$settings->site_logo}">
            <meta name="twitter:image" content="{$config->root_url}/design/{$settings->theme}/images/{$settings->site_logo}">
        {/if}
        <meta property="og:description" content='{$post->annotation|strip_tags}'>
        {*twitter*}
        <meta name="twitter:card" content="summary">
        <meta name="twitter:title" content="{$post->name|escape}">
        <meta name="twitter:description" content="{$post->annotation|strip_tags}">
        <meta name="twitter:image" content="{$post->image|resize:400:300:false:$config->resized_blog_dir}">
    {else}
        <meta property="og:title" content="{$settings->site_name|escape}">
        <meta property="og:type" content="website">
        <meta property="og:url" content="{$config->root_url}">
        <meta property="og:image" content="{$config->root_url}/design/{$settings->theme}/images/{$settings->site_logo}">
        <meta property="og:site_name" content="{$settings->site_name|escape}">
        <meta property="og:description" content="{$meta_description|escape}">
        <link rel="image_src" href="{$config->root_url}/design/{$settings->theme}/images/{$settings->site_logo}">
        {*twitter*}
        <meta name="twitter:card" content="summary">
        <meta name="twitter:title" content="{$settings->site_name|escape}">
        <meta name="twitter:description" content="{$meta_description|escape}">
        <meta name="twitter:image" content="{$config->root_url}/design/{$settings->theme}/images/{$settings->site_logo}">
    {/if}

    {* The canonical address of the page *}
    {if isset($canonical)}
        <link rel="canonical" href="{$config->root_url}{if $lang_link}/{str_replace('/', '', $lang_link)}{/if}{$canonical}">
    {elseif $smarty.get.sort}
        <link rel="canonical" href="{$sort_canonical}">
    {/if}

    {* Language attribute *}
    {foreach $languages as $l}
        {if $l->enabled}
            <link rel="alternate" hreflang="{$l->href_lang}" href="{$config->root_url}/{$l->url}">
        {/if}
    {/foreach}

    {* Favicon *}
    <link href="design/{$settings->theme}/images/favicon.png" type="image/x-icon" rel="icon">
    <link href="design/{$settings->theme}/images/favicon.png" type="image/x-icon" rel="shortcut icon">

    {* JQuery *}
    <script src="design/{$settings->theme}/js/jquery-2.1.4.min.js"></script>

    {* Slick slider *}
    <script src="design/{$settings->theme}/js/slick.min.js"></script>

    {* Match height *}
    <script src="design/{$settings->theme}/js/jquery.matchHeight-min.js"></script>

    {* Fonts *}
    <link href="//fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i&amp;subset=cyrillic" rel="stylesheet">

    {* CSS *}
    <link href="design/{$settings->theme|escape}/css/libs.css" rel="stylesheet">
    <link href="design/{$settings->theme|escape}/css/style.css" rel="stylesheet">
    <link href="design/{$settings->theme|escape}/css/responsive.css" rel="stylesheet">

    {* Google Analytics *}
    {if $settings->g_analytics}
    {literal}
        <script>
            (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
                        (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
                    m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
            })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

            ga('create', {/literal}'{$settings->g_analytics}'{literal}, 'auto');
            ga('send', 'pageview');
        </script>
    {/literal}
    {/if}

    {if $settings->head_custom_script}
        {$settings->head_custom_script}
    {/if}

</head>

<body>
<header>
    <nav class="top_nav">
        <div class="container">
            {* Main menu toggle button*}
            <div class="fn_menu_switch menu_switch md-hidden"></div>

            {* Main menu *}
            <ul class="menu mobile-hidden">
                {foreach $pages as $p}
                    {if $p->menu_id == 1}
                        <li class="menu_item">
                            <a class="menu_link" data-page="{$p->id}" href="{$lang_link}{$p->url}">{$p->name|escape}</a>
                        </li>
                    {/if}
                {/foreach}
            </ul>

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
                        <a class="account_informer" href="{$lang_link}user/login" title="{$lang->index_login}"></a>
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
                                <span class="informer_name tablet-hidden">{$language->{'name_'|cat:$language->label}}</span>
                                <span class="informer_name lg-hidden">{$language->label}</span>
                            </div>
                            <div class="dropdown">
                                {foreach $languages as $l}
                                    {if $l->enabled}
                                        <a class="dropdown_item{if $language->id == $l->id} active{/if}"
                                           href="{$l->url}">
                                           <span class="tablet-hidden">{$l->{'name_'|cat:$language->label}}</span>
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
                                    <a class="dropdown_item{if $currency->id== $c->id} active{/if}" href="{url currency_id=$c->id}">
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
        <a class="logo" href="{if $smarty.get.module=="MainView"}javascript:;{else}{$lang_link}{/if}">
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
                <a class="account_link" href="{$lang_link}user/login" title="{$lang->index_login}">
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
                                <img src="{$config->banners_images_dir}{$bi->image}" alt="{$bi->alt}" title="{$bi->title}"/>
                            {/if}
                            {if $bi->url}
                        </a>
                        {/if}
                    </div>
                {/foreach}
            </div>
        {/if}
    {/if}
    {if $module == "MainView"}
        {$content}
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
<footer>
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

                            <input class="subscribe_input" type="email" name="subscribe_email" value="" data-format="email" data-notice="{$lang->form_enter_email}" placeholder="{$lang->form_email}"/>

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
                        <a class="ok" href="{$lang_link}#" target="_blank" title="Одноклассники"></a>
                        <a class="tw" href="https://twitter.com/okaycms" target="_blank" title="Twitter"></a>
                        <a class="ins" href="{$lang_link}#" target="_blank"  title="Instagram"></a>
                    </div>

                </div>

                {* Main menu *}
                <div class="foot col-sm-6 col-lg-2">
                    <div class="h3">
                        <span data-language="index_about_store">{$lang->index_about_store}</span>
                    </div>

                    <div class="foot_menu">
                        {foreach $pages as $p}
                            {if $p->menu_id == 1}
                                <div class="foot_item">
                                    <a href="{$lang_link}{$p->url}">{$p->name|escape}</a>
                                </div>
                            {/if}
                        {/foreach}
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
                <a href="http://okay-cms.com" target="_blank">
                    <span data-language="index_copyright">{$lang->index_copyright}</span>
                </a>
            </div>
        </div>
    </div>
</footer>


{* Форма обратного звонка *}
{include file='callback.tpl'}

{if $settings->yandex_metrika_counter_id}
    {literal}
    <!-- Yandex.Metrika counter -->
    <script type="text/javascript">
        (function (d, w, c) {
            (w[c] = w[c] || []).push(function() {
                try {
                    w.yaCounter{/literal}{$settings->yandex_metrika_counter_id}{literal} = new Ya.Metrika({
                        id:{/literal}{$settings->yandex_metrika_counter_id}{literal},
                        clickmap:true,
                        trackLinks:true,
                        accurateTrackBounce:true,
                        webvisor:true,
                        trackHash:true,
                        ecommerce:"dataLayer"
                    });
                } catch(e) { }
            });

            var n = d.getElementsByTagName("script")[0],
                    s = d.createElement("script"),
                    f = function () { n.parentNode.insertBefore(s, n); };
            s.type = "text/javascript";
            s.async = true;
            s.src = "https://mc.yandex.ru/metrika/watch.js";

            if (w.opera == "[object Opera]") {
                d.addEventListener("DOMContentLoaded", f, false);
            } else { f(); }
        })(document, window, "yandex_metrika_callbacks");
    </script>
    <!-- /Yandex.Metrika counter -->
{/literal}
{/if}


{if $settings->body_custom_script}
    {$settings->body_custom_script}
{/if}

{*template scripts*}
{* JQuery UI *}
{* Библиотека с "Slider", "Transfer Effect" *}
<script src="design/{$settings->theme}/js/jquery-ui.min.js"></script>

{* Fancybox *}
<link href="design/{$settings->theme|escape}/css/jquery.fancybox.min.css" rel="stylesheet">
<script src="design/{$settings->theme|escape}/js/jquery.fancybox.min.js" defer></script>

{* Autocomplete *}
<script src="design/{$settings->theme}/js/jquery.autocomplete-min.js" defer></script>

{* Admin tooltips *}
{if $smarty.session.admin}
    <script src ="backend/design/js/admintooltip/admintooltip.js"></script>
    <link href="backend/design/js/admintooltip/styles/admin.css" rel="stylesheet">
{/if}

{*JQuery Validation*}
<script src="design/{$settings->theme}/js/jquery.validate.min.js" ></script>
<script src="design/{$settings->theme}/js/additional-methods.min.js"></script>

{* Social share buttons *}
{if $smarty.get.module == 'ProductView' || $smarty.get.module == "BlogView"}
    <link href="design/{$settings->theme|escape}/css/font-awesome.min.css" rel="stylesheet">
    <link href="design/{$settings->theme|escape}/css/jssocials.css" rel="stylesheet">
    <link href="design/{$settings->theme|escape}/css/jssocials-theme-flat.css" rel="stylesheet">
    <script src="design/{$settings->theme|escape}/js/jssocials.min.js" ></script>
{/if}

{* Okay *}
{include file="scripts.tpl"}
<script src="design/{$settings->theme}/js/okay.js"></script>
{*template scripts*}
</body>
</html>
