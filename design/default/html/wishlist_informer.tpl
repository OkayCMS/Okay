{* Информера избранного (отдаётся аяксом) *}
{if $wished_products|count>0}
  <a href="{$lang_link}wishlist/">{$lang->wishlist_info_wishlist} ({$wished_products|count})</a>
{else}
  <span>{$lang->wishlist_info_wishlist}</span>
{/if}
