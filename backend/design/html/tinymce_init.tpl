{if $config->subfolder !='/'}
    <script type="text/javascript" src="/{$config->subfolder}backend/design/js/tinymce_jq/tinymce.min.js"></script>
{else}
    <script type="text/javascript" src="/backend/design/js/tinymce_jq/tinymce.min.js"></script>
{/if}

<script>
    $(function(){
        tinyMCE.init({literal}{{/literal}
            selector: "textarea.editor_large, textarea.editor_small",
            height: '300',
            plugins: [
                "advlist autolink lists link image preview anchor responsivefilemanager",
                "hr visualchars autosave noneditable searchreplace wordcount visualblocks",
                "code fullscreen save textcolor colorpicker charmap nonbreaking",
                "insertdatetime media table contextmenu paste imagetools"
            ],
            toolbar_items_size : 'small',
            menubar:'file edit insert view format table tools',
            toolbar1: "restoredraft save fontselect formatselect fontsizeselect | bold italic underline | alignleft aligncenter alignright alignjustify | bullist numlist | forecolor backcolor | table | link unlink anchor media image | fullscreen visualblocks visualchars code",
            statusbar: true,
            font_formats: "Andale Mono=andale mono,times;"+
            "Arial=arial,helvetica,sans-serif;"+
            "Arial Black=arial black,avant garde;"+
            "Book Antiqua=book antiqua,palatino;"+
            "Comic Sans MS=comic sans ms,sans-serif;"+
            "Courier New=courier new,courier;"+
            "Georgia=georgia,palatino;"+
            "Helvetica=helvetica;"+
            "Impact=impact,chicago;"+
            "Symbol=symbol;"+
            "Tahoma=tahoma,arial,helvetica,sans-serif;"+
            "Terminal=terminal,monaco;"+
            "Times New Roman=times new roman,times;"+
            "Trebuchet MS=trebuchet ms,geneva;"+
            "Verdana=verdana,geneva;"+
            "Webdings=webdings;"+
            "Wingdings=wingdings,zapf dingbats",


            image_advtab: true,
            {if $config->subfolder !='/'}
            external_filemanager_path:"/{$config->subfolder}backend/design/js/filemanager/",
            filemanager_title:"{$btr->tinymce_init_filemanager|escape}" ,
            external_plugins: { "filemanager" : "/{$config->subfolder}backend/design/js/filemanager/plugin.min.js"},
            {else}
            external_filemanager_path:"/backend/design/js/filemanager/",
            filemanager_title:"{$btr->tinymce_init_filemanager|escape}" ,
            external_plugins: { "filemanager" : "/backend/design/js/filemanager/plugin.min.js"},
            {/if}


            save_enablewhendirty: true,
            save_title: "save",
            theme_advanced_buttons3_add : "save",
            save_onsavecallback: function() {literal}{{/literal}
                $("[type='submit']").trigger("click");
                {literal}}{/literal},

            language : "{$manager->lang}",
            /* Замена тега P на BR при разбивке на абзацы
             force_br_newlines : true,
             force_p_newlines : false,
             forced_root_block : '',
             */
            {if $smarty.get.module != "SeoPatternsAdmin"}
                setup : function(ed) {
                    ed.on('keyup change', (function() {
                        set_meta();
                    }));
                }
            {/if}

            {literal}}{/literal});
    });

</script>
