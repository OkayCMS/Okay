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
    {if in_array('import', $manager->permissions)}
        <li>
            <a href="index.php?module=MultiImportAdmin">Импорт переводов</a>
        </li>
    {/if}
    <li class="active">
        <a href="index.php?module=MultiExportAdmin">Экспорт переводов</a>
    </li>
    {if in_array('import', $manager->permissions)}
        <li>
            <a href="index.php?module=ImportLogAdmin">Лог импорта</a>
        </li>
    {/if}
{/capture}
{$meta_title='Мультиязычный експорт товаров' scope=parent}

<script src="{$config->root_url}/backend/design/js/piecon/piecon.js"></script>
<script>
    {literal}

    var in_process=false;
    var field = '',
        value = '',
        lang_id = 0;

    $(function() {

        $('.fn-type').on('change', function() {
            $('.fn-select').hide();
            $('.fn-select.fn-select'+$(this).val()).show();
        });

        // On document load
        $('input#start').click(function() {
            var elem = $('.fn-select:visible');
            if (elem) {
                field = elem.attr('name');
                value = elem.val();
            }
            lang_id = $('select[name=lang_id]').find('option:selected').val();
            if (!lang_id) {
                alert('missing language');
                return false;
            }

            Piecon.setOptions({fallback: 'force'});
            Piecon.setProgress(0);
            $("#progressbar").progressbar({ value: 0 });

            $("#start").hide('fast');
            do_export();

        });

        function do_export(page)
        {
            page = typeof(page) != 'undefined' ? page : 1;
            var data = {page: page, lang_id: lang_id};
            if (field && value) {
                data[field] = value;
            }

            $.ajax({
                url: "ajax/multi_export.php",
                data: data,
                dataType: 'json',
                success: function(data){

                    if(data && !data.end)
                    {
                        Piecon.setProgress(Math.round(100*data.page/data.totalpages));
                        $("#progressbar").progressbar({ value: 100*data.page/data.totalpages });
                        do_export(data.page*1+1);
                    }
                    else
                    {
                        if(data && data.end)
                        {
                            Piecon.setProgress(100);
                            $("#progressbar").hide('fast');
                            window.location.href = 'files/export/multi_export.csv';
                        }
                    }
                },
                error:function(xhr, status, errorThrown) {
                    alert(errorThrown+'\n'+xhr.responseText);
                }

            });

        }

    });
    {/literal}
</script>

<style>
    .ui-progressbar-value { background-image: url(design/images/progress.gif); background-position:left; border-color: #009ae2;}
    #progressbar{ clear: both; height:29px; }
    #result{ clear: both; width:100%;}
    #download{ display:none;  clear: both; }
</style>


{if $message_error}
    <!-- Системное сообщение -->
    <div class="message message_error">
	<span class="text">
	{if $message_error == 'no_permission'}Установите права на запись в папку {$export_files_dir}
    {elseif $message_error == 'no_languages'}Языков в системе не обнаружено
    {else}{$message_error}
    {/if}
	</span>
    </div>
    <!-- Системное сообщение (The End)-->
{/if}

<div>
    <h1>Мультиязычный експорт товаров</h1>
    {if !$message_error}
        <div id='progressbar'></div>
        <div id="start">
            <input class="button_green" id="start" type="button" name="" value="Экспортировать" />
            {if $languages}
                <select name='lang_id'>
                    {foreach $languages as $l}
                        <option value="{$l->id}" {if $l->id == $lang_id_default}selected=""{/if}>{$l->name|escape}</option>
                    {/foreach}
                </select>
            {/if}
            <select class="fn-type">
                <option value="0">Все товары</option>
                {if $brands}
                    <option value="1">По брендам</option>
                {/if}
                {if $categories}
                    <option value="2">По категориям</option>
                {/if}
            </select>
            {if $brands}
                <select class="fn-select fn-select1" name="brand_id" style="display: none;">
                    {foreach $brands as $b}
                        <option value="{$b->id}" {if $b@first}selected=""{/if}>{$b->name|escape}</option>
                    {/foreach}
                </select>
            {/if}
            {if $categories}
                <select class="fn-select fn-select2" name="category_id" style="display: none;">
                    {function name=categories_tree}
                        {foreach $categories as $c}
                            <option value="{$c->id}">{section name=sp loop=$level}&nbsp;&nbsp;&nbsp;&nbsp;{/section}{$c->name|escape}</option>
                            {categories_tree categories=$c->subcategories level=$level+1}
                        {/foreach}
                    {/function}
                    {categories_tree categories=$categories level=0}
                </select>
            {/if}
        </div>
    {/if}
</div>

