{* Compaison informer (given by Ajax) *}
{if $comparison->products|count > 0}
    <a href="{$lang_link}comparison">
        <i class="compare_icon"></i>
        <span class="informer_name tablet-hidden" data-language="index_comparison">{$lang->index_comparison}</span>
        <span class="informer_counter">({$comparison->products|count})</span>
    </a>
{else}
    <div>
        <i class="compare_icon"></i>
        <span class="informer_name tablet-hidden" data-language="index_comparison">{$lang->index_comparison}</span>
    </div>
{/if}
