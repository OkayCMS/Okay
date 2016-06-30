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
	{if in_array('managers', $manager->permissions)}
        <li>
            <a href="index.php?module=ManagersAdmin">Менеджеры</a>
        </li>
    {/if}
    {if in_array('languages', $manager->permissions)}
        <li>
            <a href="index.php?module=LanguagesAdmin">Языки</a>
        </li>
    {/if}
	<li class="active">
        <a href="index.php?module=TranslationsAdmin">Переводы</a>
    </li>
{/capture}

{* Title *}
{$meta_title='Переводы' scope=parent}

{* Заголовок *}
<div id="header">
	<h1>Переводы</h1>
	<a class="add" href="{url module=TranslationAdmin}">Добавить перевод</a>
</div>

<div id="main_list">
    <div>Сортировка переводов:</div>
    <ul class="sort_translation">
        <li>
            <a {if $sort=='translation' || $sort=='translation_desc'} class="selected" {/if} href="{if $sort=='translation'}{url sort=translation_desc}{else}{url sort=translation}{/if}">По переводу &nbsp;{if $sort=='translation_desc'}&#8659;{else}&#8657;{/if}</a>
        </li>
        <li>
            <a {if $sort=='date' || $sort=='date_desc'} class="selected" {/if}href="{if $sort=='date'}{url sort=date_desc}{else}{url sort=date}{/if}">По новизне &nbsp;{if $sort=='date_desc'}&#8659;{else}&#8657;{/if}</a>
        </li>
        <li>
            <a {if $sort=='label' || $sort=='label_desc' || !$sort} class="selected" {/if}href="{if $sort=='label' || !$sort}{url sort=label_desc}{else}{url sort=null}{/if}">По переменной &nbsp;{if $sort=='label_desc'}&#8659;{else}&#8657;{/if}</a>
        </li>
    </ul>
	<form id="list_form" method="post">
        <input type="hidden" name="session_id" value="{$smarty.session.id}">

        <div id="list">

            {foreach $translations as $translation}
                <div class="{if !$translation->enabled}invisible{/if} row">
                    <div class="checkbox cell">
                        <input type="checkbox" id="{$translation->id}" name="check[]" value="{$translation->id}" />
                        <label for="{$translation->id}"></label>
                    </div>
                    <div class="name cell">
                        <span style='width:350px;display:inline-block;overflow:hidden'>
                            <a href="{url module=TranslationAdmin id=$translation->id return=$smarty.server.REQUEST_URI}">{$translation->value|escape}</a>
                        </span>
                         <a href="{url module=TranslationAdmin id=$translation->id return=$smarty.server.REQUEST_URI}">{$translation->label|escape}</a>
                    </div>
                    <div class="icons cell">
                        <a class="delete" title="Удалить" href="#"></a>
                    </div>
                    <div class="clear"></div>
                </div>
            {/foreach}
        </div>

        <div id="action">
        <label id="check_all" class='dash_link'>Выбрать все</label>
        <span id="select">
            <select name="action">
                <option value="delete">Удалить</option>
            </select>
        </span>
        <input id="apply_action" class="button_green" type="submit" value="Применить">
        </div>
	</form>

</div>

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
	
	$("form").submit(function() {
		if($('select[name="action"]').val()=='delete' && !confirm('Подтвердите удаление'))
			return false;	
	});


});

</script>
{/literal}
