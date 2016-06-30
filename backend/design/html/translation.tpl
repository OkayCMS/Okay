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

{* On document load *}
{literal}
<script>
$(function() {

	$('textarea').on( "focusout", function(){

	    label = $(this).val();
	    label = label.replace(/[\s]+/gi, '_');
	    label = translit(label);
	    label = label.replace(/[^0-9a-z_\-]+/gi, '').toLowerCase();

    	if(($('input[name="label"]').val() == label || $('input[name="label"]').val() == ''))
            $('input[name="label"]').val(label);
    });

});

function translit(str)
{
	var ru=("А-а-Б-б-В-в-Ґ-ґ-Г-г-Д-д-Е-е-Ё-ё-Є-є-Ж-ж-З-з-И-и-І-і-Ї-ї-Й-й-К-к-Л-л-М-м-Н-н-О-о-П-п-Р-р-С-с-Т-т-У-у-Ф-ф-Х-х-Ц-ц-Ч-ч-Ш-ш-Щ-щ-Ъ-ъ-Ы-ы-Ь-ь-Э-э-Ю-ю-Я-я").split("-")
	var en=("A-a-B-b-V-v-G-g-G-g-D-d-E-e-E-e-E-e-ZH-zh-Z-z-I-i-I-i-I-i-J-j-K-k-L-l-M-m-N-n-O-o-P-p-R-r-S-s-T-t-U-u-F-f-H-h-TS-ts-CH-ch-SH-sh-SCH-sch-'-'-Y-y-'-'-E-e-YU-yu-YA-ya").split("-")
 	var res = '';
	for(var i=0, l=str.length; i<l; i++)
	{
		var s = str.charAt(i), n = ru.indexOf(s);
		if(n >= 0) { res += en[n]; }
		else { res += s; }
    }
    return res;
}
</script>

{/literal}

{if $translation->id}
{$meta_title = $translation->label scope=parent}
{else}
{$meta_title = 'Новый перевод' scope=parent}
{/if}

{if $message_success}
    <!-- Системное сообщение -->
    <div class="message message_success">
        <span>{if $message_success == 'added'}Перевод добавлен{elseif $message_success == 'updated'}Перевод обновлен{/if}</span>
        <a class="button" href="{url module=TranslationsAdmin}">Вернуться</a>
    </div>
    <!-- Системное сообщение (The End)-->
{/if}

{if $message_error}
    <!-- Системное сообщение -->
    <div class="message message_error">
        <span>
        {if $message_error == 'label_empty'}Переменная пуста{/if}
        {if $message_error == 'label_exists'}Переменная уже используется{/if}
        {if $message_error == 'label_is_class'}Переменная с именем определённым в api/Okay.php не допустима!!!{/if}
        </span>
        <a class="button" href="{url module=TranslationsAdmin}">Вернуться</a>
    </div>
    <!-- Системное сообщение (The End)-->
{/if}


<!-- Основная форма -->
<form method=post id=product enctype="multipart/form-data">
<input type=hidden name="session_id" value="{$smarty.session.id}">
<input name=id type="hidden" value="{$translation->id}"/>

	<div id="column_left">
		<div class="block">
			<h2>Перевод</h2>
            <BR>
			<ul>
				<li><label class=property>Переменная
                        <div class="helper_wrap">
                            <a href="javascript:;" id="show_help_search" class="helper_link"></a>
                            <div class="right helper_block">
                                <span>
                                    Название переменной, которая используется в шаблоне
                                </span>
                            </div>
                        </div>
                    </label>
                    <input name="label" class="okay_inp" type="text" value="{$translation->label}" /></li>
                {foreach $languages as $lang}
				<li>
                    <label class=property>{$lang->name}</label>
                    <textarea name="lang_{$lang->label}" class="okay_inp">{$translation->lang_{$lang->label}}</textarea>
                </li>
                {/foreach}
			</ul>
		</div>
        <input class="button_green button_save" type="submit" name="" value="Сохранить" />
    </div>

</form>
<!-- Основная форма (The End) -->

