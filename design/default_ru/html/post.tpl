{* Страница отдельной записи блога *}

{* Канонический адрес страницы *}
{$canonical="/blog/{$post->url}" scope=parent}

<!-- Заголовок /-->
<h1 class="h1" data-post="{$post->id}">{$post->name|escape}</h1>

<p class="post_date">{$post->date|date}</p>

<!-- Тело поста /-->
{$post->text}

<!-- Комментарии -->
<div id="comments">
	<div class="block_name">Комментарии</div>
	{if $comments}
    	<!-- Список с комментариями -->
    	<ul class="comment_list">
    		{foreach $comments as $comment}
        		<a name="comment_{$comment->id}"></a>
        		<li>
        			<!-- Имя и дата комментария-->
        			<div class="comment_header">	
        				<span class="comment_name">{$comment->name|escape}</span> <i>{$comment->date|date}, {$comment->date|time}</i>
        				{if !$comment->approved}<b>ожидает модерации</b>{/if}
        			</div>
        			<!-- Имя и дата комментария (The End)-->
        			
        			<!-- Комментарий -->
        			{$comment->text|escape|nl2br}
        			<!-- Комментарий (The End)-->
                </li>
    		{/foreach}
    	</ul>
    	<!-- Список с комментариями (The End)-->
	{else}
    	<p>
		    Пока нет комментариев
    	</p>
	{/if}	
	<!--Форма отправления комментария-->

	<!--Подключаем js-проверку формы -->
	
	<form class="form comment_form" method="post" action="">
		<div class="comment_form_title">Написать комментарий</div>
		{if $error}
			<div class="message_error">
				{if $error=='captcha'}
					Неверно введена капча
				{elseif $error=='empty_name'}
					Введите имя
				{elseif $error=='empty_comment'}
					Введите комментарий
				{/if}
			</div>
		{/if}
		
		<div class="form_group">
			<label>Имя</label>
			<input class="form_input" type="text" id="comment_name" name="name" value="{$comment_name|escape}" data-format=".+" data-notice="Введите имя" />
		</div>

		<label>Введите комментарий</label>
		<textarea class="comment_textarea" id="comment_text" name="text" data-format=".+" data-notice="Введите комментарий" >{$comment_text}</textarea>
		
		<div class="captcha">
			<img src="captcha/image.php?{math equation='rand(10,10000)'}"/>
			<input class="input_captcha" id="comment_captcha" type="text" name="captcha_code" value="" data-format="\d\d\d\d" data-notice="Введите капчу" placeholder="Введите капчу"/>
		</div>

		<input class="button" type="submit" name="comment" value="Отправить"/>
	</form>
	<!--Форма отправления комментария (The End)-->
</div>
<!-- Комментарии (The End) -->