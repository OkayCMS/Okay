{* Письмо ответа на комметарий пользователю *}
{$subject = "Ответ на комментарий `{$settings->site_name}`" scope=parent}
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
</head>
    <body>
    <h1 style="text-align: center;font: 18px;background: #41ade2;color: #fff;padding: 5px; width: 800px;">
        Вы оставили комментарий ({$parent_comment->date|date} {$parent_comment->date|time}): на сайте {$settings->site_name}
    </h1>
        <div style="margin-bottom: 15px">
            {if $parent_comment->type == 'product'}
                Товар: &nbsp;<a target="_blank" href="{$config->root_url}/products/{$parent_comment->product->url}#comment_{$parent_comment->id}">{$parent_comment->product->name}</a>
            {/if}
            {if $parent_comment->type == 'blog'}
                Статья: &nbsp;<a target="_blank" href="{$config->root_url}/blog/{$parent_comment->post->url}#comment_{$parent_comment->id}">{$parent_comment->post->name}</a>
            {/if}
        </div>
        <div style="border: 1px dashed #41ade2;padding: 5px;margin-left: 10px;width: 800px;">
            {$parent_comment->text|escape}
        </div>
        <h2>Ответ ({$comment->date|date} {$comment->date|time}):</h2>
        <div style="border: 1px dashed #41ade2;padding: 5px;margin-left: 10px;width: 800px;">{$comment->text|escape}</div>
    </body>
</html>