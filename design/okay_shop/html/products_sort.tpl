{if $products|count > 0}
    <div class="sort{if $ajax} fn_is_ajax{/if} clearfix">
        <span class="sort_title" data-language="products_sort_by">{$lang->products_sort_by}:</span>

        <a class="sort_link{if $sort=='position'} active_up{/if} no_after" href="javascript:;" onclick="document.location.href = '{furl sort=position page=null}'">
            <span data-language="products_by_default">{$lang->products_by_default}</span>
        </a>

        <a class="sort_link{if $sort=='price'} active_up{elseif $sort=='price_desc'} active_down{/if}" href="javascript:;" onclick="document.location.href = '{if $sort=='price'}{furl sort=price_desc page=null}{else}{furl sort=price page=null}{/if}'">
            <span data-language="products_by_price">{$lang->products_by_price}</span>
        </a>

        <a class="sort_link{if $sort=='name'} active_up{elseif $sort=='name_desc'} active_down{/if}" href="javascript:;" onclick="document.location.href = '{if $sort=='name'}{furl sort=name_desc page=null}{else}{furl sort=name page=null}{/if}'">
            <span data-language="products_by_name">{$lang->products_by_name}</span>
        </a>

        <a class="sort_link {if $sort=='rating'} active_up{elseif $sort=='rating_desc'} active_down{/if}" href="javascript:;" onclick="document.location.href = '{if $sort=='rating'}{furl sort=rating_desc page=null}{else}{furl sort=rating page=null}{/if}'">
            <span data-language="products_by_rating">{$lang->products_by_rating}</span>
        </a>
    </div>
{/if}
