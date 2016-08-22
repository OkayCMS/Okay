{capture name=tabs}
    <li>
        <a href="index.php?module=ThemeAdmin">Тема</a>
    </li>
    <li>
        <a href="index.php?module=TemplatesAdmin">Шаблоны</a>
    </li>
    <li>
        <a href="index.php?module=StylesAdmin">Стили</a>
    </li>
    <li>
        <a href="index.php?module=ScriptsAdmin">Скрипты</a>
    </li>
    <li>
        <a href="index.php?module=ImagesAdmin">Изображения</a>
    </li>
    <li class="active">
        <a href="index.php?module=RobotsAdmin">Robots.txt</a>
    </li>
{/capture}


{$meta_title = "Robots.txt $style_file" scope=parent}

{if $message_error}
    <!-- Системное сообщение -->
    <div class="message message_error">
        <span class="text">
        {if $message_error == 'write_error'}
            Установите права на запись файла robots.txt
        {/if}
        </span>
    </div>
    <!-- Системное сообщение (The End)-->
{/if}

{if $message_success}
    <!-- Системное сообщение -->
    <div class="message message_success">
        <span class="text">{if $message_success == 'updated'}Robots обновлен{/if}</span>
    </div>
    <!-- Системное сообщение (The End)-->
{/if}

<form method="post">
    <input type=hidden name="session_id" value="{$smarty.session.id}">
    <div class="block layer">
        <h2>Файл robots.txt</h2>
        <div>
            <textarea class="settings_robots_area" name="robots">{$robots_txt|escape}</textarea>
        </div>
    </div>
    <input class="button_green button_save" type="submit" name="save" value="Сохранить" />
</form>
