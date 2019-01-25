{* The products comparison page *}

{* The page title *}
{$meta_title = $lang->comparison_title scope=parent}

{* The page heading *}
<h1 class="h1">
    <span data-language="comparison_header">{$lang->comparison_header}</span>
</h1>

{if $comparison->products}
    <div class="comparison_page clearfix block">
        <div class="comparison_left">
            <div class="fn_resize compare_controls">

                {* Show all/different product features *}
                {if $comparison->products|count > 1}
                    <div class="fn_show compare_show">

                        <a href="#show_all" class="active"><span data-language="comparison_all">{$lang->comparison_all}</span></a>

                        <a href="#show_dif" class="unique"><span data-language="comparison_unique">{$lang->comparison_unique}</span></a>

                    </div>
                {/if}

            </div>

            {* Rating *}
            <div class="cprs_rating" data-use="cprs_rating">
                <span data-language="product_rating">{$lang->product_rating}</span>
            </div>

            {* Feature name *}
            {if $comparison->features}
                {foreach $comparison->features as $id=>$cf}
                    <div class="cprs_feature_{$id} cell{if $cf->not_unique} not_unique{/if}" data-use="cprs_feature_{$id}">
                        <span data-feature="{$cf->feature_id}">{$cf->name}</span>
                    </div>
                {/foreach}
            {/if}

        </div>

        <div class="fn_comparison_products comparison_products">
            {foreach $comparison->products as $id=>$product}
                <div class="comparison_item">
                    <div class="fn_resize">
                        {include file="product_list.tpl"}
                    </div>

                    {* Rating *}
                    <div id="product_{$product->id}" class="cprs_rating">
                        <span class="rating_starOff">
                            <span class="rating_starOn" style="width:{$product->rating*90/5|string_format:'%.0f'}px;"></span>
                        </span>
                    </div>

                    {* Feature value *}
                    {if $product->features}
                        {foreach $product->features as $id=>$value}
                            <div class="cprs_feature_{$id} cell{if $comparison->features.{$id}->not_unique} not_unique{/if}">
                                {$value|default:"&mdash;"}
                            </div>
                        {/foreach}
                    {/if}

                </div>
            {/foreach}
        </div>
    </div>
{else}
    <div class="block padding">
        <span data-language="comparison_empty">{$lang->comparison_empty}</span>
    </div>
{/if}
