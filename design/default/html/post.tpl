{* Страница отдельной записи блога *}
{* Канонический адрес страницы *}
{$canonical="/blog/{$post->url}" scope=parent}

<div class="container">
	{* Хлебные крошки *}
	{include file='breadcrumb.tpl'}

	{* Заголовок страницы *}
	<h1>
		<span data-post="{$post->id}">{$post->name|escape}</span>
	</h1>

	{* Дата создания поста *}
	<div class="m-b-1">
		<span class="blog-data static">{$post->date|date}</span>
	</div>

	{* Тело поста *}
	{$post->text}

    {* Поделиться в соц. сетях *}
    <div class="p-y-05 text-xs-center text-md-left">
        <span data-language="{$translate_id['product_share']}">{$lang->product_share}</span>:
    </div>
    <div class="ya-share2 m-b-2 text-xs-center text-md-left" data-services="vkontakte,facebook,twitter"></div>

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

    {* Связанные товары *}
    {if $related_products}
        <div class="p-y-2">
            <div class="container">
                <div class="h1 m-b-1">
                    <span data-language="{$translate_id['product_recommended_products']}">{$lang->product_recommended_products}</span>
                </div>
                <div class="row">
                    {foreach $related_products as $p}
                        <div class="col-md-4 col-xl-3{if $p@iteration == 4} hidden-lg{/if}">
                            {include "tiny_products.tpl" product = $p}
                        </div>
                        {if $p@iteration % 4 == 0}<div class="col-xs-12 hidden-sm-down"></div>{/if}
                    {/foreach}
                </div>
            </div>
        </div>
    {/if}

	<div id="comments" class="m-t-2">
		<div class="h3 m-b-1">
			<span data-language="{$translate_id['post_comments']}">{$lang->post_comments}</span>
		</div>
		{* Список с комментариями *}
		{if $comments}
            {function name=comments_tree level=0}
                {foreach $comments as $comment}
                    {* Якорь комментария *}
                    {* после добавления комментария кидает автоматически по якорю *}
                    <a name="comment_{$comment->id}"></a>

                    <div class="m-b-1 {if $level > 0}admin_note{/if}" style="margin-left:{$level*20}px">
                        {* Имя комментария *}
                        <div>
                            <span class="h5">{$comment->name|escape}</span>
                        </div>
                        <div class="p-y-05">
                            {* Дата комментария *}
                            <span class="blog-data static">{$comment->date|date}, {$comment->date|time}</span>

                            {* Статус комментария *}
                            {if !$comment->approved}
                                <span class="font-weight-bold text-muted" data-language="{$translate_id['post_comment_status']}">({$lang->post_comment_status})</span>
                            {/if}
                        </div>
                        {* Тело комментария *}
                        {$comment->text|escape|nl2br}
                        {if isset($children[$comment->id])}
                            {comments_tree comments=$children[$comment->id] level=$level+1}
                        {/if}
                    </div>
                {/foreach}
            {/function}
            {comments_tree comments=$comments}
		{else}
			<div class="text-muted">
				<span data-language="{$translate_id['post_no_comments']}">{$lang->post_no_comments}</span>
			</div>
		{/if}

		{* Форма отправления комментария *}
		<form id="fn-blog_comment" class="col-lg-6 m-y-2 p-y-1 bg-info" method="post" action="">
			<div class="h3 text-xs-center">
				<span data-language="{$translate_id['cart_header']}">{$lang->post_write_comment}</span>
			</div>
			{* Вывод ошибок формы *}
			{if $error}
				<div class="p-x-1 p-y-05 m-b-1 text-red">
					{if $error=='captcha'}
						<span data-language="{$translate_id['form_error_captcha']}">{$lang->form_error_captcha}</span>
					{elseif $error=='empty_name'}
						<span data-language="{$translate_id['form_enter_name']}">{$lang->form_enter_name}</span>
					{elseif $error=='empty_comment'}
						<span data-language="{$translate_id['form_enter_comment']}">{$lang->form_enter_comment}</span>
					{/if}
				</div>
			{/if}
			<div class="row m-b-1">
				{* Имя комментария *}
				<div class="col-lg-6 form-group">
					<input class="form-control" type="text" name="name" value="{$comment_name|escape}" data-format=".+" data-notice="{$lang->form_enter_name}" data-language="{$translate_id['form_name']}" placeholder="{$lang->form_name}*"/>
				</div>
                <div class="col-lg-6 form-group">
                    <input class="form-control" type="text" name="email" value="{$comment_email|escape}" data-language="{$translate_id['form_email']}" placeholder="{$lang->form_email}"/>
                </div>
			</div>
			{* Текст комментария *}
			<div class="form-group">
				<textarea class="form-control" rows="3" name="text" data-format=".+" data-notice="{$lang->form_enter_comment}" data-language="{$translate_id['form_enter_comment']}" placeholder="{$lang->form_enter_comment}*">{$comment_text}</textarea>
			</div>
            {if $settings->captcha_post}
                <div class="col-xs-12 col-lg-7 form-inline m-b-1-md_down p-l-0">
                    {* Изображение капчи *}
                    <div class="form-group">
                        <img class="brad-3" src="captcha/image.php?{math equation='rand(10,10000)'}" alt='captcha'/>
                    </div>

                    {* Поле ввода капчи *}
                    <div class="form-group">
                        <input class="form-control" type="text" name="captcha_code" value="" data-format="\d\d\d\d\d" data-notice="{$lang->form_enter_captcha}" data-language="{$translate_id['form_enter_captcha']}" placeholder="{$lang->form_enter_captcha}*"/>
                    </div>
                </div>
            {/if}
			{* Кнопка отправки формы *}
			<div class="text-xs-center">
				<input class="btn btn-warning" type="submit" name="comment" data-language="{$translate_id['form_send']}" value="{$lang->form_send}"/>
			</div>
		</form>
	</div>
</div>