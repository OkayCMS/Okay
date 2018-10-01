{if $banner->id}
    {$meta_title = $banner->name scope=parent}
{else}
    {$meta_title = $btr->banner_new_group scope=parent}
{/if}
{*Название страницы*}
<div class="row">
    <div class="col-lg-12 col-md-12">
        <div class="wrap_heading">
            <div class="box_heading heading_page">
                {if !$banner->id}
                    {$btr->banner_new_group|escape}
                {else}
                    {$banner->name|escape}
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
                    {if $message_success == 'added'}
                        {$btr->general_group_added|escape}
                    {elseif $message_success == 'updated'}
                        {$btr->banner_updated|escape}
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
                    {if $message_error == 'group_id_exists'}
                        {$btr->banner_id_exists|escape}
                    {elseif $message_error == 'empty_group_id'}
                        {$btr->banner_enter_id|escape}
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
            <div class="boxed">
                <div class="row d_flex">
                    {*Название элемента сайта*}
                    <div class="col-lg-10 col-md-9 col-sm-12">
                        <div class="heading_label">
                            {$btr->general_name|escape}
                        </div>
                        <div class="form-group">
                            <input class="form-control mb-h" name="name" type="text" value="{$banner->name|escape}"/>
                            <input name="id" type="hidden" value="{$banner->id|escape}"/>
                        </div>
                        <div class="row">
                            <div class="col-lg-6 col-sm-12">
                                <div class="mt-h">
                                    <span class="boxes_inline">
                                        <label class="switch switch-default switch-pill switch-primary-outline-alt boxes_inline">
                                        <input class="switch-input" name="show_all_pages" value='1' type="checkbox" {if $banner->show_all_pages}checked=""{/if}/>
                                        <span class="switch-label"></span>
                                        <span class="switch-handle"></span>
                                    </label>
                                    </span>
                                    <span class="boxes_inline heading_label">{$btr->banner_show_group|escape}</span>
                                </div>
                            </div>
                            <div class="col-lg-6 col-sm-12">
                                <div class="input-group">
                                    <span class="boxes_inline heading_label">{$btr->banner_id_enter|escape}</span>
                                    <span class="boxes_inline bnr_id_grup">
                                        <input name="group_id" class="form-control" type="text" value="{$banner->group_id|escape}" />
                                    </span>
                                </div>
                            </div>
                        </div>
                    </div>
                    {*Видимость элемента*}
                    <div class="col-lg-2 col-md-3 col-sm-12">
                        <div class="activity_of_switch">
                            <div class="activity_of_switch_item"> {* row block *}
                                <div class="okay_switch clearfix">
                                    <label class="switch_label">{$btr->general_enable|escape}</label>
                                    <label class="switch switch-default">
                                        <input class="switch-input" name="visible" value='1' type="checkbox" id="visible_checkbox" {if $banner->visible}checked=""{/if}/>
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
        <div class="col-md-12">
            <div class="boxed fn_toggle_wrap min_height_230px">
                <div class="heading_box">
                    {$btr->banner_show_banner|escape}
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="fa fn_icon_arrow fa-angle-down"></i></a>
                    </div>
                </div>

                <div class="toggle_body_wrap fn_card on">
                    <div class="row">
                        <div class="col-lg-4 col-md-6 col-sm-12">
                            <div class="banner_card">
                                <div class="banner_card_header">
                                    <span class="font-weight-bold">{$btr->general_pages|escape}</span>
                                </div>
                                <div class="banner_card_block">
                                    <select name="pages[]" class="selectpicker fn_action_select" multiple="multiple" data-selected-text-format="count">
                                        <option value="0" {if !$banner->page_selected || 0|in_array:$banner->page_selected}selected{/if}>{$btr->banner_hide|escape}</option>
                                        {foreach from=$pages item=page}
                                            {if $page->name != ''}
                                                <option value="{$page->id}" {if $banner->page_selected && $page->id|in_array:$banner->page_selected}selected{/if}>{$page->name|escape}</option>
                                            {/if}
                                        {/foreach}
                                    </select>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-4 col-md-6 col-sm-12">
                            <div class="banner_card">
                                <div class="banner_card_header">
                                    <span class="font-weight-bold">{$btr->general_categories|escape}</span>
                                </div>
                                <div class="banner_card_block">
                                    <select name="categories[]" class="selectpicker" multiple="multiple" data-selected-text-format="count">
                                        <option value='0' {if !$banner->category_selected || 0|in_array:$banner->category_selected}selected{/if}>{$btr->banner_hide|escape}</option>
                                        {function name=category_select level=0}
                                            {foreach from=$categories item=category}
                                                <option value="{$category->id}" {if $selected && $category->id|in_array:$selected}selected{/if}>{section name=sp loop=$level}&nbsp;{/section}{$category->name|escape}</option>
                                                {category_select categories=$category->subcategories selected=$banner->category_selected  level=$level+1}
                                            {/foreach}
                                        {/function}
                                        {category_select categories=$categories selected=$banner->category_selected}
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4 col-md-6 col-sm-12">
                            <div class="banner_card">
                                <div class="banner_card_header">
                                    <span class="font-weight-bold">{$btr->general_brands|escape}</span>
                                </div>
                                <div class="banner_card_block">
                                    <select name="brands[]" class="selectpicker" multiple="multiple" data-selected-text-format="count">
                                        <option value='0' {if !$banner->brand_selected || 0|in_array:$banner->brand_selected}selected{/if}>{$btr->banner_hide|escape}</option>
                                        {foreach from=$brands item=brand}
                                            <option value='{$brand->id}' {if $banner->brand_selected && $brand->id|in_array:$banner->brand_selected}selected{/if}>{$brand->name|escape}</option>
                                        {/foreach}
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-12 col-md-12 ">
                            <button type="submit" class="btn btn_small btn_blue float-md-right">
                                {include file='svg_icon.tpl' svgId='checked'}
                                <span>{$btr->general_apply|escape}</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    {if $banner->id}
        <div class="row">
            <div class="col-lg-12 col-md-12">
                <div class="boxed fn_toggle_wrap min_height_230px">
                    <div class="heading_box">
                        {$btr->banner_instruction|escape}
                    </div>
                    <textarea id="fn_banner_code" readonly>
                    {literal}
                        {get_banner var="{/literal}banner_{$banner->group_id}{literal}" group="{/literal}{$banner->group_id}{literal}"}
                        {if {/literal}$banner_{$banner->group_id}{literal}->items}
                        <div class="container hidden-md-down">
                            <div class="fn_banner_{/literal}{$banner->group_id}{literal} slick-banner">
                                {foreach {/literal}$banner_{$banner->group_id}{literal}->items as $bi}
                                <div>
                                    {if $bi->url}
                                        <a href="{$bi->url}" target="_blank">
                                    {/if}
                                    {if $bi->image}
                                        <img src="{$bi->image|resize:1170:390:false:$config->resized_banners_images_dir}" alt="{$bi->alt}" title="{$bi->title}"/>
                                    {/if}
                                    <span class="slick-name">
                                        {$bi->title}
                                    </span>
                                    {if $bi->description}
                                        <span class="slick-description">
                                        {$bi->description}
                                    </span>
                                    {/if}
                                    {if $bi->url}
                                    </a>
                                    {/if}
                                </div>
                                {/foreach}
                            </div>
                        </div>
                        {/if}
                        {/literal}
                    </textarea>
                </div>
            </div>
            <div class="col-lg-12 col-md-12">
                <div class="boxed fn_toggle_wrap min_height_230px">
                    <div class="heading_box">
                       {$btr->banner_instruction2|escape}
                    </div>
                    <textarea disabled id="fn_banner_js">
                       $('.fn_banner_{$banner->group_id}').slick({
                            infinite: true,
                            speed: 500,
                            slidesToShow: 1,
                            slidesToScroll: 1,
                            swipeToSlide : true,
                            dots: true,
                            arrows: false,
                            adaptiveHeight: true,
                            autoplaySpeed: 8000,
                            autoplay: true
                        });
                    </textarea>
                </div>
            </div>
        </div>
    {/if}

