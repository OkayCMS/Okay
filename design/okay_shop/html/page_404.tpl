{* The template of page 404 *}

{* The page heading *}
{*<h1 class="h1"><span data-page="{$page->id}">{if $page->name_h1|escape}{$page->name_h1|escape}{else}{$page->name|escape}{/if}</span></h1>*}

{* The page content *}
<div class="block padding">
    <div class="container">
        <div class="row">
            <div class="col-sm-12 col-md-5">
                {$page->description}
            </div>
            <div class="col-sm-12 col-md-7">
                <div class="menu_404">
                    <div class="text_404">
                        <span data-language="page404_text">{$lang->page404_text}</span>
                    </div>
                    {* 404 menu *}
                    {$menu_404}
                </div>
            </div>
        </div>
    </div>
</div>