{if $feature->id}
    {$meta_title = $feature->name scope=parent}
{else}
    {$meta_title = $btr->feature_new scope=parent}
{/if}

{*Название страницы*}
<div class="row">
    <div class="col-lg-12 col-md-12">
        <div class="wrap_heading">
            <div class="box_heading heading_page">
                {if !$feature->id}
                    {$btr->feature_add|escape}
                {else}
                    {$feature->name|escape}
                {/if}
            </div>
        </div>
    </div>
    <div class="col-md-12 col-lg-12 col-sm-12 float-xs-right"></div>
</div>

{*Вывод успешных сообщений*}
{if $message_success}
    <div class="row">
        <div class="col-lg-12 col-md-12 col-sm-12">
            <div class="boxed boxed_success">
                <div class="heading_box">
                    {if $message_success=='added'}
                        {$btr->feature_added|escape}
                    {elseif $message_success=='updated'}
                        {$btr->feature_updated|escape}
                    {else}
                        {$message_success|escape}
                    {/if}
                    {if $smarty.get.return}
                        <a class="btn btn_return float-xs-right" href="{$smarty.get.return}">
                            {include file='svg_icon.tpl' svgId='return'}
                            <span>{$btr->general_back|escape}</span>
                        </a>
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
                    {if $message_error=='empty_name'}
                        {$btr->general_enter_title|escape}
                    {elseif $message_error == "duplicate_url"}
                        {$btr->feature_duplicate_url|escape}
                    {elseif $message_error=='auto_name_id_exists'}
                        {$btr->feature_auto_name_id_exists|escape}
                    {elseif $message_error=='auto_value_id_exists'}
                        {$btr->feature_auto_value_id_exists|escape}
                    {elseif $message_error == 'forbidden_name'}
                        {$btr->feature_forbidden_name|escape}:<BR>
                        {implode(", ", $forbidden_names)}
                    {else}
                        {$message_error|escape}
                    {/if}
                </div>
            </div>
        </div>
    </div>
{/if}

