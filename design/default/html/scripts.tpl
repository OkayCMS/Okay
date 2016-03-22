<script>
	/* Глобальный обьект */
	/* все глобальные переменные добавляем в оъект и работаем с ним!!! */
	var okay = {literal}{}{/literal};
	{* Предзаказ *}
	okay.is_preorder = {$settings->is_preorder};
	{* Ошибка при отправке комментария в посте *}
	{if $smarty.get.module == 'BlogView' && $error}
		{* Переход по якорю к форме *}
		$( window ).load( function() {
			location.href = location.href + '#fn-blog_comment';
			$( '#fn-blog_comment' ).trigger( 'submit' );
		} );
	{/if}
	{* Обратный звонок, отправка формы *}
	{if $call_sent}
		$( function() {
			$.fancybox( {
				href: '#fn-callback-sent',
				padding: 0,
				minHeight: 0
			} );
		} );
	{/if}
	{* Карточка товара, ошибка в форме *}
	{if $smarty.get.module == 'ProductView' && $error}
		$( window ).load( function() {
			$( 'a[href="#comments"]' ).tab( 'show' );
			location.href = location.href + '#comments';
		} );
	{* Карточка товара, отправка комментария *}
	{elseif $smarty.get.module == 'ProductView'}
		$( window ).load( function() {
			if( location.hash.search('comment') !=-1 ) {
				$( 'a[href="#comments"]' ).tab( 'show' );
			}
		} );
	{/if}
	{if $subscribe_success}
		$( function() {
			$.fancybox( {
				href: '#fn-subscribe-sent',
				padding: 0,
				minHeight: 0,
                closeBtn: false
			} );
		} );
	{elseif $subscribe_error}
		$( window ).load( function() {
			location.href = location.href + '#subscribe_error';
		} );
	{/if}
</script>