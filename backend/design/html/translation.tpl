{if $translation->id}
    {$meta_title = $translation->label scope=global}
{else}
    {$meta_title = $btr->translation_new scope=global}
{/if}

{*Название страницы*}
<div class="row">
    <div class="col-lg-6 col-md-6">
        {if !$translation->id}
            <div class="heading_page">{$btr->translation_add|escape}{if $settings->admin_theme} {$btr->theme_theme} {$settings->admin_theme|escape}{/if}</div>
        {else}
            <div class="heading_page">{$translation->label|escape}{if $settings->admin_theme} {$btr->theme_theme} {$settings->admin_theme|escape}{/if}</div>
        {/if}
    </div>
    <div class="col-lg-4 col-md-3 text-xs-right float-xs-right"></div>
</div>

{if $locked_theme}
    <div class="row">
        <div class="col-lg-12 col-md-12 col-sm-12">
            <div class="boxed boxed_warning">
                <div class="">
                    {$btr->general_protected|escape}
                </div>
            </div>
        </div>
    </div>
{/if}

{*Вывод успешных сообщений*}
{if $message_success}
    <div class="row">
        <div class="col-lg-12 col-md-12 col-sm-12">
            <div class="boxed boxed_success">
                <div class="heading_box">
                    <span class="text">
                        {if $message_success == 'added'}
                            {$btr->translation_added|escape}
                        {elseif $message_success == 'updated'}
                            {$btr->translation_updated|escape}
                        {/if}
                    </span>
                    {if $smarty.get.return}
                        <a class="btn btn_return float-xs-right" href="{url module=TranslationsAdmin id=null}">{$btr->general_back|escape}</a>
                    {/if}
                </div>
            </div>
        </div>
    </div>
{/if}

{*Вывод ошибок*}
{if $message_error}
    <div class="row">
        <div class="col-lg-12 col-md-12 col-sm-12">
            <div class="boxed boxed_warning">
                <div class="heading_box">
                    {if $message_error == 'label_empty'}{$btr->translation_empty|escape}{/if}
                    {if $message_error == 'label_exists'}{$btr->translation_used|escape}{/if}
                    {if $message_error == 'label_is_class'}{$btr->translation_not_allowed|escape}{/if}
                    {if $smarty.get.return}
                        <a class="button" href="{url module=TranslationsAdmin}">{$btr->general_back|escape}</a>
                    {/if}
                </div>
            </div>
        </div>
    </div>
{/if}


{*Главная форма страницы*}
<form method="post" enctype="multipart/form-data">
    <input type=hidden name="session_id" value="{$smarty.session.id}">
    <input name=id type="hidden" value="{$translation->id}"/>

    <div class="row">
        <div class="col-lg-12 ">
            <div class="boxed match_matchHeight_true">
                <div class="row">
                    {*Название элемента сайта*}
                    <div class="col-lg-12 col-md-12">
                        <div class="heading_label">
                            {$btr->translation_name|escape}
                        </div>
                        <div class="form-group">
                            <input name="label" class="form-control" type="text" value="{$translation->label}" {if $locked_theme}readonly=""{/if} />
                        </div>
                    </div>
                </div>
                <div class="row">
                    {foreach $languages as $lang}
                        <div class="col-lg-4 col-md-4 col-sm-6 col-xs-12 mb-h">
                            <div class="heading_label">{$lang->name|escape}</div>
                            <div class="">
                                <textarea name="lang_{$lang->label}" class="form-control okay_textarea" {if $locked_theme}readonly=""{/if}>{$translation->values[{$lang->id}]}</textarea>
                            </div>
                        </div>
                    {/foreach}
                </div>
                {if !$locked_theme}
                    <div class="row">
                        <div class="col-lg-12 col-md-12 mt-1">
                            <button type="submit" class="btn btn_small btn_blue float-md-right">
                                {include file='svg_icon.tpl' svgId='checked'}
                                <span>{$btr->general_apply|escape}</span>
                            </button>
                        </div>
                    </div>
                {/if}
            </div>
        </div>
    </div>
</form>

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
