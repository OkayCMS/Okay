{* Список записей блога *}

{* Канонический адрес страницы *}
{$canonical="/brands" scope=parent}

<!-- Заголовок /-->
<h1 class="h1">{$page->name}</h1>

{if $brands}
<ul id="brands_list">
	{foreach $brands as $b}
	<li>
		{if $b->image}
			<a href="{$lang_link}brands/{$b->url}" data-brand="{$b->id}"><img src="{$b->image|resize:100:100:false:$config->resized_brands_dir}" alt="{$b->name|escape}"></a>
        {else}
			<a href="{$lang_link}brands/{$b->url}" data-brand="{$b->id}">{$b->name}</a>
		{/if}
		{*<p>{$brand->description}</p>*}
	</li>
	{/foreach}
</ul>
{/if}
