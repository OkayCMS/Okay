<div style="display: none;">
	<form id="callback_form" class="form" method="post">
		<div class="callback_title">{$lang->zakaz_obratnogo_zvonka}</div>
		<div class="form_group">
			<label for="callback_name">{$lang->vvedite_imya}</label>
			<input id="callback_name" class="form_input" type="text" name="name" data-format=".+" data-notice="{$lang->vvedite_imya}" value=""/>
		</div>

		<div class="form_group">
			<label for="callback_phone">{$lang->vvedite_nomer_telefona}</label>
			<input id="callback_phone" class="form_input" type="text" name="phone" data-format=".+" data-notice="{$lang->vvedite_nomer_telefona}" value="" maxlength="255"/>
		</div>
		<input class="button" type="submit" name="callback" value="{$lang->zakazat}"/>
	</form>

	<a id="callback_sent" href="#callback_notice" class="callback_link"></a>
	<div id="callback_notice">
		<div class="callback_title">{$lang->vasha_zayavka_prinyata}</div>
		{$lang->my_svyazhemsya_s_vami_v_blizhajshee_vremya}
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