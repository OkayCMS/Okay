{* Вкладки *}
{capture name=tabs}
	<li class="active">
        <a href="index.php?module=BlogAdmin">Блог</a>
    </li>
{/capture}

{* Title *}
{$meta_title='Блог' scope=parent}

{if $posts || $keyword}
    <form method="get">
    <div id="search">
        <input type="hidden" name="module" value='BlogAdmin'>
        <input class="search" type="text" name="keyword" value="{$keyword|escape}" />
        <input class="search_button" type="submit" value=""/>
    </div>
    </form>
{/if}

<div id="header">
	{if $keyword && $posts_count}
	    <h1>{$posts_count|plural:'Нашлась':'Нашлись':'Нашлись'} {$posts_count} {$posts_count|plural:'запись':'записей':'записи'}</h1>
	{elseif $posts_count}
	    <h1>{$posts_count} {$posts_count|plural:'запись':'записей':'записи'} в блоге</h1>
	{else}
	    <h1>Нет записей</h1>
	{/if}
	<a class="add" href="{url module=PostAdmin return=$smarty.server.REQUEST_URI}">Добавить запись</a>
</div>

{if $posts}
    <div id="main_list">
        {include file='pagination.tpl'}
        <form id="form_list" method="post">
            <input type="hidden" name="session_id" value="{$smarty.session.id}">
            <div id="list">
                {foreach $posts as $post}
                    <div class="{if !$post->visible}invisible{/if} row">
                        <input type="hidden" name="positions[{$post->id}]" value="{$post->position}">

                        <div class="checkbox cell">
                            <input type="checkbox" id="{$post->id}" name="check[]" value="{$post->id}"/>
                            <label for="{$post->id}"></label>
                        </div>
                        <div class="image cell">
                            {if $post->image}
                                <a href="{url module=PostAdmin id=$post->id return=$smarty.server.REQUEST_URI}">
                                    <img src="{$post->image|escape|resize:35:35:false:$config->resized_blog_dir}"/>
                                </a>
                            {else}
                                <img height="35" width="35" src="design/images/no_image.png"/>
                            {/if}
                        </div>
                        <div class="name cell">
                            <a href="{url module=PostAdmin id=$post->id return=$smarty.server.REQUEST_URI}">{$post->name|escape}</a>
                            <br>
                            {$post->date|date}
                        </div>
                        <div class="icons cell blogs">
                            <a class="preview" title="Предпросмотр в новом окне" href="../{$lang_link}blog/{$post->url}" target="_blank"></a>
                            <a class="enable" title="Активна" href="#"></a>
                            <a class="delete" title="Удалить" href="#"></a>
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
                        <option value="delete">Удалить</option>
                    </select>
                </span>
                <input id="apply_action" class="button_green" type="submit" value="Применить">
            </div>
        </form>
        {include file='pagination.tpl'}
    </div>
{/if}

{* On document load *}
{literal}

<script>
$(function() {

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
		$(this).closest(".row").find('input[type="checkbox"][name*="check"]').attr('checked', true);
		$(this).closest("form").find('select[name="action"] option[value=delete]').attr('selected', true);
		$(this).closest("form").submit();
	});
	
	// Скрыт/Видим
	$("a.enable").click(function() {
		var icon        = $(this);
		var line        = icon.closest(".row");
		var id          = line.find('input[type="checkbox"][name*="check"]').val();
		var state       = line.hasClass('invisible')?1:0;
		icon.addClass('loading_icon');
		$.ajax({
			type: 'POST',
			url: 'ajax/update_object.php',
			data: {'object': 'blog', 'id': id, 'values': {'visible': state}, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
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