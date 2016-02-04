{* Список записей блога *}
{* Канонический адрес страницы *}
{$canonical="/blog" scope=parent}
{* @END Канонический адрес страницы *}
<div class="container">
	{* Хлебные крошки *}
	{include file='breadcrumb.tpl'}
	{* @END Хлебные крошки *}
	{* Заголовок страницы *}
	<h1 class="m-b-1"><span data-page="{$page->id}">{$page->name}</span></h1>
	{* Заголовок страницы *}
	<div class="row">
		{foreach $posts as $post}
            <div class="col-md-12 p-y-1">
                <div class="col-xs-12 col-md-1 m-b-1 m-b-0-md_down">
                    <a class="blog-img" href="{$lang_link}blog/{$post->url}">
                        {* Дата создания поста *}
                        <div class="blog-data hidden-md-down">{$post->date|date}</div>
                        {* @END Дата создания поста *}
                        {* Изображение поста *}
                        {if $post->image}
                            <img class="hidden-md-down img-fluid" src="{$post->image|resize:162:77:false:$config->resized_blog_dir}" />
                        {/if}
                        {* @END Изображение поста *}
                    </a>
                </div>
                <div class="col-xs-12 col-md-11 m-b-1">
                    {* Название поста *}
                    <div class="h5 font-weight-bold">
                        <a class="link-black" href="{$lang_link}blog/{$post->url}" data-post="{$post->id}">{$post->name|escape}</a>
                    </div>
                    {* @END Название поста *}
                    {* Краткое описание поста *}
                    {if $post->annotation}
                        <div>
                            {$post->annotation}
                        </div>
                    {/if}
                    {* @END Краткое описание поста *}
                </div>
            </div>
		{/foreach}
	</div>
	{* Пагинация *}
	{include file='pagination.tpl'}
	{* @END Пагинация *}
</div>