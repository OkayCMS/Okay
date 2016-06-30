{capture name=tabs}
    <li class="active">
        <a href="index.php?module=SettingsAdmin">Настройки</a>
    </li>
    {if in_array('currency', $manager->permissions)}
        <li>
            <a href="index.php?module=CurrencyAdmin">Валюты</a>
        </li>
    {/if}
    {if in_array('delivery', $manager->permissions)}
        <li>
            <a href="index.php?module=DeliveriesAdmin">Доставка</a>
        </li>
    {/if}
    {if in_array('payment', $manager->permissions)}
        <li>
            <a href="index.php?module=PaymentMethodsAdmin">Оплата</a>
        </li>
    {/if}
    {if in_array('managers', $manager->permissions)}
        <li>
            <a href="index.php?module=ManagersAdmin">Менеджеры</a>
        </li>
    {/if}
    {if in_array('languages', $manager->permissions)}
        <li>
            <a href="index.php?module=LanguagesAdmin">Языки</a>
        </li>
    {/if}
    {if in_array('languages', $manager->permissions)}
        <li>
            <a href="index.php?module=TranslationsAdmin">Переводы</a>
        </li>
    {/if}
{/capture}
 
{$meta_title = "Настройки" scope=parent}

{if $message_success}
    <div class="message message_success">
        <span class="text">{if $message_success == 'saved'}Настройки сохранены{/if}</span>
        {if $smarty.get.return}
        <a class="button" href="{$smarty.get.return}">Вернуться</a>
        {/if}
    </div>
{/if}

{if $message_error}
    <div class="message message_error">
        <span class="text">
            {if $message_error == 'watermark_is_not_writable'}
                Установите права на запись для файла {$config->watermark_file}
            {/if}
        </span>
        <a class="button" href="">Вернуться</a>
    </div>
{/if}