{*Главная форма страницы*}
<form method="post" enctype="multipart/form-data" class="fn_fast_button">
    <input type=hidden name="session_id" value="{$smarty.session.id}">
    <input type="hidden" name="lang_id" value="{$lang_id}" />

    <div class="row">
        <div class="col-xs-12">
            <div class="boxed match_matchHeight_true">
                {*Название элемента сайта*}
                <div class="row d_flex">
                    <div class="col-lg-10 col-md-9 col-sm-12">
                        <div class="heading_label">
                            {$btr->general_name|escape}
                        </div>
                        <div class="form-group">
                            <input class="form-control" name="name" type="text" value="{$feature->name|escape}"/>
                            <input name="id" type="hidden" value="{$feature->id|escape}"/>
                        </div>
                        <div class="row">
                            <div class="col-xs-12 col-lg-6 col-md-10">
                                <div class="">
                                    <div class="input-group">
                                        <span class="input-group-addon">URL</span>
                                        <input name="url" class="form-control fn_url {if $feature->id}fn_disabled{/if}" {if $feature->id}readonly=""{/if} type="text" value="{$feature->url|escape}" />
                                        <input type="checkbox" id="block_translit" class="hidden" value="1" {if $feature->id}checked=""{/if}>
                                        <span class="input-group-addon fn_disable_url">
                                            {if $feature->id}
                                                <i class="fa fa-lock"></i>
                                            {else}
                                                <i class="fa fa-lock fa-unlock"></i>
                                            {/if}
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-3 col-sm-12">
                        <div class="activity_of_switch">
                            <div class="activity_of_switch_item"> {* row block *}
                                <div class="okay_switch clearfix">
                                    <label class="switch_label">{$btr->feature_filter|escape}</label>
                                    <label class="switch switch-default">
                                        <input class="switch-input" name="in_filter" value='1' type="checkbox" id="visible_checkbox" {if $feature->in_filter}checked=""{/if}/>
                                        <span class="switch-label"></span>
                                        <span class="switch-handle"></span>
                                    </label>
                                </div>
                            </div>
                            <div class="activity_of_switch_item"> {* row block *}
                                <div class="okay_switch clearfix">
                                    <label class="switch_label">{$btr->feature_xml|escape}</label>
                                    <label class="switch switch-default">
                                        <input class="switch-input" name="yandex" value='1' type="checkbox" id="visible_checkbox" {if $feature->yandex}checked=""{/if}/>
                                        <span class="switch-label"></span>
                                        <span class="switch-handle"></span>
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    {*Параметры элемента*}
    <div class="row">
        <div class="col-lg-6 col-md-12 pr-0">
            <div class="boxed fn_toggle_wrap min_height_210px">
                <div class="heading_box">
                    {$btr->feature_in_categories|escape}
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="fa fn_icon_arrow fa-angle-down"></i></a>
                    </div>
                </div>
                <div class="toggle_body_wrap on fn_card">
                    <div class="boxed boxed_warning">
                        <div class="">
                           {$btr->feature_message|escape}
                        </div>
                    </div>
                    <select class="selectpicker col-xs-12 px-0" multiple name="feature_categories[]" size="10" data-selected-text-format="count" >
                        {function name=category_select selected_id=$product_category level=0}
                            {foreach $categories as $category}
                                <option value='{$category->id}' {if in_array($category->id, $feature_categories)}selected{/if} category_name='{$category->single_name}'>{section name=sp loop=$level}&nbsp;&nbsp;&nbsp;&nbsp;{/section}{$category->name}</option>
                                {category_select categories=$category->subcategories selected_id=$selected_id  level=$level+1}
                            {/foreach}
                        {/function}
                        {category_select categories=$categories}
                    </select>
                </div>
            </div>
        </div>
        <div class="col-lg-6 col-md-12">
            <div class="boxed match fn_toggle_wrap min_height_210px">
                <div class="heading_box">
                    {$btr->general_metatags|escape}
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="icon-arrow-down"></i></a>
                    </div>
                </div>
                <div class="toggle_body_wrap on fn_card">
                    <div class="heading_label" >{$btr->feature_id|escape}</div>
                    <input name="auto_name_id" class="form-control  mb-1" type="text" value="{$feature->auto_name_id|escape}"/>

                    <div class="heading_label" >{$btr->feature_value_id|escape}</div>
                    <input name="auto_value_id" class="form-control mb-t" type="text" value="{$feature->auto_value_id|escape}"/>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
       <div class="col-lg-12 col-md-12 ">
            <button type="submit" class="btn btn_small btn_blue float-md-right">
                {include file='svg_icon.tpl' svgId='checked'}
                <span>{$btr->general_apply|escape}</span>
            </button>
        </div>
    </div>

</form>

{* On document load *}
{literal}
    <script>
        $(function() {
            $('input[name="name"]').keyup(function() {
                if(!$('#block_translit').is(':checked')) {
                    $('input[name="url"]').val(generate_url());
                }
            });

        });
        function generate_url() {
            url = $('input[name="name"]').val();
            url = url.replace(/[\s-_]+/gi, '');
            url = translit(url);
            url = url.replace(/[^0-9a-z\-]+/gi, '').toLowerCase();
            return url;
        }
        function translit(str) {
            var ru=("А-а-Б-б-В-в-Ґ-ґ-Г-г-Д-д-Е-е-Ё-ё-Є-є-Ж-ж-З-з-И-и-І-і-Ї-ї-Й-й-К-к-Л-л-М-м-Н-н-О-о-П-п-Р-р-С-с-Т-т-У-у-Ф-ф-Х-х-Ц-ц-Ч-ч-Ш-ш-Щ-щ-Ъ-ъ-Ы-ы-Ь-ь-Э-э-Ю-ю-Я-я-'_'").split("-")
            var en=("A-a-B-b-V-v-G-g-G-g-D-d-E-e-E-e-E-e-ZH-zh-Z-z-I-i-I-i-I-i-J-j-K-k-L-l-M-m-N-n-O-o-P-p-R-r-S-s-T-t-U-u-F-f-H-h-TS-ts-CH-ch-SH-sh-SCH-sch-'-'-Y-y-'-'-E-e-YU-yu-YA-ya-''").split("-")
            var res = '';
            for(var i=0, l=str.length; i<l; i++) {
                var s = str.charAt(i), n = ru.indexOf(s);
                if(n >= 0) { res += en[n]; }
                else { res += s; }
            }
            return res;
        }
    </script>
{/literal}
