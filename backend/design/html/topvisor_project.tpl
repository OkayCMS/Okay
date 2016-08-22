{* Вкладки *}
{capture name=tabs}
    <li>
        <a href="index.php?module=TopvisorProjectsAdmin">Топвизор</a>
    </li>
    <li class="active">
        <a href="index.php?module=TopvisorProjectAdmin&id={$project->id}">Проект</a>
    </li>
{/capture}

{* Title *}
{$meta_title='Проект '|cat:$projects[$project->id]->site scope=parent}

<script src="design/js/autocomplete/jquery.autocomplete-min.js"></script>
<script src="design/js/charts/js/highcharts.js"></script>
<script src="design/js/charts/js/modules/exporting.js"></script>
<script src="design/js/fancybox/jquery.fancybox.js"></script>
<script src="design/js/jquery.matchHeight.js"></script>
<script src="design/js/slick/slick.min.js"></script>
<link href="design/js/slick/slick.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="design/js/fancybox/jquery.fancybox.css" type="text/css" media="screen" />
<div id="header" style="overflow: visible;clear: both;">
	<h1 class="h_blue" style="overflow: visible;clear: both;"><span>{if isset($projects[$project->id])}Проект {$projects[$project->id]->site}</span>{else}Проект не найден{/if}
        <div class="helper_wrap">
            <a class="top_help" id="show_help_search" href="https://www.youtube.com/watch?v=46WgnX9JAxo" target="_blank"></a>
            <div class="right helper_block topvisor_help">
                <p>Видеоинструкция по разделу</p>
            </div>
        </div>
    </h1>
</div>

{if $message_success}
<div class="message message_success">
	<span class="text">
        {if $message_success == 'added_searcher'}
            Поисковая система добавлена
        {elseif $message_success == 'delete_searcher'}
            Поисковые системы были успешно удалены
        {elseif $message_success == 'added_region'}
            Регион добавлен
        {elseif $message_success == 'delete_region'}
            Регионы были успешно удалены
        {elseif $message_success == 'added_group'}
            Группа добавлена
        {elseif $message_success == 'added_query'}
            Запросы добавлены
        {else}
            {$message_success}
        {/if}
    </span>
	{if $smarty.get.return}
        <a class="button" href="{$smarty.get.return}">Вернуться</a>
	{/if}
</div>
{/if}

{if $message_error}
<div class="message message_error">
	<span class="text">
        {if $message_error == 'delete_searcher'}
            Поисковые системы с id: 
            {foreach $api_results as $id=>$result}
                {$id}{if !$result@last},{/if}
            {/foreach}
             - не были удалёны
        {elseif $message_error == 'empty_region'}
            Регион не выбран
        {elseif $message_error == 'query_all_empty'}
            Все запросы пустые
        {elseif $message_error == 'query_empty'}
            Не передано запросов
        {else}
            {$message_error}
        {/if}
    </span>
    {if $smarty.get.return}
        <a class="button" href="{$smarty.get.return}">Вернуться</a>
	{/if}
</div>
{/if}

