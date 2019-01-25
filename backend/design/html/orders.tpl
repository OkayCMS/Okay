{* Title *}
{$meta_title=$btr->general_orders scope=parent}

{*Название страницы*}
<div class="row">
    <div class="col-lg-7 col-md-7">
        <div class="wrap_heading">
            <div class="box_heading heading_page">
                {if $orders_count}
                    {$btr->general_orders|escape} - {$orders_count}
                {else}
                    {$btr->orders_no|escape}
                {/if}
                {if $orders_count>0 && !$keyword}
                    <div class="export_block hint-bottom-middle-t-info-s-small-mobile hint-anim" data-hint="{$btr->orders_export|escape}">
                        <span class="fn_start_export fa fa-file-excel-o"></span>
                    </div>
                {/if}
            </div>
            <div class="box_btn_heading">
                <a class="btn btn_small btn-info" href="{url module=OrderAdmin}">
                    {include file='svg_icon.tpl' svgId='plus'}
                    <span>{$btr->orders_add|escape}</span>
                </a>
            </div>
        </div>
    </div>
    <div class="col-md-12 col-lg-5 col-xs-12 float-xs-right">
        <div class="boxed_search">
            <form class="search" method="get">
                <input type="hidden" name="module" value="OrdersAdmin">
                <div class="input-group">
                    <input name="keyword" class="form-control" placeholder="{$btr->general_search|escape}" type="text" value="{$keyword|escape}" >
                    <span class="input-group-btn">
                        <button type="submit" class="btn btn_blue"><i class="fa fa-search"></i> <span class="hidden-md-down"></span></button>
                    </span>
                </div>
            </form>
        </div>
    </div>
</div>

{*Вывод ошибок*}
{if $message_error}
    <div class="row">
        <div class="col-lg-12 col-md-12 col-sm-12">
            <div class="boxed boxed_warning">
                <div class="heading_box">
                    {if $message_error=='error_closing'}
                        {$btr->orders_in|escape}
                        {foreach $error_orders as $error_order_id}
                            <div>
                                № {$error_order_id}
                            </div>
                        {/foreach}
                        {$btr->orders_shortage|escape}
                    {else}
                        {$message_error|escape}
                    {/if}
                </div>
            </div>
        </div>
    </div>
{/if}


