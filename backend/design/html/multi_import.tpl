{capture name=tabs}
    {if in_array('import', $manager->permissions)}
        <li>
            <a href="index.php?module=ImportAdmin">Импорт</a>
        </li>
    {/if}
    {if in_array('export', $manager->permissions)}
        <li>
            <a href="index.php?module=ExportAdmin">Экспорт</a>
        </li>
    {/if}
    <li class="active">
        <a href="index.php?module=MultiImportAdmin">Импорт переводов</a>
    </li>
    {if in_array('export', $manager->permissions)}
        <li>
            <a href="index.php?module=MultiExportAdmin">Экспорт переводов</a>
        </li>
    {/if}
    <li>
        <a href="index.php?module=ImportLogAdmin">Лог импорта</a>
    </li>
{/capture}
{$meta_title='Мультиязычный импорт товаров' scope=parent}

<script src="{$config->root_url}/backend/design/js/piecon/piecon.js"></script>
<script>
    {if $filename && $message_error != 'no_languages'}
        {literal}
            var lang_id = {/literal}{$smarty.post.import_lang_id}{literal};
            // On document load
            $(function() {
                Piecon.setOptions({fallback: 'force'});
                Piecon.setProgress(0);
                $("#progressbar").progressbar({ value: 1 });
                do_import();
            });

            function do_import(from) {
                from = typeof(from) != 'undefined' ? from : 0;
                $.ajax({
                    url: "ajax/multi_import.php",
                    data: {from:from, lang_id:lang_id},
                    dataType: 'json',
                    success: function(data){
                        if (data.error) {
                            var error = '';
                            if (data.missing_fields) {
                                error = '<span>В файле импорта отсутсвтуют необходимые столбцы: </span><b>';
                                for (var i in data.missing_fields) {
                                    error += data.missing_fields[i] + ', ';
                                }
                                error = error.substring(0, error.length-2);
                                error += '</b>';
                            }

                            $("#progressbar").hide('fast');
                            $('#import_error').html(error);
                            $('#import_error').show();
                        } else {
                            Piecon.setProgress(Math.round(100 * data.from / data.totalsize));
                            $("#progressbar").progressbar({value: 100 * data.from / data.totalsize});
                            if (data != false && !data.end) {
                                do_import(data.from);
                            } else {
                                Piecon.setProgress(100);
                                $("#progressbar").hide('fast');
                                $("#import_result").show();
                            }
                        }
                    },
                    error: function(xhr, status, errorThrown) {
                        alert(errorThrown+'\n'+xhr.responseText);
                    }
                });
            }
        {/literal}
    {/if}
</script>

<style>
    .ui-progressbar-value { background-color:#b4defc; background-image: url(design/images/progress.gif); background-position:left; border-color: #009ae2;}
    #progressbar{ clear: both; height:29px;}
    #result{ clear: both; width:100%;}
</style>

<div id="import_error" class="message message_error" style="display: none;"></div>

{if $message_error}
    <!-- Системное сообщение -->
    <div class="message message_error">
	<span class="text">
	{if $message_error == 'no_permission'}Установите права на запись в папку {$import_files_dir}
    {elseif $message_error == 'convert_error'}Не получилось сконвертировать файл в кодировку UTF8
    {elseif $message_error == 'locale_error'}На сервере не установлена локаль {$locale}, импорт может работать некорректно
    {elseif $message_error == 'no_languages'}Языков в системе не обнаружено
    {else}{$message_error}{/if}
	</span>
    </div>
    <!-- Системное сообщение (The End)-->
{/if}

{if $message_error != 'no_permission' && $message_error != 'no_languages'}

    {if $filename}
        <div>
            <h1>Импорт {$filename|escape}</h1>
        </div>
        <div id='progressbar'></div>
        <div id='import_result' style="display: none; clear: left;">
            <a href="index.php?module=ImportLogAdmin" target="_blank">Лог последнего импорта</a>
        </div>
    {else}
        <h1>Мультиязычный импорт товаров</h1>
        <div class="block">
            <form method=post id=product enctype="multipart/form-data">
                <input type=hidden name="session_id" value="{$smarty.session.id}">
                {if $languages}
                    <select name="import_lang_id">
                        {foreach $languages as $l}
                            <option value="{$l->id}" {if $l->id==$lang_id_default}selected=""{/if}>{$l->name|escape}</option>
                        {/foreach}
                    </select>
                {/if}
                <input name="file" class="import_file" type="file" value="" />
                <input class="button_green" type="submit" name="" value="Загрузить" />
                <p>
                    (максимальный размер файла &mdash; {if $config->max_upload_filesize>1024*1024}{$config->max_upload_filesize/1024/1024|round:'2'} МБ{else}{$config->max_upload_filesize/1024|round:'2'} КБ{/if})
                </p>
            </form>
        </div>

        <div class="block block_help">
            <p>
                Создайте бекап на случай неудачного импорта.
            </p>
            <p>
                Сохраните таблицу в формате CSV
            </p>
            <p>
                В первой строке таблицы должны быть указаны названия колонок в таком формате:
            <ul>
                <li><label>Товар</label> название товара</li>
                <li><label>ID варианта</label>ID варианта в системе</li>
                <li><label>Вариант</label> название варианта</li>
                <li><label>Цена</label> цена товара</li>
                <li><label>ID валюты</label>ID валюты в системе</li>
                <li><label>Старая цена</label> старая цена товара</li>
                <li><label>Аннотация</label> краткое описание товара</li>
                <li><label>Описание</label> полное описание товара</li>
                <li><label>Заголовок страницы</label> заголовок страницы товара (Meta title)</li>
                <li><label>Ключевые слова</label> ключевые слова (Meta keywords)</li>
                <li><label>Описание страницы</label> описание страницы товара (Meta description)</li>
            </ul>
            </p>
            <p>
                Любое другое название колонки трактуется как название свойства товара
            </p>
            <p>
                <a href='files/import/multi_example.csv'>Скачать пример файла</a>
            </p>
        </div>
    {/if}
{/if}