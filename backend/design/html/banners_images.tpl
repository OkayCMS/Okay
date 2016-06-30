{* Вкладки *}
{capture name=tabs}
    <li class="active">
        <a href="index.php?module=BannersImagesAdmin">Баннеры</a>
    </li>
    <li>
        <a href="index.php?module=BannersAdmin">Группы баннеров</a>
    </li>
{/capture}

{* Title *}
{if $banner}
	{$meta_title=$banner->name scope=parent}
{else}
	{$meta_title='Баннеры' scope=parent}
{/if}


<form method="get">
<div id="search">
	<input type="hidden" name="module" value="BannersImagesAdmin">
	<input class="search" type="text" name="keyword" value="{$keyword|escape}" />
	<input class="search_button" type="submit" value=""/>
</div>
</form>
	
{* Заголовок *}
<div id="header">	
	{if $banners_images_count}
		{if $banner->name}
			<h1>{$banner->name} ({$banners_images_count} {$banners_images_count|plural:'товар':'товаров':'товара'})</h1>
		{elseif $keyword}
			<h1>{$banners_images_count|plural:'Найден':'Найдено':'Найдено'} {$banners_images_count} {$banners_images_count|plural:'баннер':'баннеров':'баннера'}</h1>
		{else}
			<h1>{$banners_images_count} {$banners_images_count|plural:'баннер':'баннеров':'баннера'}</h1>
		{/if}		
	{else}
		<h1>Нет баннеров</h1>
	{/if}
	<a class="add" href="{url module=BannersImageAdmin return=$smarty.server.REQUEST_URI}">Добавить баннер</a>
</div>

<div id="main_list">
    {include file='pagination.tpl'}
    {if $banners_images}
        {* Основная форма *}
        <form id="list_form" method="post">
            <input type="hidden" name="session_id" value="{$smarty.session.id}">
            <div id="list">
                {foreach $banners_images as $banners_image}
                    <div class="{if !$banners_image->visible}invisible{/if} {if $banners_image->featured}featured{/if} row">
                        <input type="hidden" name="positions[{$banners_image->id}]" value="{$banners_image->position}">
                        <div class="move cell">
                            <div class="move_zone"></div>
                        </div>
                        <div class="checkbox cell">
                            <input type="checkbox" id="{$banners_image->id}" name="check[]" value="{$banners_image->id}"/>
                            <label for="{$banners_image->id}"></label>
                        </div>
                        <div class="image cell">
                            {if $banners_image->image}
                                <a href="{url module=BannersImageAdmin id=$banners_image->id return=$smarty.server.REQUEST_URI}">
                                    <img src="../{$config->banners_images_dir}{$banners_image->image}" width="30px"/>
                                </a>
                            {/if}
                        </div>
                        <div class="name cell">
                            <a href="{url module=BannersImageAdmin id=$banners_image->id return=$smarty.server.REQUEST_URI}">{$banners_image->name|escape}</a>
                        </div>
                        <div class="icons cell banner">
                            <a class="enable" title="Активен" href="#"></a>
                            <a class="delete" title="Удалить" href="#"></a>
                        </div>
                        <div class="icons cell">
                            {if $banners}
                                <select name=image_banners[{$banners_image->id}] style="width:150px;">
                                    {foreach $banners as $b}
                                        <option value="{$b->id}"{if $b->id == $banners_image->banner_id} selected{/if}>{$b->name}</option>
                                    {/foreach}
                                </select>
                            {/if}
                        </div>
                        <div class="clear"></div>
                    </div>
                {/foreach}
            </div>

            <div id="action">
                <label id="check_all" class="dash_link">Выбрать все</label>
                <span id="select">
                    <select name="action">
                        <option value="enable">Сделать видимыми</option>
                        <option value="disable">Сделать невидимыми</option>
                        <option value="duplicate">Создать дубликат</option>
                        {if $banners|count>1}
                            <option value="move_to_banner">Переместить в группу</option>
                        {/if}
                        <option value="delete">Удалить</option>
                    </select>
                </span>
                <span id="move_to_banner">
                    <select name="target_banner">
                        {foreach $banners as $b}
                            <option value="{$b->id}"{if $b->id == $banners_image->banner_id} selected{/if}>{$b->name}</option>
                        {/foreach}
                    </select>
                </span>
                <input id="apply_action" class="button_green" type="submit" value="Применить">
            </div>
        </form>
    {/if}

    {include file='pagination.tpl'}
