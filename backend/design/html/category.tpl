{* Вкладки *}
{capture name=tabs}
	{if in_array('products', $manager->permissions)}
        <li>
            <a href="index.php?module=ProductsAdmin">Товары</a>
        </li>
    {/if}
	<li class="active">
        <a href="index.php?module=CategoriesAdmin">Категории</a>
    </li>
	{if in_array('brands', $manager->permissions)}
        <li>
            <a href="index.php?module=BrandsAdmin">Бренды</a>
        </li>
    {/if}
	{if in_array('features', $manager->permissions)}
        <li>
            <a href="index.php?module=FeaturesAdmin">Свойства</a>
        </li>
    {/if}
    {if in_array('special', $manager->permissions)}
        <li>
            <a href="index.php?module=SpecialAdmin">Промо-изображения</a>
        </li>
    {/if}
{/capture}

{if $category->id}
    {$meta_title = $category->name scope=parent}
{else}
    {$meta_title = 'Новая категория' scope=parent}
{/if}
{* Подключаем Tiny MCE *}
{include file='tinymce_init.tpl'}
{* On document load *}
{literal}
<script src="design/js/autocomplete/jquery.autocomplete-min.js"></script>
    <style>
        .autocomplete-suggestions{
            width: auto!important;
        }
    </style>
