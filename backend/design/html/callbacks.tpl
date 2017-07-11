{* Title *}
{$meta_title=$btr->callbacks_order scope=parent}

{*Название страницы*}
<div class="row">
    <div class="col-lg-7 col-md-7">
        <div class="wrap_heading">
            <div class="box_heading heading_page">
               {$btr->callbacks_requests|escape} ({$callbacks_count})
            </div>
        </div>
    </div>
</div>

{*Главная форма страницы*}
<div class="boxed fn_toggle_wrap">
    {if $callbacks}
        <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
                <form class="fn_form_list" method="post">
                    <input type="hidden" name="session_id" value="{$smarty.session.id}">
                    <div class="post_wrap okay_list">
                        {*Шапка таблицы*}
                        <div class="okay_list_head">
                            <div class="okay_list_heading okay_list_check">
                                <input class="hidden_check fn_check_all" type="checkbox" id="check_all_1" name="" value=""/>
                                <label class="okay_ckeckbox" for="check_all_1"></label>
                            </div>
                            <div class="okay_list_heading okay_list_comments_name">{$btr->callbacks_requests|escape}</div>
                            <div class="okay_list_heading okay_list_comments_btn"></div>
                            <div class="okay_list_heading okay_list_close"></div>
                        </div>

                        {*Параметры элемента*}
                        <div class="okay_list_body">
                            {foreach $callbacks as $callback}
                                <div class="fn_row okay_list_body_item">
                                    <div class="okay_list_row">
                                        <div class="okay_list_boding okay_list_check">
                                            <input class="hidden_check" type="checkbox" id="id_{$callback->id}" name="check[]" value="{$callback->id}"/>
                                            <label class="okay_ckeckbox" for="id_{$callback->id}"></label>
                                        </div>

                                        <div class="okay_list_boding okay_list_comments_name">
                                            <div class="okay_list_text_inline mb-q mr-1">
                                                <span class="text_dark text_bold">{$btr->general_name|escape} </span> {$callback->name|escape}
                                            </div>
                                            <div class="okay_list_text_inline mb-q">
                                                <span class="text_dark text_bold">{$btr->general_phone|escape} </span>{$callback->phone|escape}
                                            </div>
                                            <div class="mb-q">
                                                <span class="text_dark text_bold">{$btr->general_message|escape} </span>
                                                {$callback->message|escape|nl2br}
                                            </div>
                                            <div>
                                                {$btr->general_request_sent|escape} <span class="tag tag-default">{$callback->date|date} | {$callback->date|time}</span>
                                                {$btr->general_from_page|escape} <a href="{$callback->url|escape}" target="_blank">{$callback->url|escape}</a>
                                            </div>
                                            <div class="hidden-md-up mt-q">
                                                <button type="button" class="btn btn_small btn-outline-warning fn_ajax_action fn_callbacks_toggle {if $callback->processed}hidden{/if}" data-module="callback" data-action="processed" data-id="{$callback->id}">
                                                    {$btr->general_process|escape}
                                                </button>
                                                <button type="button" class="btn btn_small btn-outline-warning fn_ajax_action fn_callbacks_toggle fn_active_class {if !$callback->processed}hidden{/if}" data-module="callback" data-action="processed" data-id="{$callback->id}">
                                                    {$btr->general_unprocess|escape}
                                                </button>
                                             </div>
                                            <div class="mb-q fn_ajax_block admin_note" data-id="{$callback->id}" data-module="callback">
                                                <span class="text_dark text_bold">{$btr->callbacks_admin_notes|escape}</span>
                                                <span class="fn_an_text">{$callback->admin_notes|escape|nl2br}</span>
                                                <div>
                                                    <a href="javascript:;" class="fn_an_edit">{$btr->callbacks_edit|escape}</a>
                                                </div>
                                                <div class="fn_an_edit_block hidden">
                                                    <textarea class="fn_ajax_element" name="admin_notes">{$callback->admin_notes|escape|nl2br}</textarea>
                                                    <p><a href="javascript:;" class="fn_an_save">{$btr->general_apply|escape}</a></p>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="okay_list_boding okay_list_comments_btn">
                                            <button type="button" class="btn btn_small btn-outline-warning fn_ajax_action fn_callbacks_toggle {if $callback->processed}hidden{/if}" data-module="callback" data-action="processed" data-id="{$callback->id}">
                                                {$btr->general_process|escape}
                                            </button>
                                            <button type="button" class="btn btn_small btn-outline-warning fn_ajax_action fn_callbacks_toggle fn_active_class {if !$callback->processed}hidden{/if}" data-module="callback" data-action="processed" data-id="{$callback->id}">
                                                {$btr->general_unprocess|escape}
                                            </button>
                                        </div>

                                        <div class="okay_list_boding okay_list_close">
                                            {*delete*}
                                            <button data-hint="{$btr->general_delete_request|escape}" type="button" class="btn_close fn_remove hint-bottom-right-t-info-s-small-mobile  hint-anim" data-toggle="modal" data-target="#fn_action_modal" onclick="success_action($(this));">
                                                {include file='svg_icon.tpl' svgId='delete'}
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            {/foreach}
                        </div>

                        {*Блок массовых действий*}
                        <div class="okay_list_footer fn_action_block">
                            <div class="okay_list_foot_left">
                                <div class="okay_list_heading okay_list_check">
                                    <input class="hidden_check fn_check_all" type="checkbox" id="check_all_2" name="" value=""/>
                                    <label class="okay_ckeckbox" for="check_all_2"></label>
                                </div>
                                <div class="okay_list_option">
                                    <select name="action" class="selectpicker">
                                        <option value="processed">{$btr->general_process|escape}</option>
                                        <option value="unprocessed">{$btr->general_unprocess|escape}</option>
                                        <option value="delete">{$btr->general_delete|escape}</option>
                                    </select>
                                </div>
                            </div>
                            <button type="submit" class="btn btn_small btn_blue">
                                {include file='svg_icon.tpl' svgId='checked'}
                                <span>{$btr->general_apply|escape}</span>
                            </button>
                        </div>
                    </div>
                </form>
            </div>
            <div class="row">
                <div class="col-lg-12 col-md-12 col-sm 12 txt_center">
                    {include file='pagination.tpl'}
                </div>
            </div>
        </div>
    {else}
        <div class="heading_box mt-1">
            <div class="text_grey">{$btr->general_no_request|escape}</div>
        </div>
    {/if}
</div>
<script>
    $(function() {
        $(document).on('click', '.fn_an_edit', function() {
            var block = $(this).closest('.fn_ajax_block');
            block.find('.fn_an_edit_block').removeClass("hidden");
            $(this).addClass("hidden");
        });
        $(document).on('click', '.fn_an_save', function() {
            var block = $(this).closest('.fn_ajax_block');
            block.find('.fn_an_text').text(block.find('[name="admin_notes"]').val());
            ajax_action(block);

            block.find('.fn_an_edit_block').addClass("hidden");
            block.find('.fn_an_edit').removeClass("hidden");
        });
    });
</script>
