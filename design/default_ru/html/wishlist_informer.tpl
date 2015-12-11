{* Информера избранного (отдаётся аяксом) *}
{if $wished_products|count>0}
  <a href="{$lang_link}wishlist/">Избранное ({$wished_products|count})</a>
{else}
  <span>Избранное</span>
{/if}
