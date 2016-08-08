{* Письмо ответа на комметарий пользователю *}
{$subject = "{$lang->email_comment_theme} `{$settings->site_name}`" scope=parent}
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
</head>
    <body>
    <h1 style="text-align: center;font: 18px;background: #41ade2;color: #fff;padding: 5px; width: 800px;">
        {$lang->email_comment_title} ({$parent_comment->date|date} {$parent_comment->date|time}): {$lang->email_comment_on_site} {$settings->site_name}
    </h1>
        <div style="margin-bottom: 15px">
            {if $parent_comment->type == 'product'}
                {$lang->email_comment_product} &nbsp;<a target="_blank" href="{$config->root_url}/{$lang_link}products/{$parent_comment->product->url}#comment_{$parent_comment->id}">{$parent_comment->product->name}</a>
            {/if}
            {if $parent_comment->type == 'blog'}
                {$lang->email_comment_artilcle} &nbsp;<a target="_blank" href="{$config->root_url}/{$lang_link}blog/{$parent_comment->post->url}#comment_{$parent_comment->id}">{$parent_comment->post->name}</a>
            {/if}
        </div>
        <div style="border: 1px dashed #41ade2;padding: 5px;margin-left: 10px;width: 800px;">
            {$parent_comment->text|escape}
        </div>
        <h2>{$lang->email_comment_answer} ({$comment->date|date} {$comment->date|time}):</h2>
        <div style="border: 1px dashed #41ade2;padding: 5px;margin-left: 10px;width: 800px;">{$comment->text|escape}</div>
    </body>
</html>