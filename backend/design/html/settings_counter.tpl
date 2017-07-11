{$meta_title = $btr->settings_notify_counters scope=parent}

{*Название страницы*}
<div class="row">
    <div class="col-lg-7 col-md-7">
        <div class="heading_page">{$btr->settings_notify_counters|escape}</div>
    </div>
    <div class="col-lg-5 col-md-5 float-xs-right"></div>
</div>

{*Вывод успешных сообщений*}
{if $message_success}
    <div class="row">
        <div class="col-lg-12 col-md-12 col-sm-12">
            <div class="boxed boxed_success">
                <div class="heading_box">
                    {if $message_success == 'saved'}
                        {$btr->general_settings_saved|escape}
                    {/if}
                    {if $smarty.get.return}
                        <a class="btn btn_return float-xs-right" href="{$smarty.get.return}">
                            {include file='svg_icon.tpl' svgId='return'}
                            <span>{$btr->general_back|escape}</span>
                        </a>
                    {/if}
                </div>
            </div>
        </div>
    </div>
{/if}

{*Главная форма страницы*}
<form method="post" enctype="multipart/form-data">
    <input type=hidden name="session_id" value="{$smarty.session.id}">

    <div class="row">
        <div class="col-lg-12 col-md-12">
            <div class="boxed fn_toggle_wrap">
                <div class="heading_box">
                    {$btr->settings_notify_ga|escape}
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="icon-arrow-down"></i></a>
                    </div>
                </div>
                {*Параметры элемента*}
                <div class="toggle_body_wrap on fn_card">
                    <div class="boxed boxed_attention">
                        <div class="text_box mt-0">
                            <div class=""><span class="text_700">Google Analytics ID</span> - {$btr->settings_notify_ga_info1|escape}(UA-xxxxxxxx-x)</div> <br>
                            <div class=""><span class="text_700">Google Webmaster</span> - {$btr->settings_notify_ga_info2|escape}</div> <br>
                             <div class="">{$btr->settings_notify_ga_info3|escape} meta name='google-site-verification' content='<i class="text_600">786f3d0f736b732c</i></div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="heading_label">Google Analytics ID</div>
                            <div class="mb-1">
                                <input type="text" name="g_analytics" value="{$settings->g_analytics}" class="form-control">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="heading_label">Google Webmaster</div>
                            <div class="mb-1">
                                <input type="text" name="g_webmaster" value="{$settings->g_webmaster}" class="form-control">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    {*Параметры элемента*}
    <div class="row">
        <div class="col-lg-12 col-md-12">
            <div class="boxed fn_toggle_wrap">
                <div class="heading_box">
                    {$btr->settings_notify_ym|escape}
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="icon-arrow-down"></i></a>
                    </div>
                </div>
                <div class="toggle_body_wrap on fn_card">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="heading_label">{$btr->settings_notify_counter_id|escape}</div>
                            <div class="mb-1">
                                <input name="yandex_metrika_counter_id" class="form-control" type="text" value="{$settings->yandex_metrika_counter_id|escape}" />
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="heading_label">{$btr->settings_notify_ym_webmaster|escape}</div>
                            <div class="mb-1">
                                <input type="text" name="y_webmaster" value="{$settings->y_webmaster}" class="form-control">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    {*Параметры элемента*}
    <div class="row">
        <div class="col-lg-12 col-md-12">
            <div class="boxed fn_toggle_wrap">
                <div class="heading_box">
                    {$btr->settings_notify_sided_scripts|escape}
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="icon-arrow-down"></i></a>
                    </div>
                </div>
                <div class="toggle_body_wrap on fn_card">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="heading_label">{$btr->settings_notify_head|escape}</div>
                            <div class="mb-1">
                                <textarea id="head_script" class="script_content" name="head_custom_script" rows="20">{$settings->head_custom_script}</textarea>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="heading_label">{$btr->settings_notify_body|escape}</div>
                            <div class="mb-1">
                                <textarea id="body_script" class="" name="body_custom_script" rows="20">{$settings->body_custom_script}</textarea>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                       <div class="col-lg-12 col-md-12 ">
                            <button type="submit" class="btn btn_small btn_blue float-md-right">
                                {include file='svg_icon.tpl' svgId='checked'}
                                <span>{$btr->general_apply|escape}</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>

{* Подключаем редактор кода *}
<link rel="stylesheet" href="design/js/codemirror/lib/codemirror.css">
<link rel="stylesheet" href="design/js/codemirror/theme/monokai.css">

<script src="design/js/codemirror/lib/codemirror.js"></script>

<script src="design/js/codemirror/mode/smarty/smarty.js"></script>
<script src="design/js/codemirror/mode/smartymixed/smartymixed.js"></script>
<script src="design/js/codemirror/mode/htmlmixed/htmlmixed.js"></script>
<script src="design/js/codemirror/mode/javascript/javascript.js"></script>
<script src="design/js/codemirror/addon/selection/active-line.js"></script>

{literal}
    <style type="text/css">

        .CodeMirror{
            font-family:'Courier New';
            margin-bottom:10px;
            border:1px solid #c0c0c0;
            background-color: #ffffff;
            height: 400px;
            width:100%;
        }
        .CodeMirror-scroll
        {
            overflow-y: hidden;
            overflow-x: auto;
        }
        .cm-s-monokai .cm-smarty.cm-tag{color: #ff008a;}
        .cm-s-monokai .cm-smarty.cm-string {color: #007000;}
        .cm-s-monokai .cm-smarty.cm-variable {color: #ff008a;}
        .cm-s-monokai .cm-smarty.cm-variable-2 {color: #ff008a;}
        .cm-s-monokai .cm-smarty.cm-variable-3 {color: #ff008a;}
        .cm-s-monokai .cm-smarty.cm-property {color: #ff008a;}
        .cm-s-monokai .cm-comment {color: #505050;}
        .cm-s-monokai .cm-smarty.cm-attribute {color: #ff20Fa;}
    </style>

<script>
    var editor = CodeMirror.fromTextArea(document.getElementById("body_script"), {
        mode: "javascript",
        lineNumbers: true,
        styleActiveLine: true,
        matchBrackets: false,
        enterMode: 'keep',
        indentWithTabs: false,
        indentUnit: 2,
        tabMode: 'classic',
        theme : 'monokai'
    });

    var editor2 = CodeMirror.fromTextArea(document.getElementById("head_script"), {
        mode: "javascript",
        lineNumbers: true,
        styleActiveLine: true,
        matchBrackets: false,
        enterMode: 'keep',
        indentWithTabs: false,
        indentUnit: 2,
        tabMode: 'classic',
        theme : 'monokai'
    });
</script>
{/literal}
