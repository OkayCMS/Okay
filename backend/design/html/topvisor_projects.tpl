{* Вкладки *}
{capture name=tabs}
    <li class="active">
        <a href="index.php?module=TopvisorProjectsAdmin">Топвизор</a>
    </li>
{/capture}

{* Title *}
{$meta_title='Топвизор проекты' scope=parent}

<div id="topvisor_heading" style="overflow: visible">
    {if $balance !== ''}<span>Апометр</span> {else}Введите API Key {/if}
    <div class="helper_wrap">
        <a class="top_help" id="show_help_search" href="https://www.youtube.com/watch?v=46WgnX9JAxo" target="_blank"></a>
        <div class="right helper_block topvisor_help">
            <p>Видеоинструкция по разделу</p>
        </div>
    </div>
	<span id="balans_heading">{if $balance !== ''}Баланс: <span>{$balance}р.</span>{/if}</span>
</div>

<form id="topvisor_key_form" method="post">
    <input type="hidden" name="session_id" value="{$smarty.session.id}"/>
    <label class="property">API key</label>
    <input name="topvisor_key" class="okay_inp" type="text" value="{$settings->topvisor_key|escape}" />
    <input class="button" type="submit" value="Сохранить" name="api_settings"/>

    <a class="topvisor_link" href="https://topvisor.ru/?inv=64152" target="_blank">Перейти в Топвизор</a>
</form>

{if $message_success}
<div class="message message_success">
	<span class="text">{if $message_success=='added'}Проект добавлен{elseif $message_success == 'delete'}Проекты были успешно удалены{else}{$message_success}{/if}</span>
	{if $smarty.get.return}
        <a class="button" href="{$smarty.get.return}">Вернуться</a>
	{/if}
</div>
{/if}

{if $message_error}
<div class="message message_error">
	<span class="text">
        {if $message_error == 'delete'}
            Проекты с id: 
            {foreach $api_results as $id=>$result}
                {$id}{if !$result@last},{/if}
            {/foreach}
             - не были удалёны
        {elseif $message_error == 'empty_site'}
            Сайт должен быть заполнен.
        {elseif $message_error == 'Wrong API KEY'}
            Неверный API Key &nbsp;
            <a class="topvisor_link" href="https://topvisor.ru/?inv=64152" target="_blank">Перейти в Топвизор</a>
        {elseif $message_error == 'unknown_error'}
            Неизвестная ошибка. Возможно у вас нет соединения с интернетом.
        {else}
            {$message_error}
        {/if}
    </span>
    {if $smarty.get.return}
        <a class="button" href="{$smarty.get.return}">Вернуться</a>
	{/if}
</div>
{/if}

{if $balance !== ''}
    <div id="apometr">
        <div class="filter">
            <select class="searcher ajax_freeze">
                <option value="0">Yandex</option>
                <option value="1">Google</option>
                <option value="2">go.Mail</option>
                <option value="5">Bing</option>
            </select>
            <select class="region ajax_freeze">
                <option value="213:ru">Москва</option>
                <option value="2:ru">Санкт-Петербург</option>
                <option value="143:uk">Киев</option>
                <option value="157:be">Минск</option>
            </select>
            <input type="hidden" class="date_month" value="{date('Y-m-01')}" />
        </div>

        <div class="content">
            <div class="apometr"></div>
        </div>
    </div>
        <div id="header">
            <h1>Проекты</h1>
        </div>
        <form id="topvisor_projects_form" method="post">
            <input type="hidden" name="session_id" value="{$smarty.session.id}"/>
            <div id="list">
                <div class="projects_head">
                    <div class="checkbox cell">@</div>
                    <div class="cell project_name">Сайт проекта</div>
                    <div class="cell query_frequency">Состояние проверки, %</div>
                    <div class="cell query_position">Проверка позиций</div>
                    <div class="clear"></div>
                </div>
                {foreach $projects as $project}
                    <div class="row">
                        <div class="checkbox cell">
                            <input type="checkbox" id="{$project->id}" name="check[]" value="{$project->id}"/>
                            <label for="{$project->id}"></label>
                        </div>
                        <div class="cell project_name">
                            <a href="{url module=TopvisorProjectAdmin id=$project->id return=$smarty.server.REQUEST_URI}">{$project->site|escape}</a>
                        </div>
                        <div class="cell query_frequency">
                            <span class="percent_of_parse_val">{$project->percent_of_parse}</span>
                            <a href="javascript:;" class="check_percent_of_parse" data-id="{$project->id}" title="Обновить статус"></a>
                        </div>
                        <div class="cell query_position">
                            <a href="javascript:;" class="check_positions" data-id="{$project->id}"><span class="button_blue">Проверить</span>({$project->price}р.)</a>
                        </div>
                        <div class="icons cell">
                            <a class="delete" title="Удалить" href="#"></a>
                        </div>
                        <div class="clear"></div>
                    </div>
                {/foreach}
                <div class="row">
                    <div class="cell">
                        <label>Введите сайт: </label>
                        <input class="okay_inp" type="text" name="new_site" value=""/>
                    </div>
                    <div class="icons cell brand">
                        <input class="button" type="submit" name="add_project" value="Добавить проект"/>
                    </div>
                    <div class="clear"></div>
                </div>
            </div>
            <div id="action">
                <label id="check_all" class="dash_link">Выбрать все</label>
                <span id="select">
                <select name="action">
                    <option value="delete">Удалить</option>
                </select>
                </span>
                <input id="apply_action" class="button" type="submit" value="Применить"/>
            </div>

        </form>
{/if}

