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

{* Title *}
{$meta_title='Категории' scope=parent}

{* Заголовок *}
<div id="header" style="overflow: visible;">
	<h1>Категории товаров</h1>
	<a class="add" href="{url module=CategoryAdmin return=$smarty.server.REQUEST_URI}">Добавить категорию</a>
    <div class="helper_wrap">
        <a class="top_help" id="show_help_search" href="https://www.youtube.com/watch?v=-EIM2YxnV4Q" target="_blank"></a>
        <div class="right helper_block topvisor_help">
            <p>Видеоинструкция по разделу</p>
        </div>
    </div>
</div>
{* Заголовок END *}

{if $categories}
    <div id="main_list" class="categories">

        <form id="list_form" method="post">
            <input type="hidden" name="session_id" value="{$smarty.session.id}">

            <div id="list">
                {function name=categories_tree level=0}
                    {if $categories}
                        <div class="sortable">
                            {foreach $categories as $category}
                                <div class="{if !$category->visible}invisible{/if} row">
                                    <div class="tree_row">
                                        <input type="hidden" name="positions[{$category->id}]" value="{$category->position}">

                                        <div class="move cell" style="margin-left:{$level*20}px">
                                            <div class="move_zone"></div>
                                        </div>
                                        <div class="checkbox cell">
                                            <input type="checkbox" name="check[]" id="{$category->id}" value="{$category->id}"/>
                                            <label for="{$category->id}"></label>
                                        </div>
                                        <div class="image cell">
                                            {if $category->image}
                                                <a href="{url module=CategoryAdmin id=$category->id return=$smarty.server.REQUEST_URI}">
                                                    <img src="{$category->image|resize:35:35:false:$config->resized_categories_dir}" alt="" /></a>
                                                {else}
                                                    <img height="35" width="35" src="design/images/no_image.png"/>
                                            {/if}
                                        </div>
                                        <div class="cell categ_name">
                                            <a href="{url module=CategoryAdmin id=$category->id return=$smarty.server.REQUEST_URI}">{$category->name|escape}</a>
                                        </div>
                                        <div class="icons cell cat">
                                            <a class="preview" title="Предпросмотр в новом окне" href="../{$lang_link}catalog/{$category->url}" target="_blank"></a>
                                            <a class="enable" title="Активность" href="#"></a>
                                            <a class="delete" title="Удалить" href="#"></a>
                                        </div>
                                        <div class="icons cell">
                                            <div class="helper_wrap">
                                                <a href="javascript:;" id="show_help_search" class="helper_link"></a>
                                                <div class="helper_block">
                                                    Отметить/снять отметку выгрузки всех товаров из этой категории и её подкатегорий в файл экспорта для ЯндексМаркета
                                                </div>
                                            </div>
                                            <a class="yandex" data-to_yandex="1" href="javascript:;">В Я.Маркет</a>
                                            <a class="yandex" data-to_yandex="0" href="javascript:;">Из Я.Маркета</a>
                                        </div>
                                        <div class="clear"></div>
                                    </div>
                                    {categories_tree categories=$category->subcategories level=$level+1}
                                </div>
                            {/foreach}

                        </div>
                    {/if}
                {/function}
                {categories_tree categories=$categories}
            </div>
            <div id="action">
                <label id="check_all" class="dash_link">Выбрать все</label>
                <span id="select">
                    <select name="action">
                        <option value="enable">Сделать видимыми</option>
                        <option value="disable">Сделать невидимыми</option>
                        <option value="delete">Удалить</option>
                    </select>
                </span>
                <input id="apply_action" class="button_green" type="submit" value="Применить">
            </div>

        </form>
    </div>
{else}
    Нет категорий
{/if}

{literal}
<script>
$(function() {
    
    $("a.yandex").click(function() {
		var icon        = $(this);
		var line        = icon.closest(".row");
		var id          = line.find('input[type="checkbox"][name*="check"]').val();
        var state = $(this).data('to_yandex');
		$.ajax({
			type: 'POST',
			url: 'ajax/update_object.php',
			data: {'object': 'category_yandex', 'id': id, 'values': {'to_yandex': state}, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
			success: function(data){
                line.find('.tree_row a.yandex.success_yandex').removeClass('success_yandex');
                line.find('.tree_row a.yandex.fail_yandex').removeClass('fail_yandex');
                if (data == -1) {
                    line.find('.tree_row a.yandex[data-to_yandex="' + state + '"]').addClass('fail_yandex');
                } else if (data) {
                    line.find('.tree_row a.yandex[data-to_yandex="' + state + '"]').addClass('success_yandex');
				} else {
                    line.find('.tree_row a.yandex[data-to_yandex="' + state + '"]').removeClass('success_yandex');
				}
			},
			dataType: 'json'
		});	
		return false;	
	});

	// Сортировка списка
	$(".sortable").sortable({
		items:".row",
		handle: ".move_zone",
		tolerance:"pointer",
		scrollSensitivity:40,
		opacity:0.7, 
		axis: "y",
		update:function()
		{
			$("#list_form input[name*='check']").attr('checked', false);
			$("#list_form").ajaxSubmit();
		}
	});
 
	// Выделить все
	$("#check_all").click(function() {
		$('#list input[type="checkbox"][name*="check"]:not(:disabled)').attr('checked', $('#list input[type="checkbox"][name*="check"]:not(:disabled):not(:checked)').length>0);
	});	

	// Показать категорию
	$("a.enable").click(function() {
		var icon        = $(this);
		var line        = icon.closest(".row");
		var id          = line.find('input[type="checkbox"][name*="check"]').val();
		var state       = line.hasClass('invisible')?1:0;
		icon.addClass('loading_icon');
		$.ajax({
			type: 'POST',
			url: 'ajax/update_object.php',
			data: {'object': 'category', 'id': id, 'values': {'visible': state}, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
			success: function(data){
				icon.removeClass('loading_icon');
				if(state)
					line.removeClass('invisible');
				else
					line.addClass('invisible');				
			},
			dataType: 'json'
		});	
		return false;	
	});

	// Удалить 
	$("a.delete").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', false);
		$(this).closest("div.row").find('input[type="checkbox"][name*="check"]:first').attr('checked', true);
		$(this).closest("form").find('select[name="action"] option[value=delete]').attr('selected', true);
		$(this).closest("form").submit();
	});

	
	// Подтвердить удаление
	$("form").submit(function() {
		if($('select[name="action"]').val()=='delete' && !confirm('Подтвердите удаление'))
			return false;	
	});

});
</script>
{/literal}