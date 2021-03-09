{* The blog page template *}

{* The canonical address of the page *}
{if $type_post == "blog"}
    {$canonical="/blog" scope=global}
{else}
    {$canonical="/news" scope=global}
{/if}

{* The page heading *}
<h1 class="h1"><span data-page="{$page->id}">{if $page->name_h1|escape}{$page->name_h1|escape}{else}{$page->name|escape}{/if}</span></h1>

{* The list of the blog posts *}
<div class="blog clearfix">
    {foreach $posts as $post}
        <div class="blog_item no_padding col-sm-6 col-lg-4 col-xl-3">

            {* The post image *}
            <a class="blog_image" href="{$lang_link}{$type_post}/{$post->url}">
                {if $post->image}
                    <picture>
                        {if $settings->support_webp}
                            <source type="image/webp" srcset="{$post->image|resize:360:360:false:$config->resized_blog_dir}.webp">
                        {/if}
                        <source srcset="{$post->image|resize:360:360:false:$config->resized_blog_dir}">
                        <img class="blog_img" src="{$post->image|resize:360:360:false:$config->resized_blog_dir}" alt="{$post->name|escape}" title="{$post->name|escape}">
                    </picture>
                {/if}
            </a>

            <div class="blog_content">
                {* The post name *}
                <div class="h5">
                    <a href="{$lang_link}{$type_post}/{$post->url}" data-post="{$post->id}">{$post->name|escape}</a>
                </div>

                {* The post date *}
                <div class="blog_date"><span>{$post->date|date:"d cFR Y, cD"}</span></div>

                {* The short description of the post *}
                {if $post->annotation}
                    <div class="blog_annotation">
                        {$post->annotation}
                    </div>
                {/if}        
            </div>
        </div>
    {/foreach}
</div>

{* Pagination *}
{include file='pagination.tpl'}
