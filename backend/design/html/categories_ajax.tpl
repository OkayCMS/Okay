{*Параметры элемента*}
{if $categories_ajax}
    {foreach $categories_ajax as $ajax_category}
        <div class="fn_row">
            <div class="okay_list_row fn_sort_item">
                <input type="hidden" name="positions[{$ajax_category->id}]" value="{$ajax_category->position}" />

                {if $ajax_category->subcategories}
                    <div class="okay_list_heading okay_list_subicon">
                        <a href="javascript:;" class="fn_ajax_toggle" data-toggle="0" data-category_id="{$ajax_category->id}" >
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
                    <input class="hidden_check" type="checkbox" id="id_{$ajax_category->id}" name="check[]" value="{$ajax_category->id}" />
                    <label class="okay_ckeckbox" for="id_{$ajax_category->id}"></label>
                </div>

                <div class="okay_list_boding okay_list_photo hidden-sm-down">
                    {if $ajax_category->image}
                        <a href="{url module=CategoryAdmin id=$ajax_category->id return=$smarty.server.REQUEST_URI}">
                            <img src="{$ajax_category->image|resize:55:55:false:$config->resized_categories_dir}" alt="" />
                        </a>
                    {else}
                        <img height="55" width="55" src="design/images/no_image.png"/>
                    {/if}
                </div>

                <div class="okay_list_boding okay_list_categories_name">
                    <a href="index.php?module=CategoryAdmin&id={$ajax_category->id}">
                        {$ajax_category->name|escape}
                    </a>
                </div>


                <div class="okay_list_boding okay_list_status">
                    {*visible*}
                    <div>
                        <label class="switch switch-default">
                            <input class="switch-input fn_ajax_action {if $ajax_category->visible}fn_active_class{/if}" data-module="category" data-action="visible" data-id="{$ajax_category->id}" name="visible" value="1" type="checkbox"  {if $ajax_category->visible}checked=""{/if}/>
                            <span class="switch-label"></span>
                            <span class="switch-handle"></span>
                        </label>
                    </div>
                </div>

                <div class="okay_list_setting">
                    {*open*}
                    <a href="{$lang_link}../catalog/{$ajax_category->url|escape}" target="_blank" data-hint="{$btr->general_view|escape}" class="setting_icon setting_icon_open hint-bottom-middle-t-info-s-small-mobile  hint-anim">
                        {include file='svg_icon.tpl' svgId='icon_desktop'}
                    </a>
                </div>
                <div class="okay_list_boding okay_list_close">
                    {*delete*}
                    <button data-hint="{$btr->categories_delete|escape}" type="button" class="btn_close fn_remove hint-bottom-middle-t-info-s-small-mobile  hint-anim" data-toggle="modal" data-target="#fn_action_modal" onclick="success_action($(this));">
                        {include file='svg_icon.tpl' svgId='delete'}
                    </button>
                </div>
            </div>
            {if $ajax_category->subcategories}
                <div class="fn_ajax_categories categories_sub_block sortable subcategories_level_2"></div>
            {/if}
        </div>
    {/foreach}
{/if}
