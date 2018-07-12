{* Title *}
<title>{strip}
        {if $seo_filter_pattern->title}
            {$seo_filter_pattern->title|escape}
        {else}
            {$meta_title|escape}{$filter_meta->title|escape}
        {/if}
        {if $smarty.get.page && $smarty.get.page != 'all'}
            {$lang->meta_page} {$smarty.get.page}
        {/if}
    {/strip}</title>

{* Meta tags *}
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

{if (!empty($meta_description)
|| !empty($meta_keywords)
|| !empty($filter_meta->description)
|| !empty($filter_meta->keywords)
|| !empty($seo_filter_pattern->meta_description)
|| !empty($seo_filter_pattern->keywords)
)
&& !$smarty.get.page}

    <meta name="description" content="{strip}
            {if $seo_filter_pattern->meta_description}
                {$seo_filter_pattern->meta_description|escape}
            {else}
                {$meta_description|escape}{$filter_meta->description|escape}
            {/if}
        {/strip}" />

    <meta name="keywords" content="{strip}
            {if $seo_filter_pattern->keywords}
                {$seo_filter_pattern->keywords|escape}
            {else}
                {$meta_keywords|escape}{$filter_meta->keywords|escape}
            {/if}
        {/strip}" />

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
    <meta property="og:type" content="website">
    <meta property="og:title" content="{$product->name|escape}">
    <meta property="og:description" content='{$product->annotation|strip_tags|escape}'>
    <meta property="og:image" content="{$product->image->filename|resize:330:300}">
    <link rel="image_src" href="{$product->image->filename|resize:330:300}">
    {*twitter*}
    <meta name="twitter:card" content="product"/>
    <meta name="twitter:url" content="{$config->root_url}{if $lang_link}/{str_replace('/', '', $lang_link)}{/if}{$canonical}">
    <meta name="twitter:site" content="{$settings->site_name|escape}">
    <meta name="twitter:title" content="{$product->name|escape}">
    <meta name="twitter:description" content="{$product->annotation|strip_tags|escape}">
    <meta name="twitter:image" content="{$product->image->filename|resize:330:300}">
    <meta name="twitter:data1" content="{$lang->cart_head_price}">
    <meta name="twitter:label1" content="{$product->variant->price|convert:null:false} {$currency->code|escape}">
    <meta name="twitter:data2" content="{$lang->meta_organization}">
    <meta name="twitter:label2" content="{$settings->company_name|escape}">
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
    <meta property="og:description" content='{$post->annotation|strip_tags|escape}'>
    {*twitter*}
    <meta name="twitter:card" content="summary">
    <meta name="twitter:title" content="{$post->name|escape}">
    <meta name="twitter:description" content="{$post->annotation|strip_tags|escape}">
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
{if !$hide_alternate}
    {foreach $languages as $l}
        {if $l->enabled}
            <link rel="alternate" hreflang="{$l->href_lang}" href="{$config->root_url}/{preg_replace('/^(.+)\/$/', '$1', $l->url)}">
        {/if}
    {/foreach}
{/if}