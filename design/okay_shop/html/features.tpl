{if ($category->subcategories && $category->count_children_visible) ||
($category->path[$category->level_depth-2]->subcategories && $category->path[$category->level_depth-2]->count_children_visible)}
    <div class="filters__item--mob">
    <div class="filters_heading fn_switch lg-hidden">
        <span data-language="features_catalog">{$lang->features_catalog}</span>
        <i class="angle_icon"></i>
    </div>

    <div class="filters tablet-hidden">
        <div class="h2 filter_name tablet-hidden">
        <span data-language="features_catalog">{$lang->features_catalog}</span>
        </div>
        <div class="">
            {function name=categories_tree_sidebar}
                {if $categories}
                    <div class="level_{$level} {if $level == 1}catalog_menu {else}subcatalog {/if}">
                        {foreach $categories as $c}
                            {if $c->visible}
                                <div class="catalog_item has_child">
                                    <{if $c->id == $category->id}b{else}a{/if} class="catalog_link{if $c->subcategories} sub_cat{/if}{if $category->id == $c->id} selected{/if}" href="{$lang_link}catalog/{$c->url}" data-category="{$c->id}">
                                        <span>{$c->name|escape}</span>
                                    </{if $c->id == $category->id}b{else}a{/if}>
                                </div>
                            {/if}
                        {/foreach}
                    </div>
                {/if}
            {/function}
            {if $category->subcategories && $category->count_children_visible}
                {categories_tree_sidebar categories=$category->subcategories level=1}
            {elseif $category->path[$category->level_depth-2]->subcategories && $category->path[$category->level_depth-2]->count_children_visible}
                {categories_tree_sidebar categories=$category->path[$category->level_depth-2]->subcategories level=1}
            {/if}
        </div>
    </div>
</div>
{/if}

{if $brand->categories}
    <div class="catalog_nav filters tablet-hidden">
        <div class="h2 filter_name">
            <span data-language="features_catalog">{$lang->features_catalog}</span>
        </div>
        <div class="filters">
            <div class="level_1 catalog_menu">
                {foreach $brand->categories as $c}
                    <div class="catalog_item has_child">
                        <a class="catalog_link" href="{$lang_link}catalog/{$c->url}/brand-{$brand->url}" data-category="{$c->id}">
                            <span>{$c->name|escape}</span>
                        </a>
                    </div>
                {/foreach}
            </div>
        </div>
    </div>
{/if}

