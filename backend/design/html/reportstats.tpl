{$meta_title = $btr->reportstats_orders scope=global}

{*Название страницы*}
<div class="row">
    <div class="col-lg-7 col-md-7">
        <div class="wrap_heading">
            <div class="box_heading heading_page">
                {$btr->reportstats_orders|escape}
            </div>
        </div>
    </div>
</div>

{*Главная форма страницы*}
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
                   <div class="col-xs-12 mb-1">
                        <div class="row">
                            <div class="col-md-11 col-lg-11 col-xl-7 col-sm-12 ">
                                {*Блок фильтров*}
                               <div class="date">
                                   <form class="date_filter row" method="get">
                                       <input type="hidden" name="module" value="ReportStatsAdmin">
                                       <input type="hidden" name="date_filter" value="">

                                       <div class="col-md-5 col-lg-5 pr-0 pl-0">
                                           <div class="input-group mobile_input-group">
                                               <span class="input-group-addon-date">{$btr->general_from|escape}</span>
                                               {if $is_mobile || $is_tablet}
                                                   <input type="date" class="fn_from_date form-control" name="date_from" value="{$date_from}" autocomplete="off">
                                                   {else}
                                                   <input type="text" class="fn_from_date form-control" name="date_from" value="{$date_from}" autocomplete="off">
                                               {/if}
                                               <div class="input-group-addon">
                                                   <i class="fa fa-calendar"></i>
                                               </div>
                                           </div>
                                       </div>
                                       <div class="col-md-5 col-lg-5 pr-0 pl-0">
                                           <div class="input-group mobile_input-group">
                                               <span class=" input-group-addon-date">{$btr->general_to|escape}</span>
                                               {if $is_mobile || $is_tablet}
                                                   <input type="date" class="fn_to_date form-control" name="date_to" value="{$date_to}" autocomplete="off" >
                                                   {else}
                                                   <input type="text" class="fn_to_date form-control" name="date_to" value="{$date_to}" autocomplete="off" >
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
                    </div>
                    <div class="col-md-3 col-lg-3 col-sm-12">
                        <select id="id_categories" name="categories_filter" title="{$btr->general_category_filter|escape}" class="selectpicker form-control" data-live-search="true" data-size="10" onchange="location = this.value;">
                            <option value="{url keyword=null brand_id=null page=null limit=null category_id=null}" {if !$category}selected{/if}>{$btr->general_all_categories|escape}</option>
                            {function name=category_select level=0}
                                {foreach $categories as $c}
                                    <option value='{url keyword=null brand_id=null page=null category_id={$c->id}}' {if $smarty.get.category_id == $c->id}selected{/if}>
                                        {section sp $level}-{/section}{$c->name|escape}
                                    </option>
                                    {category_select categories=$c->subcategories level=$level+1}
                                {/foreach}
                            {/function}
                            {category_select categories=$categories}
                        </select>
                    </div>
                    <div class="col-md-3 col-lg-3 col-sm-12">
                        <select class="selectpicker" data-live-search="true" data-size="10" onchange="location = this.value;">
                            <option {if !$smarty.get.status}selected{/if} value="{url status=null}">{$btr->reportstats_all_statuses|escape}</option>
                            {foreach $all_status as $status_item}
                                <option {if $status_item->id == $smarty.get.status}selected{/if} value="{url status=$status_item->id}">{$status_item->name|escape}</option>
                            {/foreach}
                        </select>
                    </div>
                    <div class="col-lg-3 col-md-3 col-sm 12">
                        <select onchange="location = this.value;" class="selectpicker">
                            <option {if !$date_filter}selected{/if} value="{url date_filter=null date_to=null date_from=null filter_check=null}">{$btr->reportstats_all_orders|escape}</option>
                            <option {if $date_filter == today}selected{/if} value="{url date_filter=today date_to=null date_from=null filter_check=null}" >{$btr->reportstats_today|escape}</option>
                            <option {if $date_filter == this_week}selected{/if} value="{url date_filter=this_week date_to=null date_from=null filter_check=null}">{$btr->reportstats_this_week|escape}</option>
                            <option {if $date_filter == this_month}selected{/if} value="{url date_filter=this_month date_to=null date_from=null filter_check=null}" >{$btr->reportstats_this_month|escape}</option>
                            <option {if $date_filter == this_year}selected{/if} value="{url date_filter=this_year date_to=null date_from=null filter_check=null}" >{$btr->reportstats_this_year|escape}</option>
                            <option {if $date_filter == yesterday}selected{/if}  value="{url date_filter=yesterday date_to=null date_from=null filter_check=null}">{$btr->reportstats_yesterday|escape}</option>
                            <option {if $date_filter == last_week}selected{/if} value="{url date_filter=last_week date_to=null date_from=null filter_check=null}" >{$btr->reportstats_last_week|escape}</option>
                            <option {if $date_filter == last_month}selected{/if} value="{url date_filter=last_month date_to=null date_from=null filter_check=null}" >{$btr->reportstats_last_month|escape}</option>
                            <option {if $date_filter == last_year}selected{/if} value="{url date_filter=last_year date_to=null date_from=null filter_check=null}" >{$btr->reportstats_last_year|escape}</option>
                            <option {if $date_filter == last_24hour}selected{/if} value="{url date_filter=last_24hour date_to=null date_from=null filter_check=null}" >{$btr->reportstats_last_24|escape}</option>
                            <option {if $date_filter == last_7day}selected{/if} value="{url date_filter=last_7day date_to=null date_from=null filter_check=null}" >{$btr->reportstats_last_7_days|escape}</option>
                            <option {if $date_filter == last_30day}selected{/if} value="{url date_filter=last_30day date_to=null date_from=null filter_check=null}" >{$btr->reportstats_last_30_days|escape}</option>
                        </select>
                    </div>

                    <div class="col-md-3 col-lg-3 col-sm-12 mobile_text_right">
                        <button id="fn_start" type="submit" class="btn btn_small btn_blue float-md-right">
                            {include file='svg_icon.tpl' svgId='magic'}
                            <span>{$btr->general_export|escape}</span>
                        </button>
                    </div>
                </div>
            </div>
            </div>
        </div>
    </div>

    <form method="post" class="fn_form_list">
        <input type="hidden" name="session_id" value="{$smarty.session.id}" />
        {assign 'total_summ' 0}
        {assign 'total_amount' 0}
        <div class="okay_list products_list fn_sort_list">
            {*Шапка таблицы*}
            <div class="okay_list_head">
                <div class="okay_list_heading okay_list_reportstats_categories">{$btr->general_category|escape}</div>
                <div class="okay_list_heading okay_list_reportstats_products">{$btr->general_name|escape}</div>
                <div class="okay_list_heading okay_list_reportstats_total">{$btr->general_sales_amount|escape}</div>
                <div class="okay_list_heading okay_list_reportstats_setting">{$btr->general_amt|escape}</div>
            </div>

            {*Параметры элемента*}
            <div class="okay_list_body">
                {foreach $report_stat_purchases as $purchase}
                    {assign var='total_summ'  value=$total_summ+$purchase->sum_price}
                    {assign var='total_amount' value=$total_amount+$purchase->amount}
                    <div class="okay_list_body_item">
                        <div class="okay_list_row ">
                            <div class="okay_list_boding okay_list_reportstats_categories">
                                {foreach $purchase->category->path as $c}
                                    {$c->name}/
                                {/foreach}
                            </div>
                            <div class="okay_list_boding okay_list_reportstats_products">
                                <a title="{$purchase->product_name|escape}" href="{url module=ProductAdmin id=$purchase->product_id return=$smarty.server.REQUEST_URI}">{$purchase->product_name}</a> {$purchase->variant_name}
                                <div class="hidden-md-up mt-q">
                                    <span class="text_dark text_600">
                                        <span class="hidden-xs-down">Сумма продаж: </span>
                                        <span class="text_primary">
                                            {$purchase->sum_price|format} {$currency->sign|escape}
                                        </span>
                                    </span>
                                </div>
                            </div>

                            <div class="okay_list_boding okay_list_reportstats_total">
                                {$purchase->sum_price|format} {$currency->sign|escape}
                            </div>

                            <div class="okay_list_reportstats_setting">
                                {$purchase->amount} {if $purchase->units}{$purchase->units|escape}{else}{$settings->units}{/if}
                            </div>
                        </div>
                    </div>
                {/foreach}
            </div>
        </div>
        <div class="row mt-1">
            <div class="col-lg-12 col-md-12">
                <div class="text_dark text_500 text-xs-right mr-1 mt-h">
                    <div class="h5">{$btr->general_total|escape} {$total_summ|format} {$currency->sign|escape}  <span class="text_grey">({$total_amount}  {$btr->reportstats_units})</span></div>
                </div>
            </div>
        </div>
    </form>
    <div class="col-lg-12 col-md-12 col-sm 12 txt_center">
        {include file='pagination.tpl'}
    </div>
