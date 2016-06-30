{* Вкладки *}
{capture name=tabs}
    {if in_array('settings', $manager->permissions)}
        <li>
            <a href="index.php?module=SettingsAdmin">Настройки</a>
        </li>
    {/if}
    {if in_array('currency', $manager->permissions)}
        <li>
            <a href="index.php?module=CurrencyAdmin">Валюты</a>
        </li>
    {/if}
    {if in_array('delivery', $manager->permissions)}
        <li>
            <a href="index.php?module=DeliveriesAdmin">Доставка</a>
        </li>
    {/if}
    {if in_array('payment', $manager->permissions)}
        <li>
            <a href="index.php?module=PaymentMethodsAdmin">Оплата</a>
        </li>
    {/if}
    <li class="active">
        <a href="index.php?module=ManagersAdmin">Менеджеры</a>
    </li>
    {if in_array('languages', $manager->permissions)}
        <li>
            <a href="index.php?module=LanguagesAdmin">Языки</a>
        </li>
    {/if}
    {if in_array('languages', $manager->permissions)}
        <li>
            <a href="index.php?module=TranslationsAdmin">Переводы</a>
        </li>
    {/if}
{/capture}

{* Title *}
{$meta_title='Менеджеры' scope=parent}

<div id="header">
	<h1>{$managers_count} {$managers_count|plural:'менеджер':'менеджеров':'менеджера'}</h1> 	
	<a class="add" href="index.php?module=ManagerAdmin">Добавить менеджера</a>
</div>

{if $message_error}
    <div class="message message_error">
        <span class="text">
            {$message_error|escape}
        </span>
        <a class="button" href="">Вернуться</a>
    </div>
{/if}


{if $managers}
    <div id="main_list">
        <form id="form_list" method="post">
            <input type="hidden" name="session_id" value="{$smarty.session.id}">
            <div id="list">
                {foreach $managers as $m}
                    <div class="row">
                        <div class="checkbox cell">
                            <input type="checkbox" id="manager_{$m->id}" name="check[]" value="{$m->id}" {if $manager->id == $m->id}disabled{/if}/>
                            <label  for="manager_{$m->id}">
                        </div>
                        <div class="user_name cell">
                            <a href="index.php?module=ManagerAdmin&id={$m->id}">{$m->login}</a>
                        </div>
                        <div class="user_email cell">
                            <a href="mailto:{$user->name|escape}<{$user->email|escape}>">{$user->email|escape}</a>
                        </div>
                        <div class="user_group cell">
                            {$groups[$user->group_id]->name}
                        </div>
                        <div class="icons cell">
                            {if $manager->id != $m->id}
                                <a class="delete" title="Удалить" href="#"></a>
                            {/if}
                        </div>
                        <div class="clear"></div>
                    </div>
                {/foreach}
            </div>
            <div id="action">
                <label id="check_all" class="dash_link">Выбрать все</label>
                <span id=select>
                    <select name="action">
                        <option value="delete">Удалить</option>
                    </select>
                </span>
                <input id="apply_action" class="button_green" type="submit" value="Применить">
            </div>
        </form>
    </div>
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
		$('#list input[type="checkbox"][name*="check"]:not(:disabled)').attr('checked', $('#list input[type="checkbox"][name*="check"]:not(:disabled):not(:checked)').length>0);
	});	

	// Удалить 
	$("a.delete").click(function() {
		$('#list input[type="checkbox"][name*="check"]').attr('checked', false);
		$(this).closest(".row").find('input[type="checkbox"][name*="check"]').attr('checked', true);
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
