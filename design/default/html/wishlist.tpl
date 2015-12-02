{$meta_title = $lang->izbrannye_tovary scope=parent}

{* Тело страницы *}
{$page->body}

<!-- Список товаров-->
<h1 class="h1">{$lang->izbrannoe}</h1>

{if $wished_products|count}
<ul class="wish_products products row">
    {foreach $wished_products as $product}
        <!-- Товар-->
        <li class="product column col_4">
            <div class="inner">
                <!-- Фото товара -->
                {if $product->image}
                    <div class="image">
                        <a href="{$lang_link}products/{$product->url}"><img src="{$product->image->filename|resize:200:200}" alt="{$product->name|escape}"/></a>
                    </div>
                {/if}
                <!-- Фото товара (The End) -->
                
                <!-- Название товара -->
                <a class="product_name" data-product="{$product->id}" href="{$lang_link}products/{$product->url}">{$product->name|escape}</a>
                <a href="{$lang_link}wishlist/delete/{$product->id}">{$lang->iz_izbrannogo}</a>
                <!-- Название товара (The End) -->
            </div>
        </li>
        <!-- Товар (The End)-->
    {/foreach}
</ul>
{else}
	{$lang->v_izbrannom_pusto}
{/if}