{* Вкладки *}
{capture name=tabs}
    {if in_array('products', $manager->permissions)}
        <li>
            <a href="index.php?module=ProductsAdmin">Товары</a>
        </li>
    {/if}
    {if in_array('categories', $manager->permissions)}
        <li>
            <a href="index.php?module=CategoriesAdmin">Категории</a>
        </li>
    {/if}
    {if in_array('brands', $manager->permissions)}
        <li>
            <a href="index.php?module=BrandsAdmin">Бренды</a>
        </li>
    {/if}
    <li class="active">
        <a href="index.php?module=FeaturesAdmin">Свойства</a>
    </li>
    {if in_array('special', $manager->permissions)}
        <li>
            <a href="index.php?module=SpecialAdmin">Промо-изображения</a>
        </li>
    {/if}
{/capture}

{if $feature->id}
    {$meta_title = $feature->name scope=parent}
{else}
    {$meta_title = 'Новое свойство' scope=parent}
{/if}
<script src="design/js/sumoselect/jquery.sumoselect.js"></script>
<link rel="stylesheet" type="text/css" href="design/js/sumoselect/sumoselect.css" media="screen" />
{* On document load *}
{literal}
<script>
$(function() {
    $('.multiple_categories').SumoSelect({selectAll: true});
    
    $('input[name="name"]').keyup(function() {
        if(!$('#block_translit').is(':checked')) {
            $('input[name="url"]').val(generate_url());
        }
    });
    
});

function generate_url() {
    url = $('input[name="name"]').val();
    url = url.replace(/[\s-_]+/gi, '');
    url = translit(url);
    url = url.replace(/[^0-9a-z\-]+/gi, '').toLowerCase();	
    return url;
}

function translit(str) {
    var ru=("А-а-Б-б-В-в-Ґ-ґ-Г-г-Д-д-Е-е-Ё-ё-Є-є-Ж-ж-З-з-И-и-І-і-Ї-ї-Й-й-К-к-Л-л-М-м-Н-н-О-о-П-п-Р-р-С-с-Т-т-У-у-Ф-ф-Х-х-Ц-ц-Ч-ч-Ш-ш-Щ-щ-Ъ-ъ-Ы-ы-Ь-ь-Э-э-Ю-ю-Я-я-'_'").split("-")
    var en=("A-a-B-b-V-v-G-g-G-g-D-d-E-e-E-e-E-e-ZH-zh-Z-z-I-i-I-i-I-i-J-j-K-k-L-l-M-m-N-n-O-o-P-p-R-r-S-s-T-t-U-u-F-f-H-h-TS-ts-CH-ch-SH-sh-SCH-sch-'-'-Y-y-'-'-E-e-YU-yu-YA-ya-''").split("-")
    var res = '';
    for(var i=0, l=str.length; i<l; i++) {
        var s = str.charAt(i), n = ru.indexOf(s);
        if(n >= 0) { res += en[n]; }
        else { res += s; }
    }
    return res;
}

</script>
{/literal}

<div id="compact_languages_block">
    <div class="helper_wrap" style="margin-left: -6px">
        <a class="top_help" id="show_help_search" href="https://www.youtube.com/watch?v=eATslZw5RxI" target="_blank"></a>
        <div class="right helper_block topvisor_help">
            <p>Видеоинструкция по разделу</p>
        </div>
    </div>

    {if $languages}{include file='include_languages.tpl'}{/if}
</div>

{if $message_success}
    <div class="message message_success">
        <span class="text">{if $message_success=='added'}Свойство добавлено{elseif $message_success=='updated'}Свойство обновлено{else}{$message_success}{/if}</span>
        {if $smarty.get.return}
        <a class="button" href="{$smarty.get.return}">Вернуться</a>
        {/if}
    </div>
{/if}

{if $message_error}
    <div class="message message_error">
        <span class="text">{if $message_error=='empty_name'}Введите название{else}{$message_error}{/if}</span>
        <a class="button" href="">Вернуться</a>
    </div>
{/if}

<form method=post id=product>
    <input type="hidden" name="lang_id" value="{$lang_id}" />
    <div id="name">
        <input class="name" name=name type="text" value="{$feature->name|escape}"/>
        <input name=id type="hidden" value="{$feature->id|escape}"/>
        <div class="checkbox">
            <input name="yandex" value="1" type="checkbox" id="yandex_checkbox" {if $feature->yandex}checked=""{/if}/>
            <label for="yandex_checkbox">В Я.Маркет</label>
        </div>
    </div>

    <div id="column_left">
        <div class="block layer">
            <h2>Идентификаторы для описаний в категориях
                <div class="helper_wrap">
                    <a href="javascript:;" id="show_help_search" class="helper_link"></a>
                    <div class="right helper_block">
                        <span>
                         Используются в категориях при автоматическом формировании мета данных товаров
                        </span>
                    </div>
                </div>
            </h2>
            <ul>
                <li>
                    <label class="property">ID свойства</label>
                    <input name="auto_name_id" class="okay_inp" type="text" value="{$feature->auto_name_id|escape}"/>
                </li>
                <li>
                    <label class="property">ID значения</label>
                    <input name="auto_value_id" class="okay_inp" type="text" value="{$feature->auto_value_id|escape}"/>
                </li>
            </ul>
        </div>

        <div class="block">
            <h2>Использовать в категориях
                <div class="helper_wrap">
                    <a href="javascript:;" id="show_help_search" class="helper_link"></a>
                    <div class="right helper_block">
                        <span>
                            Чекбоксами отмечается в каких категориях будет использоваться данное свойство
                        </span>
                    </div>
                </div>
            </h2>
            <h3 class="warning_icon">При снятии отметки с категории все значения этого свойства в этой категории будут удалены безвозвратно!</h3>
            <select class=multiple_categories multiple name="feature_categories[]">
                {function name=category_select selected_id=$product_category level=0}
                    {foreach $categories as $category}
                        <option value='{$category->id}' {if in_array($category->id, $feature_categories)}selected{/if} category_name='{$category->single_name}'>{section name=sp loop=$level}&nbsp;&nbsp;&nbsp;&nbsp;{/section}{$category->name}</option>
                        {category_select categories=$category->subcategories selected_id=$selected_id  level=$level+1}
                    {/foreach}
                {/function}
                {category_select categories=$categories}
            </select>
        </div>

    </div>
    <div id="column_right">
        <div class="block">
            <h2>Настройки свойства</h2>
            <ul>
                <li>
                    <label class="property" for="block_translit">Заблокировать авто генерацию ссылки</label>
                    <input type="checkbox" id="block_translit" {if $feature->id}checked=""{/if} />
                </li>
                <li>
                    <label for="url">url</label>
                    <input type="text" name="url" id="url" value="{$feature->url}"/>
                    <div class="helper_wrap">
                        <a href="javascript:;" id="show_help_search" class="helper_link"></a>
                        <div class="helper_block">
                            <span>
                            Используется при формиировании URL после применения фильтра
                            </span>
                        </div>
                    </div>
                </li>
                <li>
                    <input type=checkbox name=in_filter id=in_filter {if $feature->in_filter}checked{/if} value="1">
                    <label for=in_filter>Использовать в фильтре</label>
                </li>
            </ul>
        </div>
        <input type=hidden name='session_id' value='{$smarty.session.id}'>
        <input class="button_green" type="submit" name="" value="Сохранить"/>
    </div>
</form>

