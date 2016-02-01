{* Страница отдельной записи блога *}
{* Канонический адрес страницы *}
{$canonical="/blog/{$post->url}" scope=parent}
{* @END Канонический адрес страницы *}
<div class="container">
	{* Хлебные крошки *}
	{include file='breadcrumb.tpl'}
	{* @END Хлебные крошки *}
	{* Заголовок страницы *}
	<h1>
		<span data-post="{$post->id}">{$post->name|escape}</span>
	</h1>
	{* @END Заголовок страницы *}
	{* Дата создания поста *}
	<div class="m-b-1">
		<span class="blog-data static">{$post->date|date}</span>
	</div>
	{* @END Дата создания поста *}
	{* Тело поста *}
	{$post->text}
	{* @END Тело поста *}
	{* Соседние посты *}
	{if $prev_post || $next_post}
		<nav>
			<ol class="pager">
				<li>
					{if $prev_post}
						<a href="blog/{$prev_post->url}">← {$prev_post->name}</a>
					{/if}
				</li>
				<li>
					{if $next_post}
						<a href="blog/{$next_post->url}">{$next_post->name} →</a>
					{/if}
				</li>
			</ol>
		</nav>
	{/if}
	{* @END Соседние посты *}
	<div id="comments" class="m-t-2">
		<div class="h3 m-b-1">
			<span data-language="{$translate_id['post_comments']}">{$lang->post_comments}</span>
		</div>
		{* Список с комментариями *}
		{if $comments}
			{foreach $comments as $comment}
				{* Якорь комментария *}
				{* после добавления комментария кидает автоматически по якорю *}
				<a name="comment_{$comment->id}"></a>
				{* @END Якорь комментария *}
				<div class="m-b-1">
					{* Имя комментария *}
					<div>
						<span class="h5">{$comment->name|escape}</span>
					</div>
					{* @END Имя комментария *}
					<div class="p-y-05">
						{* Дата комментария *}
						<span class="blog-data static">{$comment->date|date}, {$comment->date|time}</span>
						{* @END Дата комментария *}
						{* Статус комментария *}
						{if !$comment->approved}
							<span class="font-weight-bold text-muted" data-language="{$translate_id['post_comment_status']}">({$lang->post_comment_status})</span>
						{/if}
						{* @END Статус комментария *}
					</div>
					{* Тело комментария *}
					{$comment->text|escape|nl2br}
					{* @END Тело комментария *}
				</div>
			{/foreach}
		{else}
			<div class="text-muted">
				<span data-language="{$translate_id['post_no_comments']}">{$lang->post_no_comments}</span>
			</div>
		{/if}
		{* @END Список с комментариями *}
		{* Форма отправления комментария *}
		<form id="fn-blog_comment" class="col-lg-6 m-y-2 p-y-1 bg-info" method="post" action="">
			<div class="h3 text-xs-center">
				<span data-language="{$translate_id['cart_header']}">{$lang->post_write_comment}</span>
			</div>
			{* Вывод ошибок формы *}
			{if $error}
				<div class="p-x-1 p-y-05 m-b-1 bg-danger text-white">
					{if $error=='captcha'}
						<span data-language="{$translate_id['form_error_captcha']}">{$lang->form_error_captcha}</span>
					{elseif $error=='empty_name'}
						<span data-language="{$translate_id['form_enter_name']}">{$lang->form_enter_name}</span>
					{elseif $error=='empty_comment'}
						<span data-language="{$translate_id['form_enter_comment']}">{$lang->form_enter_comment}</span>
					{/if}
				</div>
			{/if}
			{* Вывод ошибок формы *}
			<div class="row">
				{* Имя комментария *}
				<div class="col-lg-6 form-group">
					<input class="form-control" type="text" name="name" value="{$comment_name|escape}" data-format=".+" data-notice="{$lang->form_enter_name}" data-language="{$translate_id['form_name']}" placeholder="{$lang->form_name}*"/>
				</div>
				{* @END Имя комментария *}
				{if $settings->captcha_post}
					<div class="col-xs-12 col-lg-6 form-inline m-b-1-md_down">
						{* Изображение капчи *}
						<div class="form-group">
							<img class="brad-3" src="captcha/image.php?{math equation='rand(10,10000)'}" alt='captcha'/>
						</div>
						{* @END Изображение капчи *}
						{* Поле ввода капчи *}
						<div class="form-group">
							<input class="form-control" type="text" name="captcha_code" value="" data-format="\d\d\d\d\d" data-notice="{$lang->form_enter_captcha}" data-language="{$translate_id['form_enter_captcha']}" placeholder="{$lang->form_enter_captcha}*"/>
						</div>
						{* @END Поле ввода капчи *}
					</div>
				{/if}
			</div>
			{* Текст комментария *}
			<div class="form-group">
				<textarea class="form-control" rows="3" name="text" data-format=".+" data-notice="{$lang->form_enter_comment}" data-language="{$translate_id['form_enter_comment']}" placeholder="{$lang->form_enter_comment}*">{$comment_text}</textarea>
			</div>
			{* @END Текст комментария *}
			{* Кнопка отправки формы *}
			<div class="text-xs-center">
				<input class="btn btn-warning" type="submit" name="comment" data-language="{$translate_id['form_send']}" value="{$lang->form_send}"/>
			</div>
			{* @END Кнопка отправки формы *}
		</form>
		{* @END Форма отправления комментария *}
	</div>
</div>