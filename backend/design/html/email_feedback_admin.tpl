{$subject="Вопрос от пользователя `$feedback->name|escape`" scope=parent}
<h1 style="text-align: center;font: 18px;background: #41ade2;color: #fff;padding: 5px; width: 800px;">
    Вопрос от пользователя {$feedback->name|escape}
</h1>
<table cellpadding=6 cellspacing=0 style='border-collapse: collapse; border: 2px solid #2c6f95;'>
  <tr style="border-bottom: 2px solid #2c6f95;">
    <td style='padding:6px; width:170px; background-color:#41ade2; font-family:arial;'>
      Имя
    </td>
    <td style='padding:6px; width:330px; background-color:#ffffff; font-family:arial;'>
      {$feedback->name|escape}
    </td>
  </tr>
  <tr style="border-bottom: 2px solid #2c6f95;">
    <td style='padding:6px; width:170px; background-color:#41ade2; font-family:arial;'>
      Email
    </td>
    <td style='padding:6px; width:330px; background-color:#ffffff; font-family:arial;'>
      <a href='mailto:{$feedback->email|escape}?subject={$settings->site_name}'>{$feedback->email|escape}</a>
    </td>
  </tr>
  <tr style="border-bottom: 2px solid #2c6f95;">
    <td style='padding:6px; background-color:#41ade2; font-family:arial;'>
      IP
    </td>
    <td style='padding:6px; width:170px; background-color:#ffffff; font-family:arial;'>
      {$feedback->ip|escape} (<a href='http://www.ip-adress.com/ip_tracer/{$feedback->ip}/'>где это?</a>)
    </td>
  </tr>
  <tr style="border-bottom: 2px solid #2c6f95;">
    <td style='padding:6px; width:170px; background-color:#41ade2; font-family:arial;'>
      Сообщение:
    </td>
    <td style='padding:6px; width:330px; background-color:#ffffff; font-family:arial;'>
       {$feedback->message|escape|nl2br}
    </td>
  </tr>
</table>
<br><br>
<div style="float: left;width: 800px; border: 2px dashed #41ade2; text-align: center;margin-top: 10px;padding: 5px">
    Приятной работы с <a href='http://okay-cms.com'>Okay</a>!
</div>