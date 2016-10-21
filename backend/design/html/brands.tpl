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
    <li class="active">
        <a href="index.php?module=BrandsAdmin">Бренды</a>
    </li>
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
{$meta_title='Бренды' scope=parent}


<div id="header" style="overflow: visible;">
	<h1>Бренды</h1> 
	<a class="add" href="{url module=BrandAdmin return=$smarty.server.REQUEST_URI}">Добавить бренд</a>
    <div class="helper_wrap">
        <a class="top_help" id="show_help_search" href="https://www.youtube.com/watch?v=GXMSLwsgJLk" target="_blank"></a>
        <div class="right helper_block topvisor_help">
            <p>Видеоинструкция по разделу</p>
        </div>
    </div>
</div>

{if $brands}
    <div id="main_list" class="brands">
        <form id="list_form" method="post">
            <input type="hidden" name="session_id" value="{$smarty.session.id}">
            <div id="list" class="brands">
                {foreach $brands as $brand}
                    <div class="row">
                        <input type="hidden" name="positions[{$brand->id}]" value="{$brand->position}">
                        <div class="move cell">
                            <div class="move_zone"></div>
                        </div>
                        <div class="checkbox cell">
                            <input type="checkbox" id="{$brand->id}" name="check[]" value="{$brand->id}"/>
                            <label for="{$brand->id}"></label>
                        </div>
                        <div class="image cell">
                            {if $brand->image}
                                <a href="{url module=BrandAdmin id=$brand->id return=$smarty.server.REQUEST_URI}">
                                    <img src="{$brand->image|resize:35:35:false:$config->resized_brands_dir}" alt="" /></a>
                            {else}
                                <img height="35" width="35" src="design/images/no_image.png"/>
                            {/if}
                        </div>
                        <div class="cell">
                            <a href="{url module=BrandAdmin id=$brand->id return=$smarty.server.REQUEST_URI}">{$brand->name|escape}</a>
                        </div>
                        <div class="icons cell brand">
                            <a class="preview" title="Предпросмотр в новом окне" href="../{$lang_link}brands/{$brand->url}" target="_blank"></a>
                            <a class="delete" title="Удалить" href="#"></a>
                        </div>
                        <div class="icons cell">
                            <a class="yandex" data-to_yandex="1" href="javascript:;">В Я.Маркет</a>
                            <a class="yandex" data-to_yandex="0" href="javascript:;">Из Я.Маркета</a>
                        </div>
                        <div class="clear"></div>
                    </div>
                {/foreach}
            </div>
            <div id="action">
                <label id="check_all" class="dash_link">Выбрать все</label>
                <span id="select">
                    <select name="action">
                        <option value="delete">Удалить</option>
                    </select>
                </span>
                <input id="apply_action" class="button_green" type="submit" value="Применить">
            </div>

        </form>
    </div>
{else}
    Нет брендов
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
			data: {'object': 'brand_yandex', 'id': id, 'values': {'to_yandex': state}, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
			success: function(data){
                line.find('a.yandex.success_yandex').removeClass('success_yandex');
                line.find('a.yandex.fail_yandex').removeClass('fail_yandex');
				if (data == -1) {
                    line.find('a.yandex[data-to_yandex="' + state + '"]').addClass('fail_yandex');
                } else if (data) {
                    line.find('a.yandex[data-to_yandex="' + state + '"]').addClass('success_yandex');
				} else {
                    line.find('a.yandex[data-to_yandex="' + state + '"]').removeClass('success_yandex');
				}
			},
			dataType: 'json'
		});	
		return false;	
	});

	// Раскраска строк
	function colorize()
	{
		$("#list div.row:even").addClass('even');
		$("#list div.row:odd").removeClass('even');
	}
	// Раскрасить строки сразу
	colorize();

    // Сортировка списка
    $("#list").sortable({
        items:             ".row",
        tolerance:         "pointer",
        handle:            ".move_zone",
        axis: 'y',
        scrollSensitivity: 40,
        opacity:           0.7,
        forcePlaceholderSize: true,

        helper: function(event, ui){
            if($('input[type="checkbox"][name*="check"]:checked').size()<1) return ui;
            var helper = $('<div/>');
            $('input[type="checkbox"][name*="check"]:checked').each(function(){
                var item = $(this).closest('.row');
                helper.height(helper.height()+item.innerHeight());
                if(item[0]!=ui[0]) {
                    helper.append(item.clone());
                    $(this).closest('.row').remove();
                }
                else {
                    helper.append(ui.clone());
                    item.find('input[type="checkbox"][name*="check"]').attr('checked', false);
                }
            });
            return helper;
        },
        start: function(event, ui) {
            if(ui.helper.children('.row').size()>0)
                $('.ui-sortable-placeholder').height(ui.helper.height());
        },
        beforeStop:function(event, ui){
            if(ui.helper.children('.row').size()>0){
                ui.helper.children('.row').each(function(){
                    $(this).insertBefore(ui.item);
                });
                ui.item.remove();
            }
        },
        update:function(event, ui)
        {
            $("#list_form input[name*='check']").attr('checked', false);
            $("#list_form").ajaxSubmit(function() {
                colorize();
            });
        }
    });
	
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
