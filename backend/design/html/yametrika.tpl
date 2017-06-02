{* Title *}
{$meta_title = "Яндекс.Метрика" scope=parent}

{*Название страницы*}
<div class="row">
    <div class="col-lg-7 col-md-7">
        <div class="heading_page">Яндекс.Метрика для сайта</div>
    </div>
    <div class="col-lg-5 col-md-5 float-xs-right"></div>
</div>

{*Вывод ошибок*}
{if !$settings->yandex_metrika_app_id || !$settings->yandex_metrika_token}
    <div class="row">
        <div class="col-lg-12 col-md-12 col-sm-12">
            <div class="boxed boxed_warning">
                <div class="heading_box">
                   Заполните поля (ID приложения) и/или (Токен) в настройках магазина
                </div>
            </div>
        </div>
    </div>
{/if}

{*Вывод успешных сообщений*}
{if $message_success}
    <div class="row">
        <div class="col-lg-12 col-md-12 col-sm-12">
            <div class="boxed boxed_success">
                <div class="heading_box">
                    {if $message_success == 'saved'}
                        Настройки сохранены
                    {/if}
                    {if $smarty.get.return}
                        <a class="btn btn_return float-xs-right" href="{$smarty.get.return}">
                            {include file='svg_icon.tpl' svgId='return'}
                            <span>Вернуться</span>
                        </a>
                    {/if}
                </div>
            </div>
        </div>
    </div>
{/if}

{*Главная форма страницы*}
<form method="post" enctype="multipart/form-data">
    <input type=hidden name="session_id" value="{$smarty.session.id}">

    <div class="row">
        <div class="col-lg-12 col-md-12">
            <div class="boxed fn_toggle_wrap">
                <div class="heading_box">
                    Настройка Yandex метрики для админ панели
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="fa fn_icon_arrow fa-angle-down"></i></a>
                    </div>
                </div>
                <div class="toggle_body_wrap on fn_card">
                    <div class="boxed boxed_attention">
                        <div class="mt-0">
                            <div class="ya_metrica_helper">
                                <div class="heading_box">Подключение статистики яндекс метрики к административной части OkayCMS</div>
                                <ul class="text_box">
                                    <li>
                                        Шаг 1. Необходимо зайти на ссылку <a target="_blank" href="https://oauth.yandex.ru">https://oauth.yandex.ru</a>
                                    </li>
                                    <li>
                                        Шаг 2. Нажать кнопку «Зарегистрировать приложение»
                                    </li>

                                    <li>
                                        Шаг 3. Ввести следующие данные:<br>
                                        <b>Название:</b> YandexMetrikaAPI<br>
                                        <b>Описание:</b> Приложение для доступа к API метрики с OkayCMS<br>
                                        <b>Иконка:</b> Пусто<br>
                                        <b>Ссылка на сайт приложения:</b> Пусто<br>
                                        <b>Права:</b> Выбираем пункт Яндекс.Метрика и отмечаем галочкой
                                        Получение статистики, чтение параметров своих и доверенных счётчиков<br>
                                        <b>Callback URL:</b> https://oauth.yandex.ru/verification_code
                                    </li>
                                    <li>
                                        Шаг 4. Нажимаем «Сохранить»
                                    </li>
                                    <li>
                                        Шаг 5. На открывшейся странице копируем ID приложения и сохраняем его в настройках Яндекс
                                        Метрики в административной части
                                    </li>
                                    <li>
                                        Шаг 6. Авторизуемся на Яндексе под учетной записью пользователя, от имени которого будет
                                        работать приложение
                                    </li>
                                    <li>
                                        Шаг 7. Переходим по URL:
                                        <a target="_blank" href="https://oauth.yandex.ru/authorize?response_type=token&amp;client_id=&lt;идентификатор приложения&gt;">https://oauth.yandex.ru/authorize?response_type=token&amp;client_id=
                                            &lt;идентификатор приложения&gt;
                                        </a>
                                        ,где   <b>&lt;идентификатор приложения&gt;</b> - ранее полученный ID
                                        <br>
                                        <i><b>
                                                Пример:
                                                https://oauth.yandex.ru/authorize?response_type=token&amp;client_id=
                                                a4e35e82346a4264abdaa54aff04a143
                                            </b></i>
                                    </li>
                                    <li>
                                        Шаг 8. Приложение запросит разрешение на доступ, которое нужно предоставить, нажав «Разрешить»
                                    </li>
                                    <li>
                                        Шаг 9 . Сохранить полученный токен в настройки Яндекс Метрики, в административную часть на
                                        сайте.
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="heading_label">ID приложения</div>
                            <div class="mb-1">
                                <input name="yandex_metrika_app_id" class="form-control" type="text" value="{$settings->yandex_metrika_app_id|escape}" />
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="heading_label">Токен</div>
                            <div class="mb-1">
                                <input name="yandex_metrika_token" class="form-control" type="text" value="{$settings->yandex_metrika_token|escape}" />
                            </div>
                        </div>
                    </div>
                    <div class="row">
                       <div class="col-lg-12 col-md-12 ">
                            <button type="submit" class="btn btn_small btn_blue float-md-right">
                                {include file='svg_icon.tpl' svgId='checked'}
                                <span>Применить</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    {*Блок фильтров*}
    {if $settings->yandex_metrika_app_id && $settings->yandex_metrika_token}
        <div class="row">
            <div class="col-lg-12 col-md-12">
                <div class="boxed fn_toggle_wrap">
                    <div class="row">
                        <div class="col-lg-4 col-md-12">
                            <div class="heading_label">Статистика</div>
                            <div class="">
                                <select id="period_selector" name="period" class="selectpicker form-control">
                                      <option value="{$smarty.now|date_format:"%Y%m%d"}">За сегодня</option> <!-- today -->
                                      <option value="{"-1 day"|date_format:"%Y%m%d"}">За вчера</option> <!-- yesterday -->
                                      <option value="{"-7 days"|date_format:"%Y%m%d"}">За неделю</option> <!-- week -->
                                      <option value="{"-1 month"|date_format:"%Y%m%d"}">За месяц</option> <!-- month -->
                                      <option value="{"-3 month"|date_format:"%Y%m%d"}">За квартал</option> <!-- quarter -->
                                      <option value="{"-1 year"|date_format:"%Y%m%d"}">За год</option> <!-- year -->
                                </select>
                                <div class="row">
                                   <div class="col-lg-12 col-md-12 mt-1">
                                         <input class="btn btn_small btn_blue float-md-right" id="show_statistic" type="button" onclick="getCallback()" value="Отобразить" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-8 col-md-12">
                            <div class="heading_label">График</div>
                            <div id="container" class="boxed" style="width: 100%; height: 800px;"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    {/if}
</form>


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
