{if $order->id}
    {$meta_title = "`$btr->general_order_number` `$order->id`" scope=parent}
{else}
    {$meta_title = $btr->order_new scope=parent}
{/if}

<form method="post" enctype="multipart/form-data" class="fn_fast_button">
    <input type="hidden" name="session_id" value="{$smarty.session.id}">
    <input name="id" type="hidden" value="{$order->id|escape}"/>

    <div class="row">
        <div class="col-lg-12 col-md-12">
            <div class="wrap_heading">
                <div class="box_heading heading_page">
                    {if $order->id}
                        {$btr->general_order_number|escape} {$order->id|escape}
                    {else}
                        {$btr->order_new|escape}
                    {/if}
                </div>
                {*Статус заказа*}
                <div class="boxes_inline">
                    <select class="selectpicker" name="status_id">
                        {foreach $all_status as $status_item}
                            <option value="{$status_item->id}" {if $order->status_id == $status_item->id}selected=""{/if} {if $hasVariantNotInStock && !$order->closed && $status_item->is_close} disabled{/if} >{$status_item->name|escape}</option>
                        {/foreach}
                    </select>
                </div>
                <div data-hint="{$btr->order_print|escape}" class="boxes_inline hint-bottom-middle-t-info-s-small-mobile  hint-anim ml-h">
                    <a href="{url view=print id=$order->id}" target="_blank" title="{$btr->order_print|escape}" class="print_block">
                        <i class="fa fa-print"></i>
                    </a>
                </div>
                {*Метки заказа*}
                <div class="box_btn_heading ml-h hidden-xs-down">
                    <div class="add_order_marker">
                        <span class="fn_ajax_label_wrapper">
                            <span class="fn_labels_show box_labels_show box_btn_heading ml-h">{include file='svg_icon.tpl' svgId='tag'} <span>{$btr->general_select_label|escape}</span> </span>

                            <div class='fn_labels_hide box_labels_hide'>
                                <span class="heading_label">{$btr->general_labels|escape} <i class="fn_delete_labels_hide btn_close delete_labels_hide">{include file='svg_icon.tpl' svgId='delete'}</i></span>
                                <ul class="option_labels_box">
                                    {foreach $labels as $l}
                                        <li class="fn_ajax_labels" data-order_id="{$order->id}"  style="background-color: #{$l->color|escape}">
                                            <input id="l{$order->id}_{$l->id}" type="checkbox" class="hidden_check_1" name="order_labels[]"  value="{$l->id}" {if in_array($l->id, $order_labels) && is_array($order_labels)}checked=""{/if} />
                                            <label   for="l{$order->id}_{$l->id}" class="label_labels"><span>{$l->name|escape}</span></label>
                                        </li>
                                    {/foreach}
                                </ul>
                            </div>
                            <div class="fn_order_labels orders_labels box_btn_heading ml-h">
                                {include file="labels_ajax.tpl"}
                            </div>
                        </span>
                    </div>
                </div>
                {if $neighbors_orders}
                    <div class="neighbors_orders">
                        {if $neighbors_orders['prev']->id}
                            <span>
                                <a title="{$btr->order_prev}" class="prev_order" href="{url id=$neighbors_orders.prev->id}">&lt;</a>
                            </span>
                        {/if}
                        {if $neighbors_orders['next']}
                            <span>
                                <a title="{$btr->order_next}" class="next_order" href="{url id=$neighbors_orders.next->id}">&gt;</a>
                            </span>
                        {/if}
                    </div>
                {/if}
            </div>
        </div>
    </div>


    {if $hasVariantNotInStock && !$order->closed}
        <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
                <div class="boxed boxed_warning">
                    <div class="">
                        {$btr->order_not_in_stock|escape}
                    </div>
                </div>
            </div>
        </div>
    {/if}

    {*Вывод ошибок*}
    {if $message_error}
        <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
                <div class="boxed boxed_warning">
                    <div class="heading_box">
                        {if $message_error=='error_closing'}
                            {$btr->order_shortage|escape}
                        {elseif $message_error == 'empty_purchase'}
                            {$btr->general_empty_purchases|escape}
                        {else}
                            {$message_error|escape}
                        {/if}
                    </div>
                </div>
            </div>
        </div>
    {*Вывод успешных сообщений*}
    {elseif $message_success}
        <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
                <div class="boxed boxed_success">
                    <div class="heading_box">
                        {if $message_success=='updated'}
                            {$btr->order_updated|escape}
                        {elseif $message_success=='added'}
                            {$btr->order_added|escape}
                        {else}
                            {$message_success|escape}
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

    <div class="row">
        {*left_column*}
        <div class="col-xl-8 break_1300_12  pr-0">
            <div class="boxed fn_toggle_wrap min_height_230px">
                <div class="heading_box">
                    {$btr->order_content|escape}
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="icon-arrow-down"></i></a>
                    </div>
                </div>
                <div class="toggle_body_wrap on fn_card">
                    <div class="">
                        <div id="fn_purchase" class="okay_list">
                            {*Шапка таблицы*}
                            <div class="okay_list_head">
                                <div class="okay_list_heading okay_list_photo">{$btr->general_photo|escape}</div>
                                <div class="okay_list_heading okay_list_order_name">{$btr->order_name_option|escape} </div>
                                <div class="okay_list_heading okay_list_price">{$btr->general_price|escape} {$currency->sign|escape}</div>
                                <div class="okay_list_heading okay_list_count">{$btr->order_qty|escape}
                                </div>
                                <div class="okay_list_heading okay_list_order_amount_price">{$btr->general_sales_amount}</div>
                            </div>
                            {*Список покупок*}
                            <div class="okay_list_body">
                                {foreach $purchases as $purchase}
                                    <div class="fn_row okay_list_body_item purchases">
                                        <div class="okay_list_row">
                                            <input type=hidden name=purchases[id][{$purchase->id}] value='{$purchase->id}'>

                                            <div class="okay_list_boding okay_list_photo">
                                                {if $purchase->product->image}
                                                    <img class=product_icon src="{$purchase->product->image->filename|resize:50:50}">
                                                {else}
                                                    <img width="50" src="design/images/no_image.png"/>
                                                {/if}
                                            </div>
                                            <div class="okay_list_boding okay_list_order_name">
                                                <div class="boxes_inline">
                                                    {if $purchase->product}
                                                        <a href="{url module=ProductAdmin id=$purchase->product->id}">{$purchase->product_name|escape}</a>
                                                        {if $purchase->variant_name}
                                                            <span class="text_grey">{$btr->order_option|escape} {$purchase->variant_name|escape}</span>
                                                        {/if}
                                                        {if $purchase->sku}
                                                            <span class="text_grey">{$btr->general_sku|escape} {$purchase->sku|default:"&mdash;"}</span>
                                                        {/if}
                                                    {else}
                                                        <div class="text_grey">{$purchase->product_name|escape}</div>
                                                        {if $purchase->variant_name}
                                                            <div class="text_grey">{$btr->order_option|escape}{$purchase->variant_name|escape}</div>
                                                        {/if}
                                                        {if $purchase->sku}
                                                            <div class="text_grey">{$btr->general_sku|escape}{$purchase->sku|default:"&mdash;"}</div>
                                                        {/if}
                                                    {/if}
                                                    <div class="hidden-lg-up mt-q">
                                                        <span class="text_primary text_600">{$purchase->price}</span>
                                                        <span class="hidden-md-up text_500">
                                                        {$purchase->amount} {if $purchase->units}{$purchase->units|escape}{else}{$settings->units|escape}{/if}</span>
                                                    </div>
                                                </div>

                                                {if !$purchase->variant}
                                                    <input class="form-control " type="hidden" name="purchases[variant_id][{$purchase->id}]" value="" />
                                                {else}
                                                    <div class="boxes_inline">
                                                        <select name="purchases[variant_id][{$purchase->id}]" class="selectpicker {if $purchase->product->variants|count == 1}hidden{/if} fn_purchase_variant">
                                                            {foreach $purchase->product->variants as $v}
                                                                <option data-price="{$v->price}" data-units="{$v->units|escape}" data-amount="{$v->stock}" value="{$v->id}" {if $v->id == $purchase->variant_id}selected{/if} >
                                                                    {if $v->name}
                                                                        {$v->name|escape}
                                                                    {else}
                                                                        #{$v@iteration}
                                                                    {/if}
                                                                </option>
                                                            {/foreach}
                                                        </select>
                                                    </div>
                                                {/if}
                                            </div>
                                            <div class="okay_list_boding okay_list_price">
                                                <div class="input-group">
                                                    <input type="text" class="form-control fn_purchase_price" name="purchases[price][{$purchase->id}]" value="{$purchase->price}">
                                                    <span class="input-group-addon">{$currency->sign}</span>
                                                </div>
                                            </div>
                                            <div class="okay_list_boding okay_list_count">
                                                <div class="input-group">
                                                    <input class="form-control fn_purchase_amount" type="text" name="purchases[amount][{$purchase->id}]" value="{$purchase->amount}"/>
                                                    <span class="input-group-addon p-0 fn_purchase_units">
                                                         {if $purchase->units}{$purchase->units|escape}{else}{$settings->units|escape}{/if}
                                                    </span>
                                                </div>
                                            </div>
                                            <div class="okay_list_boding okay_list_order_amount_price">
                                                <div class="text_dark">
                                                    <span>{($purchase->price) * ($purchase->amount)}</span>
                                                    <span class="">{$currency->sign}</span>
                                                </div>
                                            </div>
                                            <div class="okay_list_boding okay_list_close">
                                                {*delete*}
                                                <button data-hint="{$btr->general_delete_product|escape}" type="button" class="btn_close fn_remove_item hint-bottom-right-t-info-s-small-mobile  hint-anim" >
                                                    {include file='svg_icon.tpl' svgId='delete'}
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                {/foreach}
                            </div>
                            <div class="okay_list_body fn_new_purchase" style="display: none">
                                <div class="fn_row okay_list_body_item " >
                                <div class="okay_list_row">

                                    <div class="okay_list_boding okay_list_photo">
                                        <input type="hidden" name="purchases[id][]" value="" />
                                        <img class="fn_new_image" src="">
                                    </div>

                                    <div class="okay_list_boding okay_list_order_name">
                                        <div class="boxes_inline">
                                            <a class="fn_new_product" href=""></a>
                                            <div class="fn_new_variant_name"></div>
                                        </div>
                                        <div class="boxes_inline">
                                            <select name="purchases[variant_id][]" class="fn_new_variant"></select>
                                        </div>

                                    </div>
                                    <div class="okay_list_boding okay_list_price">
                                        <div class="input-group">
                                            <input type="text" class="form-control fn_purchase_price" name=purchases[price][] value="">
                                            <span class="input-group-addon">{$currency->sign|escape}</span>
                                        </div>
                                    </div>
                                    <div class="okay_list_boding okay_list_count">
                                        <div class="input-group">
                                            <input class="form-control fn_purchase_amount" type="text" name="purchases[amount][]" value="1"/>
                                            <span class="input-group-addon p-0 fn_purchase_units">
                                            </span>
                                        </div>
                                    </div>
                                    <div class="okay_list_boding okay_list_order_amount_price">
                                        <div class="text_dark">
                                            <span></span>
                                            <span class=""></span>
                                        </div>
                                    </div>
                                    <div class="okay_list_boding okay_list_close">
                                        {*delete*}
                                        <button data-hint="{$btr->general_delete_product|escape}" type="button" class="btn_close fn_remove_item hint-bottom-right-t-info-s-small-mobile  hint-anim">
                                            {include file='svg_icon.tpl' svgId='delete'}
                                        </button>
                                    </div>
                                </div>
                            </div>
                            </div>
                        </div>

                        <div class="row mt-1">
                            <div class="col-lg-6 col-md-12">
                                <div class="autocomplete_arrow">
                                    <input type="text" name="new_purchase" id="fn_add_purchase" class="form-control" placeholder="{$btr->general_add_product|escape}">
                                </div>
                            </div>
                            <div class="col-lg-6 col-md-12">
                                {if $purchases}
                                    <div class="text_dark text_500 text-xs-right mr-1 mt-h">
                                        <div class="h5">{$btr->order_sum|escape} {$subtotal} {$currency->sign|escape}</div>
                                    </div>
                                {/if}
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            {*Информация по заказу*}
            <div class="boxed fn_toggle_wrap min_height_230px">
                <div class="heading_box">
                    {$btr->order_parameters|escape}
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="icon-arrow-down"></i></a>
                    </div>
                </div>
                <div class="toggle_body_wrap on fn_card">
                    <div class="">
                        <div class="">
                            <div class="okay_list">
                                <div class="okay_list_body">
                                    <div class="okay_list_body_item">
                                        <div class="okay_list_row  d_flex">
                                            <div class="okay_list_boding okay_list_ordfig_name">
                                                <div class="text_600 text_dark">{$btr->general_discount|escape}</div>
                                            </div>
                                            <div class="okay_list_boding okay_list_ordfig_val">
                                                <div class="input-group">
                                                    <input type="text" class="form-control" name="discount" value="{$order->discount}">
                                                    <span class="input-group-addon p-0"><i class="fa fa-percent"></i></span>
                                                </div>
                                            </div>
                                            <div class="okay_list_boding okay_list_ordfig_price">
                                                <div class="text_dark">
                                                    <span>{($subtotal-$subtotal*$order->discount/100)|round:2}</span>
                                                    <span class="">{$currency->sign|escape}</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="okay_list_body_item">
                                        <div class="okay_list_row d_flex">
                                            <div class="okay_list_boding okay_list_ordfig_name">
                                                <div class="text_600 text_dark">{$btr->general_coupon|escape}{if $order->coupon_code} ({$order->coupon_code}){/if}</div>
                                            </div>
                                            <div class="okay_list_boding okay_list_ordfig_val">
                                                <div class="input-group">
                                                    <input type="text" class="form-control" name="coupon_discount" value="{$order->coupon_discount}" />
                                                    <span class="input-group-addon p-0">{$currency->sign|escape}</span>
                                                </div>
                                            </div>
                                            <div class="okay_list_boding okay_list_ordfig_price">
                                                <div class="text_dark">
                                                    <span>{($subtotal-$subtotal*$order->discount/100-$order->coupon_discount)|round:2}</span>
                                                    <span class="">{$currency->sign|escape}</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="okay_list_body_item">
                                        <div class="okay_list_row  d_flex">
                                            <div class="okay_list_boding okay_list_ordfig_name">
                                                <div class="text_600 text_dark boxes_inline">{$btr->general_shipping|escape}</div>
                                                <div class="boxes_inline">
                                                    <select name="delivery_id" class="selectpicker">
                                                        <option value="0">{$btr->order_not_selected|escape}</option>
                                                        {foreach $deliveries as $d}
                                                            <option value="{$d->id}" {if $d->id==$delivery->id}selected{/if}>{$d->name|escape}</option>
                                                        {/foreach}
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="okay_list_boding okay_list_ordfig_val">
                                                <div class="input-group">
                                                    <input type=text name=delivery_price class="form-control" value='{$order->delivery_price}'>
                                                    <span class="input-group-addon p-0">{$currency->sign|escape}</span>
                                                </div>
                                            </div>
                                            <div class="okay_list_boding okay_list_ordfig_price">
                                                <div class="input-group"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row ">
                                <div class="col-lg-4 col-md-12 mt-2">
                                    <div class="heading_label">{$btr->order_payment_selected|escape}</div>
                                    <div class="">
                                        <select name="payment_method_id" class="selectpicker">
                                            <option value="0">{$btr->order_not_selected|escape}</option>
                                            {foreach $payment_methods as $pm}
                                                <option value="{$pm->id}" {if $pm->id==$payment_method->id}selected{/if}>{$pm->name|escape}</option>
                                            {/foreach}
                                        </select>
                                    </div>
                                </div>
                                <div class="col-lg-8 col-md-12">
                                    <div class="text_dark text_500 text-xs-right mr-1 mt-1">
                                        <div class="h5">{$btr->general_total|escape} {$order->total_price} {$currency->sign|escape}</div>
                                    </div>
                                    <div class="text_grey text_500 text-xs-right mr-1 mt-1">
                                        {if $payment_method}
                                            <div class=" text-xs-right">
                                                <div class="h5">{$btr->order_to_pay|escape} {$order->total_price|convert:$payment_currency->id} {$payment_currency->sign}</div>
                                            </div>
                                        {/if}
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                            <div class="col-lg-12 col-md-12 mt-1">

                                <label class="switch_label boxes_inline">{$btr->order_paid|escape}</label>
                                <label class="switch switch-default switch-pill switch-primary-outline-alt boxes_inline">
                                    <input class="switch-input" name="paid" value='1' type="checkbox" id="paid" {if $order->paid}checked{/if}/>
                                    <span class="switch-label"></span>
                                    <span class="switch-handle"></span>
                                </label>

                            </div>
                        </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        {*right_column*}
        {*Информация о заказчике/детали заказа*}
        <div class="col-xl-4 break_1300_12">
            <div class="boxed fn_toggle_wrap min_height_230px">
                <div class="heading_box">
                    {$btr->order_buyer_information|escape}
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="icon-arrow-down"></i></a>
                    </div>
                </div>
                <div class="toggle_body_wrap on fn_card">
                    <div class="box_border_buyer">
                        <div class="mb-1">
                            <div class="heading_label boxes_inline">{$btr->order_date|escape}</div>
                            <div class="boxes_inline text_dark text_600">{$order->date|date} {$order->date|time}</div>
                        </div>
                        <div class="mb-1">
                            <div class="heading_label">{$btr->general_name|escape}</div>
                            <input name="name" class="form-control" type="text" value="{$order->name|escape}" />
                        </div>
                        <div class="mb-1">
                            <div class="heading_label">{$btr->general_phone|escape}</div>
                            <input name="phone" class="form-control" type="text" value="{$order->phone|escape}" />
                        </div>
                        <div class="mb-1">
                            <div class="heading_label">E-mail</div>
                            <input name="email" class="form-control" type="text" value="{$order->email|escape}" />
                        </div>
                        <div class="mb-1">
                            <div class="heading_label">{$btr->general_adress|escape} <a href="https://www.google.com/maps/search/{$order->address|escape}?hl=ru" target="_blank"><i class="fa fa-map-marker"></i> {$btr->order_on_map|escape}</a></div>
                            <textarea name="address" class="form-control short_textarea">{$order->address|escape}</textarea>
                        </div>
                        <div class="mb-1">
                            <div class="heading_label">{$btr->general_comment|escape}</div>
                            <textarea name="comment" class="form-control short_textarea">{$order->comment|escape}</textarea>
                        </div>
                         <div class="mb-1">
                            <div class="heading_label boxes_inline">{$btr->order_ip|escape} {if $order->id}<a href="https://who.is/whois-ip/ip-address/{$order->ip}" target="_blank"><i class="fa fa-map-marker"></i> whois</a>{/if}</div>
                            <div class="boxes_inline text_dark text_600">{$order->ip|escape}</div>
                        </div>
                    </div>
                    <div class="box_border_buyer">
                        <div class="mb-1">
                            <div style="position:relative;">
                                {if !$user}
                                    <div class="heading_label">
                                        {$btr->order_buyer_not_registred|escape}
                                    </div>
                                    <div style="position:relative;">
                                        <input type="hidden" name="user_id" value="{$user->id}" />

                                        <input type="text" class="fn_user_complite form-control" placeholder="{$btr->order_user_select|escape}" />
                                    </div>
                                {else}
                                    <div class="fn_user_row">
                                        <input type="hidden" name="user_id" value="{$user->id}" />
                                        <div class="heading_label boxes_inline">
                                            {$btr->order_buyer|escape}
                                            <a href="{url module=UserAdmin id=$user->id}" target=_blank>
                                                 {$user->name|escape}
                                            </a>
                                        </div>
                                        <a href="javascript:;" data-hint="{$btr->users_delete|escape}" class="btn_close delete_grey fn_delete_user hint-bottom-right-t-info-s-small-mobile  hint-anim boxes_inline" >
                                            {include file='svg_icon.tpl' svgId='delete'}
                                        </a>
                                        {if $user->group_id > 0}
                                            <div class="text_grey">{$user->group->name|escape}</div>
                                        {else}
                                            <div class="text_grey">{$btr->order_not_in_group|escape}</div>
                                        {/if}
                                    </div>
                                {/if}
                            </div>
                        </div>
                    </div>
                    <div class="box_border_buyer">
                        <div class="mb-1">
                            <div class="heading_label">{$btr->order_language|escape}</div>
                            <select name="entity_lang_id" class="selectpicker">
                                {foreach $languages as $l}
                                    <option value="{$l->id}" {if $l->id == $order->lang_id}selected=""{/if}>{$l->name|escape}</option>
                                {/foreach}
                            </select>
                        </div>
                        <div class="">
                            <div class="form-group">
                                <div class="heading_label">{$btr->order_note|escape}</div>
                                <textarea name="note" class="form-control short_textarea">{$order->note|escape}</textarea>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 col-md-12 mb-2">
            <button type="submit" class="btn btn_small btn_blue float-sm-right">
                {include file='svg_icon.tpl' svgId='checked'}
                <span>{$btr->general_apply|escape}</span>
            </button>
            <div class="checkbox_email float-sm-right text_dark mr-1">
                <input id="order_to_email" name="notify_user" type="checkbox" class="hidden_check_1"  value="1" />
                <label for="order_to_email" class="checkbox_label mr-h"></label>
                <span>{$btr->order_email|escape}</span>
            </div>
        </div>
    </div>
