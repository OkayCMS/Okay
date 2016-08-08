{capture name=tabs}
    <li>
        <a href="{url module=StatsAdmin}">Статистика</a>
    </li>
    {*statistic*}
    <li>
        <a href="{url module=ReportStatsAdmin filter=null status=null}">Отчет о продажах</a>
    </li>
    <li>
        <a href="{url module=CategoryStatsAdmin category=null brand=null supplier=null date_from=null date_to=null}">Категоризация продаж</a>
    </li>
    {*statistic*}
	{if in_array('yametrika', $manager->permissions)}
        <li class="active">
            <a href="index.php?module=YametrikaAdmin">Яндекс.Метрика</a>
        </li>
    {/if}
{/capture}

{* Title *}
{$meta_title = "Яндекс.Метрика" scope=parent}

{literal}
<script src="design/js/amcharts/amcharts.js" type="text/javascript"></script>
<script src="design/js/amcharts/serial.js" type="text/javascript"></script>
<script>

	var chart;

	$(document).ready(function() {
		getCallback();
	});
	
	function getCallback()
	{
		var link2PHP = "ajax/metrika.php";
		var period = $("#period_selector").val();
		var counter = [];
			$.ajax ({
				type: "GET",
				url:link2PHP,
				data: { periodfor: period },
				dataType: "jsonp",
				async: false,
				jsonp: "callback",
				jsonpCallback: 'jsonCallback2',
				contentType: "application/json",
				success: function(json) {
					$.each(json.data.reverse(), function (index,value){
                        var data = value.date[6]+value.date[7] + '-'+ value.date[4]+value.date[5]+'-'+value.date[2]+ value.date[3];
						var metrika = {
							'date2': data,
							'visits2': value.visits,  /*Визиты*/
							'visitors2': value.visitors,  /*Посетители*/
							'page_views': value.page_views,  /*Просмотры*/
							'new_visitors': value.new_visitors, /*Новые посетители*/
							'denial': value.denial /*Отказы*/
						};
						counter.push(metrika);
						console.log(metrika);
					});
				},
				error: function (xhr, ajaxOptions, thrownError) {
					console.log(xhr.status);
					console.log(thrownError);
				}
			});
			initChart(counter);
	}
	
	function initChart(json)
	{
		var chart = AmCharts.makeChart("container", {
				"pathToImages": "design/js/amcharts/images/",
				"type": "serial",
				"theme": "light",
				"dataDateFormat": "DD:MM:YY",
				"language": "ru",
				"titles": [{
					"text": "Я.Метрика",
					"size": 15
				}],
				"legend": {
					"equalWidths": true,
					"useGraphSettings": true,
					"valueAlign": "right",
					"valueWidth": 120

				},
				"valueAxes": [ {
					"id": "visitsAxis",
					"axisAlpha": 0,
					"gridAlpha": 0,
					"labelsEnabled": false,
					"position": "left"
				}, {
					"id": "visitorsAxis",
					"axisAlpha": 0,
					"gridAlpha": 0,
					"inside": false,
					"position": "right",
					"title": "Количество"
				}],
				"graphs": [  {
					"bullet": "round",
					"bulletBorderAlpha": 1,
					"balloonText": "Посетителей:[[value]]",

					"legendPeriodValueText": "Всего: [[value.sum]]",
					"legendValueText": "[[value]]",
					"title": "Посетителей",
					"fillAlphas": 0.6,
					"valueField": "visitors2",
					"valueAxis": "visitorsAxis"
				},
				{
					"balloonText": "Посещений:[[value]]",
					"bullet": "round",
					"bulletBorderAlpha": 1,
					"useLineColorForBulletBorder": true,
					"bulletColor": "#FFFFFF",
					"bulletSizeField": "townSize",
					"dashLengthField": "dashLength",

					"labelPosition": "right",
					"legendPeriodValueText": "Всего: [[value.sum]]",
					"legendValueText": "[[value]]",
					"title": "Посещений",
					"fillAlphas": 0,
					"valueField": "visits2",
					"valueAxis": "visitorsAxis"
				},
				{
					"balloonText": "Просмотры страниц:[[value]]",
					"bullet": "round",
					"bulletBorderAlpha": 1,
					"useLineColorForBulletBorder": true,
					"bulletColor": "#FFFFFF",
					"bulletSizeField": "townSize",
					"dashLengthField": "dashLength",

					"labelPosition": "right",
					"legendPeriodValueText": "Всего: [[value.sum]]",
					"legendValueText": "[[value]]",
					"title": "Просмотров",
					"fillAlphas": 0,
					"valueField": "page_views",
					"valueAxis": "visitorsAxis"
				},
				{
					"balloonText": "Новые посетители:[[value]]",
					"bullet": "round",
					"bulletBorderAlpha": 1,
					"useLineColorForBulletBorder": true,
					"bulletColor": "#FFFFFF",
					"bulletSizeField": "townSize",
					"dashLengthField": "dashLength",

					"labelPosition": "right",
					"legendPeriodValueText": "Всего: [[value.sum]]",
					"legendValueText": "[[value]]",
					"title": "Новых посетителей",
					"fillAlphas": 0,
					"valueField": "new_visitors",
					"valueAxis": "visitorsAxis"
				},
				{
					"balloonText": "Отказы:[[value]]",
					"bullet": "round",
					"bulletBorderAlpha": 1,
					"useLineColorForBulletBorder": true,
					"bulletColor": "#FFFFFF",
					"bulletSizeField": "townSize",
					"dashLengthField": "dashLength",

					"labelPosition": "right",
					"legendPeriodValueText": "Всего: [[value.sum]]",
					"legendValueText": "[[value]]",
					"title": "Отказов",
					"fillAlphas": 0,
					"valueField": "denial",
					"valueAxis": "visitorsAxis"
				}
				],
				"chartScrollbar": {
				
					"gridCount": 7,
					"scrollbarHeight": 25,
					"graphType": "line",
					"usePeriod": "WW",
					"backgroundColor": "#56b9ff",
					"graphFillColor": "#56b9ff",
					"graphFillAlpha": 0.5,
					"gridColor": "#555",
					"gridAlpha": 1,
					"selectedBackgroundColor": "#444",
					"selectedGraphFillAlpha": 1
				},
				"chartCursor": {
					"categoryBalloonDateFormat": "DD MMM",
					"cursorAlpha": 0.1,
					"cursorColor":"#56b9ff",
					"fullWidth":true,
					"valueBalloonsEnabled": true,
					"zoomable": true
				},
				"dataProvider": json ,
				"dataDateFormat": "DD:MM:YY",
				"categoryField": "date2"
			});
	}
	
		
