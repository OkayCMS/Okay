{* Информер избранного (отдаётся аяксом) *}
{if $wished_products|count > 0}
	<a class="nav-link link-black i-favorites" href="{$lang_link}wishlist">
		<span data-language="{$translate_id['index_favorites']}">{$lang->index_favorites} ({$wished_products|count})</span>
	</a>
{else}
	<span class="nav-link i-favorites"><span data-language="{$translate_id['index_favorites']}">{$lang->index_favorites}</span></span>
{/if}