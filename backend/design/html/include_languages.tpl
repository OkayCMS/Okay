{*id мультиязычных сущностей сайта*}
{if $product->id}
    {$id = $product->id}
{/if}
{if $category->id}
    {$id = $category->id}
{/if}
{if $brand->id}
    {$id = $brand->id}
{/if}
{if $feature->id}
    {$id = $feature->id}
{/if}
{if $post->id}
    {$id = $post->id}
{/if}
{if $page->id}
    {$id = $page->id}
{/if}
{if $payment_method->id}
    {$id = $payment_method->id}
{/if}
{if $delivery->id}
    {$id = $delivery->id}
{/if}
{if $language->id}
    {$id = $language->id}
{/if}
{if $order->id}
    {$id = $order->id}
{/if}
{if $translation->id}
    {$id = $translation->id}
{/if}

{*Список языков*}
{if $languages}
    {foreach $languages as $lang}
        <a class="flag flag_{$lang->id} {if $lang->id == $lang_id} focus{/if} hint-bottom-middle-t-info-s-small-mobile  hint-anim" data-hint="{$lang->name|escape}" href="{url lang_id=$lang->id id=$id}" data-label="{$lang->label}">
            <img src="../files/lang/{$lang->label}.png" width="32px;" height="32px;">
        </a>
    {/foreach}
{/if}
