{* Вкладки *}
{capture name=tabs}
    {if in_array('comments', $manager->permissions)}
        <li>
            <a href="index.php?module=CommentsAdmin">Комментарии</a>
        </li>
    {/if}
    <li class="active">
        <a href="index.php?module=FeedbacksAdmin">Обратная связь</a>
    </li>
    {if in_array('callbacks', $manager->permissions)}
        <li>
            <a href="index.php?module=CallbacksAdmin">Заказ обратного звонка</a>
        </li>
    {/if}
{/capture}

{* Title *}
{$meta_title='Обратная связь' scope=parent}


{if $feedbacks || $keyword}
    <form method="get">
    <div id="search">
        <input type="hidden" name="module" value='FeedbacksAdmin'>
        <input class="search" type="text" name="keyword" value="{$keyword|escape}" />
        <input class="search_button" type="submit" value=""/>
    </div>
    </form>
{/if}

<div id="header">
	{if $feedbacks_count}
	    <h1>{$feedbacks_count} {$feedbacks_count|plural:'сообщение':'сообщений':'сообщения'}</h1>
	{else}
	    <h1>Нет сообщений</h1>
	{/if}
</div>

<div id="main_list">
    {include file='pagination.tpl'}
    {if $feedbacks}
        <form id="list_form" method="post">
            <input type="hidden" name="session_id" value="{$smarty.session.id}">
            <div id="list" style="width:100%;">

                {foreach $feedbacks as $feedback}
                    <div class="{if !$feedback->processed}unapproved{/if} row">
                        <div class="checkbox cell">
                            <input type="checkbox" id="{$feedback->id}" name="check[]" value="{$feedback->id}"/>
                            <label for="{$feedback->id}"></label>
                        </div>
                        <div class="name cell" data-email_name="{$feedback->name|escape}">
                            <div class='comment_name'>
                                <a href="mailto:{$feedback->name|escape}<{$feedback->email|escape}>?subject=Вопрос от пользователя {$feedback->name|escape}">{$feedback->name|escape} {if $feedback->email}&nbsp;({$feedback->email|escape}){/if}</a>
                                {if !$feedback->processed}
                                    <a class="approve" href="#">Обработать</a>
                                {/if}
                            </div>
                            <div class='comment_text'>
                                {$feedback->message|escape|nl2br}
                            </div>
                            {if $feedback->email}
                                <a href="#feedback_answer" class="answer" data-feedback_id="{$feedback->id}">Ответить</a>
                            {/if}
                            <div class='comment_info'>
                                Сообщение отправлено {$feedback->date|date} в {$feedback->date|time}
                            </div>
                        </div>
                        <div class="icons cell">
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
<form id="feedback_answer" style="display: none;" method="post">
    <input type="hidden" name="session_id" value="{$smarty.session.id}">
    <h2>Написать ответ</h2>
        <input type="hidden" name="feedback_id" value="" />
        <textarea name="text" rows="10" cols="50"></textarea>
    <br>
    <input class="button" type="submit" name="feedback_answer" value="Отправить" />
</form>
{literal}
<script type="text/javascript" src="design/js/fancybox/jquery.fancybox.js"></script>
<link type="text/css" href="design/js/fancybox/jquery.fancybox.css" rel="stylesheet" />
<script>
$(function() {

    $('.answer').click(function() {
        $('input[name="feedback_id"]').val($(this).data('feedback_id'));
        $('#feedback_answer textarea').html($(this).parent().data('email_name')+',');
    });
    $('.answer').fancybox();


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
    $("a.approve").click(function() {
        var line        = $(this).closest(".row");
        var id          = line.find('input[type="checkbox"][name*="check"]').val();
        line.addClass('loading_icon');
        $.ajax({
            type: 'POST',
            url: 'ajax/update_object.php',
            data: {'object': 'feedback', 'id': id, 'values': {'processed': 1}, 'session_id': '{/literal}{$smarty.session.id}{literal}'},
            success: function(data){
                line.removeClass('loading_icon');
                line.removeClass('unapproved');
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