<div class="boxed fn_toggle_wrap">
    <div class="row">
        <div class="col-lg-12 col-md-12 ">
            <div class="fn_toggle_wrap">
                <div class="heading_box visible_md">
                    {$btr->general_filter|escape}
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="fa fn_icon_arrow fa-angle-down"></i></a>
                    </div>
                </div>
                <div class="boxed_sorting toggle_body_wrap off fn_card">
                <div class="row">
                    <div class="col-md-11 col-lg-11 col-xl-7 col-sm-12 mb-1">
                        <div class="date">
                            {*Блок фильтров*}
                            <form class="date_filter row" method="get">
                                <input type="hidden" name="module" value="OrdersAdmin">
                                <input type="hidden" name="status" value="{$status}">

                                <div class="col-md-5 col-lg-5 pr-0 pl-0">
                                    <div class="input-group mobile_input-group">
                                        <span class="input-group-addon-date">{$btr->general_from|escape}</span>
                                        {if $is_mobile || $is_tablet}
                                            <input type="date" class="fn_from_date form-control" name="from_date" value="{$from_date}" autocomplete="off" >
                                        {else}
                                            <input type="text" class="fn_from_date form-control" name="from_date" value="{$from_date}" autocomplete="off" >
                                        {/if}
                                        <div class="input-group-addon">
                                            <i class="fa fa-calendar"></i>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-5 col-lg-5 pr-0 pl-0">
                                    <div class="input-group mobile_input-group">
                                        <span class="input-group-addon-date">{$btr->general_to|escape}</span>
                                        {if $is_mobile || $is_tablet}
                                            <input type="date" class="fn_to_date form-control" name="to_date" value="{$to_date}" autocomplete="off" >
                                            {else}
                                            <input type="text" class="fn_to_date form-control" name="to_date" value="{$to_date}" autocomplete="off" >
                                        {/if}
                                        <div class="input-group-addon">
                                            <i class="fa fa-calendar"></i>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-2 col-lg-2 pr-0 mobile_text_right">
                                    <button class="btn btn_blue" type="submit">{$btr->general_apply|escape}</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                {*Блок фильтров*}
                <div class="row">
                    {if $all_status}
                        <div class="col-md-6 col-lg-4 col-sm-12">
                            <select name="status" class="selectpicker"  onchange="location = this.value;">
                                {foreach $all_status as $order_status}
                                    <option value="{url module=OrdersAdmin status=$order_status->id keyword=null id=null page=null label=null from_date=null to_date=null}" {if $status == $order_status->id}selected=""{/if} >{$order_status->name|escape}</option>
                                {/foreach}
                                <option value="{url module=OrdersAdmin status=null keyword=null id=null page=null label=null from_date=null to_date=null}" {if !$status}selected{/if}>{$btr->general_all|escape}</option>
                            </select>
                        </div>
                    {/if}
                    {if $labels}
                        <div class="col-md-6 col-lg-4 col-sm-12">
                            <select class="selectpicker" onchange="location = this.value;">
                                {foreach $labels as $l}
                                    <option value="{url label=$l->id}" {if $label->id == $l->id}selected{/if}>{$l->name|escape}</option>
                                {/foreach}
                                <option value="{url label=null}" {if !$label} selected{/if}>{$btr->general_all|escape}</option>
                            </select>
                        </div>
                    {/if}
                </div>
            </div>
            </div>
        </div>
    </div>

    {*Главная форма страницы*}
    {if $orders}
        <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
                <form class="fn_form_list" method="post">
                    <input type="hidden" name="session_id" value="{$smarty.session.id}">

                    <div class="orders_list okay_list products_list">
                        {*Шапка таблицы*}
                        <div class="okay_list_head">
                            <div class="okay_list_heading okay_list_check">
                                <input class="hidden_check fn_check_all" type="checkbox" id="check_all_1" name="" value=""/>
                                <label class="okay_ckeckbox" for="check_all_1"></label>
                            </div>
                            <div class="okay_list_heading okay_list_order_number">№ </div>
                            <div class="okay_list_heading okay_list_orders_name">{$btr->general_full_name|escape}</div>
                            <div class="okay_list_heading okay_list_order_status">{$btr->general_status|escape}</div>
                            <div class="okay_list_heading okay_list_order_product_count">{$btr->general_products|escape}</div>
                            <div class="okay_list_heading okay_list_orders_price">{$btr->general_sales_amount}</div>
                            <div class="okay_list_heading okay_list_order_marker">{$btr->orders_label|escape}</div>
                            <div class="okay_list_heading okay_list_close"></div>
                        </div>
                        {*Параметры элемента*}
                        <div class="okay_list_body">
                            {foreach $orders as $order}
                            <div class="fn_row okay_list_body_item " style="border-left: 5px solid #{$order->status_color};">
                                <div class="okay_list_row">
                                    <div class="okay_list_boding okay_list_check">
                                        <input class="hidden_check" type="checkbox" id="id_{$order->id}" name="check[]" value="{$order->id}"/>
                                        <label class="okay_ckeckbox" for="id_{$order->id}"></label>
                                    </div>

                                    <div class="okay_list_boding okay_list_order_number">
                                        <a href="{url module=OrderAdmin id=$order->id return=$smarty.server.REQUEST_URI}">{$btr->orders_order|escape} {$order->id}</a>
                                        {if $order->paid}
                                            <div class="order_paid">
                                                <span class="tag tag-success">{$btr->general_paid|escape}</span>
                                            </div>
                                        {/if}
                                    </div>

                                    <div class="okay_list_boding okay_list_orders_name">
                                        <a href="{url module=OrderAdmin id=$order->id return=$smarty.server.REQUEST_URI}" class="text_dark text_bold">{$order->name|escape}</a>
                                        {if $order->note}
                                            <div class="note">{$order->note|escape}</div>
                                        {/if}
                                        <div class="hidden-lg-up mt-q">
                                            <span class="tag tag-warning">{$orders_status[$order->status_id]->name|escape}</span>
                                        </div>
                                        <div class="mt-q"><span class="hidden-md-down">{$btr->orders_order_in|escape}</span>
                                        <span class="tag tag-default">{$order->date|date} | {$order->date|time}</span></div>
                                    </div>

                                    <div class="okay_list_boding okay_list_order_status">
                                        {$orders_status[$order->status_id]->name|escape}
                                    </div>

                                    <div class="okay_list_boding okay_list_order_product_count">
                                        <span>{$order->purchases|count}</span>
                                        {if $order->purchases|count > 0}
                                            <span  class="fn_orders_toggle">
                                                <i class="fn_icon_arrow fa fa-angle-down fa-lg m-t-2 "></i>
                                            </span>
                                        {/if}
                                    </div>

                                    <div class="okay_list_boding okay_list_orders_price">
                                        <div class="input-group">
                                            <span class="form-control">
                                                {$order->total_price|escape}
                                            </span>
                                            <span class="input-group-addon">
                                                {$currency->sign|escape}
                                            </span>
                                        </div>
                                    </div>

                                    <div class="okay_list_boding okay_list_order_marker">
                                        <span class="fn_ajax_label_wrapper">
                                            <span class="fn_labels_show box_labels_show">{include file='svg_icon.tpl' svgId='tag'} <span>{$btr->orders_choose|escape}</span> </span>

                                            <div class='fn_labels_hide box_labels_hide'>
                                                <span class="heading_label">{$btr->general_labels|escape} <i class="fn_delete_labels_hide btn_close delete_labels_hide">{include file='svg_icon.tpl' svgId='delete'}</i></span>
                                                <ul class="option_labels_box">
                                                    {foreach $labels as $l}
                                                        <li class="fn_ajax_labels" data-order_id="{$order->id}"  style="background-color: #{$l->color|escape}">
                                                            <input id="l{$order->id}_{$l->id}" type="checkbox" class="hidden_check_1"  value="{$l->id}" {if is_array($order->labels_ids) && in_array($l->id,$order->labels_ids)}checked=""{/if} />
                                                            <label   for="l{$order->id}_{$l->id}" class="label_labels"><span>{$l->name|escape}</span></label>
                                                        </li>
                                                    {/foreach}
                                                </ul>
                                            </div>
                                            <div class="fn_order_labels orders_labels">
                                                {include file="labels_ajax.tpl"}
                                            </div>
                                        </span>
                                    </div>

                                    <div class="okay_list_boding okay_list_close">
                                        {*delete*}
                                        <button data-hint="{$btr->orders_delete|escape}" type="button" class="btn_close fn_remove hint-bottom-right-t-info-s-small-mobile hint-anim" data-toggle="modal" data-target="#fn_action_modal" onclick="success_action($(this));" >
                                           {include file='svg_icon.tpl' svgId='delete'}
                                        </button>
                                    </div>
                                </div>
                                {*Список товаров из заказа*}
                                <div class="okay_list_row">
                                    {if $order->purchases|count > 0}
                                        <div class="orders_purchases_block" style="display: none">
                                            <div class="purchases_table">
                                                <div class="purchases_head">
                                                    <div class="purchases_heading purchases_table_orders_num">№</div>
                                                    <div class="purchases_heading purchases_table_orders_sku">{$btr->general_sku|escape}</div>
                                                    <div class="purchases_heading purchases_table_orders_name">{$btr->general_name|escape}</div>
                                                    <div class="purchases_heading purchases_table_orders_price">{$btr->general_price|escape}</div>
                                                    <div class="purchases_heading col-lg-2 purchases_table_orders_unit">{$btr->general_qty|escape}</div>
                                                    <div class="purchases_heading purchases_table_orders_total">{$btr->orders_total_price|escape}</div>
                                                </div>
                                                <div class="purchases_body">
                                                    {foreach $order->purchases as $purchase}
                                                        <div class="purchases_body_items">
                                                            <div class="purchases_body_item">
                                                                <div class="purchases_bodyng purchases_table_orders_num">{$purchase@iteration}</div>
                                                                <div class="purchases_bodyng purchases_table_orders_sku">{$purchase->sku|default:"&mdash;"}</div>
                                                                <div class="purchases_bodyng purchases_table_orders_name">
                                                                    {$purchase->product_name|escape}
                                                                    {if $purchase->variant_name}({$purchase->variant_name|escape}){/if}
                                                                </div>
                                                                <div class="purchases_bodyng purchases_table_orders_price">{$purchase->price|convert} {$currency->sign|escape}</div>
                                                                <div class="purchases_bodyng purchases_table_orders_unit"> {$purchase->amount}{if $purchase->units}{$purchase->units|escape}{else}{$settings->units|escape}{/if}</div>
                                                                <div class="purchases_bodyng purchases_table_orders_total"> {($purchase->amount*$purchase->price)|convert} {$currency->sign|escape}</div>

                                                             </div>
                                                        </div>
                                                    {/foreach}
                                                </div>
                                            </div>
                                        </div>
                                    {/if}
                                </div>
                            </div>
                            {/foreach}
                        </div>
                        {*Блок массовых действий*}
                        <div class="okay_list_footer">
                            <div class="okay_list_foot_left">
                                <div class="okay_list_heading okay_list_check">
                                    <input class="hidden_check fn_check_all" type="checkbox" id="check_all_2" name="" value=""/>
                                    <label class="okay_ckeckbox" for="check_all_2"></label>
                                </div>
                                <div class="okay_list_option">
                                    <select name="action" class="selectpicker fn_change_orders">
                                        <option value="0">{$btr->general_select_action|escape}</option>
                                        <option data-item="status" value="change_status">{$btr->orders_change_status|escape}</option>
                                        <option data-item="label" value="set_label">{$btr->orders_set_label|escape}</option>
                                        <option data-item="label" value="unset_label">{$btr->orders_unset_label|escape}</option>
                                        <option data-item="remove" value="delete">{$btr->orders_permanently_delete|escape}</option>
                                    </select>
                                </div>
                                <div class="okay_list_option fn_show_label" style="display: none">
                                    <select name="change_label_id" class="selectpicker px-0 fn_labels_select" >
                                        <option value="0">{$btr->general_select_label|escape}</option>
                                        {foreach $labels as $change_label}
                                            <option value="{$change_label->id}">{$change_label->name|escape}</option>
                                        {/foreach}
                                    </select>
                                </div>
                                <div class="okay_list_option fn_show_status" style="display: none;">
                                    <select name="change_status_id" class="selectpicker px-0 fn_labels_select">
                                        <option value="0">{$btr->general_select_status|escape}</option>
                                        {foreach $all_status as $change_status}
                                            <option value="{$change_status->id}">{$change_status->name|escape}</option>
                                        {/foreach}
                                    </select>
                                </div>
                            </div>
                            <button type="submit" class=" btn btn_small btn_blue">
                                {include file='svg_icon.tpl' svgId='checked'}
                                <span>{$btr->general_apply|escape}</span>
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12 col-md-12 col-sm 12 txt_center">
                {include file='pagination.tpl'}
            </div>
        </div>
    {else}
        <div class="heading_box mt-1">
            <div class="text_grey">{$btr->orders_no|escape}</div>
        </div>
    {/if}
