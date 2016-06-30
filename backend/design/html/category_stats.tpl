{capture name=tabs}
    <li>
        <a href="{url module=StatsAdmin}">Статистика</a>
    </li>
    <li>
        <a href="{url module=ReportStatsAdmin filter=null status=null}">Отчет о продажах</a>
    </li>
    <li class="active">
        <a href="{url module=CategoryStatsAdmin category=null brand=null date_from=null date_to=null}">Категоризация продаж</a>
    </li>
    {if in_array('yametrika', $manager->permissions)}
        <li>
            <a href="index.php?module=YametrikaAdmin">Яндекс.Метрика</a>
        </li>
    {/if}
{/capture}
{$meta_title='Категоризация продаж' scope=parent}

{* On document load *}
<script>
    {if $category}
        var category = {$category->id};
    {/if}
    {if $brand}
        var brand = {$brand->id};
    {/if}
    {if $date_from}
        var date_from = '{$date_from}';
    {/if}
    {if $date_to}
        var date_to = '{$date_to}';
    {/if}
</script>
{literal}
    <script src="design/js/jquery/datepicker/jquery.ui.datepicker-ru.js"></script>
    <script type="text/javascript">

        $(function() {
            $('input[name="date_from"]').datepicker({
                regional:'ru'
            });

            $('input[name="date_to"]').datepicker({
                regional:'ru'
            });

            $('input#start').click(function () {
                do_export();

            });
            function do_export(page) {
                page = typeof(page) != 'undefined' ? page : 1;
                category = typeof(category) != 'undefined' ? category : 0;
                brand = typeof(brand) != 'undefined' ? brand : 0;
                date_from = typeof(date_from) != 'undefined' ? date_from : 0;
                date_to = typeof(date_to) != 'undefined' ? date_to : 0;
                $.ajax({
                    url: "ajax/export_stat.php",
                    data: {
                        page: page,
                        category: category,
                        brand: brand,
                        date_from: date_from,
                        date_to: date_to
                    },
                    dataType: 'json',
                    success: function () {

                            window.location.href = 'files/export/export_stat.csv';
                    },
                    error: function (xhr, status, errorThrown) {
                        alert(errorThrown + '\n' + xhr.responseText);
                    }

                });

            }
        });
    </script>

{/literal}
<div>
    <div id="header">
        <h1>
            Категоризация продаж<br />
            {$category->name} {$brand->name}
        </h1>
        <input class="button_green" id="start" type="button" name="" value="Скачать" />
    </div>

    <div id="main_list">
        <div id="list">
            <table class="table_blue" width="100%">
                <thead class="thead">
                    <tr>
                        <td>Категория</td>
                        <td class="stats_amount">Количество, {$settings->units}</td>
                        <td class="stats_price">Сумма, {$currency->sign}</td>
                    </tr>
                </thead>
                <tbody>
                {function name=categories_list_tree level=0}
                    {if $categories}
                        {foreach $categories as $category}
                            <tr>
                                <td style="padding-left:{($level+1)*15}px">{$category->name|escape}</td>
                                <td class="stats_amount">{if $category->amount}<b>{$category->amount}</b>{else}{$category->amount}{/if} {$settings->units}</td>
                                <td class="stats_price">{if $category->price}<b>{$category->price}</b>{else}{$category->price}{/if} {$currency->sign}</td>
                                {categories_list_tree categories=$category->subcategories level=$level+1}
                            </tr>
                        {/foreach}
                    {/if}
                {/function}
                {categories_list_tree categories=$categories_list}
                </tbody>
                <tfoot>
                    <tr class="top_row">
                        <td  colspan="3"></td>
                    </tr>
                    <tr>
                        <th style="text-align: right">Итого</th>
                        <th>{$total_amount} {$settings->units}</th>
                        <th style="text-align: right">{$total_price} {$currency->sign}</th>
                    </tr>
                </tfoot>
            </table>
        </div>
          
    </div>
</div>
    <div id="right_menu">
        {* Фильтр *}
            <form class="date_filter" method="get">
                <div class="date_filter_title">
                    <span>Выбрать период</span>
                    <div class="helper_wrap">
                        <a id="show_help_filter" class="helper_link" href="javascript:;"></a>
                        <div id="help_date_filter" class="helper_block">
                            <span> Если не указана дата «С», то выбираются продажи начиная с самой первой.</span>
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

                <input type="hidden" name="module" value="CategoryStatsAdmin" />
                <input id="apply_action" class="button_green" type="submit" value="Применить" />
            </form>
        <h4>Категории</h4>
        {function name=categories_tree}
            {if $categories}
                <ul class="cats_right{if $level > 1} sub_menu{/if}" >
                    {if $categories[0]->parent_id == 0}
                        <li {if !$category->id}class="selected"{/if}>
                            <a href="{url category=null brand=null}">Все категории</a>
                        </li>
                    {/if}
                    {foreach $categories as $c}
                        <li {if $category->id == $c->id}class="selected"{/if}>
                            <a href="{url brand=null supplier=null category={$c->id}}">{$c->name}</a>
                            {if $c->subcategories}<span class="slide_menu"></span>{/if}
                        </li>
                        {categories_tree categories=$c->subcategories level=$level+1}
                    {/foreach}
                </ul>
            {/if}
        {/function}
        {categories_tree categories=$categories level=1}

        <h4>Бренды</h4>
        {if $brands}
            <ul>
                <li {if !$brand->id}class="selected"{/if}>
                    <a href="{url brand=null}">Все бренды</a>
                </li>
                {foreach $brands as $b}
                    <li brand_id="{$b->id}" {if $brand->id == $b->id}class="selected"{else}class="droppable brand"{/if}>
                        <a href="{url brand=$b->id}">{$b->name}</a>
                    </li>
                {/foreach}
            </ul>
        {/if}
    </div>
    <!-- Меню  (The End) -->
<script>
    $(function(){
        $('.slide_menu').on('click',function(){
            if($(this).hasClass('open')){
                $(this).removeClass('open');
            }
            else{
                $(this).addClass('open');
            }
            $(this).parent().next().slideToggle(500);
        })
    });
</script>
