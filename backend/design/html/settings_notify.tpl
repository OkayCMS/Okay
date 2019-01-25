{$meta_title = $btr->settings_notify_notifications scope=parent}

{*Название страницы*}
<div class="row">
    <div class="col-lg-6 col-md-6">
        <div class="heading_page">{$btr->settings_notify_notifications|escape}</div>
    </div>
    <div class="col-lg-4 col-md-3 text-xs-right float-xs-right"></div>
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
                    {$btr->settings_notify_notifications|escape}
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="fa fn_icon_arrow fa-angle-down"></i></a>
                    </div>
                </div>
                {*Параметры элемента*}
                <div class="toggle_body_wrap on fn_card">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="heading_label">{$btr->settings_notify_emails|escape}</div>
                            <div class="mb-1">
                                 <input name="order_email" class="form-control" type="text" value="{$settings->order_email|escape}" />
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="heading_label">{$btr->settings_notify_reverce|escape}</div>
                            <div class="mb-1">
                                <input name="notify_from_email" class="form-control" type="text" value="{$settings->notify_from_email|escape}" />
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="heading_label">{$btr->settings_notify_comments|escape}</div>
                            <div class="mb-1">
                                <input name="comment_email" class="form-control" type="text" value="{$settings->comment_email|escape}" />
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="heading_label">{$btr->settings_notify_sender_name|escape}</div>
                            <div class="mb-1">
                                <input name="notify_from_name" class="form-control" type="text" value="{$settings->notify_from_name|escape}" />
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="heading_label">{$btr->settings_notify_email_lang|escape}</div>
                            <div class="mb-1">
                                <select name="email_lang" class="selectpicker">
                                    {foreach $btr_languages as $name=>$label}
                                        <option value="{$label}" {if $settings->email_lang==$label}selected{/if}>
                                            {$name|escape}
                                        </option>
                                    {/foreach}
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="heading_label">{$btr->settings_notify_auto_approved}</div>
                            <div class="mb-1">
                                <select name="auto_approved" class="selectpicker">
                                    <option value="0" {if $settings->auto_approved=='0'}selected{/if}>
                                        {$btr->settings_notify_auto_approved_off}
                                    </option>
                                    <option value="1" {if $settings->auto_approved=='1'}selected{/if}>
                                        {$btr->settings_notify_auto_approved_on}
                                    </option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-lg-12 col-md-12">
            <div class="boxed fn_toggle_wrap">
                <div class="heading_box">
                    {$btr->settings_notify_smtp|escape}
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;"><i class="fa fn_icon_arrow fa-angle-down"></i></a>
                    </div>
                </div>
                {*Параметры элемента*}
                <div class="toggle_body_wrap on fn_card">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="heading_label">{$btr->settings_notify_use_smtp}</div>
                            <div class="mb-1">
                                <select name="use_smtp" class="selectpicker">
                                    <option value="0" {if $settings->use_smtp=='0'}selected{/if}>
                                        {$btr->settings_notify_turn_off}
                                    </option>
                                    <option value="1" {if $settings->use_smtp=='1'}selected{/if}>
                                        {$btr->settings_notify_turn_on}
                                    </option>
                                </select>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="heading_label">{$btr->settings_notify_smtp_server}</div>
                            <div class="mb-1">
                                <input name="smtp_server" class="form-control" type="text" value="{$settings->smtp_server|escape}" />
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="heading_label">{$btr->settings_notify_smtp_port}</div>
                            <div class="mb-1">
                                <input name="smtp_port" class="form-control" type="text" value="{$settings->smtp_port|escape}" />
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="heading_label">{$btr->settings_notify_smtp_user}</div>
                            <div class="mb-1">
                                <input name="smtp_user" class="form-control" type="text" value="{$settings->smtp_user|escape}" />
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="heading_label">{$btr->settings_notify_smtp_pass}</div>
                            <div class="mb-1">
                                <input name="smtp_pass" class="form-control" type="password" value="{$settings->smtp_pass|escape}" />
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="heading_label">{$btr->settings_notify_test_smtp}</div>
                            <div class="mb-1">
                                <button type="button" class="fn_test_smtp btn btn_small btn_blue float-xs-left">
                                    {include file='svg_icon.tpl' svgId='refresh_icon'}
                                    <span>{$btr->settings_notify_do_test_smtp|escape}</span>
                                </button>
                                <div class="fn_test_smtp_status float-xs-left form-control"></div>
                            </div>
                        </div>
                    </div>
                    <div class="row fn_row hidden">
                        <div class="col-md-12">
                            <div class="heading_label">{$btr->settings_notify_test_smtp_trace}</div>
                            <div class="fn_test_smtp_trace"></div>
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

<script>
    $(document).on('click', '.fn_test_smtp', function() {
        $('.fn_test_smtp_status').fadeOut(100);
        var server = $('input[name="smtp_server"]').val(),
            port   = $('input[name="smtp_port"]').val(),
            user   = $('input[name="smtp_user"]').val(),
            pass   = $('input[name="smtp_pass"]').val();
        $.ajax({
            url: 'ajax/test_smtp.php',
            type: 'POST',
            data: {
                server: server,
                port: port,
                user: user,
                pass: pass
            },
            success: function (data) {
                $('.fn_test_smtp_status').text(data.message);
                if (data.status == true) {
                    $('.fn_test_smtp_trace').text('').closest('.fn_row').addClass('hidden');
                    $('.fn_test_smtp_status').removeClass('text-danger').addClass('text-success');
                } else {
                    $('.fn_test_smtp_trace').html(data.trace).closest('.fn_row').removeClass('hidden');
                    $('.fn_test_smtp_status').removeClass('text-success').addClass('text-danger');
                }
                $('.fn_test_smtp_status').fadeIn(500);
            }
        });
    });
</script>
