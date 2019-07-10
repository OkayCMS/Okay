{* Title *}
{$meta_title=$btr->brands_brands scope=parent}

{*Название страницы*}
<div class="row">
    <div class="col-lg-7 col-md-7">
        <div class="wrap_heading">
            <div class="box_heading heading_page">
                {$btr->brands_brands|escape} - {$brands_count}
            </div>
            <div class="box_btn_heading">
                <a class="btn btn_small btn-info" href="{url module=BrandAdmin return=$smarty.server.REQUEST_URI}">
                    {include file='svg_icon.tpl' svgId='plus'}
                    <span>{$btr->brands_add_brand|escape}</span>
                </a>
            </div>
        </div>
    </div>
</div>

{*Главная форма страницы*}
<div class="boxed fn_toggle_wrap">
    {if $brands}
        <div class="row">
            <div class="col-lg-12 col-md-12 ">
                <div class="fn_toggle_wrap">
                    <div class="heading_box visible_md">
                        {$btr->general_filter|escape}
                        <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                            <a class="btn-minimize" href="javascript:;" ><i class="fa fn_icon_arrow fa-angle-down"></i></a>
                        </div>
                    </div>
                    <div class="boxed_sorting toggle_body_wrap off fn_card">
                        <div class="row">
                            <div class="col-lg-3 col-md-3 col-sm 12">
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
                </div>
            </div>
        </div>

        <form method="post" class="fn_form_list fn_fast_button">
            <input type="hidden" name="session_id" value="{$smarty.session.id}" />

            <div class="okay_list products_list fn_sort_list">
                {*Шапка таблицы*}
                <div class="okay_list_head">
                    <div class="okay_list_boding okay_list_drag"></div>
                    <div class="okay_list_heading okay_list_check">
                        <input class="hidden_check fn_check_all" type="checkbox" id="check_all_1" name="" value="" />
                        <label class="okay_ckeckbox" for="check_all_1"></label>
                    </div>
                    <div class="okay_list_heading okay_list_photo">{$btr->general_photo|escape}</div>
                    <div class="okay_list_heading okay_list_brands_name">{$btr->general_name|escape}</div>
                    <div class="okay_list_heading okay_list_status">{$btr->general_enable|escape}</div>
                    <div class="okay_list_heading okay_list_setting">{$btr->general_activities|escape}</div>
                    <div class="okay_list_heading okay_list_close"></div>
                </div>

                {*Параметры элемента*}
                <div class="okay_list_body sort_extended">
                    {foreach $brands as $brand}
                        <div class="fn_row okay_list_body_item fn_sort_item">
                            <div class="okay_list_row ">
                                <input type="hidden" name="positions[{$brand->id}]" value="{$brand->position}" />

                                <div class="okay_list_boding okay_list_drag move_zone">
                                    {include file='svg_icon.tpl' svgId='drag_vertical'}
                                </div>

                                <div class="okay_list_boding okay_list_check">
                                    <input class="hidden_check" type="checkbox" id="id_{$brand->id}" name="check[]" value="{$brand->id}" />
                                    <label class="okay_ckeckbox" for="id_{$brand->id}"></label>
                                </div>

                                <div class="okay_list_boding okay_list_photo">
                                    {if $brand->image}
                                        <a href="{url module=BrandAdmin id=$brand->id return=$smarty.server.REQUEST_URI}">
                                            <img src="{$brand->image|resize:55:55:false:$config->resized_brands_dir}" alt="" /></a>
                                    {else}
                                        <img height="55" width="55" src="design/images/no_image.png"/>
                                    {/if}
                                </div>

                                <div class="okay_list_boding okay_list_brands_name">
                                    <a href="{url module=BrandAdmin id=$brand->id return=$smarty.server.REQUEST_URI}">
                                        {$brand->name|escape}
                                    </a>
                                </div>

                                <div class="okay_list_boding okay_list_status">
                                    {*visible*}
                                     <label class="switch switch-default ">
                                        <input class="switch-input fn_ajax_action {if $brand->visible}fn_active_class{/if}" data-module="brands" data-action="visible" data-id="{$brand->id}" name="visible" value="1" type="checkbox"  {if $brand->visible}checked=""{/if}/>
                                        <span class="switch-label"></span>
                                        <span class="switch-handle"></span>
                                    </label>
                                </div>

                                <div class="okay_list_setting">
                                    <a href="../{$lang_link}brands/{$brand->url|escape}" target="_blank" data-hint="{$btr->general_view|escape}" class="setting_icon setting_icon_open hint-bottom-middle-t-info-s-small-mobile  hint-anim">
                                        {include file='svg_icon.tpl' svgId='icon_desktop'}
                                    </a>
                                </div>

                                <div class="okay_list_boding okay_list_close">
                                    {*delete*}
                                    <button data-hint="{$btr->brands_delete_brand|escape}" type="button" class="btn_close fn_remove hint-bottom-right-t-info-s-small-mobile  hint-anim" data-toggle="modal" data-target="#fn_action_modal" onclick="success_action($(this));">
                                        {include file='svg_icon.tpl' svgId='delete'}
                                    </button>
                                </div>
                            </div>
                        </div>
                    {/foreach}
                </div>

                {*Блок массовых действий*}
                <div class="okay_list_footer fn_action_block">
                    <div class="okay_list_foot_left">
                        <div class="okay_list_boding okay_list_drag"></div>
                        <div class="okay_list_heading okay_list_check">
                            <input class="hidden_check fn_check_all" type="checkbox" id="check_all_2" name="" value=""/>
                            <label class="okay_ckeckbox" for="check_all_2"></label>
                        </div>
                        <div class="okay_list_option">
                            <select name="action" class="selectpicker brands_action">
                                <option value="enable">{$btr->general_do_enable|escape}</option>
                                <option value="disable">{$btr->general_do_disable|escape}</option>
                                <option value="in_feed">{$btr->brands_in_xml|escape}</option>
                                <option value="out_feed">{$btr->brands_out_xml|escape}</option>
                                <option value="delete">{$btr->general_delete|escape}</option>
                                {if $pages_count>1}
                                    <option value="move_to_page">{$btr->products_move_to_page|escape}</option>
                                {/if}
                            </select>
                        </div>
                        <div class="fn_additional_params">
                            <div class="fn_move_to_page col-lg-12 col-md-12 col-sm-12 hidden fn_hide_block">
                                <select name="target_page" class="selectpicker">
                                    {section target_page $pages_count}
                                        <option value="{$smarty.section.target_page.index+1}">{$smarty.section.target_page.index+1}</option>
                                    {/section}
                                </select>
                            </div>
                        </div>
                    </div>
                    <button type="submit" class="btn btn_small btn_blue">
                        {include file='svg_icon.tpl' svgId='checked'}
                        <span>{$btr->general_apply|escape}</span>
                    </button>
                </div>
            </div>
        </form>
        <div class="row">
            <div class="col-lg-12 col-md-12 col-sm 12 txt_center">
                {include file='pagination.tpl'}
            </div>
        </div>
    {else}
        <div class="heading_box mt-1">
            <div class="text_grey">{$btr->brands_no|escape}</div>
        </div>
    {/if}
</div>

{literal}
    <script>
        $(function() {
            $(document).on('change', '.fn_action_block select.brands_action', function () {
                var elem = $(this).find('option:selected').val();
                $('.fn_hide_block').addClass('hidden');
                if ($('.fn_' + elem).size() > 0) {
                    $('.fn_' + elem).removeClass('hidden');
                }
            });
        });
    </script>
{/literal}