{if $project}
    
    <input id="project_id" type="hidden" value="{$project->id}" />  
    
    <div id="right_menu">
        <ul class="filter_right">
            {foreach $projects as $p}
                <li {if $p->id == $project->id}class="selected"{/if}>
                    <a href="{url id=$p->id}">{$p->site|escape}</a>
                </li>
            {/foreach}
        </ul>
    </div>
    
    {*Запросы*}
    
    <div id="main_list" class="brands">
        <span class="h2">Запросы</span>
        <div class="tabs">
            <div class="tab_navigation">
                <a href="#queries_dynamics" class="tab_navigation_link">Динамика по запросам</a>
                <a href="#queries_group" class="tab_navigation_link">По группам</a> 
                 
                <div class="row project_check">
                    <div class="cell query_position">
                        <a href="javascript:;" class="check_positions" data-id="{$project->id}"><span class="button_blue">Проверить позиции</span>({$project->price}р.)</a>
                    </div>
                    <div class="cell query_frequency">
                        <span class="percent_of_parse_val">{$project->percent_of_parse}</span>
                        <span>%</span>
                        <a href="javascript:;" class="check_percent_of_parse" data-id="{$project->id}" title="Обновить статус"></a>
                    </div>
                </div>
            </div>
            <div class="tab_container">

                <div id="queries_dynamics" class="tab">
                    <div class="dymamic_selects clearfix">
                        {if $project->searchers|count > 0}
                            <select class="frequency_searcher ajax_freeze">
                                {foreach $project->searchers as $s}
                                    <option value="{$s->searcher|escape}">{$s->name|escape}</option>
                                {/foreach}
                            </select>
                            {foreach $project->searchers as $s}
                                <select class="frequency_region ajax_freeze" data-searcher="{$s->searcher}">
                                    {foreach $s->regions as $r}
                                        <option value="{$r->key}" data-lang="{$r->lang}">{$r->name|escape}</option>
                                    {/foreach}
                                </select>
                            {/foreach}
                            <select class="frequency_group ajax_freeze">
                                <option value="-1">Все группы</option>
                                {foreach $queries_groups as $gid=>$group}
                                    <option value="{$gid}">{$group->name|escape}</option>
                                {/foreach}
                            </select>
                            <label>С</label>
                            <input type="text" value="{date('d.m.Y', time()-2419200)}" class="frequency_date_from ajax_freeze" readonly style="width: 100px; margin-right: 4px;" />
                            <label>По</label>
                            <input type="text" value="{date('d.m.Y', time()+86400)}" class="frequency_date_to ajax_freeze" readonly style="width: 100px;" />
                            <br />
                            <a href="javascript:;" class="button frequency_date ajax_freeze">Применить</a>
                        </div>
                        <div id="list" class="queries_dynamics ajax_freeze">
                            {*include file='topvisor_queries_dynamics.tpl'*}
                        </div>
                    {/if}
                </div>

                <div id="queries_group" class="tab">
                    <form id="topvisor_group_form" method="post">
                        <input type="hidden" name="session_id" value="{$smarty.session.id}"/>
                        <div id="list" class="brands">
                            {foreach $queries_groups as $gid=>$group}
                                <div class="row topvisor_block clearfix">
                                    
                                    <span class="topvisor_group_name">{$group->name|escape} <span>({$group->queries|count})</span></span>

                                    
                                    <div class="brands queries">
                                        {foreach $group->queries as $q}
                                            <div class="row">
                                                <div class="checkbox cell">
                                                    <a href="javascript:;" class="delete_query" data-id="{$q->id}"></a>
                                                </div>
                                                <div class="order_name cell">
                                                    {$q->phrase|escape}
                                                </div>
                                                <div class="clear"></div>
                                            </div>
                                        {/foreach}

                                        <a href="javascript:;" class="add_query" data-gid="{$gid}">Еще запрос</a>
                                        
                                        <div id="new_query" class="row" style="display: none;">
                                            <div class="checkbox cell" style="padding-top: 5px;">
                                                <a href="javascript:;" class="delete_query"></a>
                                            </div>
                                            <div class="cell">
                                                <input type="text" class="new_query_input"/>
                                            </div>
                                            <div class="clear"></div>
                                        </div>
                                    </div>
                                    
                                    <input class="button_blue" type="submit" name="add_queries[{$gid}]" value="Добавить запросы"/>
                                    
                                </div>
                            {/foreach}
                        </div>
                        <div id="list" class="brands">
                            <div class="row">
                                
                                <label>Введите имя группы: </label>
                                <input class="okay_inp" type="text" name="new_group"/>
                                <input class="button" type="submit" name="add_group" value="Добавить группу"/>
                               
                                <div class="clear"></div>
                            </div>
                        </div>
                    </form>
                </div>
                
            </div>
        </div>
    </div>

    {*Поисковые системы*}
    <div id="main_list" class="brands">
        <span class="h2">Поисковые системы</span>
        <form id="topvisor_project_form" method="post">
            <input type="hidden" name="session_id" value="{$smarty.session.id}"/>
            <div id="list">
                {foreach $project->searchers as $searcher}
                    <div class="row topvisor_block">
                        <div class="search_system_name">
                            <div class="checkbox cell">
                                <input type="checkbox" id="searcher_{$searcher->id}" name="check[]" value="{$searcher->id}"/>
                                <label for="searcher_{$searcher->id}"></label>
                            </div>
                            <div class="cell">
                                {$searcher->name|escape}
                            </div>
                            <div class="icons cell brand">
                                <a class="delete" title="Удалить" href="#"></a>
                            </div>
                            <div class="clear"></div>
                        </div>
                        
                        <div class="brands regions">
                            {foreach $searcher->regions as $r}
                                <div class="row">
                                    <div class="checkbox cell">
                                        <a href="javascript:;" class="delete_region" data-id="{$r->id}"></a>
                                    </div>
                                    <div class="cell">
                                        {$r->name|escape}
                                    </div>
                                    <div class="clear"></div>
                                </div>
                            {/foreach}
                        </div>

                        <div class="add_regions">
                            <input type="text" class="input_autocomplete" placeholder='Выберите регион'/>
                            <input type="hidden" name="new_region[{$searcher->id}]" />
                            <input class="button_blue" type="submit" name="add_region[{$searcher->id}]" value="Добавить регион"/>
                        </div>
                        
                    </div>
                {/foreach}
            </div>
            <div id="list" class="brands">
                <div id="search_systems" class="row">
                    <div>
                        <label>Выберите поисковую систему: </label>
                        <select name="new_searcher">
                            <option value="0">Yandex</option>
                            <option value="1">Google</option>
                            <option value="2">Mail</option>
                            <option value="3">Спутник</option>
                            <option value="4">Youtube</option>
                            <option value="5">Bing</option>
                            <option value="6">Yahoo</option>
                        </select>
                        <input class="button" type="submit" name="add_searcher" value="Добавить поисковую систему"/>
                    </div>
                    <div class="icons cell brand">
                        
                    </div>
                    <div class="clear"></div>
                </div>
            </div>
            <div id="action">
                <label class="dash_link check_all">Выбрать все</label>
                <span id="select">
                <select name="action">
                    <option value="delete">Удалить</option>
                </select>
                </span>
                <input id="apply_action" class="button" type="submit" value="Применить"/>
            </div>

        </form>
    </div>
    
