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
	<h2 class="block_name">{$lang->kommentarii}</h2>
	{if $comments}
    	<!-- Список с комментариями -->
    	<ul class="comment_list">
    		{foreach $comments as $comment}
        		<a name="comment_{$comment->id}"></a>
        		<li>
        			<!-- Имя и дата комментария-->
        			<div class="comment_header">	
        				<span class="comment_name">{$comment->name|escape}</span> <i>{$comment->date|date}, {$comment->date|time}</i>
        				{if !$comment->approved}<b>{$lang->ozhidaet_moderatsii}</b>{/if}
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
		    {$lang->poka_net_kommentariev}
    	</p>
	{/if}	
	<!--Форма отправления комментария-->

	<!--Подключаем js-проверку формы -->
	
	<form class="form comment_form" method="post" action="">
		<h2>{$lang->napisat_kommentarij}</h2>
		{if $error}
			<div class="message_error">
				{if $error=='captcha'}
					{$lang->neverno_vvedena_kapcha}
				{elseif $error=='empty_name'}
					{$lang->vvedite_imya}
				{elseif $error=='empty_comment'}
					{$lang->vvedite_kommentarij}
				{/if}
			</div>
		{/if}
		
		<div class="form_group">
			<label>{$lang->imya}</label>
			<input class="form_input" type="text" id="comment_name" name="name" value="{$comment_name|escape}" data-format=".+" data-notice="{$lang->vvedite_imya}" />
		</div>

		<label>{$lang->vvedite_kommentarij}</label>
		<textarea class="comment_textarea" id="comment_text" name="text" data-format=".+" data-notice="{$lang->vvedite_kommentarij}" >{$comment_text}</textarea>
		
		<div class="captcha">
			<img src="captcha/image.php?{math equation='rand(10,10000)'}"/>
			<input class="input_captcha" id="comment_captcha" type="text" name="captcha_code" value="" data-format="\d\d\d\d" data-notice="{$lang->vvedite_kapchu}" placeholder="{$lang->vvedite_kapchu}"/>
		</div>

		<input class="button" type="submit" name="comment" value="{$lang->otpravit}"/>
	</form>
	<!--Форма отправления комментария (The End)-->
</div>
<!-- Комментарии (The End) -->