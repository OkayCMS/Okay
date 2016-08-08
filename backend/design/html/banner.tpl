{capture name=tabs}		
	<li>
        <a href="index.php?module=BannersImagesAdmin">Баннеры</a>
    </li>
	<li class="active">
        <a href="index.php?module=BannersAdmin">Группы баннеров</a>
    </li>
{/capture}

{if $banner->id}
    {$meta_title = $banner->name scope=parent}
{else}
    {$meta_title = 'Новая группа' scope=parent}
{/if}

{if $message_success}
    <!-- Системное сообщение -->
    <div class="message message_success">
        <span class="text">{if $message_success == 'added'}Группа добавлена{elseif $message_success == 'updated'}Группа обновлена{/if}</span>
        {if $smarty.get.return}
        <a class="button" href="{$smarty.get.return}">Вернуться</a>
        {/if}
    </div>
    <!-- Системное сообщение (The End)-->
{/if}

{if $message_error}
    <!-- Системное сообщение -->
    <div class="message message_error">
        <span class="text">
            {if $message_error == 'group_id_exists'}
                Страница с таким ID группы уже существует
            {elseif $message_error == 'empty_group_id'}
                Введите ID группы
            {else}
                {$message_error}
            {/if}
        </span>
        <a class="button" href="">Вернуться</a>
    </div>
    <!-- Системное сообщение (The End)-->
{/if}