<div style="display: none;">
<div id="container" style="min-width: 800px; height: 400px; margin: 0 auto"></div>
</div>
<a href="#container" id="fancy"></a>
{/if}



{literal}

<script>
    var chart = '';
$(function() {

    $('input.input_autocomplete').autocomplete({
		serviceUrl:'ajax/topvisor.php?module=search_regions&session_id={/literal}{$smarty.session.id}{literal}',
		minChars:1,
		noCache: false,
		onSelect:
            function(suggestion) {
                $(this).closest('div').find('input[name*="new_region"]').val(suggestion.data);
            }
	});

    // удалить регион
    $('.delete_region').on('click', function() {
        $(this).closest('.row').remove();
        $.ajax({
			type: 'POST',
			url: 'ajax/topvisor.php',
			data: {'id': $(this).data('id'), module: 'delete_region', session_id: '{/literal}{$smarty.session.id}{literal}'},
			success: function(data){
				if (data.result != 1) {
				    console.log(data);
				}
			},
			dataType: 'json'
		});
    });

    // добавить запрос
    var new_query = $('#new_query').clone(true);
    new_query.removeAttr('id');
    $('#new_query').remove();
    $('.add_query').on('click', function() {
        var new_item = new_query.clone().appendTo($(this).closest('.queries'));
        new_item.find('.new_query_input').attr('name', 'new_queries[' + $(this).data('gid') + '][]');
        new_item.show();
    });
    // удалить запрос
    $(document).on('click', '.delete_query', function() {
        $(this).closest('.tabs').find('a[data-id="' + $(this).data('id') + '"]').closest('.row').remove();
        $(this).closest('.row').remove();
        if ($(this).data('id')) {
            $.ajax({
    			type: 'POST',
    			url: 'ajax/topvisor.php',
    			data: {'id': $(this).data('id'), module: 'delete_query', session_id: '{/literal}{$smarty.session.id}{literal}'},
    			success: function(data){
    				if (data.result != 1) {
    				    console.log(data);
    				}
    			},
    			dataType: 'json'
    		});
        }
    });

    // фильтр динамики запросов
    // поисковые системы
    $(document).on('change', '.frequency_searcher', function() {
        var region = $('.frequency_region.[data-searcher="' + $(this).val() + '"]');
        $('.frequency_region').hide();
        region.show();
        region.trigger('change');
    });
    // регионы
    $(document).on('change', '.frequency_region', function() {
        var elem = $(this),
            dates = $('.frequency_date_from').val() + '---' + $('.frequency_date_to').val();
        $('.ajax_freeze').attr('disabled', true);
        frequency_ajax($('#project_id').val(), elem.data('searcher'), elem.val(), elem.find('option:selected').data('lang'), $('.frequency_group').val(), dates);
    });
    $('.frequency_searcher').trigger('change');
    // группы запросов
    $(document).on('change', '.frequency_group', function() {
        $('.ajax_freeze').attr('disabled', true);
        var region = $('.frequency_region:visible'),
            dates = $('.frequency_date_from').val() + '---' + $('.frequency_date_to').val();
        frequency_ajax($('#project_id').val(), region.data('searcher'), region.val(), region.find('option:selected').data('lang'), $(this).val(), dates);
    });
    // даты
    $(document).on('click', '.frequency_date', function() {
        $('.ajax_freeze').attr('disabled', true);
        var region = $('.frequency_region:visible'),
            dates = $('.frequency_date_from').val() + '---' + $('.frequency_date_to').val();
        frequency_ajax($('#project_id').val(), region.data('searcher'), region.val(), region.find('option:selected').data('lang'), $('.frequency_group').val(), dates);
    })
    $('.frequency_date_from,.frequency_date_to').datepicker({
        firstDay:1,
        dateFormat:'dd.mm.yy',
        defaultDate:$(this).val(),
        numberOfMonths:1
    });

    // пагинация динамики запросов
    $(document).on('click', '.topvisor_pagination', function() {
        $('.ajax_freeze').attr('disabled', true);
        var region = $('.frequency_region:visible'),
            dates = $('.frequency_date_from').val() + '---' + $('.frequency_date_to').val();
        frequency_ajax($('#project_id').val(), region.data('searcher'), region.val(), region.find('option:selected').data('lang'), $('.frequency_group').val(), dates, $(this).data('page'));
    });
    function frequency_ajax(project_id, searcher, region, region_lang, group_id, dates, page) {
        $.ajax({
			type: 'POST',
			url: 'ajax/topvisor_queries_dynamics.php',
			data: {'project_id': project_id, 'searcher': searcher, 'region_key': region, region_lang: region_lang, group_id: group_id, dates: dates, page: page, session_id: '{/literal}{$smarty.session.id}{literal}'},
			success: function(data){
				$('.queries_dynamics').html(data.content);
                $('.ajax_freeze').attr('disabled', false);
                chart = data.data;
			},
			dataType: 'json'
		});
    }

    // табы
    $('.tabs').each(function(i) {
        var cur_nav = $(this).find('.tab_navigation'),
            cur_tabs = $(this).find('.tab_container');
        if(cur_nav.children('.selected').size() > 0) {
            $(cur_nav.children('.selected').attr("href")).show();
            cur_tabs.css('height', cur_tabs.children($(cur_nav.children('.selected')).attr("href")).outerHeight());
        } else {
            cur_nav.children().first().addClass('selected');
            cur_tabs.children().first().show();
        }
    });
    $('.tab_navigation_link').click(function(e){
        e.preventDefault();
        if($(this).hasClass('selected')){
            return true;
        }
        var cur_nav = $(this).closest('.tabs').find('.tab_navigation'),
            cur_tabs = $(this).closest('.tabs').find('.tab_container');
        cur_tabs.children().hide();
        cur_nav.children().removeClass('selected');
        $(this).addClass('selected');
        $($(this).attr("href")).fadeIn(200);
        return false;
    });

    $('.check_positions').on('click', function() {
        var elem = $(this);
        if (elem.data('id')) {
            $.ajax({
                type: 'POST',
                url: 'ajax/topvisor.php',
                data: {'id': elem.data('id'), module: 'check_positions', session_id: '{/literal}{$smarty.session.id}{literal}'},
                success: function(data){
                    if (data.result != 1) {
                        alert(data.message);
                    }
                    elem.closest('.row').find('.percent_of_parse_val').html('0');
                },
                dataType: 'json'
            });
        }
    });

    $('.check_percent_of_parse').on('click', function() {
        var elem = $(this);
        if (elem.data('id')) {
            $.ajax({
                type: 'POST',
                url: 'ajax/topvisor.php',
                data: {'id': elem.data('id'), module: 'check_percent_of_parse', session_id: '{/literal}{$smarty.session.id}{literal}'},
                success: function(data){
                    elem.closest('.query_frequency').find('.percent_of_parse_val').html(data.percent);
                },
                dataType: 'json'
            });
        }
    });


	// Выделить все
	$(".check_all").click(function() {
        var form = $(this).closest('form');
        form.find('#list input[type="checkbox"][name*="check"]').attr('checked', form.find('#list input[type="checkbox"][name*="check"]:not(:checked)').length>0);
	});

	// Удалить
	$("a.delete").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', false);
		$(this).closest("div.row").find('input[type="checkbox"][name*="check"]').attr('checked', true);
		$(this).closest("form").find('select[name="action"] option[value=delete]').attr('selected', true);
		$(this).closest("form").submit();
	});

	// Подтверждение удаления
    $("form").submit(function() {
        if($(this).find('#list input[type="checkbox"][name*="check"]:checked').length>0) {
            if($(this).find('select[name="action"]').val()=='delete' && !confirm('Подтвердите удаление')) {
                return false;
            }
        }
	});

    //Рисовалка графиков
    $(".graph_create").live('click',function(){
        var from = $('.frequency_date_from').val();
        var to = $('.frequency_date_to').val();
        var date =[];
        var pos = $(this).data('pos');
        var name_pos= $(this).data('name');
        for(var i in chart.scheme.dates){
            var k= date.push(chart.scheme.dates[i].date);
        }
        pos = pos.substr(0,pos.length - 1);
        pos = pos.split(',');
        for(var i= 0;i<pos.length;i++){
            if(pos[i] == 0){
                pos[i]=100;
            }
            else {
                pos[i] = parseInt(pos[i]);
            }
        }
        var ch = $('#container');
        ch.highcharts({
            title: {
                text: 'Динамика позиций запроса:' + ' ' + name_pos,
                x: -20 //center
            },
            subtitle: {
                text: {/literal}'{$projects[$project->id]->site}'{literal},
                x: -20
            },
            xAxis: {
                type:'categories',
                categories: date
            },
            yAxis: {
                title: {
                    text: 'Позиции'
                },
                reversed: true,
                min:0,
                max:100,
                plotLines: [{
                    value: 0,
                    width: 1,
                    color: '#808080'
                }]
            },
            tooltip: {
                valueSuffix: ''
            },
            legend: {
                layout: 'vertical',
                align: 'right',
                verticalAlign: 'middle',
                borderWidth: 0
            },
            series: [{
                name: name_pos,
                data: pos
            }]

        });
        $('#container').highcharts().redraw();
        $("#fancy").fancybox({
            padding:0
        });
        $("#fancy").trigger('click');
    });


});
</script>
{/literal}
