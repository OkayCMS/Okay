{* Письмо восстановления пароля *}
{$subject = {$lang->email_password_subject} scope=parent}
<html xmlns="http://www.w3.org/1999/xhtml"><head>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /><style type="text/css">
        /*<![CDATA[*/
        div, p, a, li, td, span {
            -webkit-text-size-adjust:none;
        }
        @media only screen and (max-width: 600px) {
            *[class="gmail-fix"] {
                display: none !important;
            }
        }
        /*]]>*/
    </style>
</head>
<body style="margin: 0">
<div style="padding: 15px 0px; background-color: rgb(239, 239, 239); background: rgb(239, 239, 239) url({$config->root_url}/design/{$settings->theme}/images/email_pattern.png); background-repeat: repeat; padding-left: 0px !important; padding-right: 0px !important;">
    <table width="600" border="0" cellspacing="0" cellpadding="0" align="center" style="margin: 0 auto">
        <tbody>
        <tr>
            <td border="0" valign="top" align="left" style="border: 0">
                <div style="border-width: 0px; border-style: solid; border-radius: 0px; border-color: rgb(204, 204, 204)"><!-- CONTENT BEGIN  -->
                    <div>
                        <div>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0" style="padding: 5px; background-color: rgb(255, 255, 255); background: rgb(255, 255, 255) no-repeat; border-top-left-radius: 0px; border-top-right-radius: 0px; overflow: hidden">
                                <tbody>
                                <tr>
                                    <td border="0" valign="top" width="1%" align="left" style="border: 0">
                                        <div>
                                            <div style="text-align: left"><a><img src="{$config->root_url}/design/{$settings->theme}/images/{$settings->site_logo}" width="200" align="left" style="border: 0; display: block; margin: 0 auto" /></a></div>
                                        </div>
                                    </td>

                                    <td border="0" valign="middle" align="left" style="border: 0">
                                        <div>
                                            <div style="text-align: left; font-family: 'Trebuchet MS'; font-size: 14px; color: rgb(51, 51, 51); line-height: normal">
                                                <div style="text-align: right;">
                                                <span style="font-size:18px;">
                                                    <span style="font-family:trebuchet ms,helvetica,sans-serif;">
                                                        <span style="color:#333333;">
                                                            <strong>{$lang->company_phone_1}</strong><br />
                                                            <strong>{$lang->company_phone_2}</strong>
                                                        </span>
                                                    </span>
                                                </span>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div style="height: 30px; width: 100%; background: transparent;"></div>
                    <div>
                        <div>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0" style="background: rgb(255, 255, 255)">
                                <tbody>
                                <tr>
                                    <td border="0" valign="top" align="left" style="border: 0">
                                        <div>
                                            <div style="text-align: left; font-family: 'Trebuchet MS'; font-size: 14px; color: rgb(51, 51, 51); line-height: 1.5"><span style="font-size:18px;"><span style="font-family:trebuchet ms,helvetica,sans-serif;"><strong>{$lang->email_comment_hello} {$user->name|escape}</strong></span></span><br />
                                                <br />
                                                <span style="font-family:trebuchet ms,helvetica,sans-serif;">
                                                    <p>{$user->name|escape} {$lang->email_password_on_site}<a href='{$config->root_url}/{$lang_link}'>{$settings->site_name}</a> {$lang->email_password_was_reply}</p>
                                                    <p>{$lang->email_password_change_pass}</p></span><br />
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                        <div>
                            <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background: rgb(255, 255, 255)">
                                <tbody>
                                <tr>
                                    <td align="center" valign="top" border="0" style="border: 0">
                                        <div>
                                            <div style="text-align: center; font-family: 'Trebuchet MS'; font-size: 14px; color: rgb(51, 51, 51); line-height: 1.5">
                                                <span style="font-family:trebuchet ms,helvetica,sans-serif;">
                                                    <span style="border-style: solid; border-color: rgb(234, 182, 9); background-color: rgb(234, 182, 9); border-width: 0px 0px 0px 0px; display: inline-block; border-radius: 29px">
                                                        <a href="{$config->root_url}/{$lang_link}user/password_remind/{$code}" style="font-family: 'Trebuchet MS'; font-size: 14px; color: rgb(29, 103, 164); text-decoration: underline; border-style: solid; border-width: 8px 25px 8px 25px; display: inline-block; border-radius: 28px; border-color: rgb(242, 189, 11); background: rgb(242, 189, 11); font-size: 16px; font-family: 'Lucida Sans Unicode', 'Lucida Grande'; font-weight: bold; color: rgb(255, 255, 255); text-decoration: none">
                                                            <span style="font-family:trebuchet ms,helvetica,sans-serif;">{$lang->user_change_password}</span>
                                                        </a>
                                                    </span>
                                                </span>
                                                <br />
                                                <p style="color: rgb(0, 0, 0); font-family: Arial, sans-serif; font-size: 15px; text-align: start; background-color: rgb(255, 255, 255);">
                                                    <span style="color:#a9a9a9;">
                                                        <span style="font-family:trebuchet ms,helvetica,sans-serif;">
                                                            <span style="font-size:14px;">
                                                                <em>{$lang->email_password_text}</em>
                                                            </span>
                                                        </span>
                                                    </span><br />
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <!-- CONTENT END  --></div>
            </td>
        </tr>
        </tbody>
    </table>
</div>
</body>
</html>


