{*Вывод меток*}
{if $smarty.get.module == "OrderAdmin"}
    {foreach $labels as $l}
        {if in_array($l->id, $order_labels)}
            <span class="tag font-xs" style="background-color:#{$l->color};" >{$l->name|escape}</span>
            <input type="hidden" name="order_labels[]" value="{$l->id}">
        {/if}
    {/foreach}
{else}
    {if $order->labels}
        {foreach $order->labels as $l}
            <span class="tag" style="background-color:#{$l->color};" >{$l->name|escape}</span>
        {/foreach}
    {/if}
{/if}
