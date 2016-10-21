{capture name=tabs}
    {if in_array('products', $manager->permissions)}
        <li>
        <a href="{url module=ProductsAdmin category_id=$product->category_id return=null brand_id=null id=null}">Товары</a>
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
    {if in_array('features', $manager->permissions)}
        <li>
            <a href="index.php?module=FeaturesAdmin">Свойства</a>
        </li>
    {/if}
    {if in_array('special', $manager->permissions)}
        <li class="active">
            <a href="index.php?module=SpecialAdmin">Промо-изображения</a>
        </li>
    {/if}
{/capture}

{$meta_title = 'Промо-изображения' scope=parent}


<div id="main_list" class="brands">

	<form id="list_form" method="post">
        <input type="hidden" name="session_id" value="{$smarty.session.id}"/>
		<div id="list" class="brands">	
			{foreach $special_images as $special}
			<div class="row">
                <input type="hidden" name="positions[{$special->id}]" value="{$special->position}"/>
                <div class="move cell"><div class="move_zone"></div></div>
                
		 		<div class="checkbox cell">
					<input id="special_{$special->id}" type="checkbox" name="check[]" value="{$special->id}" />
                    <label for="special_{$special->id}"></label>
				</div>
                <div class="image cell">
                    {if $special->filename}
                        <img height="35" width="35" src="../{$config->special_images_dir}{$special->filename}" alt="{$special->name}" />
                    {else}
                        <img height="35" width="35" src="design/images/no_image.png"/>
                    {/if}
                </div>
				<div class="cell">
                    <input type="text" name="special[name][{$special->id}]" value="{$special->name}" /> 	 			
				</div>
				<div class="icons cell">
					<a class="delete"  title="Удалить" href="#"></a>
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
			<input id="apply_action" class="button_green" type="submit" value="Применить"/>
		</div>
	</form>
    
    <form id="" method="post" enctype="multipart/form-data">
        <input type="hidden" name="session_id" value="{$smarty.session.id}"/>
		<div id="list2" class="brands">
            <div class="row" style="display: none;" id="new_special">
				<div class="cell">
                    <input type="text" name="new_special[name][]" />
				</div>
                <div class="cell">
                    <input class="upload" name="special_files[]" type="file" />
				</div>
				<div class="clear"></div>
			</div>
            <a href="javascript:;" class="add_special">Добавить промо-изображение</a>
        </div>
        <input id="apply_action" class="button_green" type="submit" value="Добавить"/>
    </form>
</div>

{literal}
<script>
$(function() {
    
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
    
    var new_special = $('#new_special').clone(true);
	$('#new_special').remove();
    new_special.removeAttr('id');
    $('.add_special').on('click', function() {
        new_item = new_special.clone().appendTo('#list2');
        new_item.show();
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
