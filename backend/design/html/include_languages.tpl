
<style type="text/css">
<!--
.languages {
    width:100%;
    display:table;
    margin-bottom:20px;
}
.languages a{
    border:1px solid #ABADB3;
    padding:3px 5px;
    margin-right:5px;
    background: #FFFFFF;
    text-decoration:none;
    color:#787878;
    line-height:normal;
}
.languages a.active, .languages a:hover{
    color:#18A5FF;
    border:1px solid #18A5FF;
}
.add_lang{
    display:none;
}

-->
</style>

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

{if $languages}
    <div class='languages'>
    {foreach $languages as $lang}
        <a href="{url lang_id=$lang->id id=$id}" data-label='{$lang->label}' {if $lang->id == $lang_id}class='active'{/if}>{$lang->name}{if $langs.{$lang->id}}&crarr;{/if}</a>
    {/foreach}
    </div>
{/if}