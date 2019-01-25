{* Title *}
{$meta_title=$btr->general_categories scope=parent}

{*Название страницы*}
<div class="row">
    <div class="col-lg-7 col-md-7">
        <div class="wrap_heading">
            <div class="box_heading heading_page">
                {$btr->general_categories|escape}
            </div>
            <div class="box_btn_heading">
                <a class="btn btn_small btn-info" href="{url module=CategoryAdmin return=$smarty.server.REQUEST_URI}">
                    {include file='svg_icon.tpl' svgId='plus'}
                    <span>{$btr->categories_add|escape}</span>
                </a>
            </div>
        </div>
    </div>
</div>

{*Главная форма страницы*}
<div class="boxed fn_toggle_wrap">
    {if $categories}
        <form method="post" class="fn_form_list fn_fast_button">
            <input type="hidden" name="session_id" value="{$smarty.session.id}" />
            <div class="okay_list products_list fn_sort_list">
                {*Шапка таблицы*}
                <div class="okay_list_head">
                    <div class="okay_list_heading okay_list_subicon"></div>
                    <div class="okay_list_heading okay_list_drag"></div>
                    <div class="okay_list_heading okay_list_check">
                        <input class="hidden_check fn_check_all" type="checkbox" id="check_all_1" name="" value=""/>
                        <label class="okay_ckeckbox" for="check_all_1"></label>
                    </div>
                    <div class="okay_list_heading okay_list_photo hidden-sm-down">{$btr->general_photo|escape}</div>
                    <div class="okay_list_heading okay_list_categories_name">{$btr->general_name|escape}</div>
                    <div class="okay_list_heading okay_list_status">{$btr->general_enable|escape}</div>
                    <div class="okay_list_heading okay_list_setting">{$btr->general_activities|escape}</div>
                    <div class="okay_list_heading okay_list_close"></div>
                </div>

                {*Параметры элемента*}
                <div class="okay_list_body categories_wrap sortable ">
                {if $categories}
                    {foreach $categories as $category}
                        <div class="fn_row okay_list_body_item   fn_sort_item">
                            <div class="okay_list_row ">
                                <input type="hidden" name="positions[{$category->id}]" value="{$category->position}" />

                                {if $category->subcategories}
                                    <div class="okay_list_heading okay_list_subicon">
                                        <a href="javascript:;" class="fn_ajax_toggle" data-toggle="0" data-category_id="{$category->id}" >
                                            <i class="fa fa-plus-square"></i>
                                        </a>
                                    </div>
                                {else}
                                    <div class="okay_list_heading okay_list_subicon"></div>
                                {/if}

                                <div class="okay_list_boding okay_list_drag move_zone">
                                    {include file='svg_icon.tpl' svgId='drag_vertical'}
                                </div>

                                <div class="okay_list_boding okay_list_check">
                                    <input class="hidden_check" type="checkbox" id="id_{$category->id}" name="check[]" value="{$category->id}" />
                                    <label class="okay_ckeckbox" for="id_{$category->id}"></label>
                                </div>

                                <div class="okay_list_boding okay_list_photo hidden-sm-down">
                                    {if $category->image}
                                        <a href="{url module=CategoryAdmin id=$category->id return=$smarty.server.REQUEST_URI}">
                                            <img src="{$category->image|resize:55:55:false:$config->resized_categories_dir}" alt="" />
                                        </a>
                                    {else}
                                        <img height="55" width="55" src="design/images/no_image.png"/>
                                    {/if}
                                </div>

                                <div class="okay_list_boding okay_list_categories_name">
                                    <a class="link" href="{url module=CategoryAdmin id=$category->id return=$smarty.server.REQUEST_URI}">
                                        {$category->name|escape}
                                    </a>
                                </div>

                                <div class="okay_list_boding okay_list_status">
                                    {*visible*}
                                    <label class="switch switch-default">
                                        <input class="switch-input fn_ajax_action {if $category->visible}fn_active_class{/if}" data-module="category" data-action="visible" data-id="{$category->id}" name="visible" value="1" type="checkbox"  {if $category->visible}checked=""{/if}/>
                                        <span class="switch-label"></span>
                                        <span class="switch-handle"></span>
                                    </label>
                                </div>

                                <div class=" okay_list_setting">
                                    {*open*}
                                    <a href="../{$lang_link}catalog/{$category->url|escape}" target="_blank" data-hint="{$btr->general_view|escape}" class="setting_icon setting_icon_open hint-bottom-middle-t-info-s-small-mobile  hint-anim">
                                        {include file='svg_icon.tpl' svgId='icon_desktop'}
                                    </a>
                                </div>
                                <div class="okay_list_boding okay_list_close">
                                    {*delete*}
                                    <button data-hint="{$btr->categories_delete|escape}" type="button" class="btn_close fn_remove hint-bottom-right-t-info-s-small-mobile  hint-anim" data-toggle="modal" data-target="#fn_action_modal" onclick="success_action($(this));">
                                        {include file='svg_icon.tpl' svgId='delete'}
                                    </button>
                                </div>
                            </div>

                            {if $category->subcategories}
                                <div class="fn_ajax_categories categories_sub_block subcategories_level_1">
                                    {include file="categories_ajax.tpl"}
                                </div>
                            {/if}
                        </div>
                    {/foreach}
                {/if}
                </div>

                {*Блок массовых действий*}
                <div class="okay_list_footer fn_action_block">
                    <div class="okay_list_foot_left">
                        <div class="okay_list_heading okay_list_subicon"></div>
                        <div class="okay_list_heading okay_list_drag"></div>
                        <div class="okay_list_heading okay_list_check">
                            <input class="hidden_check fn_check_all" type="checkbox" id="check_all_2" name="" value=""/>
                            <label class="okay_ckeckbox" for="check_all_2"></label>
                        </div>
                        <div class="okay_list_option">
                            <select name="action" class="selectpicker">
                                <option value="enable">{$btr->general_do_enable|escape}</option>
                                <option value="in_feed">{$btr->categories_in_xml|escape}</option>
                                <option value="out_feed">{$btr->categories_out_xml|escape}</option>
                                <option value="disable">{$btr->general_do_disable|escape}</option>
                                <option value="delete">{$btr->general_delete|escape}</option>
                            </select>
                        </div>
                    </div>
                    <button type="submit" class="btn btn_small btn_blue">
                        {include file='svg_icon.tpl' svgId='checked'}
                        <span>{$btr->general_apply|escape}</span>
                    </button>
                </div>
            </div>
        </form>
    {else}
        <div class="heading_box mt-1">
            <div class="text_grey">{$btr->categories_no|escape}</div>
        </div>
    {/if}
