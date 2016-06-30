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
    <li>
        <a href="{url module=StatsAdmin}">Статистика</a>
    </li>
    <li class="active">
        <a href="{url module=ReportStatsAdmin filter=null status=null}">Отчет о продажах</a>
    </li>
    <li>
        <a href="{url module=CategoryStatsAdmin category=null brand=null supplier=null date_from=null date_to=null}">Категоризация продаж</a>
    </li>
    {if in_array('yametrika', $manager->permissions)}
        <li>
            <a href="index.php?module=YametrikaAdmin">Яндекс.Метрика</a>
        </li>
    {/if}

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
    {if $category}
    var category = '{$category}';
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

            <table class="table_blue" width="100%">
                <thead class="thead">
                    <tr>
                        <th width="27%">Категория</th>
                        <th width="40%">Наименование товара</th>
                        <th width="20%" class="c"><a class="sort {if $sort_prod=='price'}top{elseif $sort_prod=='price_in'}bottom{/if}" href="{if $sort_prod=='price'}{url sort_prod=price_in}{else}{url sort_prod=price}{/if}">Сумма продаж</a>
                        </th>
                        <th width="13%" class="c"><a class="sort {if $sort_prod=='amount'}top{elseif $sort_prod=='amount_in'}bottom{/if}" href="{if $sort_prod=='amount'}{url sort_prod=amount_in}{else}{url sort_prod=amount}{/if}">Кол-во</a>
                        </th>
                    </tr>
                </thead>
                <tbody>
                {foreach $report_stat_purchases as $purchase}
                    {assign var='total_summ'  value=$total_summ+$purchase->sum_price}
                    {assign var='total_amount' value=$total_amount+$purchase->amount}
                    <tr>
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
                </tbody>
                <tfoot>
                    <tr class="top_row">
                        <td  colspan="4"></td>
                    </tr>
                    <tr>
                        <th></th>
                        <th style="text-align: right">Итого:</th>
                        <th class="c">{$total_summ|string_format:'%.2f'} {$currency->sign|escape}</th>
                        <th class="c">{$total_amount} {$settings->units}</th>
                    </tr>
                </tfoot>
            </table>
        </div>
    </form>

</div>

<!-- Меню -->
<div id="right_menu">

    <form class="date_filter" method="get">

        <div class="date_filter_title">
            <span>Заказы за период</span>
            <div class="helper_wrap">
                <a id="show_help_filter" class="helper_link" href="javascript:;"></a>
                <div id="help_date_filter" class="helper_block">
                    <span> Если не указана дата «С», то выбираются заказы начиная с самого первого.</span>
                    <span> Если не указана конечная дата «По», то автоматом подставляется текущая дата.</span>
                </div>
            </div>
        </div>

        <div class="form_group">
            <label for="from_date">C</label>
            <input id="from_date" class="okay_inp" type=text name=date_from value='{$date_from}' />
        </div>

        <div class="form_group">
            <label for="to_date">По</label>
            <input id="to_date" class="okay_inp" type=text name=date_to value='{$date_to}' />
        </div>

        <input type="hidden" name="module" value="ReportStatsAdmin">
        <input type="hidden" name="date_filter" value="">
          
        <input id="apply_action" class="button" type="submit" value="Применить">
        
    </form>

    <span class="right_block_name">Статусы заказов</span>
    <ul id="status-order">
        <li {if !$status}class="selected"{/if}><a href="{url status=null}">Все заказы</a></li>
        <li {if $status==1}class="selected"{/if}><a href="{url status=1}">Новые</a></li>
        <li {if $status==2}class="selected"{/if}><a href="{url status=2}">Принятые</a></li>
        <li {if $status==3}class="selected"{/if}><a href="{url status=3}">Выполенные</a></li>
        <li {if $status==4}class="selected"{/if}><a href="{url status=4}">Удаленные</a></li>
    </ul>

    <span class="right_block_name">Период</span>
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
            <ul class="cats_right{if $level > 1} sub_menu{/if}">
                {if $categories[0]->parent_id == 0}
                    <li {if !$category->id}class="selected"{/if}><a href="{url category_id=null brand_id=null}">Все категории</a></li>
                {/if}
                {foreach $categories as $c}
                    <li category_id="{$c->id}" {if $smarty.get.category_id == $c->id}class="selected"{else}class="droppable category"{/if}>
                        <a href='{url keyword=null brand_id=null page=all category_id={$c->id}}'>{$c->name}</a>
                        {if $c->subcategories}<span class="slide_menu"></span>{/if}
                    </li>

                    {categories_tree categories=$c->subcategories level=$level+1}
                {/foreach}
            </ul>
        {/if}
    {/function}
    {categories_tree categories=$categories level=1}


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


            $('.slide_menu').on('click',function(){
                if($(this).hasClass('open')){
                    $(this).removeClass('open');
                }
                else{
                    $(this).addClass('open');
                }
                $(this).parent().next().slideToggle(500);
            });
            $('.cats_right li.selected').parents().removeClass('sub_menu');
            $('.cats_right li.selected').parents().prev().find('span').addClass('open');
        });

    </script>
{/literal}
