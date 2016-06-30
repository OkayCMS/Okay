{* Канонический адрес страницы *}
{$canonical="/brands" scope=parent}

<div class="container">
	{* Хлебные крошки *}
	{include file='breadcrumb.tpl'}

	{* Заголовок страницы *}
	<h1 class="m-b-1"><span data-page="{$page->id}">{$page->name}</span></h1>

	{* Список брендов *}
	{if $brands}
		<div class="row">
			{foreach $brands as $b}
				<div class="col-sm-6 col-md-4 col-lg-3 col-xl-2 text-xs-center m-b-1 m-b-3-md_down brand-list">
					<a href="{$lang_link}brands/{$b->url}">
						{* Изображение бренда *}
						{if $b->image}
							<img class="img-fluid center-block m-b-1" src="{$b->image|resize:165:90:false:$config->resized_brands_dir}" alt="{$b->name|escape}" title="{$b->name|escape}">
						{/if}

						{* Название бренда *}
						<span data-brand="{$b->id}">{$b->name}</span>
					</a>
				</div>
			{/foreach}
		</div>
	{/if}

    {* Тело страницы *}
    {$page->body}
</div>