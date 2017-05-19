{* Page template *}

{* The canonical address of the page *}
{$canonical="/{$page->url}" scope=parent}

{if $page->url == '404'}
    {include file='page_404.tpl'}
{else}

    {* The page heading *}
    <h1 class="h1">
        <span data-page="{$page->id}">{$page->name|escape}</span>
    </h1>
    
    {* The page content *}
    <div class="block padding">
        {$page->description}
    </div>
    
{/if}
