{capture name=tabs}
	<li class="active">
        <a href="index.php?module=BlogAdmin">Блог</a>
    </li>
{/capture}

{if $post->id}
{$meta_title = $post->name scope=parent}
{else}
{$meta_title = 'Новая запись в блоге' scope=parent}
{/if}

{* Подключаем Tiny MCE *}
{include file='tinymce_init.tpl'}
{* On document load *}
{literal}
<script src="design/js/jquery/datepicker/jquery.ui.datepicker-ru.js"></script>
<script src="design/js/autocomplete/jquery.autocomplete-min.js"></script>
<script>
    $(window).on("load", function() {
    
    // Удаление изображений
	$(".images a.delete").click( function() {
		$("input[name='delete_image']").val('1');
		$(this).closest("ul").fadeOut(200, function() { $(this).remove(); });
		return false;
	});

	$('input[name="date"]').datepicker({
		regional:'ru'
	});

    $("table.related_products").sortable({ items: 'tr' , axis: 'y',  cancel: '#header', handle: '.move_zone' });


    // Сортировка связанных товаров
    $(".sortable").sortable({
        items: "div.row",
        tolerance:"pointer",
        scrollSensitivity:40,
        opacity:0.7,
        handle: '.move_zone'
    });

    // Удаление связанного товара
    $(".related_products a.delete").live('click', function() {
        $(this).closest("div.row").fadeOut(200, function() { $(this).remove(); });
        return false;
    });


    // Добавление связанного товара
    var new_related_product = $('#new_related_product').clone(true);
    $('#new_related_product').remove().removeAttr('id');

    $("input#related_products").autocomplete({
        serviceUrl:'ajax/search_products.php',
        minChars:0,
        noCache: false,
        onSelect:
                function(suggestion){
                    $("input#related_products").val('').focus().blur();
                    new_item = new_related_product.clone().appendTo('.related_products');
                    new_item.removeAttr('id');
                    new_item.find('a.related_product_name').html(suggestion.data.name);
                    new_item.find('a.related_product_name').attr('href', 'index.php?module=ProductAdmin&id='+suggestion.data.id);
                    new_item.find('input[name*="related_products"]').val(suggestion.data.id);
                    if(suggestion.data.image)
                        new_item.find('img.product_icon').attr("src", suggestion.data.image);
                    else
                        new_item.find('img.product_icon').remove();
                    new_item.show();
                },
        formatResult:
                function(suggestions, currentValue){
                    var reEscape = new RegExp('(\\' + ['/', '.', '*', '+', '?', '|', '(', ')', '[', ']', '{', '}', '\\'].join('|\\') + ')', 'g');
                    var pattern = '(' + currentValue.replace(reEscape, '\\$1') + ')';
                    return (suggestions.data.image?"<img align=absmiddle src='"+suggestions.data.image+"'> ":'') + suggestions.value.replace(new RegExp(pattern, 'gi'), '<strong>$1<\/strong>');
                }

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
	$('select[name="brand_id"]').change(function() { set_meta(); });

});

function set_meta()
{
	if(!meta_title_touched)
		$('input[name="meta_title"]').val(generate_meta_title());
	if(!meta_keywords_touched)
		$('input[name="meta_keywords"]').val(generate_meta_keywords());
    if(!meta_description_touched)
    {
        descr = $('textarea[name="meta_description"]');
        descr.val(generate_meta_description());
        descr.scrollTop(descr.outerHeight());
    }
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

{if $languages}{include file='include_languages.tpl'}{/if}

{if $message_success}
<!-- Системное сообщение -->
<div class="message message_success">
	<span class="text">{if $message_success == 'added'}Запись добавлена{elseif $message_success == 'updated'}Запись обновлена{/if}</span>
	<a class="link" target="_blank" href="../{$lang_link}blog/{$post->url}">Открыть запись на сайте</a>
	{if $smarty.get.return}
	<a class="button" href="{$smarty.get.return}">Вернуться</a>
	{/if}

	<span class="share">		
		<a href="#" onClick='window.open("http://vkontakte.ru/share.php?url={$config->root_url|urlencode}/blog/{$post->url|urlencode}&title={$post->name|urlencode}&description={$post->annotation|urlencode}&noparse=false","displayWindow","width=700,height=400,left=250,top=170,status=no,toolbar=no,menubar=no");return false;'>
  		<img src="{$config->root_url}/backend/design/images/vk_icon.png" /></a>
		<a href="#" onClick='window.open("http://www.facebook.com/sharer.php?u={$config->root_url|urlencode}/blog/{$post->url|urlencode}","displayWindow","width=700,height=400,left=250,top=170,status=no,toolbar=no,menubar=no");return false;'>
  		<img src="{$config->root_url}/backend/design/images/facebook_icon.png" /></a>
		<a href="#" onClick='window.open("http://twitter.com/share?text={$post->name|urlencode}&url={$config->root_url|urlencode}/blog/{$post->url|urlencode}&hashtags={$post->meta_keywords|replace:' ':''|urlencode}","displayWindow","width=700,height=400,left=250,top=170,status=no,toolbar=no,menubar=no");return false;'>
  		<img src="{$config->root_url}/backend/design/images/twitter_icon.png" /></a>
	</span>
	
	
</div>
<!-- Системное сообщение (The End)-->
{/if}

{if $message_error}
<!-- Системное сообщение -->
<div class="message message_error">
	<span class="text">{if $message_error == 'url_exists'}Запись с таким адресом уже существует{elseif $message_error=='empty_name'}Введите название{elseif $message_error == 'empty_url'}Введите адрес{elseif $message_error == 'url_wrong'}Адрес не должен начинаться или заканчиваться символом '-'{else}{$message_error}{/if}</span>
	{if $smarty.get.return}
		<a class="button" href="{$smarty.get.return}">Вернуться</a>
	{/if}
	</div>
<!-- Системное сообщение (The End)-->
{/if}


<!-- Основная форма -->
<form method=post id=product enctype="multipart/form-data">
    <input type=hidden name="session_id" value="{$smarty.session.id}">
    <input type="hidden" name="lang_id" value="{$lang_id}" />
	<div id="name">
		<input class="name" name=name type="text" value="{$post->name|escape}"/> 
		<input name=id type="hidden" value="{$post->id|escape}"/> 
		<div class="checkbox">
			<input name=visible value='1' type="checkbox" id="active_checkbox" {if $post->visible}checked{/if}/> <label for="active_checkbox" class="visible_icon">Активна</label>
		</div>

	</div> 

	<!-- Левая колонка свойств товара -->
	<div id="column_left">
			
		<!-- Параметры страницы -->
		<div class="block">
			<ul>
				<li><label class=property>Дата</label><input type=text name=date value='{$post->date|date}'></li>
			</ul>
		</div>
		<div class="block layer">
		<!-- Параметры страницы (The End)-->
			<h2>Параметры страницы</h2>
		<!-- Параметры страницы -->
			<ul>
                <li><label class="property" for="block_translit">Заблокировать авто генерацию ссылки</label>
                    <input type="checkbox" id="block_translit" {if $post->id}checked=""{/if} />
                    <div class="helper_wrap">
                        <a href="javascript:;" id="show_help_search" class="helper_link"></a>
                        <div class="right helper_block">
                            <b>Запрещает изменение URL.</b>
                            <span>Используется для предотвращения случайного изменения URL.</span>
                            <span>Активируется после сохранения записи с заполненным полем адрес.</span>
                        </div>
                    </div>
                </li>
				<li><label class=property>Адрес (URL)</label><div class="page_url"> /blog/</div><input name="url" class="page_url" type="text" value="{$post->url|escape}" /></li>
				<li><label class=property>Title (<span class="count_title_symbol"></span>/<span class="word_title"></span>)
                        <div class="helper_wrap">
                            <a href="javascript:;" id="show_help_search" class="helper_link"></a>
                            <div class="right helper_block">
                                <b>Название страницы</b>
                                <span>В скобках указывается количество символов/слов в строке</span>
                            </div>
                        </div>
                    </label><input name="meta_title" type="text" value="{$post->meta_title|escape}" /></li>
				<li><label class=property>Keywords (<span class="count_keywords_symbol"></span>/<span class="word_keywords"></span>)
                        <div class="helper_wrap">
                            <a href="javascript:;" id="show_help_search" class="helper_link"></a>
                            <div class="right helper_block">
                                <b>Ключевые слова страницы</b>
                                <span> В скобках указывается количество символов/слов в строке</span>
                            </div>
                        </div>
                    </label><input name="meta_keywords"  type="text" value="{$post->meta_keywords|escape}" /></li>
				<li><label class=property>Description (<span class="count_desc_symbol"></span>/<span class="word_desc"></span>)
                        <div class="helper_wrap">
                            <a href="javascript:;" id="show_help_search" class="helper_link"></a>
                            <div class="right helper_block">
                                <b>Текст описания страницы,</b>
                                <span>который используется поисковыми системами для формирования сниппета.</span>
                                <span>В скобках указывается количество символов/слов в строке</span>
                            </div>
                        </div>
                    </label><textarea name="meta_description">{$post->meta_description|escape}</textarea></li>
			</ul>
		</div>
		<!-- Параметры страницы (The End)-->


			
	</div>
	<!-- Левая колонка свойств товара (The End)--> 
	
	<!-- Правая колонка свойств товара -->	
	<div id="column_right">
		<!-- Изображение статьи -->	
		<div class="block layer images">
			<h2>Изображение</h2>
			<input class='upload_image' name="image" type="file"/>			
			<input type="hidden" name="delete_image" value=""/>
			{if $post->image}
			<ul>
				<li>
					<a href='#' class="delete"></a>
					<img src="{$post->image|resize:100:100:false:$config->resized_blog_dir}" alt="" />
				</li>
			</ul>
			{/if}
		</div>

        <div class="block layer">
            <h2>Рекомендуемые товары</h2>
            <div id=list class="sortable related_products">
                {foreach $related_products as $related_product}
                    <div class="row">
                        <div class="move cell">
                            <div class="move_zone"></div>
                        </div>
                        <div class="image cell">
                            <input type=hidden name=related_products[] value='{$related_product->id}'>
                            <a href="{url module=ProductAdmin id=$related_product->id}">
                                {if $related_product->images[0]}
                                    <img class=product_icon src='{$related_product->images[0]->filename|resize:35:35}'>
                                {else}
                                    <img class=product_icon src="design/images/no_image.png" width="22">
                                {/if}
                            </a>
                        </div>
                        <div class="name cell">
                            <a href="{url module=ProductAdmin id=$related_product->id}">{$related_product->name}</a>
                        </div>
                        <div class="icons cell">
                            <a href='#' class="delete"></a>
                        </div>
                        <div class="clear"></div>
                    </div>
                {/foreach}
                <div id="new_related_product" class="row" style='display:none;'>
                    <div class="move cell">
                        <div class="move_zone"></div>
                    </div>
                    <div class="image cell">
                        <input type=hidden name=related_products[] value=''>
                        <img class=product_icon src=''>
                    </div>
                    <div class="name cell">
                        <a class="related_product_name" href=""></a>
                    </div>
                    <div class="icons cell">
                        <a href='#' class="delete"></a>
                    </div>
                    <div class="clear"></div>
                </div>
            </div>
            <input type=text name=related id='related_products' class="input_autocomplete" placeholder='Выберите товар чтобы добавить его'>
        </div>
        <input class="button_green button_save" type="submit" name="" value="Сохранить"/>

	</div>
	<!-- Правая колонка свойств товара (The End)--> 
	
	<!-- Описагние товара -->
	<div class="block layer">
		<h2>Краткое описание</h2>
		<textarea name="annotation" class='editor_large'>{$post->annotation|escape}</textarea>
	</div>
		
	<div class="block">
		<h2>Полное  описание</h2>
		<textarea name="body"  class='editor_large'>{$post->text|escape}</textarea>
	</div>
	<!-- Описание товара (The End)-->
	<input class="button_green button_save" type="submit" name="" value="Сохранить" />
	
</form>
<!-- Основная форма (The End) -->