</form>


{literal}
<script src="design/js/autocomplete/jquery.autocomplete-min.js"></script>
<link rel="stylesheet" type="text/css" href="design/js/autocomplete/styles.css" media="screen" />

<script>
$(function() {
    // Удаление товара
    $(document).on( "click", "#fn_purchase .fn_remove_item", function() {
         $(this).closest(".fn_row").fadeOut(200, function() { $(this).remove(); });
         return false;
    });

    $(".fn_labels_show").click(function(){
        $(this).next('.fn_labels_hide').toggleClass("active_labels");
    });
    $(".fn_delete_labels_hide").click(function(){
        $(this).closest('.box_labels_hide').removeClass("active_labels");
    });

    $(".fn_from_date, .fn_to_date ").datepicker({
        dateFormat: 'dd-mm-yy'
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


    // Добавление товара
    var new_purchase = $('#fn_purchase .fn_new_purchase').clone(true);
    $('#fn_purchase .fn_new_purchase').remove().removeAttr('class');

    $("#fn_add_purchase").devbridgeAutocomplete({
    serviceUrl:'ajax/add_order_product.php',
    minChars:0,
    orientation:'auto',
    noCache: false,
    onSelect:
        function(suggestion){
            new_item = new_purchase.clone().appendTo('#fn_purchase');
            new_item.removeAttr('id');
            new_item.find('.fn_new_product').html(suggestion.data.name);
            new_item.find('.fn_new_product').attr('href', 'index.php?module=ProductAdmin&id='+suggestion.data.id);

            // Добавляем варианты нового товара
            var variants_select = new_item.find("select.fn_new_variant");

            for(var i in suggestion.data.variants) {
                variants_select.append("<option value='"+suggestion.data.variants[i].id+"' data-price='"+suggestion.data.variants[i].price+"' data-amount='"+suggestion.data.variants[i].stock+"' data-units='"+suggestion.data.variants[i].units+"'>"+suggestion.data.variants[i].name+"</option>");
            }

            if(suggestion.data.variants.length> 1 || suggestion.data.variants[0].name != '') {
                variants_select.show();
                variants_select.selectpicker();
            } else {
                variants_select.hide();
            }
            variants_select.find('option:first').attr('selected',true);

            variants_select.bind('change', function(){
                change_variant(variants_select);
            });
            change_variant(variants_select);

            if(suggestion.data.image) {
                new_item.find('.fn_new_image').attr("src", suggestion.data.image);
            } else {
                new_item.find('.fn_new_image').remove();
            }
            $("input#fn_add_purchase").val('').focus().blur();
            new_item.show();
        },
        formatResult:
            function(suggestions, currentValue){
                    var reEscape = new RegExp('(\\' + ['/', '.', '*', '+', '?', '|', '(', ')', '[', ']', '{', '}', '\\'].join('|\\') + ')', 'g');
                    var pattern = '(' + currentValue.replace(reEscape, '\\$1') + ')';
                    return "<div>" + (suggestions.data.image?"<img align=absmiddle src='"+suggestions.data.image+"'> ":'') + "</div>" +  "<span>" + suggestions.value.replace(new RegExp(pattern, 'gi'), '<strong>$1<\/strong>') + "</span>";
                }


  });

  // Изменение цены и макс количества при изменении варианта
    function change_variant(element) {
        var price = element.find('option:selected').data('price');
        var amount = element.find('option:selected').data('amount');
        var units = element.find('option:selected').data('units');
        element.closest('.fn_row').find('input.fn_purchase_price').val(price);
        element.closest('.fn_row').find('.fn_purchase_units').text(units);
        var amount_input = element.closest('.fn_row').find('input.fn_purchase_amount');
        amount_input.val('1');
        amount_input.data('max',amount);
        return false;
  }

    $(".fn_user_complite").devbridgeAutocomplete({
        serviceUrl:'ajax/search_users.php',
        minChars:0,
        orientation:'auto',
        noCache: false,
        onSelect:
            function(suggestion){
                $('input[name="user_id"]').val(suggestion.data.id);
            },
            formatResult:
                function(suggestions, currentValue){
                        var reEscape = new RegExp('(\\' + ['/', '.', '*', '+', '?', '|', '(', ')', '[', ']', '{', '}', '\\'].join('|\\') + ')', 'g');
                        var pattern = '(' + currentValue.replace(reEscape, '\\$1') + ')';
                        return "<span>" + suggestions.value.replace(new RegExp(pattern, 'gi'), '<strong>$1<\/strong>') + "</span>";
                    }
    });

    $(document).on("click", ".fn_delete_user", function () {
        $(this).closest(".fn_user_row").hide();
        $('input[name="user_id"]').val(0);
    });


    $("select.fn_purchase_variant").bind("change", function(){
        change_variant($(this));
    });

});

</script>
{/literal}
