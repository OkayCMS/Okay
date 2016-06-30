{$subject="Заявка на обратный звонок от `$callback->name|escape`" scope=parent}
<h1 style="text-align: center;font: 18px;background: #41ade2;color: #fff;padding: 5px; width: 800px;">
    Заявка на обратный звонок от {$callback->name|escape}
</h1>
<table cellpadding=6 cellspacing=0 style='border-collapse: collapse;border: 2px solid #2c6f95;'>
    <tr style="border-bottom: 2px solid #2c6f95;">
        <td style='padding:6px; width:170px; background-color:#41ade2; border:1px solid #e0e0e0;font-family:arial;'>
            Имя
        </td>
        <td style='padding:6px; width:330px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;'>
            {$callback->name|escape}
        </td>
    </tr>
    <tr style="border-bottom: 2px solid #2c6f95;">
        <td style='padding:6px; width:170px; background-color:#41ade2; border:1px solid #e0e0e0;font-family:arial;'>
            Телефон
        </td>
        <td style='padding:6px; width:330px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;'>
            {$callback->phone|escape}
        </td>
    </tr>
    {if $callback->message}
        <tr style="border-bottom: 2px solid #2c6f95;">
            <td style='padding:6px; width:170px; background-color:#41ade2; border:1px solid #e0e0e0;font-family:arial;'>
                Сообщение
            </td>
            <td style='padding:6px; width:330px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;'>
                {$callback->message|escape}
            </td>
        </tr>
    {/if}
    <tr style="border-bottom: 2px solid #2c6f95;">
        <td style='padding:6px; width:170px; background-color:#41ade2; border:1px solid #e0e0e0;font-family:arial;'>
            Страница обращения
        </td>
        <td style='padding:6px; width:330px; background-color:#ffffff; border:1px solid #e0e0e0;font-family:arial;'>
            <a href="{$callback->url}" target="_blank">{$callback->url}</a>
        </td>
    </tr>
</table>

<div style="float: left;width: 800px; border: 2px dashed #41ade2; text-align: center;margin-top: 10px;padding: 5px">
    Приятной работы с <a href='http://okay-cms.com'>Okay</a>!
</div>