<form method=post id=product enctype="multipart/form-data">
    <input type=hidden name="session_id" value="{$smarty.session.id}">
    <div class="block">
        <h2>Настройки сайта</h2>
        <ul>
            <li><label class=property>Имя сайта</label><input name="site_name" class="okay_inp" type="text" value="{$settings->site_name|escape}" /></li>
            <li><label class=property>Имя компании</label><input name="company_name" class="okay_inp" type="text" value="{$settings->company_name|escape}" /></li>
            <li><label class=property>Формат даты</label><input name="date_format" class="okay_inp" type="text" value="{$settings->date_format|escape}" /></li>
            <li><label class=property>Email для восстановления пароля</label><input name="admin_email" class="okay_inp" type="text" value="{$settings->admin_email|escape}" /></li>
            <li>
                <label class=property>Выключение сайта</label>
                <select name="site_work">
                    <option value="on" {if $settings->site_work == "on"}selected{/if}>Включен</option>
                    <option value="off" {if $settings->site_work == "off"}selected{/if}>Выключен</option>
                </select>
            </li>
            <li>
                <label class=property>Техническое сообщение</label>
                <textarea name="site_annotation" class="okay_inp">{$settings->site_annotation|escape}</textarea>
            </li>
        </ul>
    </div>
    <div class="block layer">
        <h2>Оповещения</h2>
        <ul>
            <li><label class=property>Оповещение о заказах</label><input name="order_email" class="okay_inp" type="text" value="{$settings->order_email|escape}" /></li>
            <li><label class=property>Оповещение о комментариях</label><input name="comment_email" class="okay_inp" type="text" value="{$settings->comment_email|escape}" /></li>
            <li><label class=property>Обратный адрес оповещений</label><input name="notify_from_email" class="okay_inp" type="text" value="{$settings->notify_from_email|escape}" /></li>
            <li><label class=property>Имя отправителя письма</label><input name="notify_from_name" class="okay_inp" type="text" value="{$settings->notify_from_name|escape}" /></li>
        </ul>
    </div>
    <div class="block layer">
        <h2>Капча вкл./выкл.</h2>
        <ul>
            <li><label class=property for="captcha_product">В товаре</label><input id="captcha_product" name="captcha_product" class="okay_inp" type="checkbox" value="1" {if $settings->captcha_product}checked=""{/if} /></li>
            <li><label class=property for="captcha_post">В статье блога</label><input id="captcha_post" name="captcha_post" class="okay_inp" type="checkbox" value="1" {if $settings->captcha_post}checked=""{/if} /></li>
            <li><label class=property for="captcha_cart">В корзине</label><input id="captcha_cart" name="captcha_cart" class="okay_inp" type="checkbox" value="1" {if $settings->captcha_cart}checked=""{/if} /></li>
            <li><label class=property for="captcha_register">В форме регистрации</label><input id="captcha_register" name="captcha_register" class="okay_inp" type="checkbox" value="1" {if $settings->captcha_register}checked=""{/if} /></li>
            <li><label class=property for="captcha_feedback">В форме обратной связи</label><input id="captcha_feedback" name="captcha_feedback" class="okay_inp" type="checkbox" value="1" {if $settings->captcha_feedback}checked=""{/if} /></li>
        </ul>
    </div>

    <div class="block layer">
        <h2>Формат цены</h2>
        <ul>
            <li><label class=property>Разделитель копеек</label>
                <select name="decimals_point" class="okay_inp">
                    <option value='.' {if $settings->decimals_point == '.'}selected{/if}>точка: 12.45 {$currency->sign|escape}</option>
                    <option value=',' {if $settings->decimals_point == ','}selected{/if}>запятая: 12,45 {$currency->sign|escape}</option>
                </select>
            </li>
            <li><label class=property>Разделитель тысяч</label>
                <select name="thousands_separator" class="okay_inp">
                    <option value='' {if $settings->thousands_separator == ''}selected{/if}>без разделителя: 1245678 {$currency->sign|escape}</option>
                    <option value=' ' {if $settings->thousands_separator == ' '}selected{/if}>пробел: 1 245 678 {$currency->sign|escape}</option>
                    <option value=',' {if $settings->thousands_separator == ','}selected{/if}>запятая: 1,245,678 {$currency->sign|escape}</option>
                </select>
            </li>
        </ul>
    </div>

    <div class="block layer">
        <h2>Настройки каталога</h2>
        <ul>
            <li><label class=property>Товаров на странице сайта</label><input name="products_num" class="okay_inp" type="text" value="{$settings->products_num|escape}" /></li>
            <li><label class=property>Максимум товаров в заказе</label><input name="max_order_amount" class="okay_inp" type="text" value="{$settings->max_order_amount|escape}" /></li>
            <li><label class=property>Единицы измерения товаров</label><input name="units" class="okay_inp" type="text" value="{$settings->units|escape}" /></li>
            <li><label class="property">Максимальное количество товаров в папке сравнения</label><input name="comparison_count" class="okay_inp" type="text" value="{$settings->comparison_count|escape}" /></li>
            <li><label class="property">Статей на странице блога</label><input name="posts_num" class="okay_inp" type="text" value="{$settings->posts_num|escape}" /></li>
            <li>
                <label class="property">Если нет в наличии
                    <div class="helper_wrap">
                        <a href="javascript:;" id="show_help_search" class="helper_link"></a>
                        <div class="right helper_block">
                        <span>
                            Выберите что происходит с товарами которых нет на складе.
                            Или они доступны под заказ, или отображаются что их нет в наличии
                        </span>
                        </div>
                    </div>
                </label>
                <select name="is_preorder">
                    <option value="0" {if $settings->is_preorder == 0} selected=""{/if}>Нет на складе</option>
                    <option value="1" {if $settings->is_preorder == 1} selected=""{/if}>Предзаказ</option>
                </select>
            </li>
        </ul>
    </div>

    <div class="block layer">
        <h2>Настройки 1C</h2>
        <ul>
            <li><label class=property>Логин</label><input name="login_1c" class="okay_inp" type="text" value="{$login_1c|escape}" /></li>
            <li><label class=property>Пароль</label><input name="pass_1c" class="okay_inp" type="text" value="" /></li>
        </ul>
    </div>

    <div class="block layer">
        <h2>Изображения товаров</h2>
        <ul>
            <li><label class=property>Водяной знак</label>
            <input name="watermark_file" class="okay_inp" type="file" />

            <img style='display:block; border:1px solid #d0d0d0; margin:10px 0 10px 0;' src="{$config->root_url}/{$config->watermark_file}?{math equation='rand(10,10000)'}">
            </li>
            <li><label class=property>Горизонтальное положение водяного знака</label><input name="watermark_offset_x" class="okay_inp" type="text" value="{$settings->watermark_offset_x|escape}" /> %</li>
            <li><label class=property>Вертикальное положение водяного знака</label><input name="watermark_offset_y" class="okay_inp" type="text" value="{$settings->watermark_offset_y|escape}" /> %</li>
            <li><label class=property>Прозрачность знака (больше &mdash; прозрачней)</label><input name="watermark_transparency" class="okay_inp" type="text" value="{$settings->watermark_transparency|escape}" /> %</li>
            <li><label class=property>Резкость изображений (рекомендуется 20%)</label><input name="images_sharpen" class="okay_inp" type="text" value="{$settings->images_sharpen|escape}" /> %</li>
        </ul>
    </div>

    <div class="block layer">
        <h2>
            Настройки экспорта в яндекс
            <div class="helper_wrap" style="margin-left: 5px; margin-top: -8px;">
                <a class="top_help" id="show_help_search" href="https://www.youtube.com/watch?v=9eO8CsSvfqg" target="_blank"></a>
                <div class="right helper_block topvisor_help">
                    <p>Видеоинструкция по данному функционалу</p>
                </div>
            </div>
        </h2>
        <ul class="yandex_list">
            <li>
                <label class="property" for="yandex_export_not_in_stock">Экспортировать со статусом "под заказ" товары, отсутствующие на складе</label>
                <input id="yandex_export_not_in_stock" name="yandex_export_not_in_stock" class="okay_inp" type="checkbox" {if $settings->yandex_export_not_in_stock}checked=""{/if} />
            </li>
            <li>
                <label class="property" for="yandex_available_for_retail_store">Можно купить в розничном магазине</label>
                <input id="yandex_available_for_retail_store" name="yandex_available_for_retail_store" class="okay_inp" type="checkbox" {if $settings->yandex_available_for_retail_store}checked=""{/if} />
            </li>
            <li>
                <label class="property" for="yandex_available_for_reservation">Можно зарезервировать выбранный товар и забрать его самостоятельно.</label>
                <input id="yandex_available_for_reservation" name="yandex_available_for_reservation" class="okay_inp" type="checkbox" {if $settings->yandex_available_for_reservation}checked=""{/if} />
            </li>
            <li>
                <label for="yandex_short_description" class="property">Выводить в ЯндексМаркет краткое или полное описание товара(0-краткое, 1-полное)</label>
                <input id="yandex_short_description" name="yandex_short_description" class="okay_inp" type="checkbox" {if $settings->yandex_short_description}checked=""{/if} />
            </li>
            <li>
                <label class="property" for="yandex_has_manufacturer_warranty">У товаров есть гарантия производителя</label>
                <input id="yandex_has_manufacturer_warranty" name="yandex_has_manufacturer_warranty" class="okay_inp" type="checkbox" {if $settings->yandex_has_manufacturer_warranty}checked=""{/if} />
            </li>
            <li>
                <label class="property" for="yandex_has_seller_warranty">У товаров есть гарантия продавца</label>
                <input id="yandex_has_seller_warranty" name="yandex_has_seller_warranty" class="okay_inp" type="checkbox" {if $settings->yandex_has_seller_warranty}checked=""{/if} />
            </li>
                <label class="property" for="yandex_sales_notes">sales notes
                    <div class="helper_wrap">
                        <a href="javascript:;" id="show_help_search" class="helper_link"></a>
                        <div class="right helper_bottom helper_block" style="width: 446px;">
                            <span>
                                <b>Используйте элемент sales_notes для указания следующей информации:</b>
                                    <ol style="list-style: decimal">
                                        <li>минимальная сумма заказа (указание элемента обязательно);</li>
                                        <li>минимальная партия товара (указание элемента обязательно);</li>
                                        <li>необходимость предоплаты (указание элемента обязательно);</li>
                                        <li>варианты оплаты (указание элемента необязательно);</li>
                                        <li>условия акции (указание элемента необязательно).</li>
                                    </ol>
                                    Допустимая длина текста в элементе — 50 символов.
                            </span>
                        </div>
                    </div>
                </label>
                <input id="yandex_sales_notes" name="yandex_sales_notes" class="okay_inp" type="text" value="{$settings->yandex_sales_notes}" />
            </li>
        </ul>
    </div>


    <div class="block layer">
        <h2>Настройка Google аналитики
            <div class="helper_wrap">
                <a href="javascript:;" id="show_help_search" class="helper_link"></a>
                <div class="right helper_bottom helper_block" style="width: 446px;">
                    <span>
                        <b>Google Analytics ID</b> - прописывается ID счетчика, в формате (UA-xxxxxxxx-x)
                        <b>Google Webmaster</b> - прописывается только содержимое атрибута content (786f3d0f736b732c)
                        <br>пример: <br>meta name='google-site-verification' content='<i style="font-weight: bold">786f3d0f736b732c</i>'
                    </span>
                </div>
            </div>
        </h2>
        <ul>
            <li>
                <label class="property">Google Analytics ID</label>
                <input type="text" name="g_analytics" value="{$settings->g_analytics}" class="okay_inp">
            </li>
            <li>
                <label class="property">Google Webmaster</label>
                <input type="text" name="g_webmaster" value="{$settings->g_webmaster}" class="okay_inp">
            </li>
        </ul>
    </div>

    <div class="block layer">
        <h2>Яндекс метрика
            <div class="helper_wrap">
                <a href="javascript:;" id="show_help_search" class="helper_link"></a>
                <div class="right helper_bottom helper_block" style="width: 446px;">
                    <span>
                        <b>Yandex метрика</b> - прописывается числовой код метрики (ID)
                        <b>Yandex вебмастер</b> - прописывается только содержимое атрибута content (786f3d0f736b732c)
                        <br>пример: <br>meta name='yandex-verification' content='<i style="font-weight: bold">786f3d0f736b732c</i>'

                    </span>
                </div>
            </div>
            <div class="helper_wrap" style="margin-left: 5px; margin-top: -8px;">
                <a class="top_help" id="show_help_search" href="https://www.youtube.com/watch?v=8IVMhLKSMKA" target="_blank"></a>
                <div class="right helper_block topvisor_help">
                    <p>Видеоинструкция по данному функционалу</p>
                </div>
            </div>
        </h2>
        <ul>
            <li>
                <label class=property>ID приложения</label>
                <input name="yandex_metrika_app_id" class="okay_inp" type="text" value="{$settings->yandex_metrika_app_id|escape}" />
            </li>
            <li>
                <label class=property>Токен</label>
                <input name="yandex_metrika_token" class="okay_inp" type="text" value="{$settings->yandex_metrika_token|escape}" />
            </li>
            <li>
                <label class=property>ID счётчика</label>
                <input name="yandex_metrika_counter_id" class="okay_inp" type="text" value="{$settings->yandex_metrika_counter_id|escape}" />
            </li>
            <li>
                <label class="property">Yandex вебмастер</label>
                <input type="text" name="y_webmaster" value="{$settings->y_webmaster}" class="okay_inp">
            </li>
        </ul>
        <div>
            <h4 class="fn-helper">Инструкция по настройке поключения Я.Метрики &#8659;</h4>
            <div class="ya_metrica_helper" style="display: none;">
                <p>Подключение статистики яндекс метрики к административной части OkayCMS</p>
                <ul>
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
                        <a target="_blank" href="https://oauth.yandex.ru/authorize?response_type=token&client_id=<идентификатор приложения>">https://oauth.yandex.ru/authorize?response_type=token&client_id=
                            <идентификатор приложения>
                        </a>
                         ,где   <b><идентификатор приложения></b> - ранее полученный ID
                        <br>
                        <i><b>
                            Пример:
                            https://oauth.yandex.ru/authorize?response_type=token&client_id=
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

    <input class="button_green button_save" type="submit" name="save" value="Сохранить" />
</form>

<script>
    $(window).on('load',function(){
        $('.fn-helper').on('click',function(){
           $(this).next().slideToggle(500);
        });
    })
</script>
