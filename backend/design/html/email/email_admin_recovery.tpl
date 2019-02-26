{$subject="`$btr->email_change_pass_request` `$config->root_url`" scope=parent}
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
                <div style="border-width: 0px; border-style: solid; border-radius: 0px; border-color: rgb(204, 204, 204)">
                    <!-- CONTENT BEGIN  -->
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
                                                           {$btr->email_change_pass_request|escape}
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
                    <div style="height: 30px; width: 100%; background: transparent;"></div>
                    <div>
                        <div>
                            <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background: rgb(255, 255, 255)">
                                <tbody>
                                <tr>
                                    <td align="left" valign="top" border="0" style="border: 0">
                                        <div>
                                            <div style="text-align: left; font-family: 'Trebuchet MS'; font-size: 14px; color: rgb(51, 51, 51); line-height: 1.5">
                                                <div style="text-align: center;"><span style="font-size:14px;"><span style="font-family:trebuchet ms,helvetica,sans-serif;"><span style="font-size:16px;">{$btr->email_change_pass__link|escape}</span></span></span></div>
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
                                            <div style="text-align: center; font-family: 'Trebuchet MS'; font-size: 14px; color: rgb(51, 51, 51); line-height: 1.5"><span style="border-style: solid; border-color: rgb(234, 182, 9); background-color: rgb(234, 182, 9); border-width: 0px 0px 0px 0px; display: inline-block; border-radius: 29px"><a href="{$recovery_url}" style="font-family: 'Trebuchet MS'; font-size: 14px; color: rgb(29, 103, 164); text-decoration: underline; border-style: solid; border-width: 8px 25px 8px 25px; display: inline-block; border-radius: 28px; border-color: rgb(242, 189, 11); background: rgb(242, 189, 11); font-size: 16px; font-family: 'Lucida Sans Unicode', 'Lucida Grande'; font-weight: bold; color: rgb(255, 255, 255); text-decoration: none">{$btr->email_change_pass|escape} &gt;</a></span></div>
                                        </div>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <!-- CONTENT END  -->
                </div>
            </td>
        </tr>
        <div style="height: 30px; width: 100%; background: transparent;"></div>
        <tr>
            <td border="0" align="left" style="border: 0">
                <div>
                    <div>
                        <div>
                            <div style="text-align: center; font-family: 'Trebuchet MS'; font-size: 11px; color: rgb(51, 51, 51); line-height: normal">{$btr->email_details|escape}<br />
                                <a href="https://okay-cms.com" style="font-family: 'Trebuchet MS'; font-size: 11px; color: rgb(29, 103, 164); text-decoration: underline">okay-cms.com</a></div>
                        </div>
                    </div>
                </div>
            </td>
        </tr>
        </tbody>
    </table>
</div>
</body>
</html>
