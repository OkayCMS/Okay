{* The main page template *}
{* The canonical address of the page *}
{$canonical="" scope=parent}

<div class="container">
    {if $is_mobile === false && $is_tablet === false}
        <div class="advantages">
            <div class="container">
                <div class="row">
                    <div class="col-sm-6 col-lg-3">
                        <div class="advantage advantage_1">
                            <span data-language="advantage_1">{$lang->advantage_1}</span>
                        </div>
                    </div>
                    <div class="col-sm-6 col-lg-3">
                        <div class="advantage advantage_2">
                            <span data-language="advantage_2">{$lang->advantage_2}</span>
                        </div>
                    </div>
                    <div class="col-sm-6 col-lg-3">
                        <div class="advantage advantage_3">
                            <span data-language="advantage_3">{$lang->advantage_3}</span>
                        </div>
                    </div>
                    <div class="col-sm-6 col-lg-3">
                        <div class="advantage advantage_4">
                            <span data-language="advantage_4">{$lang->advantage_4}</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    {/if}

    {* Featured products *}
    {get_featured_products var=featured_products limit=4}
    {if $featured_products}
        <div class="h2">
            <span data-language="main_recommended_products">{$lang->main_recommended_products}</span>
        </div>

        <div class="main_products clearfix">
            {foreach $featured_products as $product}
                <div class="products_item no_padding col-sm-6 col-xl-3">
                    {include "product_list.tpl"}
                </div>
            {/foreach}

            <div class="look_all">
                <a href="{$lang_link}bestsellers" data-language="main_look_all">{$lang->main_look_all}</a>
            </div>
        </div>
    {/if}

    {* New products *}
    {get_new_products var=new_products limit=4}
    {if $new_products}
        <div class="h2">
            <span data-language="main_new_products">{$lang->main_new_products}</span>
        </div>

        <div class="main_products clearfix">
            {foreach $new_products as $product}
                <div class="products_item no_padding col-sm-6 col-xl-3">
                    {include "product_list.tpl"}
                </div>
            {/foreach}
        </div>
    {/if}

    {* Discount products *}
    {get_discounted_products var=discounted_products limit=4}
    {if $discounted_products}
        <div class="h2">
            <span data-language="main_discount_products">{$lang->main_discount_products}</span>
        </div>

        <div class="main_products clearfix">
            {foreach $discounted_products as $product}
                <div class="products_item no_padding col-sm-6 col-xl-3">
                    {include "product_list.tpl"}
                </div>
            {/foreach}

            <div class="look_all">
                <a href="{$lang_link}discounted" data-language="main_look_all">{$lang->main_look_all}</a>
            </div>
        </div>
    {/if}

    {* Brand list *}
    {get_brands var=all_brands visible_brand=1}
    {if $all_brands}
        <div class="h2">
            <span data-language="main_brands">{$lang->main_brands}</span>
        </div>

        <div class="fn_all_brands all_brands block">
            {foreach $all_brands as $b}
                <div class="fleft">
                    <a class="all_brands_link" href="{$lang_link}brands/{$b->url}" data-brand="{$b->id}">
                        {if $b->image}
                            <div class="brand_image">
                                <img class="brand_img" src="{$b->image|resize:250:100:false:$config->resized_brands_dir}" alt="{$b->name|escape}" title="{$b->name|escape}">
                            </div>
                            <span>{$b->name|escape}</span>
                        {else}
                            <div class="brand_name">
                                <span>{$b->name|escape}</span>
                            </div>
                        {/if}
                    </a>
                </div>
            {/foreach}
        </div>
    {/if}

    {* Page content and Last posts *}
    {get_posts var=last_posts limit=2 type_post="news"}
    {if $page->description || $last_posts}
        <div class="wrap_block clearfix">
            {if $page->description}
                <div class="no_padding{if $last_posts} col-lg-6{else} col-lg-12{/if}">
                    <div class="h2">
                        <span data-language="main_about_store">{$lang->main_about_store}</span>
                    </div>

                    <div class="block padding">
                        <h1 class="h4">{$page->name|escape}</h1>
                        <div class="main_text">{$page->description}</div>
                    </div>
                </div>
            {/if}

            {if $last_posts}
                <div class="no_padding{if $page->description} col-lg-6{else} col-lg-12{/if}">
                    <div class="h2">
                        <span data-language="main_news">{$lang->main_news}</span>
                    </div>

                    <div class="news clearfix block">
                        {foreach $last_posts as $post}
                            <div class="news_item no_padding col-sm-6">
                                <a class="news_image" href="{$lang_link}{$post->type_post}/{$post->url}">
                                    {if $post->image}
                                        <img class="news_img" src="{$post->image|resize:250:250:false:$config->resized_blog_dir}" alt="{$post->name|escape}" title="{$post->name|escape}"/>
                                    {/if}
                                </a>

                                <div class="news_content">

                                    {* News name *}
                                    <div class="h5">
                                        <a href="{$lang_link}{$post->type_post}/{$post->url}" data-post="{$post->id}">{$post->name|escape}</a>
                                    </div>

                                    {* News date *}
                                    <div class="news_date"><span>{$post->date|date}</span></div>

                                    {* News annotation *}
                                    {if $post->annotation}
                                        <div class="news_annotation">{$post->annotation}</div>
                                    {/if}

                                </div>
                            </div>
                        {/foreach}

                        <div class="look_all">
                            <a href="{$lang_link}news" data-language="main_all_news">{$lang->main_all_news}</a>
                        </div>
                    </div>
                </div>
            {/if}
        </div>
    {/if}

</div>