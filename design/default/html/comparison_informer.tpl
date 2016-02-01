{* Информер сравнения (отдаётся аяксом) *}
{if $comparison->products|count > 0}
	<a class="nav-link link-black i-comparison" href="{$lang_link}comparison">
		<span data-language="{$translate_id['index_comparison']}">{$lang->index_comparison} ({$comparison->products|count})</span>
	</a>
{else}
	<span class="nav-link i-comparison">
		<span data-language="{$translate_id['index_comparison']}">{$lang->index_comparison}</span>
	</span>
{/if}