<!-- Основная форма -->
<form method=post id=product class="banners_group">
	<input type=hidden name="session_id" value="{$smarty.session.id}">
	<div id="name">
		<input class="name" name=name type="text" value="{$banner->name|escape}"/> 
		<input name=id type="hidden" value="{$banner->id|escape}"/> 
		<div class="checkbox">
			<input name=visible value='1' type="checkbox" id="active_checkbox" {if $banner->visible}checked{/if}/>
            <label class="visible_icon" for="active_checkbox">Активен</label>
        </div>
	</div>

	<!-- Левая колонка свойств товара -->
	<div id="column_left">
		<!-- Параметры страницы -->
		<div class="block layer">
			<h2>Описание</h2>
			<ul>
				<li><textarea name="description" class="okay_inp">{$banner->description|escape}</textarea></li>
			</ul>
		</div>

        <div class="block layer">
            <h2>ID группы баннеров</h2>
            <ul>
                <li>
                    <input name="group_id" class="okay_inp" type="text" value="{$banner->group_id|escape}" />
                </li>
            </ul>
        </div>
		<!-- Параметры страницы (The End)-->
	</div>
	<!-- Левая колонка свойств товара (The End)-->
	<br />
		<div class="block layer">
			<h2>Баннер отображать на:</h2>				
			<label for="show_all_pages" class="banner_property">
				<input name="show_all_pages" value="1" type="checkbox" {if $banner->show_all_pages}checked{/if} id="show_all_pages"/> 
				Показывать на всех страницах сайта
			</label>
			<table>
			<tr>
				<td>
					<ul>
						<li>
							<label class="banner_property">На страницах:</label>
							<select name="pages[]" multiple="multiple" size="10">
								<option value='0' {if !$banner->page_selected OR 0|in_array:$banner->page_selected}selected{/if}>Не показывать на страницах</option>
								{foreach from=$pages item=page}
									{if $page->name != ''}<option value='{$page->id}' {if $banner->page_selected AND $page->id|in_array:$banner->page_selected}selected{/if}>{$page->name|escape}</option>{/if}
								{/foreach}
							</select>
						</li>
						<li>
							<label class="banner_property">В брендах:</label>
							<select name="brands[]" multiple="multiple" size="10">
								<option value='0' {if !$banner->brand_selected OR 0|in_array:$banner->brand_selected}selected{/if}>Не показывать в брендах</option>
								{foreach from=$brands item=brand}
									<option value='{$brand->id}' {if $banner->brand_selected AND $brand->id|in_array:$banner->brand_selected}selected{/if}>{$brand->name|escape}</option>
								{/foreach}
							</select>
						</li>
					</ul>
				</td>
				<td valign="top">
					<ul>
						<li>
							<label class="banner_property">В категориях:</label>
							<select name="categories[]" multiple="multiple" size="10">
								<option value='0' {if !$banner->category_selected OR 0|in_array:$banner->category_selected}selected{/if}>Не показывать в категориях</option>
								{function name=category_select level=0}
									{foreach from=$categories item=category}
											<option value='{$category->id}' {if $selected AND $category->id|in_array:$selected}selected{/if}>{section name=sp loop=$level}&nbsp;&nbsp;&nbsp;&nbsp;{/section}{$category->name|escape}</option>
											{category_select categories=$category->subcategories selected=$banner->category_selected  level=$level+1}
									{/foreach}
								{/function}
								{category_select categories=$categories selected=$banner->category_selected}
							</select>
						</li>
					</ul>
				</td>
			</tr>
            <tr>
                <td>
    				<ul>
	    				<li>
		    				<label class="banner_property">В товарах:</label>
		    				<select name="products[]" multiple="multiple" size="10">
								<option value='0' {if !$banner->product_selected OR 0|in_array:$banner->product_selected}selected{/if}>Не показывать в товарах</option>
								{foreach from=$products item=product}
									<option value='{$product->id}' {if $banner->product_selected AND $product->id|in_array:$banner->product_selected}selected{/if}>{$product->name|escape}</option>
								{/foreach}
							</select>
						</li>
					</ul>
    			</td>
    			<td></td>
            </table>
		</div>
		<div class="block layer">
			{$otstup1 = "&nbsp;&nbsp;&nbsp;&nbsp;"}
			{$otstup2 = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"}
			{$otstup3 = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"}
			{$otstup4 = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"}
			{$otstup5 = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"}
            {$otstup6 = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"}
            {$otstup7 = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"}
			Для того, чтобы вставить эту группу баннеров &mdash;<br>
			вставьте этот код в нужное Вам место в шаблоне<br><br>
            {ldelim}get_banner var=banner_{$banner->group_id} group='{$banner->group_id}'{rdelim}<br>
            {ldelim}if $banner_{$banner->group_id}->items{rdelim}<br>
                {$otstup1}&lt;div class="container hidden-md-down"&gt;<br>
                    {$otstup2}&lt;div class="fn-slick-banner_{$banner->group_id} okaycms slick-banner"&gt;<br>
                        {$otstup3}{ldelim}foreach $banner_{$banner->group_id}->items as $bi{rdelim}<br>
                            {$otstup4}&lt;div&gt;<br>
                                {$otstup5}{ldelim}if $bi->url{rdelim}<br>
                                    {$otstup6}&lt;a href="{ldelim}$bi->url{rdelim}" target="_blank"&gt;<br>
                                {$otstup5}{ldelim}/if{rdelim}<br>
                                {$otstup5}{ldelim}if $bi->image{rdelim}<br>
                                    {$otstup6}&lt;img src="{ldelim}$config->banners_images_dir{rdelim}{ldelim}$bi->image{rdelim}" alt="{ldelim}$bi->alt{rdelim}" title="{ldelim}$bi->title{rdelim}"/&gt;<br>
                                {$otstup5}{ldelim}/if{rdelim}<br>
                                {$otstup5}&lt;span class="slick-name"&gt;<br>
                                    {$otstup6}{ldelim}$bi->title{rdelim}<br>
                                {$otstup5}&lt;/span&gt;<br>
                                {$otstup5}{ldelim}if $bi->description{rdelim}<br>
                                    {$otstup6}&lt;span class="slick-description"&gt;<br>
                                        {$otstup7}{ldelim}$bi->description{rdelim}<br>
                                    {$otstup6}&lt;/span&gt;<br>
                                {$otstup5}{ldelim}/if{rdelim}<br>
                                {$otstup5}{ldelim}if $bi->url{rdelim}<br>
                                    {$otstup6}&lt;/a&gt;<br>
                                {$otstup5}{ldelim}/if{rdelim}<br>
                            {$otstup4}&lt;/div&gt;<br>
                        {$otstup3}{ldelim}/foreach{rdelim}<br>
                    {$otstup2}&lt;/div&gt;<br>
                {$otstup1}&lt;/div&gt;<br>
            {ldelim}/if{rdelim}<br>
		</div>
		<div class="block layer">
			Для того, чтобы баннеры сменялись &mdash; можно определить для группы слайдер<br>
			Для этого в папке с шаблоном в папке js в файле okay.js нужно вставить следующий скрипт:<br><br>
            $('.fn-slick-banner_{$banner->group_id}.okaycms').slick({ldelim}<br />
                {$otstup1}infinite: true,<br />
                {$otstup1}speed: 500,<br />
                {$otstup1}slidesToShow: 1,<br />
                {$otstup1}slidesToScroll: 1,<br />
                {$otstup1}swipeToSlide : true,<br />
                {$otstup1}dots: true,<br />
                {$otstup1}arrows: false,<br />
                {$otstup1}adaptiveHeight: true,<br />
                {$otstup1}autoplaySpeed: 8000,<br />
                {$otstup1}autoplay: true<br />
            {rdelim});<br /><br />
			*В самом файле есть пример скрипта с описанием настроек
		</div>
	
	<input class="button" type="submit" name="" value="Сохранить" />
	
</form>
<!-- Основная форма (The End) -->