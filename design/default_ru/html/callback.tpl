<div style="display: none;">
	<form id="callback_form" class="form" method="post">
		<div class="callback_title">Заказ обратного звонка</div>
		<div class="form_group">
			<label for="callback_name">Введите имя</label>
			<input id="callback_name" class="form_input" type="text" name="name" data-format=".+" data-notice="Введите имя" value=""/>
		</div>

		<div class="form_group">
			<label for="callback_phone">Введите № телефона</label>
			<input id="callback_phone" class="form_input" type="text" name="phone" data-format=".+" data-notice="Введите № телефона" value="" maxlength="255"/>
		</div>
		<input class="button" type="submit" name="callback" value="Заказать"/>
	</form>

	<a id="callback_sent" href="#callback_notice" class="callback_link"></a>
	<div id="callback_notice">
		<div class="callback_title">Ваша заявка принята</div>
		Мы свяжемся с Вами в ближайшее время
	</div>
</div>

{literal}
    <script>
        $(function() {
            $('.callback_link').fancybox();
        });
    </script>
{/literal}

{if $call_sent}
  {literal}
	<script>
	    $(function() {
			$('#callback_sent').trigger('click');
		});
	</script>
  {/literal}
{/if}