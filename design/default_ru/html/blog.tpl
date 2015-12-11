{* Список записей блога *}

{* Канонический адрес страницы *}
{$canonical="/blog" scope=parent}


<!-- Заголовок /-->
<h1 class="page_title">{$page->name}</h1>

{include file='pagination.tpl'}

<!-- Статьи /-->
<ul id="blog">
	{foreach $posts as $post}
	<li class="block">
		<div class="block_heading"><a data-post="{$post->id}" href="{$lang_link}blog/{$post->url}">{$post->name|escape}</a></div>
        {if $post->image}
        <div class="post_img">
	        <a href="{$lang_link}blog/{$post->url}">
                <img src="{$post->image|resize:140:140:false:$config->resized_blog_dir}"/>
	        </a>
        </div>
        {/if}
        <span class="post_date">{$post->date|date}</span>
		<div>{$post->annotation}</div>
	</li>
	{/foreach}
</ul>
<!-- Статьи #End /-->    

{include file='pagination.tpl'}
        