{literal}
<script src="design/js/jquery/datepicker/jquery.ui.datepicker-ru.js"></script>
<script>
var apometr_data = new Array();
$(function() {

    {/literal}
    {if $balance !== ''}
    {literal}
    // поисковые системы и регионы
    $(document).on('change', '#apometr .filter select', function() {
        apometr_ajax();
    });
    $('#apometr .searcher').trigger('change');
    
    function apometr_ajax() {
        $('.ajax_freeze').attr('disabled', true);
        $("#apometr .apometr").datepicker('disable');
        var searcher = $('#apometr .searcher').val(), 
            region = $('#apometr .region').val().split(':'), 
            date_month = $('#apometr .date_month').val();
        
        $.ajax({
			type: 'POST',
			url: 'ajax/topvisor.php',
			data: {'searcher': searcher, 'region_key': region[0], region_lang: region[1], date_month: date_month, module: 'apometr', session_id: '{/literal}{$smarty.session.id}{literal}'},
			success: function(data){
                apometr_data = data.res;
                $('#apometr .apometr').datepicker('refresh');
                $('.ajax_freeze').attr('disabled', false);
                $("#apometr .apometr").datepicker('enable');
                $("#apometr .apometr .ui-datepicker-calendar td").each(function() {
                    if ($(this).attr('title')) {
                        $(this).append('<span class="apometr_am">' + $(this).attr('title') + '</span>');
                        $(this).removeAttr('title')
                    }
                });
			},
			dataType: 'json'
		});
    }
    
    $('#apometr .apometr').datepicker({
        firstDay: 1,
        dateFormat: 'dd.mm.yy',
        numberOfMonths: 1,
        showOtherMonths: true,
        selectOtherMonths: true,
        onChangeMonthYear: function(year, month, inst) {
            $('#apometr .date_month').val(year+'-'+(month < 10 ? '0'+month : month)+'-01');
            apometr_ajax();
        },
        beforeShowDay: function (date) {
            var d = date.getDate(), m = date.getMonth()+1, y = date.getFullYear();
            m = (m < 10 ? '0'+m : m);
            d = (d < 10 ? '0'+d : d);
            var fdate = y+'-'+m+'-'+d;
            
            var classes = '';
            var title = '';
            if (apometr_data[fdate]) {
                if (apometr_data[fdate].Am >= 0 && apometr_data[fdate].Am < 1) {
                    // sunny
                    classes = 'weather1';
                } else if (apometr_data[fdate].Am >=1 && apometr_data[fdate].Am < 2) {
                    // 1/2 sunny
                    classes = 'weather2';
                } else if (apometr_data[fdate].Am >=2 && apometr_data[fdate].Am < 4) {
                    // 1rain
                    classes = 'weather3';
                } else if (apometr_data[fdate].Am >=4 && apometr_data[fdate].Am < 6) {
                    // 3rain
                    classes = 'weather4';
                } else if (apometr_data[fdate].Am >=6 && apometr_data[fdate].Am < 9) {
                    // 1cloud&lightning
                    classes = 'weather5';
                } else if (apometr_data[fdate].Am >=9) {
                    // 2cloud&lightning
                    classes = 'weather6';
                }
                if (apometr_data[fdate].is_update != 0) {
                    classes += ' update_green';
                }
                if (apometr_data[fdate].is_update_text != 0) {
                    classes += ' update_red';
                }
                title = apometr_data[fdate].Am;
            }
            return [false, classes, title];
        }
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
    {/literal}
    {/if}
    {literal}
    

	
	// Выделить все
	$("#check_all").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', $('#list input[type="checkbox"][name*="check"]:not(:checked)').length>0);
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
		if($('#list input[type="checkbox"][name*="check"]:checked').length>0)
			if($('select[name="action"]').val()=='delete' && !confirm('Подтвердите удаление'))
				return false;	
	});
 	
});
</script>
{/literal}
