{capture name=tabs}
	<li class="active">
        <a href="index.php?module=ThemeAdmin">Тема</a>
    </li>
	<li>
        <a href="index.php?module=TemplatesAdmin">Шаблоны</a>
    </li>
	<li>
        <a href="index.php?module=StylesAdmin">Стили</a>
    </li>
    <li>
        <a href="index.php?module=ScriptsAdmin">Скрипты</a>
    </li>
	<li>
        <a href="index.php?module=ImagesAdmin">Изображения</a>
    </li>
    {if in_array('robots', $manager->permissions)}
        <li>
            <a href="index.php?module=RobotsAdmin">Robots.txt</a>
        </li>
    {/if}
{/capture}

{if $theme->name}
    {$meta_title = "Тема {$theme->name}" scope=parent}
{/if}

<script>
{literal}
	
$(function() {

	// Выбрать тему
	$('.set_main_theme').click(function() {
     	$("form input[name=action]").val('set_main_theme');
    	$("form input[name=theme]").val($(this).closest('li').attr('theme'));
    	$("form").submit();
	});	
	
	// Клонировать текущую тему
	$('#header .add').click(function() {
     	$("form input[name=action]").val('clone_theme');
    	$("form").submit();
	});	
	
	// Редактировать название
	$("a.edit").click(function() {
		name = $(this).closest('li').attr('theme');
		inp1 = $('<input type=hidden name="old_name[]">').val(name);
		inp2 = $('<input type=text name="new_name[]">').val(name);
		$(this).closest('li').find("p.name").html('').append(inp1).append(inp2);
		inp2.focus().select();
		return false;
	});
	
	// Удалить тему
	$('.delete').click(function() {
     	$("form input[name=action]").val('delete_theme');
     	$("form input[name=theme]").val($(this).closest('li').attr('theme'));
   		$("form").submit();
	});	

	$("form").submit(function() {
		if($("form input[name=action]").val()=='delete_theme' && !confirm('Подтвердите удаление'))
			return false;	
	});
	
});
{/literal}
</script>

<div id="header">
    <h1 class="{if $theme->locked}locked{/if}">Текущая тема &mdash; {$theme->name}</h1>
    <a class="add" href="#">Создать копию темы {$settings->theme}</a>
</div>

{if $message_error}
    <div class="message message_error">
	<span class="text">{if $message_error == 'permissions'}Установите права на запись для папки {$themes_dir}
	{elseif $message_error == 'name_exists'}Тема с таким именем уже существует
	{else}{$message_error}{/if}</span>
    </div>
{/if}

<div class="block layer">

    <form method="post" enctype="multipart/form-data">
        <input type="hidden" name="session_id" value="{$smarty.session.id}">
        <input type=hidden name="action">
        <input type=hidden name="theme">
        <ul class="themes">
            {foreach $themes as $t}
                <li theme='{$t->name|escape}'>
                    {if $theme->name == $t->name}<img class="tick" src='design/images/tick.png'>{/if}
                    {if $t->locked}<img class="tick" src='design/images/lock.png'>{/if}
                    {if $theme->name != $t->name && !$t->locked}
                        <a href='#' title="Удалить" class='delete'></a>
                        <a href='#' title="Переименовать" class='edit'></a>
                    {elseif !$t->locked}
                        <a href='#' title="Удалить" class='delete'></a>
                        <a href='#' title="Изменить название" class='edit'></a>
                    {/if}
                    {if $theme->name == $t->name}
                        <p class=name>{$t->name|escape|truncate:16:'...'}</p>
                    {else}
                        <p class=name><a href='#' class='set_main_theme'>{$t->name|escape|truncate:16:'...'}</a></p>
                    {/if}
                    <a href="index.php?module=TemplatesAdmin" style="display: block;float: left;">
                        <img class="preview" src='{$root_dir}../design/{$t->name}/preview.png'>
                    </a>
                </li>
            {/foreach}
        </ul>
        <div class="block">
            <input class="button_green button_save" type="submit" name="save" value="Сохранить"/>
        </div>
    </form>
</div>