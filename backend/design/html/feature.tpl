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
<form method="post" enctype="multipart/form-data" class="fn_fast_button fn_is_translit_alpha">
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
                            <div class="col-xs-12 col-lg-6 col-md-6">
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
                            <div class="col-lg-6 col-md-6 mt-q">
                                <div class="heading_label boxes_inline">{$btr->feature_url_in_product|escape}</div>
                                <div class="boxes_inline">
                                    <div class="okay_switch clearfix">
                                        <label class="switch switch-default">
                                            <input class="switch-input" name="url_in_product" value='1' type="checkbox" {if $feature->url_in_product}checked=""{/if}/>
                                            <span class="switch-label"></span>
                                            <span class="switch-handle"></span>
                                        </label>
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

                    <div class="activity_of_switch_item"> {* row block *}
                        <div class="okay_switch clearfix">
                            <label class="switch_label">{$btr->feature_select_all_categories|escape}</label>
                            <label class="switch switch-default">
                                <input class="switch-input" name="" value='' type="checkbox" id="select_all_categories"/>
                                <span class="switch-label"></span>
                                <span class="switch-handle"></span>
                            </label>
                        </div>
                    </div>
                    
                    <select class="selectpicker fn_select_all_categories col-xs-12 px-0" multiple name="feature_categories[]" size="10" data-selected-text-format="count" >
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
        {*Значения свойства*}
        <div class="col-lg-12 col-md-12">
            <div class="boxed fn_toggle_wrap min_height_210px">
                <div class="heading_box">
                    {$btr->feature_feature_values|escape} ({$feature_values_count})
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="fa fn_icon_arrow fa-angle-down"></i></a>
                    </div>
                </div>
                <div class="toggle_body_wrap on fn_card fn_sort_list">

                    <div class="row mb-1">
                        <div class="col-lg-8 col-md-7 col-sm 12">
                            <button type="button" class="btn btn_small btn-info fn_add_value float-lg-left mr-1">
                                {include file='svg_icon.tpl' svgId='plus'}
                                <span>{$btr->feature_add_value|escape}</span>
                            </button>
                            <div class="float-lg-left mt-q feature_to_index_new_value">
                                <div class="heading_label boxes_inline">{$btr->feature_to_index_new_value|escape}</div>
                                <div class="boxes_inline">
                                    <div class="okay_switch clearfix">
                                        <label class="switch switch-default">
                                            <input class="switch-input" name="to_index_new_value" value="1" type="checkbox" {if $feature->to_index_new_value}checked=""{/if}/>
                                            <span class="switch-label"></span>
                                            <span class="switch-handle"></span>
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4 col-md-5 col-sm 12">
                            <div class="float-xs-none float-md-right">
                                <select onchange="location = this.value;" class="selectpicker">
                                    <option value="{url limit=5}" {if $current_limit == 5}selected{/if}>{$btr->general_show_by|escape} 5</option>
                                    <option value="{url limit=10}" {if $current_limit == 10}selected{/if}>{$btr->general_show_by|escape} 10</option>
                                    <option value="{url limit=25}" {if $current_limit == 25}selected{/if}>{$btr->general_show_by|escape} 25</option>
                                    <option value="{url limit=50}" {if $current_limit == 50}selected{/if}>{$btr->general_show_by|escape} 50</option>
                                    <option value="{url limit=100}" {if $current_limit == 100}selected=""{/if}>{$btr->general_show_by|escape} 100</option>
                                </select>
                            </div>
                        </div>
                    </div>


                    <div class="okay_list ok_related_list">
                        <div class="okay_list_head">
                            <div class="okay_list_heading okay_list_drag"></div>
                            <div class="okay_list_heading feature_value_name">{$btr->feature_value_name}</div>
                            <div class="okay_list_heading feature_value_translit">{$btr->feature_value_translit}</div>
                            <div class="okay_list_heading feature_value_products_num">{$btr->feature_value_products_num}</div>
                            <div class="okay_list_heading feature_value_index">
                                {$btr->feature_value_index}
                                <div class="okay_switch clearfix">
                                    <label class="switch switch-default">
                                        <input class="switch-input fn_to_index_all_values" value="" type="checkbox" {if $feature->to_index_new_value}checked=""{/if}/>
                                        <input type="hidden" name="to_index_all_values" value="" disabled=""/>
                                        <span class="switch-label"></span>
                                        <span class="switch-handle"></span>
                                    </label>
                                </div>
                            </div>
                            <div class="okay_list_heading okay_list_close"></div>
                        </div>
                        <div class="okay_list_body fn_feature_values_list sort_extended fn_values_list">
                            {foreach $features_values as $fv}
                                <div class="fn_row okay okay_list_body_item fn_sort_item">
                                    <div class="okay_list_row">
                                        <input type="hidden" name="feature_values[id][]" value="{$fv->id|escape}">
                                        <input class="hidden_check" type="checkbox" name="check[]" value="{$fv->id}" />
                                        <input type="hidden" class="fn_value_to_delete" name="values_to_delete[]" disabled="" value="{$fv->id|escape}">
                                        <div class="okay_list_boding okay_list_drag move_zone">
                                            {include file='svg_icon.tpl' svgId='drag_vertical'}
                                        </div>
                                        <div class="okay_list_boding feature_value_name">
                                            <div class="heading_label visible_md">{$btr->feature_value_name}</div>
                                            <input type="text" class="form-control fn_feature_alias_name" name="feature_values[value][]" value="{$fv->value|escape}">
                                        </div>
                                        <div class="okay_list_boding feature_value_translit">
                                            <div class="heading_label visible_md">{$btr->feature_value_translit}</div>
                                            <input type="text" class="form-control fn_feature_alias_name" name="feature_values[translit][]" value="{$fv->translit|escape}">
                                        </div>
                                        <div class="okay_list_boding feature_value_products_num">
                                            <div class="heading_label visible_md">{$btr->feature_value_products_num}</div>
                                            <a href="index.php?module=ProductsAdmin&features[{$feature->id}]={$fv->translit|escape}" class="form-control" target="_blank">{$fv->count|escape}</a>
                                        </div>
                                        <div class="okay_list_boding feature_value_index">
                                            <div class="heading_label visible_md">{$btr->feature_value_index}</div>
                                            <div class="okay_switch clearfix">
                                                <label class="switch switch-default">
                                                    <input class="switch-input fn_index" name="" value="" type="checkbox" {if $fv->to_index}checked=""{/if}/>
                                                    <span class="switch-label"></span>
                                                    <span class="switch-handle"></span>
                                                </label>
                                            </div>
                                            <input type="hidden" class="form-control" name="feature_values[to_index][]" value="{$fv->to_index|escape}">
                                        </div>
                                        <div class="okay_list_boding okay_list_close">
                                            <button data-hint="{$btr->feature_delete_value|escape}" type="button" class="btn_close fn_remove_value hint-bottom-right-t-info-s-small-mobile hint-anim">
                                                {include file='svg_icon.tpl' svgId='delete'}
                                                <span class="visible_md">{$btr->feature_delete_value|escape}</span>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            {/foreach}

                            <div class="fn_row okay okay_list_body_item fn_sort_item fn_new_value" style="display: none;">
                                <div class="okay_list_row">
                                    <input type="hidden" class="fn_feature_alias_id" name="feature_values[id][]" value="">
                                    <input class="hidden_check" type="checkbox" name="check[]" value="" />
                                    <div class="okay_list_boding okay_list_drag move_zone">
                                        {include file='svg_icon.tpl' svgId='drag_vertical'}
                                    </div>
                                    <div class="okay_list_boding feature_value_name">
                                        <div class="heading_label visible_md">{$btr->feature_value_name}</div>
                                        <input type="text" class="form-control fn_feature_alias_name" name="feature_values[value][]" value="">
                                    </div>
                                    <div class="okay_list_boding feature_value_translit">
                                        <div class="heading_label visible_md">{$btr->feature_value_translit}</div>
                                        <input type="text" class="form-control fn_feature_alias_name" name="feature_values[translit][]" value="">
                                    </div>
                                    <div class="okay_list_boding feature_value_products_num">
                                        <div class="heading_label visible_md">{$btr->feature_value_products_num}</div>
                                        <input type="text" class="form-control" name="" value="0" readonly="">
                                    </div>
                                    <div class="okay_list_boding feature_value_index">
                                        <div class="heading_label visible_md">{$btr->feature_value_index}</div>
                                        <div class="okay_switch clearfix">
                                            <label class="switch switch-default">
                                                <input class="switch-input fn_index" name="" value="" type="checkbox" {if $feature->to_index_new_value}checked=""{/if}/>
                                                <span class="switch-label"></span>
                                                <span class="switch-handle"></span>
                                            </label>
                                        </div>
                                        <input type="hidden" class="form-control" name="feature_values[to_index][]" value="{if $feature->to_index_new_value}1{/if}">
                                    </div>
                                    <div class="okay_list_boding okay_list_close">
                                        <button data-hint="{$btr->feature_delete_alias|escape}" type="button" class="btn_close fn_remove_item hint-bottom-right-t-info-s-small-mobile  hint-anim">
                                            {include file='svg_icon.tpl' svgId='delete'}
                                            <span class="visible_md">{$btr->feature_delete_alias|escape}</span>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="hidden">
                        {*Здесь сделано на селектах, для общей савместимости скрипта Drag-and-drop*}
                        <select name="action" class="selectpicker values_action">
                            <option value="" selected></option>
                            {if $pages_count>1}
                                <option value="move_to_page"></option>
                            {/if}
                        </select>
                        <select name="target_page" class="selectpicker">
                            {section target_page $pages_count}
                                <option value="{$smarty.section.target_page.index+1}">{$smarty.section.target_page.index+1}</option>
                            {/section}
                        </select>
                    </div>
                    
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm 12 txt_center">
                            {include file='pagination.tpl'}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    {if $feature->id}
    <div class="boxed fn_toggle_wrap">
        <div class="heading_box">
            {$btr->feature_union_values|escape}
            <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                <a class="btn-minimize" href="javascript:;" ><i class="fa fn_icon_arrow fa-angle-down"></i></a>
            </div>
        </div>
        <div class="toggle_body_wrap on fn_card">
            <div class="row">
                <div class="col-lg-6 col-md-6 mb-2">
                    <div class="heading_label">{$btr->feature_union_main_value|escape}</div>
                    <input class="form-control mb-1 fn_union_main_value" type="text" value=""/>
                    <input name="union_main_value_id" type="hidden" value=""/>
                </div>
                <div class="col-lg-6 col-md-6 mb-2">
                    <div class="heading_label">{$btr->feature_union_second_value|escape}</div>
                    <input class="form-control mb-1 fn_union_second_value" type="text" value=""/>
                    <input name="union_second_value_id" type="hidden" value=""/>
                </div>
            </div>
        </div>
    </div>
    {/if}

    <div class="row">
        <div class="col-lg-12 col-md-12 mb-2">
            <button type="submit" class="btn btn_small btn_blue float-md-right">
                {include file='svg_icon.tpl' svgId='checked'}
                <span>{$btr->general_apply|escape}</span>
            </button>
        </div>
    </div>