</script>
{/literal}

{* Заголовок *}
<div id="header">
	<h1>Яндекс.Метрика для сайта</h1> 	
</div>

{if $message_success}
    <!-- Системное сообщение -->
    <div class="message message_success">
        <span class="text">
        {if $message_success == 'saved'}Настройки сохранены{/if}
        </span>
        {if $smarty.get.return}
        <a class="button" href="{$smarty.get.return}">Вернуться</a>
        {/if}
    </div>
    <!-- Системное сообщение (The End)-->
{/if}

<!-- Счетчики -->
    <div class="block layer">
        {if !$settings->yandex_metrika_app_id || !$settings->yandex_metrika_token}
            <h2 style="color: red;">Заполните поля (ID приложения) и/или (Токен) в настройках магазина</h2>
        {/if}
        {if $settings->yandex_metrika_app_id && $settings->yandex_metrika_token}
            <h2>Статистика</h2>
                <select id="period_selector" name="period">
                      <option value="{$smarty.now|date_format:"%Y%m%d"}">За сегодня</option> <!-- today -->
                      <option value="{"-1 day"|date_format:"%Y%m%d"}">За вчера</option> <!-- yesterday -->
                      <option value="{"-7 days"|date_format:"%Y%m%d"}">За неделю</option> <!-- week -->
                      <option value="{"-1 month"|date_format:"%Y%m%d"}">За месяц</option> <!-- month -->
                      <option value="{"-3 month"|date_format:"%Y%m%d"}">За квартал</option> <!-- quarter -->
                      <option value="{"-1 year"|date_format:"%Y%m%d"}">За год</option> <!-- year -->
                </select>
        <input class="button_green" id="show_statistic" type="button" onclick="getCallback()" value="Отобразить" />

        <div>
            <div id="container" style="width: 100%; height: 800px;"></div>
        </div>
        {/if}
    </div>
<!-- @Счетчики -->
		
		