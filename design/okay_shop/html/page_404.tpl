{* The template of page 404 *}

{* The page heading *}
<h1 class="h1"><span data-page="{$page->id}">{$page->name|escape}</span></h1>

{* The page content *}
<div class="block padding">
    {$page->description}
</div>