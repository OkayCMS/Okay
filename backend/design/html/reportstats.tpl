{* On document load *}
{literal}
    <script src="design/js/jquery/datepicker/jquery.ui.datepicker-ru.js"></script>

    <script>

        $(function() {

            $('input[name="date_from"]').datepicker({
                regional:'ru'
            });

            $('input[name="date_to"]').datepicker({
                regional:'ru'
            });

        });
    </script>

    <style>

        #list td, #list th { padding: 7px 5px; text-align: left; }
        #list td.c, #list th.c { text-align: center; }
        .sort.top:before { content:"↑ "; border-bottom:none; }
        .sort.bottom:before { content: "↓ "; border-bottom:none; }
        #list tfoot { background: #d0d0d0; }

    </style>

{/literal}

{* Вкладки *}
{capture name=tabs}
    <li><a href="{url module=StatsAdmin}">Статистика</a></li>
    <li class="active"><a href="{url module=ReportStatsAdmin filter=null status=null}">Отчет о продажах</a></li>
    <li><a href="{url module=CategoryStatsAdmin category=null brand=null supplier=null date_from=null date_to=null}">Категоризация продаж</a></li>

{/capture}
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
</script>

{literal}
    <script type="text/javascript">
        $(function() {
            $('input#start').click(function () {
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

{* Title *}
{$meta_title='Отчет о продажах' scope=parent}

<div id="chart_div" style="width:900px;height:900px;display:none;">
    <div id="chart_cont"></div>
    <div id="chart_amount" style="margin-top:25px;"></div>
</div>

{* Заголовок *}
<div id="header">
    <h1>Отчет по заказам</h1>
    <input class="button_green" id="start" type="button" name="" value="Скачать" />
</div>

<div id="main_list">
    {include file='pagination.tpl'}
    <form id="form_list" method="post">
        <input type="hidden" name="session_id" value="{$smarty.session.id}">

        <div id="list">

            {assign 'total_summ' 0}
            {assign 'total_amount' 0}

            <table width="100%">
                <tbody>
                <thead class="thead">
                <th width="30%">Категория</th>
                <th width="40%">Наименование товара</th>
                <th width="15%" class="c"><a class="sort {if $sort_prod=='price'}top{elseif $sort_prod=='price_in'}bottom{/if}" href="{if $sort_prod=='price'}{url sort_prod=price_in}{else}{url sort_prod=price}{/if}">Сумма продаж</a></th>
                <th width="15%" class="c"><a class="sort {if $sort_prod=='amount'}top{elseif $sort_prod=='amount_in'}bottom{/if}" href="{if $sort_prod=='amount'}{url sort_prod=amount_in}{else}{url sort_prod=amount}{/if}">Кол-во</a></th>
                <thead>
                {foreach $report_stat_purchases as $purchase}
                    {assign var='total_summ'  value=$total_summ+$purchase->sum_price}
                    {assign var='total_amount' value=$total_amount+$purchase->amount}
                    <tr class="row">
                        <td>
                            {foreach $purchase->category->path as $c}
                                {$c->name}/
                            {/foreach}
                        </td>
                        <td>
                            <a title="{$purchase->product_name|escape}" href="{url module=ReportStatsProdAdmin id=$purchase->product_id return=$smarty.server.REQUEST_URI}">{$purchase->product_name}</a> {$purchase->variant_name}
                        </td>
                        <td class="c">{$purchase->sum_price} {$currency->sign|escape}</td>
                        <td class="c">{$purchase->amount} {$settings->units}</td>
                    </tr>
                {/foreach}
                <tfoot>
                <td></td>
                <td style="text-align: right">Итого:</td>
                <td class="c">{$total_summ|string_format:'%.2f'} {$currency->sign|escape}</td>
                <td class="c">{$total_amount} {$settings->units}</td>
                </tfoot>
                </tbody>
            </table>
        </div>
    </form>

</div>

<!-- Меню -->
<div id="right_menu">

    <div style="display: block; clear:both; border: 1px solid #C0C0C0; margin: 10px 0; padding: 10px">
        <form method="get">
            <div id='filter_check'>
                <label for="check">Заданный период</label>
            </div>

            <div id='filter_fields'>
                <input type="hidden" name="module" value="ReportStatsAdmin">
                <input type="hidden" name="date_filter" value="">
                <div style="margin: 15px 0">
                    <label>Дата с:&nbsp;</label><input type=text name=date_from value='{$date_from}' style="width: 95%">&nbsp;
                    <label>По:&nbsp;</label><input type=text name=date_to value='{$date_to}' style="width: 95%">
                </div>
                <input id="apply_action" class="button_green" type="submit" value="Применить">
            </div>
        </form>
    </div>

    <h4>Статусы заказов</h4>
    <ul id="status-order">
        <li {if !$status}class="selected"{/if}><a href="{url status=null}">Все заказы</a></li>
        <li {if $status==1}class="selected"{/if}><a href="{url status=1}">Новые</a></li>
        <li {if $status==2}class="selected"{/if}><a href="{url status=2}">Принятые</a></li>
        <li {if $status==3}class="selected"{/if}><a href="{url status=3}">Выполенные</a></li>
        <li {if $status==4}class="selected"{/if}><a href="{url status=4}">Удаленные</a></li>
    </ul>

    <h4>Период</h4>
    <ul id="filter-date">
        <li {if !$date_filter}class="selected"{/if}><a onclick="show_fields();" href="{url date_filter=null date_to=null date_from=null filter_check=null}">Все заказы</a></li>
        <li {if $date_filter == today}class="selected"{/if}><a onclick="show_fields();" href="{url date_filter=today date_to=null date_from=null filter_check=null}">Сегодня</a></li>
        <li {if $date_filter == this_week}class="selected"{/if}><a onclick="show_fields();" href="{url date_filter=this_week date_to=null date_from=null filter_check=null}">Текущая неделя</a></li>
        <li {if $date_filter == this_month}class="selected"{/if}><a onclick="show_fields();" href="{url date_filter=this_month date_to=null date_from=null filter_check=null}">Текущий месяц</a></li>
        <li {if $date_filter == this_year}class="selected"{/if}><a onclick="show_fields();" href="{url date_filter=this_year date_to=null date_from=null filter_check=null}">Текущий год</a></li>
        <li {if $date_filter == yesterday}class="selected"{/if}><a onclick="show_fields();" href="{url date_filter=yesterday date_to=null date_from=null filter_check=null}">Вчера</a></li>
        <li {if $date_filter == last_week}class="selected"{/if}><a onclick="show_fields();" href="{url date_filter=last_week date_to=null date_from=null filter_check=null}">Предыдущая неделя</a></li>
        <li {if $date_filter == last_month}class="selected"{/if}><a onclick="show_fields();" href="{url date_filter=last_month date_to=null date_from=null filter_check=null}">Предыдущий месяц</a></li>
        <li {if $date_filter == last_year}class="selected"{/if}><a onclick="show_fields();" href="{url date_filter=last_year date_to=null date_from=null filter_check=null}">Предыдущий год</a></li>
        <li {if $date_filter == last_24hour}class="selected"{/if}><a onclick="show_fields();" href="{url date_filter=last_24hour date_to=null date_from=null filter_check=null}">Последние 24 часа</a></li>
        <li {if $date_filter == last_7day}class="selected"{/if}><a onclick="show_fields();" href="{url date_filter=last_7day date_to=null date_from=null filter_check=null}">Последние 7 дней</a></li>
        <li {if $date_filter == last_30day}class="selected"{/if}><a onclick="show_fields();" href="{url date_filter=last_30day date_to=null date_from=null filter_check=null}">Последние 30 дней</a></li>
    </ul>
    {* Фильтр *}


    {function name=categories_tree}
        {if $categories}
            <ul>
                {if $categories[0]->parent_id == 0}
                    <li {if !$category->id}class="selected"{/if}><a href="{url category_id=null brand_id=null}">Все категории</a></li>
                {/if}
                {foreach $categories as $c}
                    <li category_id="{$c->id}" {if $category->id == $c->id}class="selected"{else}class="droppable category"{/if}><a href='{url keyword=null brand_id=null page=all category_id={$c->id}}'>{$c->name}</a></li>
                    {categories_tree categories=$c->subcategories}
                {/foreach}
            </ul>
        {/if}
    {/function}
    {categories_tree categories=$categories}


</div>
<!-- Меню  (The End) -->



{* On document load *}
{literal}
    <script>

        $(function() {

            // Сортировка списка
            $("#labels").sortable({
                items:             "li",
                tolerance:         "pointer",
                scrollSensitivity: 40,
                opacity:           0.7
            });

            // Раскраска строк
            function colorize()
            {
                $("#list tr.row:even").addClass('even');
                $("#list tr.row:odd").removeClass('even');
            }
            // Раскрасить строки сразу
            colorize();
        });

    </script>
{/literal}
