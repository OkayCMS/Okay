{* Информера корзины (отдаётся аяксом) *}

{if $comparison->products}
	{foreach $comparison->products as $cp}
		<div class="cp_item">
			<a href="{$lang_link}products/{$cp->url|escape}" class="cp_image">
				{if $cp->image}
					<img src="{$cp->image->filename|resize:50:50}" alt="{$cp->name|escape}"/>
				{/if}
			</a>
			<a href="{$lang_link}products/{$cp->url|escape}" class="cp_link">{$cp->name|escape}</a>
			<a href="#" data-id="{$cp->id}" class="comparison_button" data-action="delete" title="Удалить из сравнения"></a>
		</div>
	{/foreach}
	<a class="button" href="{$lang_link}comparison">
Сравнить товары </a>
{else}
	Папка пуста
{/if}