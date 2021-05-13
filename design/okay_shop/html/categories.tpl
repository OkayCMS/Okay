<nav id="categories" data-title="{$lang->index_categories}">
    {if $categories}
        {function name=categories_tree}
        <ul class="level_{$level} {if $level == 1}categories_menu {else}subcategory {/if}">
            {foreach $categories as $c}
                {if $c->visible}
                    {if $c->subcategories && $c->count_children_visible}
                        <li class="category_item has_child">
                            <a class="category_link{if $category->id == $c->id} selected{/if}" href="{$lang_link}catalog/{$c->url}" data-category="{$c->id}">{$c->name|escape}<i class="arrow_right tablet-hidden">{include file='svg.tpl' svgId='arrow_right'}</i></a>
                            <i class="fn_switch cat_switch lg-hidden"></i>
                            {categories_tree categories=$c->subcategories level=$level + 1}
                        </li>
                    {else}
                        <li class="category_item">
                            <a class="category_link{if $category->id == $c->id} selected{/if}" href="{$lang_link}catalog/{$c->url}" data-category="{$c->id}">{$c->name|escape}</a>
                        </li>
                    {/if}
                {/if}
            {/foreach}
        </ul>
        {/function}
        {categories_tree categories=$categories level=1}
    {/if}
</nav>