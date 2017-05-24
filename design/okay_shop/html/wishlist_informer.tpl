{* Информер избранного (отдаётся аяксом) *}
{if $wished_products|count > 0}
    <a href="{$lang_link}wishlist">
        <i class="wish_icon"></i>
        <span class="informer_name tablet-hidden" data-language="wishlist_header">{$lang->wishlist_header}</span> <span class="informer_counter">({$wished_products|count})</span>
    </a>
{else}
    <span>
        <i class="wish_icon"></i>
        <span class="informer_name tablet-hidden" data-language="wishlist_header">{$lang->wishlist_header}</span>
    </span>
{/if}