</div>

{literal}
<script>
    $(function() {
        $('input[name="date_from"]').datepicker();
        $('input[name="date_to"]').datepicker();
    });
</script>
{/literal}

<script>
    {if $date_filter}
    var date_filter = '{$date_filter}';
    {/if}
    {if $date_from}
    var date_from = '{$date_from}';
    {/if}
    {if $date_to}
    var date_to = '{$date_to}';
    {/if}
    {if $status}
    var status = '{$status}';
    {/if}
    {if $sort_prod}
    var sort_prod = '{$sort_prod}';
    {/if}
    {if $page}
    var page = '{$page}';
    {/if}
    {if $category}
    var category = '{$category}';
    {/if}
</script>

{literal}
    <script type="text/javascript">
        $(function() {

            $('button#fn_start').click(function() {
                do_export();
            });

            function do_export(page) {
                page = typeof(page) != 'undefined' ? page : 1;
                category = typeof(category) != 'undefined' ? category : 0;
                date_filter = typeof(date_filter) != 'undefined' ? date_filter : 0;
                date_from = typeof(date_from) != 'undefined' ? date_from : 0;
                date_to = typeof(date_to) != 'undefined' ? date_to : 0;
                status =  typeof(status) != 'undefined' ? status : 0;
                sort_prod = typeof(sort_prod) != 'undefined' ? sort_prod : 0;
                $.ajax({
                    url: "ajax/export_stat_products.php",
                    data: {
                        page: page,
                        category: category,
                        date_filter: date_filter,
                        date_from: date_from,
                        date_to: date_to,
                        status: status,
                        sort_prod: sort_prod
                    },
                    dataType: 'json',
                    success: function () {

                        window.location.href = 'files/export/export_stat_products.csv';
                    },
                    error: function (xhr, status, errorThrown) {
                        alert(errorThrown + '\n' + xhr.responseText);
                    }
                });
            }
        });
    </script>
{/literal}