<script>
    $(window).on("load", function() {
        // Удаление изображений
        $(".images a.delete").click( function() {
            $("input[name='delete_image']").val('1');
            $(this).closest("ul").fadeOut(200, function() { $(this).remove(); });
            return false;
        });

        // Автозаполнение мета-тегов
        meta_title_touched = true;
        meta_keywords_touched = true;
        meta_description_touched = true;

        if($('input[name="meta_title"]').val() == generate_meta_title() || $('input[name="meta_title"]').val() == '')
            meta_title_touched = false;
        if($('input[name="meta_keywords"]').val() == generate_meta_keywords() || $('input[name="meta_keywords"]').val() == '')
            meta_keywords_touched = false;
        if($('textarea[name="meta_description"]').val() == generate_meta_description() || $('textarea[name="meta_description"]').val() == '')
            meta_description_touched = false;

        $('input[name="meta_title"]').change(function() { meta_title_touched = true; });
        $('input[name="meta_keywords"]').change(function() { meta_keywords_touched = true; });
        $('textarea[name="meta_description"]').change(function() { meta_description_touched = true; });

        $('input[name="name"]').keyup(function() { set_meta(); });

    });

    function set_meta()
    {
        if(!meta_title_touched)
            $('input[name="meta_title"]').val(generate_meta_title());
        if(!meta_keywords_touched)
            $('input[name="meta_keywords"]').val(generate_meta_keywords());
        if(!meta_description_touched)
            $('textarea[name="meta_description"]').val(generate_meta_description());
        if(!$('#block_translit').is(':checked'))
            $('input[name="url"]').val(generate_url());
    }

    function generate_meta_title()
    {
        name = $('input[name="name"]').val();
        return name;
    }

    function generate_meta_keywords()
    {
        name = $('input[name="name"]').val();
        return name;
    }

    function generate_meta_description()
    {
        if(typeof(tinyMCE.get("annotation")) =='object')
        {
            description = tinyMCE.get("annotation").getContent().replace(/(<([^>]+)>)/ig," ").replace(/(\&nbsp;)/ig," ").replace(/^\s+|\s+$/g, '').substr(0, 512);
            return description;
        }
        else
            return $('textarea[name=annotation]').val().replace(/(<([^>]+)>)/ig," ").replace(/(\&nbsp;)/ig," ").replace(/^\s+|\s+$/g, '').substr(0, 512);
    }

    function generate_url()
    {
        url = $('input[name="name"]').val();
        url = url.replace(/[\s]+/gi, '-');
        url = translit(url);
        url = url.replace(/[^0-9a-z_\-]+/gi, '').toLowerCase();
        return url;
    }

    function translit(str)
    {
        var ru=("А-а-Б-б-В-в-Ґ-ґ-Г-г-Д-д-Е-е-Ё-ё-Є-є-Ж-ж-З-з-И-и-І-і-Ї-ї-Й-й-К-к-Л-л-М-м-Н-н-О-о-П-п-Р-р-С-с-Т-т-У-у-Ф-ф-Х-х-Ц-ц-Ч-ч-Ш-ш-Щ-щ-Ъ-ъ-Ы-ы-Ь-ь-Э-э-Ю-ю-Я-я").split("-")
        var en=("A-a-B-b-V-v-G-g-G-g-D-d-E-e-E-e-E-e-ZH-zh-Z-z-I-i-I-i-I-i-J-j-K-k-L-l-M-m-N-n-O-o-P-p-R-r-S-s-T-t-U-u-F-f-H-h-TS-ts-CH-ch-SH-sh-SCH-sch-'-'-Y-y-'-'-E-e-YU-yu-YA-ya").split("-")
        var res = '';
        for(var i=0, l=str.length; i<l; i++)
        {
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
        <a class="top_help" id="show_help_search" href="https://www.youtube.com/watch?v=pAgDKW7lqmM" target="_blank"></a>
        <div class="right helper_block topvisor_help">
            <p>Видеоинструкция по разделу</p>
        </div>
    </div>

    {if $languages}{include file='include_languages.tpl'}{/if}
</div>

{if $message_success}
    <!-- Системное сообщение -->
    <div class="message message_success">
        <span class="text">{if $message_success=='added'}Категория добавлена{elseif $message_success=='updated'}Категория обновлена{else}{$message_success}{/if}</span>
        <a class="link" target="_blank" href="../{$lang_link}catalog/{$category->url}">Открыть категорию на сайте</a>
        {if $smarty.get.return}
        <a class="button" href="{$smarty.get.return}">Вернуться</a>
        {/if}
        <span class="share">
            <a href="#" onClick='window.open("http://vkontakte.ru/share.php?url={$config->root_url|urlencode}/catalog/{$category->url|urlencode}&title={$category->name|urlencode}&description={$category->description|urlencode}&image={$config->root_url|urlencode}/files/categories/{$category->image|urlencode}&noparse=true","displayWindow","width=700,height=400,left=250,top=170,status=no,toolbar=no,menubar=no");return false;'>
            <img src="{$config->root_url}/backend/design/images/vk_icon.png" /></a>
            <a href="#" onClick='window.open("http://www.facebook.com/sharer.php?u={$config->root_url|urlencode}/catalog/{$category->url|urlencode}","displayWindow","width=700,height=400,left=250,top=170,status=no,toolbar=no,menubar=no");return false;'>
            <img src="{$config->root_url}/backend/design/images/facebook_icon.png" /></a>
            <a href="#" onClick='window.open("http://twitter.com/share?text={$category->name|urlencode}&url={$config->root_url|urlencode}/catalog/{$category->url|urlencode}&hashtags={$category->meta_keywords|replace:' ':''|urlencode}","displayWindow","width=700,height=400,left=250,top=170,status=no,toolbar=no,menubar=no");return false;'>
            <img src="{$config->root_url}/backend/design/images/twitter_icon.png" /></a>
        </span>
    </div>
    <!-- Системное сообщение (The End)-->
{/if}

{if $message_error}
    <!-- Системное сообщение -->
    <div class="message message_error">
        <span class="text">{if $message_error=='url_exists'}Категория с таким адресом уже существует{elseif $message_error == 'empty_name'}Введите название{elseif $message_error == 'empty_url'}Введите адрес{elseif $message_error == 'url_wrong'}Адрес не должен начинаться или заканчиваться символом '-'{else}{$message_error}{/if}</span>
        <a class="button" href="">Вернуться</a>
    </div>
    <!-- Системное сообщение (The End)-->
{/if}


<!-- Основная форма -->
<form method=post id=product enctype="multipart/form-data">
    <input type=hidden name="session_id" value="{$smarty.session.id}">
    <input type="hidden" name="lang_id" value="{$lang_id}" />
	<div id="name">
		<input class="name" name=name type="text" value="{$category->name|escape}"/> 
		<input name=id type="hidden" value="{$category->id|escape}"/> 
		<div class="checkbox">
			<input name=visible value='1' type="checkbox" id="active_checkbox" {if $category->visible}checked{/if}/>
            <label class="visible_icon" for="active_checkbox">Активна</label>
		</div>
        <div class="checkbox">
			<a class="yandex" data-to_yandex="1" href="javascript:;">В Я.Маркет</a>
            &nbsp;&nbsp;&nbsp;
            <a class="yandex" data-to_yandex="0" href="javascript:;">Из Я.Маркета</a>
		</div>
	</div> 

	<div id="product_categories">
			<select name="parent_id">
				<option value='0'>Корневая категория</option>
				{function name=category_select level=0}
                    {foreach $cats as $cat}
                        {if $category->id != $cat->id}
                            <option value='{$cat->id}' {if $category->parent_id == $cat->id}selected{/if}>{section name=sp loop=$level}&nbsp;&nbsp;&nbsp;&nbsp;{/section}{$cat->name}</option>
                            {category_select cats=$cat->subcategories level=$level+1}
                        {/if}
                    {/foreach}
				{/function}
				{category_select cats=$categories}
			</select>
	</div>
		
	<!-- Левая колонка свойств товара -->
	<div id="column_left">
			
		<!-- Параметры страницы -->
		<div class="block layer">
			<h2>Параметры страницы</h2>
			<ul>
                <li>
                    <label class="property" for="block_translit">Заблокировать авто генерацию ссылки</label>
                    <input type="checkbox" id="block_translit" {if $category->id}checked=""{/if} />
                    <div class="helper_wrap">
                        <a href="javascript:;" id="show_help_search" class="helper_link"></a>
                        <div class="right helper_block">
                            <b>Запрещает изменение URL.</b>
                            <span>Используется для предотвращения случайного изменения URL</span>
                            <span>Активируется после сохранения категории с заполненным полем адрес.
                            </span>
                        </div>
                    </div>
                </li>
				<li>
                    <label class="property">H1 заголовок
                        <div class="helper_wrap">
                            <a href="javascript:;" id="show_help_search" class="helper_link"></a>
                            <div class="right helper_block">
                                <span>
                                  Если поле не заполнено то в H1 подставляется название категории
                                </span>
                            </div>
                        </div>
                    </label>
                    <input name="name_h1" class="okay_inp" type="text" value="{$category->name_h1|escape}" />
                </li>
                <li>
                    <label class="property">Имя для Я.Маркета
                        <div class="helper_wrap">
                            <a href="javascript:;" id="show_help_search" class="helper_link"></a>
                            <div class="right helper_block">
                                <span>Категория Я.Маркета, в которую необходимо размещать товары из данной категории.</span>
                                <span>Начните вводить название категории и выберите подходящий вариант из выпадающего списка</span>
                            </div>
                        </div>
                    </label>
                    <input type="text" class="input_autocomplete" name="yandex_name" value="{$category->yandex_name|escape}" placeholder='Выберите категорию'/>
                </li>
				<li>
                    <label class=property>Адрес (URL)</label>
                    <div class="page_url">/catalog/</div>
                    <input name="url" class="page_url" type="text" value="{$category->url|escape}" />
                </li>
				<li>
                    <label class=property>Title (<span class="count_title_symbol"></span>/<span class="word_title"></span>)
                        <div class="helper_wrap">
                            <a href="javascript:;" id="show_help_search" class="helper_link"></a>
                            <div class="right helper_block">
                                <b>Название страницы</b>
                                <span>В скобках указывается количество символов/слов в строке</span>
                            </div>
                        </div>
                    </label>
                    <input name="meta_title" class="okay_inp" type="text" value="{$category->meta_title|escape}" />
                </li>
				<li>
                    <label class=property>Keywords (<span class="count_keywords_symbol"></span>/<span class="word_keywords"></span>)
                        <div class="helper_wrap">
                            <a href="javascript:;" id="show_help_search" class="helper_link"></a>
                            <div class="right helper_block">
                                <b>Ключевые слова страницы</b>
                                <span> В скобках указывается количество символов/слов в строке</span>
                            </div>
                        </div>
                    </label>
                    <input name="meta_keywords" class="okay_inp" type="text" value="{$category->meta_keywords|escape}" />
                </li>
				<li>
                    <label class=property>Description (<span class="count_desc_symbol"></span>/<span class="word_desc"></span>)
                        <div class="helper_wrap">
                            <a href="javascript:;" id="show_help_search" class="helper_link"></a>
                            <div class="right helper_block">
                                <b>Текст описания страницы,</b>
                                <span>который используется поисковыми системами для формирования сниппета.</span><span>В скобках указывается количество символов/слов в строке</span>
                            </div>
                        </div>
                    </label>
                    <textarea name="meta_description" class="okay_inp">{$category->meta_description|escape}</textarea>
                </li>
			</ul>
		</div>
		<!-- Параметры страницы (The End)-->
	</div>
	<!-- Левая колонка свойств товара (The End)--> 
	
	<!-- Правая колонка свойств товара -->	
	<div id="column_right">
		
		<!-- Изображение категории -->	
		<div class="block layer images">
			<h2>Изображение категории</h2>
			<input class='upload_image' name=image type=file>			
			<input type=hidden name="delete_image" value="">
			{if $category->image}
			<ul>
				<li>
					<a href='#' class="delete"></a>
					<img src="{$category->image|resize:100:100:false:$config->resized_categories_dir}" alt="" />
				</li>
			</ul>
			{/if}
		</div>
	</div>
	<!-- Правая колонка свойств товара (The End)--> 
    
    <div id="column_left">
        <div class="block layer">
    		<h2>Мета данные карточки товара
                <div class="helper_wrap">
                    <a href="javascript:;" id="show_help_search" class="helper_link"></a>
                    <div class="right helper_block">
                        <span>С помощью даных полей можно автоматически сгенерировать мета данные для товаров этой категории.</span>
                        <span>Вставки типа <b style="display: inline;">{ldelim}$brand{rdelim}</b> заменятся на соответствующие значения этого товара.</span>
                        <span> Возможные варианты вставок перечислены ниже.</span>
                    </div>
                </div>
                <div class="helper_wrap" style="margin-left: 5px; margin-top: -8px;">
                    <a class="top_help" id="show_help_search" href="https://www.youtube.com/watch?v=HM3ONkDbu0o" target="_blank"></a>
                    <div class="right helper_block topvisor_help">
                        <p>Видеоинструкция по данному функционалу</p>
                    </div>
                </div>
            </h2>
            <ul>
                {literal}
                <li>{$category} - Название категории</li>
				<li>{$category_h1} - Н1 заголовок категории</li>
                <li>{$brand} - Название бренда</li>
                <li>{$product} - Название товара</li>
                <li>{$price} - Цена товара</li>
                <li>{$sitename} - Название сайта</li>
                {/literal}
                {foreach $features as $feature}
                    {if $feature->auto_name_id && $feature->auto_value_id}
                    <li>
                        <span>"{$feature->name}": </span>
                        <span>название - {literal}{${/literal}{$feature->auto_name_id}{literal}}{/literal};</span>
                        <span>значение - {literal}{${/literal}{$feature->auto_value_id}{literal}}{/literal}</span>
                    </li>
                    {/if}
                {/foreach}
            </ul>
    		<ul>
                <li><label class="property">Title</label><textarea name="auto_meta_title" class="okay_inp">{$category->auto_meta_title|escape}</textarea></li>
                <li><label class="property">Keywords</label><textarea name="auto_meta_keywords" class="okay_inp">{$category->auto_meta_keywords|escape}</textarea></li>
    			<li><label class="property">Description</label><textarea name="auto_meta_desc" class="okay_inp">{$category->auto_meta_desc|escape}</textarea></li>
    		</ul>
    	</div>
    </div>
    <div class="block layer">
		<h2>Шаблон описания товаров из данной категории
            <div class="helper_wrap">
                <a href="javascript:;" id="show_help_search" class="helper_link"></a>
                <div class="right helper_block">
                    <span> Если у товара не задано полное описание, то в описание будет подставляться текст из данного поля.</span>
                    <span>Для создание шаблонных описаний можно использовать те же вставки что и для мета данных.</span>
                </div>
            </div>
            <div class="helper_wrap" style="margin-left: 5px; margin-top: -8px;">
                <a class="top_help" id="show_help_search" href="https://www.youtube.com/watch?v=gtvt8JlVGCE" target="_blank"></a>
                <div class="right helper_block topvisor_help">
                    <p>Видеоинструкция по данному функционалу</p>
                </div>
            </div>
        </h2>
        <textarea name="auto_body" class="editor_small">{$category->auto_body|escape}</textarea>
    </div>
    
    <div class="block layer">
		<h2>Краткое описание</h2>
		<textarea name="annotation" class="editor_small">{$category->annotation|escape}</textarea>
	</div>
    
	<!-- Описагние категории -->
	<div class="block layer">
		<h2>Полное описание</h2>
		<textarea name="description" class="editor_large">{$category->description|escape}</textarea>
	</div>
	<!-- Описание категории (The End)-->
	<input class="button_green button_save" type="submit" name="" value="Сохранить" />
	
</form>
<!-- Основная форма (The End) -->

{literal}
<script>
$(function() {
    $("a.yandex").click(function() {
		var icon = $(this);
        var id = $(this).parent().parent().find('input[name="id"]').val();
        var state = $(this).data('to_yandex');
		$.ajax({
			type: 'POST',
			url: 'ajax/update_object.php',
			data: {'object': 'category_yandex', 'id': id, 'values': {'to_yandex': state}, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
			success: function(data){
                icon.parent().find('a.yandex.success_yandex').removeClass('success_yandex');
				icon.parent().find('a.yandex.fail_yandex').removeClass('fail_yandex');
                if (data == -1) {
                    icon.addClass('fail_yandex');
                } else if (data) {
				    icon.addClass('success_yandex');
				} else {
				    icon.removeClass('success_yandex');
				}
			},
			dataType: 'json'
		});	
		return false;	
	});
    $('.input_autocomplete').autocomplete({
        serviceUrl:'ajax/market.php?module=search_market&session_id={/literal}{$smarty.session.id}{literal}',
        minChars:1,
        noCache: false,
        onSelect:
                function(suggestions) {
                    $(this).closest('div').find('input[name*="yandex_name"]').val(suggestions.data);
                }
    });
    $(".input_autocomplete").trigger('click');
});
</script>
{/literal}
