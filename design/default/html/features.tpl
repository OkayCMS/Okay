{* Фильтр по брендам *}
{if $category->brands}
<div id="brands">
    <span class="block_heading">{$lang->brendy}</span>
    <a href="{furl params=[brand=>null, page=>null]}" {if !$brand->id && !$smarty.get.b}class="selected"{/if}>{$lang->vse_brendy}</a>
    {foreach $category->brands as $b}
        <a data-brand="{$b->id}" href="{furl params=[brand=>$b->url, page=>null]}" {if $brand->id == $b->id || $smarty.get.b && in_array($b->id,$smarty.get.b)}class="selected"{/if}>{$b->name|escape}</a>
    {/foreach}
</div>
{/if}

{* Фильтр по свойствам *}
{if $features || $prices}
    <div id="features">
        {foreach $features as $key=>$f}
            <span class="feature_name block_heading" data-feature="{$f->id}">
                {$f->name}
            </span>

            <div class="feature_values">
                <a href="{furl params=[$f->url=>null, page=>null]}" {if !$smarty.get.$key}class="selected"{/if}>{$lang->vse}</a>
                {foreach $f->options as $o}
                    <a href="{furl params=[$f->url=>$o->translit, page=>null]}" {if $smarty.get.{$f@key} && in_array($o->translit,$smarty.get.{$f@key})}class="selected"{/if}>{$o->value|escape}</a>
                {/foreach}
            </div>
        {/foreach}
        {if $prices}
            <span class="feature_name block_heading" data-feature="{$f->id}">
                {$lang->tsena}:
            </span>
            <div class="feature_values">
                <form>
                    <div id="slider-range"></div>
                    <div id="selected_prices">
                        <span id="selected_prices_min"></span>
                        &mdash;
                        <span id="selected_prices_max"></span>
                        {$currency->sign}
                    </div>
                    <input type="hidden" id="p_min" name="p[min]" value="{$prices->current->min|default:$prices->range->min}" data-price="{$prices->range->min}" />
                    <input type="hidden" id="p_max" name="p[max]" value="{$prices->current->max|default:$prices->range->max}" data-price="{$prices->range->max}" />
                </form>
            </div>
        {/if}
    </div>
    {if $prices}
        <link href="design/{$settings->theme|escape}/css/jquery-ui-slider.min.css" rel="stylesheet" type="text/css" media="screen"/>
        <script src="design/{$settings->theme}/js/jquery-ui-slider.min.js"></script>
        <script src="design/{$settings->theme}/js/filter.js"></script>
    {/if}
{/if}
