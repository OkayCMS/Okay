{capture name=tabs}
		{if in_array('products', $manager->permissions)}<li><a href="{url module=ProductsAdmin category_id=$product->category_id return=null brand_id=null id=null}">Товары</a></li>{/if}
		{if in_array('categories', $manager->permissions)}<li><a href="index.php?module=CategoriesAdmin">Категории</a></li>{/if}
		{if in_array('brands', $manager->permissions)}<li><a href="index.php?module=BrandsAdmin">Бренды</a></li>{/if}
		{if in_array('features', $manager->permissions)}<li><a href="index.php?module=FeaturesAdmin">Свойства</a></li>{/if}
        {if in_array('special', $manager->permissions)}<li class="active"><a href="index.php?module=SpecialAdmin">Промо-изображения</a></li>{/if}
{/capture}

{$meta_title = 'Промо-изображения' scope=parent}

<form method="post" id="spec_form" enctype="multipart/form-data"> 
	<div id="list">
	{foreach $kartinki as $im}
		<div class="spec_irow">
			<div class="checkbox cell">
			  <input type="checkbox" name="check[]" value="{$im->id}"/>				
			</div>
			<div class="spec_img_name">
				<span>{$im->name}</span>
			</div>
			<img src="../files/special/{$im->filename}" title="{$im->name}"/>
		</div>
	{/foreach}
	</div>
	<div class="spec_act">
		<label>Действие:</label>
		<select name="action">
			<option></option>
			<option value="delete">Удалить</option>
		</select>
	</div>

	<input type="hidden" name="session_id" value="{$smarty.session.id}"/>

	<div class="form_group">
		<label>Название:</label>
		<input class="" name="name" type="text" />
	</div>

	<div class="form_group">
		<label>Выбрать изображение:</label><br />
		<input class="upload" name="spec_img" type="file" />
	</div>    
			
	<input class="button" type="submit" name="submit" value="Сохранить" />
</form>
{*literal}
<script>
    // Удалить товар
	$(".spec_irow .del").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', false);
		$(this).closest("div.spec_irow").find('input[type="checkbox"][name*="check"]').attr('checked', true);
		$(this).closest("form").find('select[name="action"] option[value=delete]').attr('selected', true);
		$(this).closest("form").submit();
	});
    
    	// Подтверждение удаления
	$("form").submit(function() {
		if($('select[name="action"]').val()=='delete' && !confirm('Подтвердите удаление'))
            return false;	
	});
</script>
{/literal*}