{$meta_title=$btr->import_products scope=parent}

<div class="row">
    <div class="col-lg-7 col-md-7">
        <div class="heading_page">
            {$btr->import_products|escape}
            <div class="export_block export_users hint-bottom-middle-t-info-s-small-mobile  hint-anim" data-hint="{$btr->general_example|escape}">
                <a class="export_block" href="files/import/example.csv" target="_blank">
                   <i class="fa fa-file"></i>
                </a>
            </div>
        </div>
    </div>
</div>

<div id="import_error" class="boxed boxed_warning" style="display: none;"></div>

{if $message_error}
    <!-- Системное сообщение -->
    <div class="row">
        <div class="col-lg-12 col-md-12 col-sm-12">
            <div class="boxed boxed_warning">
                <div class="">
                   {if $message_error == 'no_permission'}
                        {$btr->general_permissions|escape} {$import_files_dir|escape}
                    {elseif $message_error == 'convert_error'}
                        {$btr->import_utf|escape}
                    {elseif $message_error == 'locale_error'}
                        {$btr->import_locale|escape} {$locale|escape} {$btr->import_not_correctly|escape}
                    {elseif $message_error == 'upload_error'}
                       {$btr->upload_error|escape}
                    {else}
                        {$message_error|escape}
                    {/if}
                </div>
            </div>
        </div>
    </div>
    <!-- Системное сообщение (The End)-->
{/if}

{if $message_error != 'no_permission'}
    {if $filename}
    <div class="row">
        <div class="col-lg-12 col-md-12">
            <div class="boxed fn_toggle_wrap ">
                <div class="heading_box boxes_inline">
                    {$btr->import_file|escape} {if $filename}{$filename|escape}{/if}
                </div>
                {if $filename}
                    <div id='import_result' class="boxes_inline" style="display: none;">
                        <a class="btn btn_small btn-info" href="index.php?module=ImportLogAdmin" target="_blank">{$btr->import_log|escape}</a>
                    </div>
                    <div>
                        <progress id="progressbar" class="progress progress-xs progress-info mt-1" style="display: none" value="0" max="100"></progress>
                    </div>
                {/if}
            </div>
        </div>
    </div>
    {/if}
    <div class="row">
        <div class="col-lg-12 col-md-12">
            <div class="boxed fn_toggle_wrap">
                <div class="heading_box">
                    {$btr->import_download|escape}
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="icon-arrow-down"></i></a>
                    </div>
                </div>

                <div class="row">
                    <div class="col-lg-12 col-md-12 col-sm-12">
                        <div class="text_warning">
                            <div class="heading_normal text_warning">
                                <span class="text_warning">{$btr->import_backup|escape}</span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-12 col-md-12 col-sm-12">
                        <div class="text_primary">
                            <div class="heading_normal text_primary">
                                <span class="text_primary">
                                 {$btr->import_maxsize|escape}
                                    {if $config->max_upload_filesize>1024*1024}
                                        {$config->max_upload_filesize/1024/1024|round:'2'} {$btr->general_mb|escape}
                                    {else}
                                        {$config->max_upload_filesize/1024|round:'2'} {$btr->general_kb|escape}
                                    {/if}
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
                <form class="form-horizontal mt-1" method="post" enctype="multipart/form-data">
                    <div class="row">
                        <div class="col-lg-5 col-md-6 col-sm-12 my-h">
                            <input type=hidden name="session_id" value="{$smarty.session.id}">
                            <input name="file" class="import_file" style="padding:0px;" type="file" value="" />
                        </div>
                        <div class="col-lg-7 col-md-6 my-h">
                            <button type="submit" class="btn btn_small btn_blue float-md-right"><i class="fa fa-upload"></i>&nbsp;{$btr->import_to_download|escape}</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
{/if}

<script src="{$config->root_url}/backend/design/js/piecon/piecon.js"></script>
<script>
{if $filename}
    {literal}
        // On document load
        $(function(){
            Piecon.setOptions({fallback: 'force'});
            Piecon.setProgress(0);
            var progress_item = $("#progressbar"); //указываем селектор элемента с анимацией
            progress_item.show();
            do_import('',progress_item);
        });

        function do_import(from,progress)
        {
            from = typeof(from) != 'undefined' ? from : 0;
            $.ajax({
                 url: "ajax/import.php",
                    data: {from:from},
                    dataType: 'json',
                    success: function(data){
                        if (data.error) {
                            var error = '';
                            if (data.missing_fields) {
                                error = '<span class="heading_box">В файле импорта отсутствуют необходимые столбцы: </span><b>';
                                for (var i in data.missing_fields) {
                                    error += data.missing_fields[i] + ', ';
                                }
                                error = error.substring(0, error.length-2);
                                error += '</b>';
                            }

                            progress.fadeOut(500);
                            $('#import_error').html(error);
                            $('#import_error').show();
                        } else {
                            Piecon.setProgress(Math.round(100 * data.from / data.totalsize));
                            progress.attr('value',100*data.from/data.totalsize);

                            if (data != false && !data.end) {
                                do_import(data.from,progress);
                            } else {
                                Piecon.setProgress(100);
                                progress.attr('value','100');
                                $("#import_result").show();
                                progress.fadeOut(500);
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
