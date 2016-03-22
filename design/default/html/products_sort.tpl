{if $products|count > 0}
    <div class="sort{if $ajax} is_ajax{/if}">
        <span data-language="{$translate_id['products_sort_by']}">{$lang->products_sort_by}</span>:
        <a {if $sort=='position'} class="active_up"{/if} href="{furl sort=position page=null}" data-language="{$translate_id['products_by_default']}">{$lang->products_by_default}</a>
        <a {if $sort=='price'} class="active_up" {elseif $sort=='price_desc'}class="active_down"{/if} {if $sort=='price'}href="{furl sort=price_desc page=null}" {else}href="{furl sort=price page=null}"{/if} data-language="{$translate_id['products_by_price']}">{$lang->products_by_price}</a>
        <a {if $sort=='name'} class="active_up" {elseif $sort=='name_desc'}class="active_down"{/if} {if $sort=='name'}href="{furl sort=name_desc page=null}" {else}href="{furl sort=name page=null}{/if}" data-language="{$translate_id['products_by_name']}">{$lang->products_by_name}</a>
    </div>
{/if}