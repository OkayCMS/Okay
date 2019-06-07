{* Title *}
{$meta_title=$btr->order_settings_labels scope=parent}

{*Название страницы*}
<div class="row">
    <div class="col-lg-6 col-md-6">
        <div class="heading_page">{$btr->order_settings_orders|escape}</div>
    </div>
    <div class="col-lg-4 col-md-3 text-xs-right float-xs-right"></div>
</div>

<div class="row">
    {*Блок статусов заказов*}
    <div class="col-lg-6 col-md-12 pr-0">
        <div class="boxed fn_toggle_wrap">
            <div class="heading_box">
                {$btr->order_settings_statuses|escape}
                <div class="box_btn_heading ml-1">
                    <button type="button" class="btn btn_mini btn-info fn_add_status ">
                        {include file='svg_icon.tpl' svgId='plus'}
                        <span>{$btr->order_settings_add_status|escape}</span>
                    </button>
                </div>
                <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                    <a class="btn-minimize" href="javascript:;" ><i class="icon-arrow-down"></i></a>
                </div>
            </div>
            <div class="toggle_body_wrap on fn_card">
                <form class="fn_form_list" method="post">
                    <input type="hidden" value="status" name="status">
                    <input type="hidden" name="session_id" value="{$smarty.session.id}">
                    <div class="okay_list">
                        {*Шапка таблицы*}
                        <div class="okay_list_head">
                            <div class="okay_list_boding okay_list_drag"></div>
                            <div class="okay_list_heading okay_list_check">
                                <input class="hidden_check fn_check_all" type="checkbox" id="check_all_1" name="" value=""/>
                                <label class="okay_ckeckbox" for="check_all_1"></label>
                            </div>
                            <div class="okay_list_heading okay_list_order_stg_sts_name">{$btr->general_name|escape}</div>
                            <div class="okay_list_heading okay_list_order_stg_sts_status">{$btr->general_activities|escape}</div>
                            <div class="okay_list_heading okay_list_order_stg_sts_status">{$btr->order_settings_1c_action|escape}</div>
                            <div class="okay_list_heading okay_list_order_stg_sts_label">{$btr->order_settings_colour|escape}</div>
                            <div class="okay_list_heading okay_list_close"></div>
                        </div>
                        <div class="fn_status_list fn_sort_list okay_list_body sortable">
                            {if $orders_status}
                                {foreach $orders_status as $order_status}
                                    <div class="fn_row okay_list_body_item">
                                        <div class="okay_list_row fn_sort_item">
                                            <input type="hidden" name="positions[{$order_status->id}]" value="{$order_status->position}">
                                            <input type="hidden" name="id[]" value="{$order_status->id}">

                                            <div class="okay_list_boding okay_list_drag move_zone">
                                                {include file='svg_icon.tpl' svgId='drag_vertical'}
                                            </div>
                                            <div class="okay_list_boding okay_list_check">
                                                <input class="hidden_check" type="checkbox" id="id_or_{$order_status->id}" name="check[]" value="{$order_status->id}"/>
                                                <label class="okay_ckeckbox" for="id_or_{$order_status->id}"></label>
                                            </div>

                                            <div class="okay_list_boding okay_list_order_stg_sts_name">
                                                <input type="text" class="form-control" name="name[{$order_status->id}]" value="{$order_status->name|escape}">
                                                {if $is_mobile == true}
                                                <div class="hidden-sm-up mt-q">
                                                    <select name="is_close[{$order_status->id}]" class="selectpicker col-xs-12 px-0">
                                                        <option value="1" {if $order_status->is_close == 1}selected=""{/if} >{$btr->order_settings_reduse_products|escape}</option>
                                                        <option value="0" {if $order_status->is_close == 0}selected=""{/if} >{$btr->order_settings_not_reduse_products|escape}</option>
                                                    </select>
                                                </div>
                                                <div class="hidden-sm-up mt-q">
                                                    <select name="status_1c[{$order_status->id}]" class="selectpicker col-xs-12 px-0">
                                                        <option value="not_use" {if $order_status->status_1c == ''}selected=""{/if}>{$btr->order_settings_1c_not_use|escape}</option>
                                                        <option value="new" {if $order_status->status_1c == 'new'}selected=""{/if}>{$btr->order_settings_1c_new|escape}</option>
                                                        <option value="accepted" {if $order_status->status_1c == 'accepted'}selected=""{/if}>{$btr->order_settings_1c_accepted|escape}</option>
                                                        <option value="to_delete" {if $order_status->status_1c == 'to_delete'}selected=""{/if}>{$btr->order_settings_1c_to_delete|escape}</option>
                                                    </select>
                                                </div>
                                                {/if}
                                            </div>

                                            {if $is_mobile == false}
                                            <div class="okay_list_boding okay_list_order_stg_sts_status">
                                                <select name="is_close[{$order_status->id}]" class="selectpicker col-xs-12 px-0">
                                                    <option value="1" {if $order_status->is_close == 1}selected=""{/if} >{$btr->order_settings_reduse_products|escape}</option>
                                                    <option value="0" {if $order_status->is_close == 0}selected=""{/if} >{$btr->order_settings_not_reduse_products|escape}</option>
                                                </select>
                                            </div>
                                            <div class="okay_list_boding okay_list_order_stg_sts_status">
                                                <select name="status_1c[{$order_status->id}]" class="selectpicker col-xs-12 px-0">
                                                    <option value="not_use" {if $order_status->status_1c == ''}selected=""{/if}>{$btr->order_settings_1c_not_use|escape}</option>
                                                    <option value="new" {if $order_status->status_1c == 'new'}selected=""{/if}>{$btr->order_settings_1c_new|escape}</option>
                                                    <option value="accepted" {if $order_status->status_1c == 'accepted'}selected=""{/if}>{$btr->order_settings_1c_accepted|escape}</option>
                                                    <option value="to_delete" {if $order_status->status_1c == 'to_delete'}selected=""{/if}>{$btr->order_settings_1c_to_delete|escape}</option>
                                                </select>
                                            </div>
                                            {/if}
                                            <div class="okay_list_boding okay_list_order_stg_sts_label">
                                                <input  name="color[{$order_status->id}]" value="{$order_status->color}" class="hidden">
                                                <span data-hint="#{$order_status->color}" class="fn_color label_color_item hint-bottom-middle-t-info-s-small-mobile  hint-anim" style="background-color:#{$order_status->color};"></span>
                                            </div>
                                            <div class="okay_list_boding okay_list_close">
                                                {*delete*}
                                                <button data-hint="{$btr->order_settings_delete_status|escape}" type="button" class="btn_close fn_remove hint-bottom-right-t-info-s-small-mobile  hint-anim" data-toggle="modal" data-target="#fn_action_modal" onclick="success_action($(this));">
                                                    {include file='svg_icon.tpl' svgId='delete'}
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                {/foreach}
                            {/if}

                            <div class="fn_row fn_new_status fn_sort_item okay_list_body">
                                <div class="fn_row okay_list_body_item">
                                    <div class="okay_list_row fn_sort_item">
                                        <div class="okay_list_boding okay_list_drag"></div>
                                        <div class="okay_list_heading okay_list_check"></div>
                                        <div class="okay_list_boding okay_list_order_stg_sts_name">
                                            <input type="text" class="form-control" name="new_name[]" value="">
                                            {if $is_mobile == true}
                                                <div class="hidden-sm-up mt-q">
                                                    <select name="new_is_close[]" class="selectpicker col-xs-12 px-0">
                                                        <option value="1">{$btr->order_settings_reduse_products|escape}</option>
                                                        <option value="0">{$btr->order_settings_not_reduse_products|escape}</option>
                                                    </select>
                                                </div>
                                                <div class="hidden-sm-up mt-q">
                                                    <select name="new_status_1c[]" class="selectpicker col-xs-12 px-0">
                                                        <option value="not_use">{$btr->order_settings_1c_not_use|escape}</option>
                                                        <option value="new">{$btr->order_settings_1c_new|escape}</option>
                                                        <option value="accepted">{$btr->order_settings_1c_accepted|escape}</option>
                                                        <option value="to_delete">{$btr->order_settings_1c_to_delete|escape}</option>
                                                    </select>
                                                </div>
                                            {/if}
                                        </div>
                                        {if $is_mobile == false}
                                            <div class="okay_list_boding okay_list_order_stg_sts_status">
                                                <select name="new_is_close[]" class="selectpicker">
                                                    <option value="1">{$btr->order_settings_reduse_products|escape}</option>
                                                    <option value="0">{$btr->order_settings_not_reduse_products|escape}</option>
                                                </select>
                                            </div>
                                            <div class="okay_list_boding okay_list_order_stg_sts_status">
                                                <select name="new_status_1c[]" class="selectpicker col-xs-12 px-0">
                                                    <option value="not_use">{$btr->order_settings_1c_not_use|escape}</option>
                                                    <option value="new">{$btr->order_settings_1c_new|escape}</option>
                                                    <option value="accepted">{$btr->order_settings_1c_accepted|escape}</option>
                                                    <option value="to_delete">{$btr->order_settings_1c_to_delete|escape}</option>
                                                </select>
                                            </div>
                                        {/if}
                                        <div class="okay_list_boding okay_list_order_stg_sts_label">
                                            <input name="new_color[]" value="" class="hidden">
                                            <span data-hint="{$btr->order_settings_select_colour|escape}" class="fn_color label_color_item hint-bottom-middle-t-info-s-small-mobile  hint-anim"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        {*Блок массовых действий*}
                        <div class="okay_list_footer">
                            <div class="okay_list_foot_left">
                                <div class="okay_list_boding okay_list_drag"></div>
                                <div class="okay_list_heading okay_list_check">
                                    <input class="hidden_check fn_check_all" type="checkbox" id="check_all_2" name="" value=""/>
                                    <label class="okay_ckeckbox" for="check_all_2"></label>
                                </div>
                                <div class="okay_list_option">
                                    <select name="action" class="selectpicker">
                                        <option value="delete">{$btr->general_delete|escape}</option>
                                    </select>
                                </div>
                            </div>
                            <button type="submit" value="labels" class="btn btn_small btn_blue">
                                {include file='svg_icon.tpl' svgId='checked'}
                                <span>{$btr->general_apply|escape}</span>
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    {*Блок меток заказов*}
    <div class="col-lg-6 col-md-12 hidden-md-down">
        <div class="boxed fn_toggle_wrap">
            <div class="heading_box">
                {$btr->order_settings_labels|escape}
                <div class="box_btn_heading ml-1">
                    <button type="button" class="btn btn_mini btn-info fn_add_Label ">
                        {include file='svg_icon.tpl' svgId='plus'}
                        <span>{$btr->order_settings_add_label|escape}</span>
                    </button>
                </div>
                <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                    <a class="btn-minimize" href="javascript:;" ><i class="icon-arrow-down"></i></a>
                </div>
            </div>
            <div class="toggle_body_wrap on fn_card">
                <form class="fn_form_list" method="post">
                    <input type="hidden" value="labels" name="labels">
                    <input type="hidden" name="session_id" value="{$smarty.session.id}">

                    <div class="okay_list">
                        {*Шапка таблицы*}
                        <div class="okay_list_head">
                            <div class="okay_list_heading okay_list_check">
                                <input class="hidden_check fn_check_all" type="checkbox" id="check_all_3" name="" value=""/>
                                <label class="okay_ckeckbox" for="check_all_3"></label>
                            </div>
                            <div class="okay_list_heading okay_list_order_stg_lbl_name">{$btr->general_name|escape}</div>
                            <div class="okay_list_heading okay_list_order_stg_sts_label">{$btr->order_settings_colour|escape}</div>
                            <div class="okay_list_heading okay_list_close"></div>
                        </div>
                        <div class="fn_labels_list okay_list_body sortable fn_sort_list">

                            {foreach $labels as $label}
                                <div class="fn_row okay_list_body_item">
                                    <div class="okay_list_row fn_sort_item">
                                        <input type="hidden" name="positions[{$label->id}]" value="{$label->position}">
                                        <input type="hidden" name="id[]" value="{$label->id}">

                                        <div class="cokay_list_boding okay_list_check">
                                            <input class="hidden_check" type="checkbox" id="id_{$label->id}" name="check[]" value="{$label->id}"/>
                                            <label class="okay_ckeckbox" for="id_{$label->id}"></label>
                                        </div>

                                        <div class="okay_list_boding okay_list_order_stg_lbl_name">
                                            <input type="text" class="form-control" name="name[]" value="{$label->name|escape}">
                                        </div>

                                        <div class="okay_list_boding okay_list_order_stg_sts_label">
                                            <input  name="color[]" value="{$label->color}" class="hidden">
                                            <span data-hint="#{$label->color}" class="fn_color label_color_item hint-bottom-middle-t-info-s-small-mobile  hint-anim" style="background-color:#{$label->color};"></span>
                                        </div>

                                        <div class="okay_list_boding okay_list_close">
                                            {*delete*}
                                            <button data-hint="{$btr->general_delete|escape}" type="button" class="btn_close fn_remove hint-bottom-right-t-info-s-small-mobile  hint-anim" data-toggle="modal" data-target="#fn_action_modal" onclick="success_action($(this));">
                                                {include file='svg_icon.tpl' svgId='delete'}
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            {/foreach}
                            <div class="fn_row fn_new_label fn_sort_item okay_list_body_item">
                                <div class="okay_list_row fn_sort_item">
                                    <div class="cokay_list_boding okay_list_check"></div>
                                    <div class="okay_list_boding okay_list_order_stg_lbl_name">
                                        <input type="text" class="form-control" name="new_name[]" value="">
                                    </div>
                                    <div class="okay_list_boding okay_list_order_stg_sts_label">
                                        <input name="new_color[]" value="" class="hidden">
                                        <span data-hint="{$btr->order_settings_select_colour|escape}" class="fn_color label_color_item hint-bottom-middle-t-info-s-small-mobile  hint-anim"></span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        {*Блок массовых действий*}
                        <div class="okay_list_footer ">
                            <div class="okay_list_foot_left">
                                <div class="okay_list_heading okay_list_check">
                                    <input class="hidden_check fn_check_all" type="checkbox" id="check_all_4" name="" value=""/>
                                    <label class="okay_ckeckbox" for="check_all_4"></label>
                                </div>
                                <div class="okay_list_option">
                                    <select name="action" class="selectpicker">
                                        <option value="delete">{$btr->general_delete|escape}</option>
                                    </select>
                                </div>
                            </div>
                            <button type="submit" value="labels" class="btn btn_small btn_blue">
                                {include file='svg_icon.tpl' svgId='checked'}
                                <span>{$btr->general_apply|escape}</span>
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

{* On document load *}
{literal}
<link rel="stylesheet" media="screen" type="text/css" href="design/js/colorpicker/css/colorpicker.css" />
<script type="text/javascript" src="design/js/colorpicker/js/colorpicker.js"></script>
<script>
    $(function() {
        var new_label = $(".fn_new_label").clone(true);
        $(".fn_new_label").remove();

        var new_status = $(".fn_new_status").clone(true);
        $(".fn_new_status").remove();

        $(document).on("click", ".fn_add_Label", function () {
           clone_label = new_label.clone(true);
           $(".fn_labels_list").append(clone_label);
        });

        $(document).on("click", ".fn_add_status", function () {
            clone_status = new_status.clone(true);
            clone_status.find("select").selectpicker();
            $(".fn_status_list").append(clone_status);
        });

        $(document).on("mouseenter click", ".fn_color", function () {
            var elem = $(this);
            elem.ColorPicker({
                onChange: function (hsb, hex, rgb) {
                    elem.css('backgroundColor', '#' + hex);
                    elem.prev().val(hex);
                }
            });
        });

    });
</script>
{/literal}