</div>

<script>
    $(document).on("click", ".fn_ajax_toggle", function () {
        elem = $(this);
        var toggle = parseInt(elem.data("toggle"));
        var category_id = parseInt(elem.data("category_id"));
        session_id = '{$smarty.session.id}';
        if(toggle == 0){
            $.ajax({
                dataType: 'json',
                url: "ajax/get_categories.php",
                data: {
                    category_id: category_id,
                    session_id : session_id,
                },
                success: function(data){
                    var msg = "";

                    if(data.success){
                        elem.closest(".fn_row").find(".fn_ajax_categories").html(data.cats);
                        elem.closest(".fn_row").find(".fn_ajax_categories").addClass("sortable");
                        elem.data("toggle",1);
                        elem.find("i").toggleClass("fa-minus-square");
                    } else {
                        toastr.error(msg, "Error");
                    }

                    var el = document.querySelectorAll("div.sortable , .fn_ajax_categories.sortable");
                    for (i = 0; i < el.length; i++) {
                        var sortable = Sortable.create(el[i], {
                            handle: ".move_zone",  // Drag handle selector within list items
                            sort: true,  // sorting inside list
                            animation: 150,  // ms, animation speed moving items when sorting, `0` — without animation
                            scroll: true, // or HTMLElement
                            ghostClass: "sortable-ghost",  // Class name for the drop placeholder
                            chosenClass: "sortable-chosen",  // Class name for the chosen item
                            dragClass: "sortable-drag",  // Class name for the dragging item
                            scrollSensitivity: 30, // px, how near the mouse must be to an edge to start scrolling.
                            scrollSpeed: 10, // px
                        });
                    }

                }
            });
        } else {
            elem.closest(".fn_row").children(".fn_ajax_categories").slideToggle(500);
            elem.find("i").toggleClass("fa-minus-square");
        }
    });
</script>
