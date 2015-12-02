{capture name=tabs}
    <li><a href="{url module=StatsAdmin}">Статистика</a></li>
    <li><a href="{url module=ReportStatsAdmin filter=null status=null}">Отчет о продажах</a></li>
    <li class="active"><a href="{url module=CategoryStatsAdmin category=null brand=null date_from=null date_to=null}">Категоризация продаж</a></li>
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
            $('input[name="date_from"]').datepicker({regional: 'ru'});
            $('input[name="date_to"]').datepicker({regional: 'ru'});

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
    <style>
        .stats_price,.stats_amount{
            width:150px;
        }
    </style>
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
            <div class="tree_row" style="margin-left:15px;">
                <div class="cell">
                    Категория
                </div>
                <div class="icons cell stats_price">Сумма, {$currency->sign}</div>
                <div class="icons cell stats_amount">Количество, {$settings->units}</div>
                <div class="clear"></div>
            </div>
            <div class="tree_row" style="margin-left:15px;font-size:16px;">
                <div class="cell">
                    <b>Итого</b>
                </div>
                <div class="icons cell stats_price">
                    <b>{$total_price} {$currency->sign}</b>
                </div>
                <div class="icons cell stats_amount">
                    <b>{$total_amount} {$settings->units}</b>
                </div>
                <div class="clear"></div>
            </div>
            {function name=categories_list_tree level=0}
                {if $categories}
                    <div id="list" class="sortable">

                        {foreach $categories as $category}
                            <div class="row">
                                <div class="tree_row" style="margin-left:{($level+1)*15}px">
                                    <div class="cell">
                                        {$category->name|escape}
                                    </div>
                                    <div class="icons cell stats_price">{if $category->price}<b>{$category->price}</b>{else}{$category->price}{/if} {$currency->sign}</div>
                                    <div class="icons cell stats_amount">{if $category->amount}<b>{$category->amount}</b>{else}{$category->amount}{/if} {$settings->units}</div>
                                    <div class="clear"></div>
                                </div>
                                {categories_list_tree categories=$category->subcategories level=$level+1}
                            </div>
                        {/foreach}

                    </div>
                {/if}
            {/function}
            {categories_list_tree categories=$categories_list}

        </div>
        <div id="list">
            <div class="tree_row" style="margin-left:15px;font-size:16px;">
                <div class="cell">
                    <b>Итого</b>
                </div>
                <div class="icons cell stats_price">
                    <b>{$total_price} {$currency->sign}</b>
                </div>
                <div class="icons cell stats_amount">
                    <b>{$total_amount} {$settings->units}</b>
                </div>
                <div class="clear"></div>
            </div>
        </div>

    </div>

    <div id="right_menu">
        <h4>Период</h4>
        {* Фильтр *}
        <div style="display: block; clear:both; border: 1px solid #C0C0C0; margin: 10px 0; padding: 10px">
            <form method="get">
                <input type="hidden" name="module" value="CategoryStatsAdmin" />
                <div id='filter_fields'>
                    <div style="margin: 15px 0">
                        <label>Дата с:&nbsp;</label><input type=text name=date_from value='{$date_from}' style="width:95%;"><br /><br />
                        <label>По:&nbsp;</label></br><input type=text name=date_to value='{$date_to}' style="width:95%;">
                    </div>
                    <input id="apply_action" class="button_green" type="submit" value="Применить">
                </div>
            </form>
        </div>

        <h4>Категории</h4>
        {function name=categories_tree}
            {if $categories}
                <ul>
                    {if $categories[0]->parent_id == 0}
                        <li {if !$category->id}class="selected"{/if}><a href="{url category=null brand=null}">Все категории</a></li>
                    {/if}
                    {foreach $categories as $c}
                        <li category_id="{$c->id}" {if $category->id == $c->id}class="selected"{else}class="droppable category"{/if}>
                            <a href='{url brand=null supplier=null category={$c->id}}'>{$c->name}</a>
                        </li>
                        {categories_tree categories=$c->subcategories}
                    {/foreach}
                </ul>
            {/if}
        {/function}
        {categories_tree categories=$categories}

        <h4>Бренды</h4>
        {if $brands}
            <ul>
                <li {if !$brand->id}class="selected"{/if}><a href="{url brand=null}">Все бренды</a></li>
                {foreach $brands as $b}
                    <li brand_id="{$b->id}" {if $brand->id == $b->id}class="selected"{else}class="droppable brand"{/if}>
                        <a href="{url brand=$b->id}">{$b->name}</a>
                    </li>
                {/foreach}
            </ul>
        {/if}
    </div>
    <!-- Меню  (The End) -->
</div>
