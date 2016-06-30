{* Вкладки *}
{capture name=tabs}	
	<li class="active">
        <a href="index.php?module=BannersImagesAdmin">Баннеры</a>
    </li>
    <li>
        <a href="index.php?module=BannersAdmin">Группы баннеров</a>
    </li>
{/capture}

{if $banners_image->id}
    {$meta_title = $banners_image->name scope=parent}
{else}
    {$meta_title = 'Добавить баннер' scope=parent}
{/if}

{* On document load *}
{literal}
<script>
$(function() {

	// Удаление изображений
	$(".images a.delete").click( function() {
		$("input[name='delete_image']").val('1');
		$(this).closest("ul").fadeOut(200, function() { $(this).remove(); });
		return false;
	});
	  
});
</script>
 
{/literal}

{if $languages}{include file='include_languages.tpl' id=$banners_image->id}{/if}

{if $message_success}
    <!-- Системное сообщение -->
    <div class="message message_success">
        <span class="text">{if $message_success=='added'}Баннер добавлен{elseif $message_success=='updated'}Баннер обновлен{else}{$message_success}{/if}</span>
        {if $smarty.get.return}
        <a class="button" href="{$smarty.get.return}">Вернуться</a>
        {/if}
    </div>
    <!-- Системное сообщение (The End)-->
{/if}

{if $message_error}
    <!-- Системное сообщение -->
    <div class="message message_error">
        <a class="button" href="">Вернуться</a>
    </div>
    <!-- Системное сообщение (The End)-->
{/if}

<!-- Основная форма -->
<form method=post id=product enctype="multipart/form-data">
    <input type=hidden name="session_id" value="{$smarty.session.id}">
    <input type="hidden" name="lang_id" value="{$lang_id}" />
	<div id="name">
		<input class="name" name=name type="text" value="{$banners_image->name|escape}"/> 
		<input name=id type="hidden" value="{$banners_image->id}"/> 
		<div class="checkbox">
			<input name=visible value='1' type="checkbox" id="active_checkbox" {if $banners_image->visible}checked{/if}/>
            <label class="visible_icon" for="active_checkbox">Активен</label>
        </div>
	</div> 
	
	{if $banners}
	<div id="product_categories">
		<select name="banner_id">
			{foreach $banners as $banner}
				<option value='{$banner->id}' {if $banners_image->banner_id == $banner->id}selected{/if}>{$banner->name}</option>
			{/foreach}
		</select>
	</div>
	{/if}
		
	<!-- Левая колонка -->
	<div id="column_left">
		<!-- Параметры страницы -->
		<div class="block layer">
			<h2>Параметры баннера</h2>
			<ul>
				<li><label class=property>Адрес (URL)</label><input name="url" class="okay_inp" type="text" value="{$banners_image->url|escape}" /></li>
				<li><label class=property>Alt изображения</label><input name="alt" class="okay_inp" type="text" value="{$banners_image->alt|escape}" /></li>
				<li><label class=property>Title изображения</label><input name="title" class="okay_inp" type="text" value="{$banners_image->title|escape}" /></li>
				<li><label class=property>Описание</label><textarea name="description" class="okay_inp" >{$banners_image->description|escape}</textarea></li>
			</ul>
		</div>
		<!-- Параметры страницы (The End)-->
	</div>
	<!-- Левая колонка свойств товара (The End)--> 
	
	<!-- Правая колонка свойств товара -->	
	<div id="column_right">
		
		<!-- Изображение категории -->	
		<div class="block layer images">
			<h2>Изображение</h2>
			<input class='upload_image' name=image type=file>			
			<input type=hidden name="delete_image" value="">
			{if $banners_image->image}
			<ul>
				<li>
					<a href='#' class="delete"></a>
					<img src="../{$config->banners_images_dir}{$banners_image->image}" alt="" />
				</li>
			</ul>
			{/if}
		</div>
	</div>
	<!-- Правая колонка свойств товара (The End)--> 

	<!-- Описание категории (The End)-->
	<input class="button_green button_save" type="submit" name="" value="Сохранить" />
	
</form>
<!-- Основная форма (The End) -->