</form>
{if $banner->id}
    <link rel="stylesheet" href="design/js/codemirror/lib/codemirror.css">
    <link rel="stylesheet" href="design/js/codemirror/theme/monokai.css">
    <script src="design/js/codemirror/lib/codemirror.js"></script>
    <script src="design/js/codemirror/mode/smarty/smarty.js"></script>
    <script src="design/js/codemirror/mode/smartymixed/smartymixed.js"></script>
    <script src="design/js/codemirror/mode/xml/xml.js"></script>
    <script src="design/js/codemirror/mode/htmlmixed/htmlmixed.js"></script>
    <script src="design/js/codemirror/mode/javascript/javascript.js"></script>
    {literal}
        <style type="text/css">

            .CodeMirror{
                font-family:'Courier New';
                margin-bottom:10px;
                border:1px solid #c0c0c0;
                background-color: #ffffff;
                height: auto;
                min-height: 100px;
                width:100%;
            }
            .CodeMirror-scroll
            {
                overflow-y: hidden;
                overflow-x: auto;
            }
            .cm-s-monokai .cm-smarty.cm-tag{color: #ff008a;}
            .cm-s-monokai .cm-smarty.cm-string {color: #007000;}
            .cm-s-monokai .cm-smarty.cm-variable {color: #ff008a;}
            .cm-s-monokai .cm-smarty.cm-variable-2 {color: #ff008a;}
            .cm-s-monokai .cm-smarty.cm-variable-3 {color: #ff008a;}
            .cm-s-monokai .cm-smarty.cm-property {color: #ff008a;}
            .cm-s-monokai .cm-comment {color: #505050;}
            .cm-s-monokai .cm-smarty.cm-attribute {color: #ff20Fa;}
        </style>
        <script>
            var editor = CodeMirror.fromTextArea(document.getElementById("fn_banner_code"), {
                mode: "smartymixed",
                lineNumbers: true,
                matchBrackets: false,
                enterMode: 'keep',
                indentWithTabs: false,
                indentUnit: 1,
                tabMode: 'classic',
                theme : 'monokai',
                readOnly: true,
            });

            var editor_2 = CodeMirror.fromTextArea(document.getElementById("fn_banner_js"), {
                mode: "javascript",
                lineNumbers: true,
                matchBrackets: false,
                enterMode: 'keep',
                indentWithTabs: false,
                indentUnit: 1,
                tabMode: 'classic',
                theme : 'monokai',
                readOnly: true,
            });
        </script>
    {/literal}
{/if}
