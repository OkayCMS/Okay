{* Вкладки *}
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
    <li class="active">
        <a href="index.php?module=LanguagesAdmin">Языки</a>
    </li>
    {if in_array('languages', $manager->permissions)}
        <li>
            <a href="index.php?module=TranslationsAdmin">Переводы</a>
        </li>
    {/if}
{/capture}

{if $language->id}
    {$meta_title = $language->{'name_'|cat:$current_language->label}|escape scope=parent}
{else}
    {$meta_title = 'Новый язык' scope=parent}
{/if}

{if $message_success}
    <!-- Системное сообщение -->
    <div class="message message_success">
        <span>{if $message_success == 'added'}Язык добавлен{elseif $message_success == 'updated'}Язык обновлен{/if}</span>
        {if $smarty.get.return}
        <a class="button" href="{$smarty.get.return}">Вернуться</a>
        {/if}
    </div>
    <!-- Системное сообщение (The End)-->
{/if}

{if $message_error}
    <!-- Системное сообщение -->
    <div class="message message_error">
        <span>
        {if $message_error == 'label_empty'}Метка пуста{/if}
        {if $message_error == 'label_exists'}Метка уже используется{/if}
        </span>
        <a class="button" href="">Вернуться</a>
    </div>
    <!-- Системное сообщение (The End)-->
{/if}


<!-- Основная форма -->
<form method=post id=product enctype="multipart/form-data">
    <input type=hidden name="session_id" value="{$smarty.session.id}">
    <input name=id type="hidden" value="{$language->id}"/>
    <div id="name">
        <div class="checkbox">
            <input name="enabled" value="1" type="checkbox" id="active_checkbox" {if $language->enabled}checked=""{/if}/>
            <label class="visible_icon" for="active_checkbox">Активен</label>
        </div>
    </div>

    <div id="column_left">
        <div class="block layer">
            {if !$language->id}
                <h2>Выберите из списка</h2>
                <ul>
                    <li>
                        <label class=property>Язык</label>
                        <select name="lang" size="1">
                            {foreach $lang_list as $lang}<option value='{$lang->label}'>{$lang->name}</option>{/foreach}
                        </select>
                    </li>
                </ul>
            {else}
                <h2>Переводы</h2>
                <ul>
                    {foreach $languages as $l}
                        <li>
                            <label class=property>{$l->name}</label>
                            <input type="text" name="name_{$l->label}" value="{$language->name_{$l->label}}" class="okay_inp"/>
                        </li>
                    {/foreach}
                </ul>
            {/if}
        </div>
        <input class="button" type="submit" name="" value="Сохранить" />
    </div>
</form>
<!-- Основная форма (The End) -->

