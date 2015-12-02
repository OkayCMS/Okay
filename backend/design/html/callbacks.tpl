{* Вкладки *}
{capture name=tabs}
    {if in_array('comments', $manager->permissions)}
        <li><a href="index.php?module=CommentsAdmin">Комментарии</a></li>
    {/if}
    {if in_array('feedbacks', $manager->permissions)}
        <li><a href="index.php?module=FeedbacksAdmin">Обратная связь</a></li>
    {/if}
    <li class="active"><a href="index.php?module=CallbacksAdmin">Заказ обратного звонка</a></li>
{/capture}

{* Title *}
{$meta_title='Заказ обратного звонка' scope=parent}

<div id="header">
	{if $callbacks_count}
	<h1>{$callbacks_count} {$callbacks_count|plural:'заказ':'заказа':'заказов'}</h1> 
	{else}
	<h1>Нет заказов</h1> 
	{/if}
</div>

<div id="main_list">
    {include file='pagination.tpl'}
    {if $callbacks}
        <form id="list_form" method="post">
            <input type="hidden" name="session_id" value="{$smarty.session.id}">
            <div id="list" style="width:100%;">
                {foreach $callbacks as $callback}
                    <div class="row{if $callback->processed} active{/if}">
                        <div class="checkbox cell">
                            <input type="checkbox" id="{$callback->id}" name="check[]" value="{$callback->id}"/>
                            <label for="{$callback->id}"></label>
                        </div>
                        <div class="name cell">
                            <div class='comment_name'>
                                {$callback->name|escape}
                            </div>
                            <div class='comment_text'>
                                Телефон: {$callback->phone|escape|nl2br}
                            </div>
                            <div class='comment_text'>
                                Сообщение: {$callback->message|escape|nl2br}
                            </div>
                            <div class='comment_info'>
                                Заявка отправлена {$callback->date|date} в {$callback->date|time}
                            </div>
                        </div>
                        <div class="icons cell">
                            <a href='#' title='Обработать' class="processed">Обработать</a>
                            <a href='#' title='Удалить' class="delete"></a>
                        </div>
                        <div class="clear"></div>
                    </div>
                {/foreach}
            </div>

            <div id="action">
                <label id='check_all' class='dash_link'>Выбрать все</label>
                <span id=select>
                <select name="action">
                    <option value="processed">Отметить как обработанные</option>
                    <option value="delete">Удалить</option>
                </select>
                </span>
                <input id='apply_action' class="button_green" type=submit value="Применить">
            </div>
        </form>
    {else}
        Нет сообщений
    {/if}
    {include file='pagination.tpl'}
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
	
	// Обработать
	$("a.processed").click(function() {
		var icon        = $(this);
		var line        = icon.closest(".row");
		var id          = line.find('input[type="checkbox"][name*="check"]').val();
		var state       = line.hasClass('active')?null:1;
		icon.addClass('loading_icon');
		$.ajax({
			type: 'POST',
			url: 'ajax/update_object.php',
			data: {'object': 'callback', 'id': id, 'values': {'processed': state}, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
			success: function(data){
				icon.removeClass('loading_icon');
				if(state)
					line.addClass('active');
				else
					line.removeClass('active');				
			},
			dataType: 'json'
		});	
		return false;	
	});
	
	// Подтверждение удаления
	$("form#list_form").submit(function() {
		if($('select[name="action"]').val()=='delete' && !confirm('Подтвердите удаление'))
			return false;	
	});

});

</script>
{/literal}
