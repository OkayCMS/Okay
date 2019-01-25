{* selected filters *}
{if $is_filter_page}
<div class="sidebar_top">
    <div class="filters">
        <div class="h2 filter_name">
            <span data-language="selected_features_heading">{$lang->selected_features_heading}</span>
        </div>
        <div class="filter_group">
            <div class="selected_filter_boxes">

                {if $prices->current->min != '' && $prices->current->max != ''}
                    <div class="selected_filter_box">
                        <form class="selected_filter_item" method="post">
                            <button type="submit" name="prg_seo_hide" class="fn_filter_reset s_filter_link checked" value="{furl}">
                                {$lang->features_price}: {$prices->current->min|escape} - {$prices->current->max|escape}
                                <svg class="remove_icon" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="20" height="20" viewBox="0 0 20 20">
                                    <path fill="currentColor" d="M15.833 5.346l-1.179-1.179-4.654 4.654-4.654-4.654-1.179 1.179 4.654 4.654-4.654 4.654 1.179 1.179 4.654-4.654 4.654 4.654 1.179-1.179-4.654-4.654z"></path>
                                </svg>
                            </button>
                        </form>
                    </div>
                {/if}
                
                {* Other filters *}
                {if $other_filters && $smarty.get.filter}
                    {foreach $other_filters as $f}
                        {if in_array($f->url, $smarty.get.filter)}
                            {$furl = {furl params=[filter=>$f->url, page=>null]}}
                            <div class="selected_filter_box">
                                <form class="selected_filter_item" method="post">
                                    <button type="submit" name="prg_seo_hide" class="s_filter_link checked" value="{$furl|escape}">
                                        <span data-language="{$f->translation}">{$f->name}</span>
                                        <svg class="remove_icon" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="20" height="20" viewBox="0 0 20 20">
                                            <path fill="currentColor" d="M15.833 5.346l-1.179-1.179-4.654 4.654-4.654-4.654-1.179 1.179 4.654 4.654-4.654 4.654 1.179 1.179 4.654-4.654 4.654 4.654 1.179-1.179-4.654-4.654z"></path>
                                        </svg>
                                    </button>
                                </form>
                            </div>
                        {/if}
                    {/foreach}
                {/if}
        
                {* Brand filter *}
                {if $category->brands && $smarty.get.b}
                    {foreach $category->brands as $b}
                        {if $brand->id == $b->id || in_array($b->id,$smarty.get.b)}
                            {$furl = {furl params=[brand=>$b->url, page=>null]}}
                            <div class="selected_filter_box">
                                <form class="selected_filter_item" method="post">
                                    <button type="submit" name="prg_seo_hide" class="s_filter_link checked" value="{$furl|escape}">
                                        <span>{$b->name|escape}</span>
                                        <svg class="remove_icon" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="20" height="20" viewBox="0 0 20 20">
                                            <path fill="currentColor" d="M15.833 5.346l-1.179-1.179-4.654 4.654-4.654-4.654-1.179 1.179 4.654 4.654-4.654 4.654 1.179 1.179 4.654-4.654 4.654 4.654 1.179-1.179-4.654-4.654z"></path>
                                        </svg>
                                    </button>
                                </form>
                            </div>
                        {/if}
                    {/foreach}
                {/if}
                
                {* Features filter *}
                {if $features}
                    {foreach $features as $key=>$f}
                        {if $smarty.get.{$f@key}}
                            {foreach $f->features_values as $fv}
                                {if in_array($fv->translit,$smarty.get.{$f@key},true)}
                                    {$furl = {furl params=[$f->url=>$fv->translit, page=>null]}}
                                    <div class="selected_filter_box">
                                        <form class="selected_filter_item" method="post">
                                            <button type="submit" name="prg_seo_hide" class="s_filter_link checked" value="{$furl|escape}">
                                                <span>{$f->name|escape}: {$fv->value|escape}</span>
                                                <svg class="remove_icon" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="20" height="20" viewBox="0 0 20 20">
                                                    <path fill="currentColor" d="M15.833 5.346l-1.179-1.179-4.654 4.654-4.654-4.654-1.179 1.179 4.654 4.654-4.654 4.654 1.179 1.179 4.654-4.654 4.654 4.654 1.179-1.179-4.654-4.654z"></path>
                                                </svg>
                                            </button>
                                        </form>
                                    </div>
                                {/if}
                            {/foreach}
                        {/if}
                    {/foreach}
                {/if}
            </div>
    
            {if $category}
                <form method="post">
                    <button type="submit" name="prg_seo_hide" class="fn_filter_reset filter_reset" value="{$config->root_url}/{$lang_link}catalog/{$category->url}">
                        {$lang->selected_features_reset}
                    </button>
                </form>
            {elseif $brand}
                <form method="post">
                    <button type="submit" name="prg_seo_hide" class="fn_filter_reset filter_reset" value="{$config->root_url}/{$lang_link}brands/{$brand->url}">
                        {$lang->selected_features_reset}
                    </button>
                </form>
            {/if}
        </div>
    </div>
</div>
{/if}