</div>

<script src="{$config->root_url}/backend/design/js/piecon/piecon.js"></script>

{* On document load *}
{literal}
<script>

$(function() {

    $(document).on('click','.fn_orders_toggle',function(){
        $(this).find('.fn_icon_arrow').toggleClass('rotate_180');
        $(this).parents('.fn_row').find('.orders_purchases_block').slideToggle();
    });

    $(".fn_labels_show").click(function(){
        $(this).next('.fn_labels_hide').toggleClass("active_labels");
    });
    $(".fn_delete_labels_hide").click(function(){
        $(this).closest('.box_labels_hide').removeClass("active_labels");
    });

    if($(window).width() >= 1199 ){
        $(".fn_from_date, .fn_to_date ").datepicker({
            dateFormat: 'dd-mm-yy'
        });
    }


    $(document).on("change", ".fn_change_orders", function () {
       var item = $(this).find("option:selected").data("item");
       if(item == "status") {
           $(".fn_show_label").hide();
           $(".fn_show_status").show();

       } else if (item == "label") {
           $(".fn_show_label").show();
           $(".fn_show_status").hide();
       } else {
           $(".fn_show_label").hide();
           $(".fn_show_status").hide();
       }

    });

    $(document).on("change", ".fn_ajax_labels input", function () {
        elem = $(this);
       var order_id = parseInt($(this).closest(".fn_ajax_labels").data("order_id"));
       var state = "";
       session_id = '{/literal}{$smarty.session.id}{literal}';
       var label_id = parseInt($(this).closest(".fn_ajax_labels").find("input").val());
       if($(this).closest(".fn_ajax_labels").find("input").is(":checked")){
            state = "add";
       } else {
            state = "remove";
       }

        $.ajax({
            type: "POST",
            dataType: 'json',
            url: "ajax/update_order.php",
            data: {
                order_id : order_id,
                state : state,
                label_id : label_id,
                session_id : session_id
            },
            success: function(data){
                var msg = "";
                if(data){
                    elem.closest(".fn_ajax_label_wrapper").find(".fn_order_labels").html(data.data);
                    toastr.success(msg, "Success");
                } else {
                    toastr.error(msg, "Error");

                }
            }
        });
    });
    {/literal}
    var status = '{$status|escape}',
        label='{$label->id|escape}',
        from_date = '{$from_date}',
        to_date = '{$to_date}';
    {literal}
    // On document load
    $(document).on('click','.fn_start_export',function() {
        
        Piecon.setOptions({fallback: 'force'});
        Piecon.setProgress(0);
        var progress_item = $("#progressbar"); //указываем селектор элемента с анимацией
        progress_item.show();
        do_export('',progress_item);
    });

    function do_export(page,progress) {
        page = typeof(page) != 'undefined' ? page : 1;
        label = typeof(label) != 'undefined' ? label : null;
        status = typeof(status) != 'undefined' ? status : null;
        from_date = typeof(from_date) != 'undefined' ? from_date : null;
        to_date = typeof(to_date) != 'undefined' ? to_date : null;
        $.ajax({
            url: "ajax/export_orders.php",
            data: {
                page:page, 
                label:label,
                status:status, 
                from_date:from_date, 
                to_date:to_date
            },
            dataType: 'json',
            success: function(data){
                if(data && !data.end) {
                    Piecon.setProgress(Math.round(100*data.page/data.totalpages));
                    progress.attr('value',100*data.page/data.totalpages);
                    do_export(data.page*1+1,progress);
                }
                else {
                    Piecon.setProgress(100);
                    progress.attr('value','100');
                    window.location.href = 'files/export/export_orders.csv';
                    progress.fadeOut(500);
                }
            },
            error:function(xhr, status, errorThrown) {
                alert(errorThrown+'\n'+xhr.responseText);
            }
        });
    }
});
</script>
{/literal}