{* Filters *}
{if ($category->brands || ($prices->range->min != '' && $prices->range->max != '') || $features)}
    <div class="filters_heading fn_switch lg-hidden">
        <span data-language="filters">{$lang->filters}</span>
        <i class="angle_icon"></i>
    </div>

    <div class="filters tablet-hidden">
        {* Ajax Price filter *}
        {if $prices->range->min != '' && $prices->range->max != ''}
            <div class="h2 filter_name">
                <span data-language="features_price">{$lang->features_price}</span>
            </div>

            <div class="filter_group">
                {* Price slider *}
                <div id="fn_slider_price"></div>

                {* Price range *}
                <div class="price_range">
                    <div class="price_label">
                        <input class="min_input" id="fn_slider_min" name="p[min]" value="{($prices->current->min|default:$prices->range->min)|escape}" data-price="{$prices->range->min}" type="text">
                    </div>

                    <div class="price_label max_price">
                        <input class="max_input" id="fn_slider_max" name="p[max]" value="{($prices->current->max|default:$prices->range->max)|escape}" data-price="{$prices->range->max}" type="text">
                    </div>
                </div>
            </div>
        {/if}

        {* Other filters *}
        {if $other_filters}
            {* Filter name *}
            <div class="h2 filter_name">
                <span data-language="features_other_filter">{$lang->features_other_filter}</span>
            </div>
            <div class="filter_group">
                {* Display all brands *}
                <div class="filter_item">
                    <form method="post">
                        {$furl = {furl params=[filter=>null, page=>null]}}
                        <button type="submit" name="prg_seo_hide" class="filter_link {if !$smarty.get.filter} checked{/if}" value="{$furl|escape}">
                            <i class="filter_indicator"></i>
                            <span data-language="features_all">{$lang->features_all}</span>
                        </button>
                    </form>
                </div>
                {* Other filter list *}
                {foreach $other_filters as $f}
                    <div class="filter_item">
                        {$furl = {furl params=[filter=>$f->url, page=>null]}}
                        {if $seo_hide_filter || ($smarty.get.filter && in_array($f->url, $smarty.get.filter))}
                            <form method="post">
                                <button type="submit" name="prg_seo_hide" class="filter_link{if $smarty.get.filter && in_array($f->url, $smarty.get.filter)} checked{/if}" value="{$furl|escape}">
                                    <i class="filter_indicator"></i>
                                    <span data-language="{$f->translation}">{$f->name}</span>
                                </button>
                            </form>
                        {else}
                            <a class="filter_link{if $smarty.get.filter && in_array($f->url, $smarty.get.filter)} checked{/if}" href="{$furl}">
                                <i class="filter_indicator"></i>
                                <span data-language="{$f->translation}">{$f->name}</span>
                            </a>
                        {/if}
                    </div>
                {/foreach}
            </div>
        {/if}

        {* Brand filter *}
        {if $category->brands}
            {* Brand name *}
            <div class="h2 filter_name">
                <span data-language="features_manufacturer">{$lang->features_manufacturer}</span>
            </div>
            <div class="filter_group">
                {* Display all brands *}
                <div class="filter_item">
                    <form method="post">
                        {$furl = {furl params=[brand=>null, page=>null]}}
                        <button type="submit" name="prg_seo_hide" class="filter_link {if !$brand->id && !$smarty.get.b} checked{/if}" value="{$furl|escape}">
                            <i class="filter_indicator"></i>
                            <span data-language="features_all">{$lang->features_all}</span>
                        </button>
                    </form>
                </div>
                {* Brand list *}
                {foreach $category->brands as $b}
                    <div class="filter_item">
                        {$furl = {furl params=[brand=>$b->url, page=>null]}}
                        {if $seo_hide_filter || ($brand->id == $b->id || $smarty.get.b && in_array($b->id,$smarty.get.b))}
                            <form method="post">
                                <button type="submit" name="prg_seo_hide" class="filter_link{if $brand->id == $b->id || $smarty.get.b && in_array($b->id,$smarty.get.b)} checked{/if}" value="{$furl|escape}">
                                    <i class="filter_indicator"></i>
                                    <span>{$b->name|escape}</span>
                                </button>
                            </form>
                        {else}
                            <a class="filter_link{if $brand->id == $b->id || $smarty.get.b && in_array($b->id,$smarty.get.b)} checked{/if}" href="{$furl}">
                                 <i class="filter_indicator"></i>
                                <span>{$b->name|escape}</span>
                            </a>
                        {/if}
                    </div>
                {/foreach}
            </div>
        {/if}
        
        {* Features filter *}
        {if $features}
            {foreach $features as $key=>$f}
                {* Feature name *}
                <div class="h2 filter_name" data-feature="{$f->id}">{$f->name|escape}</div>

                <div class="filter_group">
                    {* Display all features *}
                    <div class="filter_item">
                        <form method="post">
                            {$furl = {furl params=[$f->url=>null, page=>null]}}
                            <button type="submit" name="prg_seo_hide" class="filter_link {if !$smarty.get.$key} checked{/if}" value="{$furl|escape}">
                                <i class="filter_indicator"></i>
                                <span data-language="features_all">{$lang->features_all}</span>
                            </button>
                        </form>
                    </div>
                    {* Feture value *}
                    {foreach $f->features_values as $fv}
                        <div class="filter_item">
                            {$furl = {furl params=[$f->url=>$fv->translit, page=>null]}}
                            {if !$fv->to_index || $seo_hide_filter || ($smarty.get.{$f@key} && in_array($fv->translit,$smarty.get.{$f@key},true))}
                                <form method="post">
                                    <button type="submit" name="prg_seo_hide" class="filter_link{if $smarty.get.{$f@key} && in_array($fv->translit,$smarty.get.{$f@key},true)} checked{/if}" value="{$furl|escape}">
                                        <i class="filter_indicator"></i>
                                        <span>{$fv->value|escape}</span>
                                    </button>
                                </form>
                            {else}
                                <a class="filter_link{if $smarty.get.{$f@key} && in_array($fv->translit,$smarty.get.{$f@key},true)} checked{/if}" href="{$furl}">
                                    <i class="filter_indicator"></i>
                                    <span>{$fv->value|escape}</span>
                                </a>
                            {/if}
                        </div>
                    {/foreach}

                </div>
            {/foreach}
        {/if}
    </div>
{/if}
