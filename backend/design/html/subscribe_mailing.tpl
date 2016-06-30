{* Вкладки *}
{capture name=tabs}
    {if in_array('users', $manager->permissions)}
        <li>
            <a href="index.php?module=UsersAdmin">Пользователи</a>
        </li>
    {/if}
    {if in_array('groups', $manager->permissions)}
        <li>
            <a href="index.php?module=GroupsAdmin">Группы</a>
        </li>
    {/if}
    {if in_array('coupons', $manager->permissions)}
        <li>
            <a href="index.php?module=CouponsAdmin">Купоны</a>
        </li>
    {/if}
    <li class="active">
        <a href="index.php?module=SubscribeMailingAdmin">Подписчики</a>
    </li>
{/capture}

{* Title *}
{$meta_title='Подписчики' scope=parent}

<div id="header">
	{if $keyword && $subscribes_count>0}
        <h1>{$subscribes_count|plural:'Нашелся':'Нашлось':'Нашлись'} {$subscribes_count} {$subscribes_count|plural:'подписчик':'подписчика':'подписчиков'}</h1>
	{elseif $subscribes_count>0}
        <h1>{$subscribes_count} {$subscribes_count|plural:'подписчик':'подписчика':'подписчиков'}</h1> 	
	{else}
        <h1>Нет подписчиков</h1> 	
	{/if}
	{if $subscribes_count>0}
        <form method="post" action="{url module=SubscribeMailingAdmin}" target="_blank">
        <input type="hidden" name="session_id" value="{$smarty.session.id}"/>
        <input type="hidden" name="is_export" value="1" />
        <input type="image" src="./design/images/export_excel.png" name="export" title="Экспортировать этих подписчиков"/>
        </form>
	{/if}
</div>

{if $subscribes}
    <div id="main_list" class="brands">
        {include file='pagination.tpl'}
        <form id="list_form" method="post">
            <input type="hidden" name="session_id" value="{$smarty.session.id}"/>
            <div id="list" class="brands">
                {foreach $subscribes as $subscribe}
                    <div class="row">
                        <div class="checkbox cell">
                            <input type="checkbox" id="{$subscribe->id}" name="check[]" value="{$subscribe->id}"/>
                            <label for="{$subscribe->id}"></label>
                        </div>
                        <div class="cell">
                            {$subscribe->email|escape}
                        </div>
                        <div class="icons cell">
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
                <option value="delete">Удалить</option>
            </select>
			</span>
                <input id="apply_action" class="button_green" type="submit" value="Применить"/>
            </div>
        </form>
        {include file='pagination.tpl'}
    </div>
{else}
    Нет подписчиков
{/if}

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