</div>

<div id="right_menu">

    <ul>
        <li {if !$filter}class="selected"{/if}>
            <a href="{url brand_id=null banner_id=null keyword=null page=null filter=null}">Все баннеры</a>
        </li>
        <li {if $filter=='visible'}class="selected"{/if}>
            <a href="{url keyword=null brand_id=null banner_id=null page=null filter='visible'}">Активные</a>
        </li>
        <li {if $filter=='hidden'}class="selected"{/if}>
            <a href="{url keyword=null brand_id=null banner_id=null page=null filter='hidden'}">Неактивные</a>
        </li>
    </ul>

	{if $banners}
	<ul>
		<li {if !$banner->id}class="selected"{/if}>
            <a href="{url banner_id=null brand_id=null}">Все группы</a>
        </li>
		{foreach $banners as $b}
		<li banner_id="{$b->id}" {if $banner->id == $b->id}class="selected"{else}class="droppable"{/if}>
            <a href='{url keyword=null page=null banner_id={$b->id}}'>{$b->name}</a>
        </li>
		{/foreach}
	</ul>
	{/if}
</div>
{* On document load *}
{literal}
<script>

$(function() {

	// Сортировка списка
	$("#list").sortable({
		items:             ".row",
		tolerance:         "pointer",
		handle:            ".move_zone",
		scrollSensitivity: 40,
		opacity:           0.7, 
		
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
	

	// Перенос товара в другую категорию
	$("#action select[name=action]").change(function() {
		if($(this).val() == 'move_to_banner')
			$("span#move_to_banner").show();
		else
			$("span#move_to_banner").hide();
	});
	$("#right_menu .droppable.banner").droppable({
		activeClass: "drop_active",
		hoverClass: "drop_hover",
		tolerance: "pointer",
		drop: function(event, ui){
			$(ui.helper).find('input[type="checkbox"][name*="check"]').attr('checked', true);
			$(ui.draggable).closest("form").find('select[name="action"] option[value=move_to_banner]').attr("selected", "selected");	
			$(ui.draggable).closest("form").find('select[name=target_banner] option[value='+$(this).attr('banner_id')+']').attr("selected", "selected");
			$(ui.draggable).closest("form").submit();
			return false;			
		}
	});


	// Раскраска строк
	function colorize()
	{
		$("#list div.row:even").addClass('even');
		$("#list div.row:odd").removeClass('even');
	}
	// Раскрасить строки сразу
	colorize();

	// Выделить все
	$("#check_all").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', $('#list input[type="checkbox"][name*="check"]:not(:checked)').length>0);
	});	

	// Удалить товар
	$("a.delete").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', false);
		$(this).closest("div.row").find('input[type="checkbox"][name*="check"]').attr('checked', true);
		$(this).closest("form").find('select[name="action"] option[value=delete]').attr('selected', true);
		$(this).closest("form").submit();
	});
	
	// Дублировать товар
	$("a.duplicate").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', false);
		$(this).closest("div.row").find('input[type="checkbox"][name*="check"]').attr('checked', true);
		$(this).closest("form").find('select[name="action"] option[value=duplicate]').attr('selected', true);
		$(this).closest("form").submit();
	});
	
	// Показать товар
	$("a.enable").click(function() {
		var icon        = $(this);
		var line        = icon.closest("div.row");
		var id          = line.find('input[type="checkbox"][name*="check"]').val();
		var state       = line.hasClass('invisible')?1:0;
		icon.addClass('loading_icon');
		$.ajax({
			type: 'POST',
			url: 'ajax/update_object.php',
			data: {'object': 'banners_image', 'id': id, 'values': {'visible': state}, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
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


	// Подтверждение удаления
	$("form").submit(function() {
		if($('select[name="action"]').val()=='delete' && !confirm('Подтвердите удаление'))
			return false;	
	});
	
});

</script>
{/literal}
