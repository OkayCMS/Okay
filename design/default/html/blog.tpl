{* Список записей блога *}
{* Канонический адрес страницы *}
{$canonical="/blog" scope=parent}

<div class="container">
	{* Хлебные крошки *}
	{include file='breadcrumb.tpl'}

	{* Заголовок страницы *}
	<h1 class="m-b-1"><span data-page="{$page->id}">{$page->name}</span></h1>

	<div class="row">
		{foreach $posts as $post}
            <div class="col-md-12 p-y-1 row">
                <div class="col-xs-12 col-md-1 m-b-1 hidden-md-down">
                    <a class="blog-img" href="{$lang_link}blog/{$post->url}">
                        {* Дата создания поста *}
                        <div class="blog-data">{$post->date|date}</div>

                        {* Изображение поста *}
                        {if $post->image}
                            <img class="img-fluid" alt="{$post->name|escape}" title="{$post->name|escape}" src="{$post->image|resize:162:77:false:$config->resized_blog_dir}" />
                        {/if}
                    </a>
                </div>
                <div class="col-xs-12 col-lg-11 m-b-1">
                    {* Название поста *}
                    <div class="h5 font-weight-bold">
                        <a class="link-black" href="{$lang_link}blog/{$post->url}" data-post="{$post->id}">{$post->name|escape}</a>
                    </div>

                    {* Краткое описание поста *}
                    {if $post->annotation}
                        <div>
                            {$post->annotation}
                        </div>
                    {/if}
                </div>
            </div>
		{/foreach}
	</div>
	{* Пагинация *}
	{include file='pagination.tpl'}
</div>