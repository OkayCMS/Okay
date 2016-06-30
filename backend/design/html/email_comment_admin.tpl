{if $comment->approved}
{$subject="Новый комментарий от `$comment->name|escape`" scope=parent}
{else}
{$subject="Комментарий от `$comment->name|escape` ожидает одобрения" scope=parent}
{/if}
{if $comment->approved}
    <h1 style="text-align: center;font: 18px;background: #41ade2;color: #fff;padding: 5px; width: 800px;">
        <a href="{$config->root_url}/backend/index.php?module=CommentsAdmin" style="color: #fff!important;">Новый комментарий</a>
        от {$comment->name|escape}
    </h1>
{else}
    <h1 style="text-align: center;font: 18px;background: #41ade2;color: #fff;padding: 5px; width: 800px;">
        <a href="{$config->root_url}/backend/index.php?module=CommentsAdmin" style="color: #fff!important;">Комментарий</a>
        от {$comment->name|escape} ожидает одобрения
    </h1>
{/if}

<table cellpadding="6" cellspacing="0" style="border-collapse: collapse; border: 2px solid #2c6f95;">
   <tr style="border-bottom: 2px solid #2c6f95;">
    <td style="padding:6px; width:170px; background-color:#41ade2;font-family:arial;">
      Имя
    </td>
    <td style="padding:6px; width:330px; background-color:#ffffff;font-family:arial;">
      {$comment->name|escape}
    </td>
  </tr>
    {if $comment->email}
        <tr style="border-bottom: 2px solid #2c6f95;">
            <td style="padding:6px; width:170px; background-color:#41ade2;font-family:arial;">
                E-mail
            </td>
            <td style="padding:6px; width:330px; background-color:#ffffff;font-family:arial;">
                {$comment->email|escape}
            </td>
        </tr>
    {/if}
   <tr style="border-bottom: 2px solid #2c6f95;">
    <td style="padding:6px; background-color:#41ade2;font-family:arial;">
      Комментарий
    </td>
    <td style="padding:6px; background-color:#ffffff;font-family:arial;">
      {$comment->text|escape|nl2br}
    </td>
  </tr>
   <tr style="border-bottom: 2px solid #2c6f95;">
    <td style="padding:6px; background-color:#41ade2;font-family:arial;">
      Время
    </td>
    <td style="padding:6px; width:170px; background-color:#ffffff;font-family:arial;">
      {$comment->date|date} {$comment->date|time}
    </td>
  </tr>
   <tr style="border-bottom: 2px solid #2c6f95;">
    <td style="padding:6px; width:170px; background-color:#41ade2;font-family:arial;">
      Статус
    </td>
    <td style="padding:6px; width:330px; background-color:#ffffff;font-family:arial;">
      {if $comment->approved}
        Одобрен    
      {else}
        Ожидает одобрения
      {/if}
    </td>
  </tr>
 <tr style="border-bottom: 2px solid #2c6f95;">
  <td style='padding:6px; background-color:#41ade2;font-family:arial;'>
    IP
  </td>
  <td style='padding:6px; width:170px; background-color:#ffffff;font-family:arial;'>
    {$comment->ip|escape} (<a href='http://www.ip-adress.com/ip_tracer/{$comment->ip}/'>где это?</a>)
  </td>
  </tr>
   <tr style="border-bottom: 2px solid #2c6f95;">
    <td style="padding:6px; width:170px; background-color:#41ade2;font-family:arial;">
      {if $comment->type == 'product'}К товару{/if}
      {if $comment->type == 'blog'}К записи{/if}
    </td>
    <td style="padding:6px; width:330px; background-color:#ffffff;font-family:arial;">
      {if $comment->type == 'product'}<a target="_blank" href="{$config->root_url}/products/{$comment->product->url}#comment_{$comment->id}">{$comment->product->name}</a>{/if}
      {if $comment->type == 'blog'}<a target="_blank" href="{$config->root_url}/blog/{$comment->post->url}#comment_{$comment->id}">{$comment->post->name}</a>{/if}
    </td>
  </tr>
</table>
<br><br>
<div style="float: left;width: 800px; border: 2px dashed #41ade2; text-align: center;margin-top: 10px;padding: 5px">
    Приятной работы с <a href='http://okay-cms.com'>Okay</a>!
</div>