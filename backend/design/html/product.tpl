{capture name=tabs}
    <li class="active">
        <a href="{url module=ProductsAdmin category_id=$product->category_id return=null brand_id=null id=null}">Товары</a>
    </li>
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

{if $product->id}
    {$meta_title = $product->name scope=parent}
{else}
    {$meta_title = 'Новый товар' scope=parent}
{/if}

{* Подключаем Tiny MCE *}
{include file='tinymce_init.tpl'}
{* On document load *}
{literal}
<script src="design/js/autocomplete/jquery.autocomplete-min.js"></script>

<script>
    $(window).on("load", function() {
    
    // Промо изображения
    $("#special_img img").click(function() {
 		var imgo        = $(this);
		var state       = $(this).attr('alt');
        var id = $('#name input[name=id]').val();
		imgo.addClass('loading_icon');
        $("#special_img	img.selected").removeClass('selected');
		$.ajax({
			type: 'POST',
			url: 'ajax/update_object.php',
			data: {'object': 'product', 'id': id, 'values': {'special': state}, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
			success: function(data){
				imgo.removeClass('loading_icon');
				imgo.addClass('selected');				
			},
			dataType: 'json'
		});	
		return false;	
	});
    $(".del_spec").click(function() {
        var id = $('#name input[name=id]').val();
      
		$.ajax({
			type: 'POST',
			url: 'ajax/update_object.php',
			data: {'object': 'product', 'id': id, 'values': {'special': ''}, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
			success: function(data){
               
                $("#special_img	img.selected").removeClass('selected');			
			},
			dataType: 'json'
		});	
		return false;	
	});
    // END Промо изображения

	// Добавление категории
	$('#product_categories .add').click(function() {
		$("#product_categories ul li:last").clone(false).appendTo('#product_categories ul').fadeIn('slow').find("select[name*=categories]:last").focus();
		$("#product_categories ul li:last span.add").hide();
		$("#product_categories ul li:last span.delete").show();
		return false;		
	});

	// Удаление категории
	$("#product_categories .delete").live('click', function() {
		$(this).closest("li").fadeOut(200, function() { $(this).remove(); });
		return false;
	});

	// Сортировка вариантов
	$("#variants_block").sortable({ items: '#variants ul' , axis: 'y',  cancel: '#header', handle: '.move_zone' });
	// Сортировка вариантов
	$("table.related_products").sortable({ items: 'tr' , axis: 'y',  cancel: '#header', handle: '.move_zone' });

	
	// Сортировка связанных товаров
	$(".sortable").sortable({
		items: "div.row",
		tolerance:"pointer",
		scrollSensitivity:40,
		opacity:0.7,
		handle: '.move_zone'
	});
		

	// Сортировка изображений
	$(".images ul").sortable({ tolerance: 'pointer'});

	// Удаление изображений
	$(".images a.delete").live('click', function() {
		 $(this).closest("li").fadeOut(200, function() { $(this).remove(); });
		 return false;
	});
	// Загрузить изображение с компьютера
	$('#upload_image').click(function() {
		$("<input class='upload_image' name=images[] type=file multiple  accept='image/jpeg,image/png,image/gif'>").appendTo('div#add_image').focus().click();
	});
	// Или с URL
	$('#add_image_url').click(function() {
		$("<input class='remote_image' name=images_urls[] type=text value='http://'>").appendTo('div#add_image').focus().select();
	});
	// Или перетаскиванием
	if(window.File && window.FileReader && window.FileList)
	{
		$("#dropZone").show();
		$("#dropZone").on('dragover', function (e){
			$(this).css('border', '1px solid #8cbf32');
		});
		$(document).on('dragenter', function (e){
			$("#dropZone").css('border', '1px dotted #8cbf32').css('background-color', '#c5ff8d');
		});
	
		dropInput = $('.dropInput').last().clone();
		
		function handleFileSelect(evt){
			var files = evt.target.files; // FileList object
			// Loop through the FileList and render image files as thumbnails.
		    for (var i = 0, f; f = files[i]; i++) {
				// Only process image files.
				if (!f.type.match('image.*')) {
					continue;
				}
			var reader = new FileReader();
			// Closure to capture the file information.
			reader.onload = (function(theFile) {
				return function(e) {
					// Render thumbnail.
					$("<li class=wizard><a href='' class='delete'></a><img onerror='$(this).closest(\"li\").remove();' src='"+e.target.result+"' /><input name=images_urls[] type=hidden value='"+theFile.name+"'></li>").appendTo('div .images ul');
					temp_input =  dropInput.clone();
					$('.dropInput').hide();
					$('#dropZone').append(temp_input);
					$("#dropZone").css('border', '1px solid #d0d0d0').css('background-color', '#ffffff');
					clone_input.show();
		        };
		      })(f);
		
		      // Read in the image file as a data URL.
		      reader.readAsDataURL(f);
		    }
		}
		$('.dropInput').live("change", handleFileSelect);
	};

	// Удаление варианта
	$('a.del_variant').click(function() {
		if($("#variants ul").size()>1)
		{
			$(this).closest("ul").fadeOut(200, function() { $(this).remove(); });
		}
		else
		{
			$('#variants_block .variant_name input[name*=variant][name*=name]').val('');
			$('#variants_block .variant_name').hide('slow');
			$('#variants_block').addClass('single_variant');
		}
		return false;
	});

	// Загрузить файл к варианту
	$('#variants_block a.add_attachment').click(function() {
		$(this).hide();
		$(this).closest('li').find('div.browse_attachment').show('fast');
		$(this).closest('li').find('input[name*=attachment]').attr('disabled', false);
		return false;		
	});
	
	// Удалить файл к варианту
	$('#variants_block a.remove_attachment').click(function() {
		closest_li = $(this).closest('li');
		closest_li.find('.attachment_name').hide('fast');
		$(this).hide('fast');
		closest_li.find('input[name*=delete_attachment]').val('1');
		closest_li.find('a.add_attachment').show('fast');
		return false;		
	});


	// Добавление варианта
	var variant = $('#new_variant').clone(true);
	$('#new_variant').remove().removeAttr('id');
	$('#variants_block span.add').click(function() {
		if(!$('#variants_block').is('.single_variant'))
		{
			$(variant).clone(true).appendTo('#variants').fadeIn('slow').find("input[name*=variant][name*=name]").focus();
		}
		else
		{
			$('#variants_block .variant_name').show('slow');
			$('#variants_block').removeClass('single_variant');		
		}
		return false;		
	});
	
	
	function show_category_features(category_id)
	{
		$('ul.prop_ul').empty();
		$.ajax({
			url: "ajax/get_features.php",
			data: {category_id: category_id, product_id: $("input[name=id]").val()},
			dataType: 'json',
			success: function(data){
				for(i=0; i<data.length; i++)
				{
					feature = data[i];
					
					line = $("<li><label class=property></label><input class='okay_inp option_value' type='text'/><input style='margin-left:175px;margin-top:2px;' readonly class='okay_inp grey_translit' type='text'/></li>");
					var new_line = line.clone(true);
					new_line.find("label.property").text(feature.name);
					new_line.find("input.option_value").attr('name', "options["+feature.id+"][value]").val(feature.value);
                    new_line.find("input:not(.option_value)").attr('name', "options["+feature.id+"][translit]").val(feature.translit);
					new_line.appendTo('ul.prop_ul').find("input.option_value")
					.autocomplete({
						serviceUrl:'ajax/options_autocomplete.php',
						minChars:0,
						params: {feature_id:feature.id},
						noCache: false,
                        onSelect:function(sugestion){
                            $(this).trigger('change');
                        }
					});
				}
			}
		});
		return false;
	}
	
	// Изменение набора свойств при изменении категории
	$('select[name="categories[]"]:first').change(function() {
		show_category_features($("option:selected",this).val());
	});

	// Автодополнение свойств
	$('ul.prop_ul input.option_value[name*=options]').each(function(index) {
		feature_id = $(this).closest('li').attr('feature_id');
		$(this).autocomplete({
			serviceUrl:'ajax/options_autocomplete.php',
			minChars:0,
			params: {feature_id:feature_id},
			noCache: false,
            onSelect:function(sugestion){
                $(this).trigger('change');
            }
		});
	}); 	
	
	// Добавление нового свойства товара
	var new_feature = $('#new_feature').clone(true);
	$('#new_feature').remove().removeAttr('id');
	$('#add_new_feature').click(function() {
		$(new_feature).clone(true).appendTo('ul.new_features').fadeIn('slow').find("input[name*=new_feature_name]").focus();
		return false;		
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
  

	// infinity
	$("input[name*=variant][name*=stock]").focus(function() {
		if($(this).val() == '∞')
			$(this).val('');
		return false;
	});

	$("input[name*=variant][name*=stock]").blur(function() {
		if($(this).val() == '')
			$(this).val('∞');
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
	$('select[name="categories[]"]').change(function() { set_meta(); });
        $('textarea[name="annotation"]').change(function() { set_meta();  });

	$("#show_translit").on('click',function(){
		$(".grey_translit").slideToggle(500);
	});
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
	result = name;
	brand = $('select[name="brand_id"] option:selected').attr('brand_name');
	if(typeof(brand) == 'string' && brand!='')
			result += ', '+brand;
	$('select[name="categories[]"]').each(function(index) {
		c = $(this).find('option:selected').attr('category_name');
		if(typeof(c) == 'string' && c != '')
    		result += ', '+c;
	}); 
	return result;
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

function translit_option($elem)
{
	url = $elem.val();
	url = url.replace(/[\s-_]+/gi, '');
	url = translit(url);
	url = url.replace(/[^0-9a-z_\-]+/gi, '').toLowerCase();	
	return url;
}
$(function(){
    $('.option_value').live('keyup click change',function(){
        $(this).next().val(translit_option($(this)));
    });
});

</script>
{/literal}

<div id="compact_languages_block">
    <div class="helper_wrap" style="margin-left: -6px">
        <a class="top_help" id="show_help_search" href="https://www.youtube.com/watch?v=5vO7uMwM9VA" target="_blank"></a>
        <div class="right helper_block topvisor_help">
            <p>Видеоинструкция по разделу</p>
        </div>
    </div>
    {if $languages}{include file='include_languages.tpl'}{/if}
</div>

{if $message_success}
    <div class="message message_success">
        <span class="text">{if $message_success=='added'}Товар добавлен{elseif $message_success=='updated'}Товар изменен{else}{$message_success|escape}{/if}</span>
        <a class="link" target="_blank" href="../{$lang_link}products/{$product->url}">Открыть товар на сайте</a>
        {if $smarty.get.return}
        <a class="button" href="{$smarty.get.return}">Вернуться</a>
        {/if}

        <span class="share">
            <a href="#" onClick='window.open("http://vkontakte.ru/share.php?url={$config->root_url|urlencode}/products/{$product->url|urlencode}&title={$product->name|urlencode}&description={$product->annotation|urlencode}&image={$product_images.0->filename|resize:1000:1000|urlencode}&noparse=true","displayWindow","width=700,height=400,left=250,top=170,status=no,toolbar=no,menubar=no");return false;'>
            <img src="{$config->root_url}/backend/design/images/vk_icon.png" /></a>
            <a href="#" onClick='window.open("http://www.facebook.com/sharer.php?u={$config->root_url|urlencode}/products/{$product->url|urlencode}","displayWindow","width=700,height=400,left=250,top=170,status=no,toolbar=no,menubar=no");return false;'>
            <img src="{$config->root_url}/backend/design/images/facebook_icon.png" /></a>
            <a href="#" onClick='window.open("http://twitter.com/share?text={$product->name|urlencode}&url={$config->root_url|urlencode}/products/{$product->url|urlencode}&hashtags={$product->meta_keywords|replace:' ':''|urlencode}","displayWindow","width=700,height=400,left=250,top=170,status=no,toolbar=no,menubar=no");return false;'>
            <img src="{$config->root_url}/backend/design/images/twitter_icon.png" /></a>
        </span>
    </div>
{/if}

{if $message_error}
    <div class="message message_error">
        <span class="text">{if $message_error=='url_exists'}Товар с таким адресом уже существует{elseif $message_error=='empty_name'}Введите название{elseif $message_error == 'empty_url'}Введите адрес{elseif $message_error == 'url_wrong'}Адрес не должен начинаться или заканчиваться символом '-'{else}{$message_error|escape}{/if}</span>
        {if $smarty.get.return}
        <a class="button" href="{$smarty.get.return}">Вернуться</a>
        {/if}
    </div>
{/if}
<form method=post id=product enctype="multipart/form-data">
    <input type=hidden name="session_id" value="{$smarty.session.id}">
    <input type="hidden" name="lang_id" value="{$lang_id}" />
    <div id="name">
        <input class="name" name=name type="text" value="{$product->name|escape}"/>
        <input name=id type="hidden" value="{$product->id|escape}"/>

        <div class="checkbox">
            <input name=visible value='1' type="checkbox" id="active_checkbox" {if $product->visible}checked{/if}/>
            <label class="visible_icon" for="active_checkbox">Активен</label>
        </div>
        <div class="checkbox">
            <input name=featured value="1" type="checkbox" id="featured_checkbox" {if $product->featured}checked{/if}/>
            <label class="featured_icon" for="featured_checkbox">Хит продаж</label>
        </div>
    </div>
    <div id="product_brand" {if !$brands}style='display:none;'{/if}>
        <label>Бренд</label>
        <select name="brand_id">
            <option value='0' {if !$product->brand_id}selected{/if} brand_name=''>Не указан</option>
            {foreach $brands as $brand}
                <option value='{$brand->id}' {if $product->brand_id == $brand->id}selected{/if} brand_name='{$brand->name|escape}'>{$brand->name|escape}</option>
            {/foreach}
        </select>
    </div>
    <div id="product_categories" {if !$categories}style='display:none;'{/if}>
        <label>Категория</label>
        <div>
            <ul>
                {foreach $product_categories as $product_category name=categories}
                    <li>
                        <select name="categories[]">
                            {function name=category_select level=0}
                                {foreach $categories as $category}
                                    <option value='{$category->id}' {if $category->id == $selected_id}selected{/if} category_name='{$category->name|escape}'>{section name=sp loop=$level}&nbsp;&nbsp;&nbsp;&nbsp;{/section}{$category->name|escape}</option>
                                    {category_select categories=$category->subcategories selected_id=$selected_id  level=$level+1}
                                {/foreach}
                            {/function}
                            {category_select categories=$categories selected_id=$product_category->id}
                        </select>
                        <span {if not $smarty.foreach.categories.first}style='display:none;'{/if} class="f_right add">
                            <i class="dash_link">Дополнительная категория</i>
                        </span>
                        <span {if $smarty.foreach.categories.first}style='display:none;'{/if} class="delete">
                            <i class="dash_link">Удалить</i>
                        </span>
                    </li>
                {/foreach}
            </ul>
        </div>
    </div>

    <div id="variants_block"
         {assign var=first_variant value=$product_variants|@first}{if $product_variants|@count <= 1 && !$first_variant->name}class=single_variant{/if}>
        <ul id="header">
            <li class="variant_move"></li>
            <li class="variant_name">Название варианта</li>
            <li class="variant_sku">Артикул</li>
            <li class="variant_price">Цена</li>
            <li class="variant_discount">Валюта</li>
            <li class="variant_discount">Старая</li>
            <li class="variant_amount">Кол-во</li>
            <li class="variant_yandex">Яндекс</li>
        </ul>
        <div id="variants">
            {foreach $product_variants as $variant}
                <ul>
                    <li class="variant_move">
                        <div class="move_zone"></div>
                    </li>
                    <li class="variant_name">
                        <input name="variants[id][]" type="hidden" value="{$variant->id|escape}"/>
                        <input name="variants[name][]" type="text" value="{$variant->name|escape}"/>
                        <a class="del_variant" href=""></a>
                    </li>
                    <li class="variant_sku">
                        <input name="variants[sku][]" type="text" value="{$variant->sku|escape}"/>
                    </li>
                    <li class="variant_price">
                        <input name="variants[price][]" type="text" value="{$variant->price|escape}"/>
                    </li>
                    <li class="variant_discount">
                        <select name="variants[currency_id][]">
                            {foreach $currencies as $currency}
                                <option value="{$currency->id}" {if $currency->id == $variant->currency_id}selected=""{/if}>{$currency->code}</option>
                            {/foreach}
                        </select>
                    </li>
                    <li class="variant_discount">
                        <input name="variants[compare_price][]" type="text" value="{$variant->compare_price|escape}"/>
                    </li>
                    <li class="variant_amount">
                        <input name="variants[stock][]" type="text" value="{if $variant->infinity || $variant->stock == ''}∞{else}{$variant->stock|escape}{/if}"/>{$settings->units}
                    </li>
                    <li class="variant_yandex">
                        <input id="ya_input_{$variant->id}" name="yandex[{$variant->id|escape}]" value="1" type="checkbox" {if $variant->yandex}checked=""{/if}/>
                        <label class="yandex_icon" for="ya_input_{$variant->id}"></label>
                    </li>
                    <li class="variant_download">
                        {if $variant->attachment}
                            <span class=attachment_name>{$variant->attachment|truncate:25:'...':false:true}</span>
                            <a href='#' class=remove_attachment></a>
                            <a href='#' class=add_attachment style='display:none;'></a>
                        {else}
                            <a href='#' class="add_attachment"></a>
                        {/if}
                        <div class=browse_attachment style='display:none;'>
                            <input type=file name=attachment[]>
                            <input type=hidden name=delete_attachment[]>
                        </div>
                    </li>
                </ul>
            {/foreach}
        </div>
        <ul id=new_variant style='display:none;'>
            <li class="variant_move">
                <div class="move_zone"></div>
            </li>
            <li class="variant_name">
                <input name="variants[id][]" type="hidden" value=""/>
                <input name="variants[name][]" type="text" value=""/>
                <a class="del_variant" href=""></a>
            </li>
            <li class="variant_sku">
                <input name="variants[sku][]" type="" value=""/>
            </li>
            <li class="variant_price">
                <input name="variants[price][]" type="" value=""/>
            </li>
            <li class="variant_discount">
                <select name="variants[currency_id][]">
                    {foreach $currencies as $currency}
                        <option value="{$currency->id}" {if $currency@first}selected=""{/if}>{$currency->code}</option>
                    {/foreach}
                </select>
            </li>
            <li class="variant_discount">
                <input name="variants[compare_price][]" type="" value=""/>
            </li>
            <li class="variant_amount">
                <input name="variants[stock][]" type="" value="∞"/>{$settings->units}
            </li>
            <li class="variant_download">
                <a href='#' class=add_attachment></a>
                <div class=browse_attachment style='display:none;'>
                    <input type=file name=attachment[]>
                    <input type=hidden name=delete_attachment[]>
                </div>
            </li>
        </ul>

        <input class="button_green button_save" type="submit" name="" value="Сохранить"/>
        <span class="add" id="add_variant"><i class="dash_link">Добавить вариант</i></span>
    </div>
    <div id="column_left">

        <div class="block layer">
            <h2>Параметры страницы</h2>
            <ul>
                <li>
                    <label class="property" for="block_translit">Заблокировать авто генерацию ссылки</label>
                    <input type="checkbox" id="block_translit" {if $product->url}checked=""{/if} />
                    <div class="helper_wrap">
                        <a href="javascript:;" id="show_help_search" class="helper_link"></a>
                        <div class="right helper_block" style="width: 207px;">
                            <b>Запрещает изменение URL.</b>
                            <span>Используется для предотвращения случайного изменения URL</span>
                            <span>Активируется после сохранения товара с заполненным полем адрес.</span>
                        </div>
                    </div>
                </li>
                <li>
                    <label class=property>Адрес (URL)</label>
                    <div class="page_url"> /products/</div>
                    <input name="url" class="page_url" type="text" value="{$product->url|escape}"/></li>
                <li>
                    <label class=property>Title  (<span class="count_title_symbol"></span>/<span class="word_title"></span>)
                        <div class="helper_wrap">
                            <a href="javascript:;" id="show_help_search" class="helper_link"></a>
                            <div class="right helper_block">
                            	<b>Название страницы</b>
                            	<p>В скобках указывается количество символов/слов в строке</p>
                            </div>
                        </div>
                    </label>

                    <input name="meta_title" class="okay_inp word_count" type="text" value="{$product->meta_title|escape}"/>
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
                    <input name="meta_keywords" class="okay_inp word_count" type="text" value="{$product->meta_keywords|escape}"/>
                </li>
                <li>
                    <label class=property>Description (<span class="count_desc_symbol"></span>/<span class="word_desc"></span>)
                        <div class="helper_wrap">
                            <a href="javascript:;" id="show_help_search" class="helper_link"></a>
                            <div class="right helper_block">
                            	<b>Описание страницы</b>
                            	<span>Используется поисковыми системами для формирования сниппета</span>
                                <span>В скобках указывается количество символов/слов в строке</span>
                            </div>
                        </div>
                    </label>
                    <textarea name="meta_description" class="okay_inp">{$product->meta_description|escape}</textarea>
                </li>
            </ul>
        </div>
        <div class="block layer">
            <h2>Рейтинг товара</h2>
            <ul>
                <li>
                    <label class=property>Рейтинг: </label>
                    <input class="okay_inp" type="text" name="rating" value="{$product->rating}"/>
                </li>
                <li>
                    <label class=property>Количество голосов: </label>
                    <input class="okay_inp" type="text" name="votes" value="{$product->votes}"/>
                </li>
            </ul>
        </div>

        <div class="block layer" {if !$categories}style='display:none;'{/if}>
            <h2>Свойства товара  <a href="javascript:;" id="show_translit">Показать транслит</a>
                <div class="helper_wrap">
                    <a href="javascript:;" id="show_help_search" class="helper_link"></a>
                    <div class="right helper_block">
                    	<b>Транслит свойства</b>
                        <span>Используется для формирования URL после применения фильтра.</span>
                        <span>Гернерируется автоматически.</span>
                    </div>
                </div>
            </h2>


            <ul class="prop_ul">
                {foreach $features as $feature}
                    {assign var=feature_id value=$feature->id}
                    <li feature_id="{$feature_id}">
                        <label class="property">{$feature->name}</label>
                        <input class="okay_inp option_value" type="text" name="options[{$feature_id}][value]" value="{$options.$feature_id->value|escape}"/>
                        <input class="okay_inp grey_translit" style="margin-left:175px;margin-top:2px;" type="text" name="options[{$feature_id}][translit]" readonly value="{$options.$feature_id->translit|escape}"/>
                    </li>
                {/foreach}
            </ul>
            <ul class=new_features>
                <li id=new_feature>
                    <label class=property><input type=text class="okay_inp" name=new_features_names[]></label>
                    <input class="okay_inp" type="text" name=new_features_values[]/>
                </li>
            </ul>
            <span class="add"><i class="dash_link" id="add_new_feature">Добавить новое свойство</i></span>
            <input class="button_green button_save" type="submit" name="" value="Сохранить"/>
        </div>
    </div>
    <div id="column_right">
        <div class="block layer images">
            <h2>Изображения товара
                <div class="helper_wrap">
                    <a href="javascript:;" id="show_help_search" class="helper_link"></a>
                    <div class="right helper_block">
                        <span>Первое изображение считается основным и выводится в списке товаров</span>
                    </div>
                </div>
            </h2>
            <ul>
                {foreach $product_images as $image}
                    <li>
                        <a href='#' class="delete"></a>
                        <img src="{$image->filename|resize:100:100}" alt=""/>
                        <input type=hidden name='images[]' value='{$image->id}'>
                    </li>
                {/foreach}
            </ul>
            <div id=dropZone>
                <div id=dropMessage>Перетащите файлы сюда</div>
                <input type="file" name="dropped_images[]" multiple class="dropInput">
            </div>
            <div id="add_image"></div>
            <span class=upload_image><i class="dash_link" id="upload_image">Добавить изображение</i></span> или
            <span class=add_image_url><i class="dash_link" id="add_image_url">загрузить из интернета</i></span>
            <h2>Промо-изображение
                <div class="helper_wrap">
                    <a href="javascript:;" id="show_help_search" class="helper_link"></a>
                    <div class="right helper_block" style="width: 168px;">
                    	<b>Промо-ярлык</b>
                        <span>Выводится поверх основного изображения товара</span>
                    </div>
                </div>
            </h2>
            <div id="special_img">
                {foreach $special_images as $special}
                    <img title="{$special->name}" class="{if $product->special == $special->filename}selected{/if}" src="../{$config->special_images_dir}{$special->filename}" alt="{$special->filename}"/>
                {/foreach}
            </div>
            <div class="del_cont" style="margin-top:10px">
                <img class="del_spec" title="сброс специального изображения" src='design/images/cross-circle-frame.png'/>
                <a class="del_spec" href="#">удалить отметку</a>
            </div>
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
                            <a href="{url id=$related_product->id}">
								{if $related_product->images[0]}
                                <img class=product_icon src='{$related_product->images[0]->filename|resize:35:35}'>
								{else}
								<img class=product_icon src="design/images/no_image.png" width="22">
								{/if}
							</a>
                        </div>
                        <div class="name cell">
                            <a href="{url id=$related_product->id}">{$related_product->name}</a>
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

    <div class="block layer">
        <h2>Краткое описание</h2>
        <textarea name="annotation" id="annotation" class="editor_small">{$product->annotation|escape}</textarea>
    </div>
    <div class="block">
        <h2>Полное описание</h2>
        <textarea name="body" class="editor_large">{$product->body|escape}</textarea>
    </div>
    <input class="button_green button_save" type="submit" name="" value="Сохранить"/>

</form>