</form>

{* On document load *}
{if $feature->id}
{literal}
    <script src="design/js/autocomplete/jquery.autocomplete-min.js"></script>
    <script>
        var union_main_value_id = $('input[name="union_main_value_id"]'),
            union_second_value_id = $('input[name="union_second_value_id"]');

        $(".fn_union_main_value").devbridgeAutocomplete({
            serviceUrl:'ajax/options_autocomplete.php',
            minChars:0,
            params: {feature_id:{/literal}{$feature->id}{literal}},
            noCache: false,
            orientation:'auto',
            onSelect:function(suggestion){
                union_main_value_id.val(suggestion.data.id);
            },
            onSearchStart:function(params){
                union_main_value_id.val("");
            }
        });

        $(".fn_union_second_value").devbridgeAutocomplete({
            serviceUrl:'ajax/options_autocomplete.php',
            minChars:0,
            params: {feature_id:{/literal}{$feature->id}{literal}},
            noCache: false,
            orientation:'auto',
            onSelect:function(suggestion){
                union_second_value_id.val(suggestion.data.id);
                $(this).trigger('change');
            },
            onSearchStart:function(params){
                union_second_value_id.val("");
            }
        });
    </script>
{/literal}
{/if}

{literal}
    <script>

        $(document).on('change', '#select_all_categories', function () {
            $('.fn_select_all_categories option').prop("selected", $(this).is(':checked'));
            $('.fn_select_all_categories').selectpicker('refresh');
        });
        
        var new_value = $(".fn_new_value").clone(false);
        $(".fn_new_value").remove();
        $(document).on("click", ".fn_add_value", function () {
            var value = new_value.clone(true),
                index_new_value = ($('input[name="to_index_new_value"]').is(':checked') ? 1 : 0);
            value.find('input[name="feature_values[to_index][]"]').val(index_new_value);
            if (index_new_value == 1) {
                value.find(".fn_index").attr("checked", true);
            }
            value.show();
            $(".fn_values_list").prepend(value);
            return false;
        });

        $(document).on('change', '.fn_index', function(){
            var state = ($(this).is(':checked') ? 1 : 0);
            $(this).closest(".fn_row").find('input[name="feature_values[to_index][]"]').val(state);
        });

        $(document).on('change', '.fn_to_index_all_values', function(){
            var state = ($(this).is(':checked') ? 1 : 0);
            $('input[name="feature_values[to_index][]"]').val(state);
            $(".fn_index").prop("checked", Boolean(state));
            $('input[name="to_index_all_values"]').val(state).attr("disabled", false);
        });

        $(document).on('click', '.fn_remove_value', function(){
            $(this).closest('.fn_row').fadeOut(200, function() {
                $(this).closest(".fn_row").find(".fn_value_to_delete").attr("disabled", false);
            });
        });

        $(function() {
            $('input[name="name"]').keyup(function() {
                if(!$('#block_translit').is(':checked')) {
                    $('input[name="url"]').val(generate_url());
                }
            });
        });
    </script>
{/literal}
