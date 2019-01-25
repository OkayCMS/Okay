{if $m->login}
    {$meta_title = $m->login scope=parent}
{else}
    {$meta_title = $btr->manager_new scope=parent}
{/if}

{*Название страницы*}
<div class="row">
    <div class="col-lg-7 col-md-7">
        {if !$m->id}
            <div class="heading_page">{$btr->manager_add|escape}</div>
        {else}
            <div class="heading_page">{$m->name|escape}</div>
        {/if}
    </div>
    <div class="col-lg-4 col-md-3 text-xs-right float-xs-right"></div>
</div>

{*Вывод успешных сообщений*}
{if $message_success}
    <div class="row">
        <div class="col-lg-12 col-md-12 col-sm-12">
            <div class="boxed boxed_success">
                <div class="heading_box">
                    {if $message_success=='added'}
                        {$btr->manager_added|escape}
                    {elseif $message_success=='updated'}
                        {$btr->manager_updated|escape}
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
                     {if $message_error=='login_exists'}
                        {$btr->manager_exists|escape}
                    {elseif $message_error=='empty_login'}
                        {$btr->manager_enter_login|escape}
                    {elseif $message_error == "password_wrong"}
                        {$btr->manager_pass_not_match|escape}
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
    <input type="hidden" name="session_id" value="{$smarty.session.id}">
    <div class="row">
        <div class="col-lg-6 col-md-12 pr-0">
            <div class="boxed fn_toggle_wrap min_height_335px">
                <div class="heading_box">
                    {$btr->manager_basic|escape}
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="fa fn_icon_arrow fa-angle-down"></i></a>
                    </div>
                </div>
                <div class="toggle_body_wrap on fn_card">
                    <div class="mb-1">
                        <div class="heading_label" >{$btr->manager_login|escape}</div>
                        <div class="">
                            <input class="form-control" name="login" autocomplete="off" type="text" value="{$m->login|escape}"/>
                            <input name="id" type="hidden" value="{$m->id|escape}"/>
                        </div>
                    </div>

                    <div class="mb-1">
                        <div class="heading_label" >{$btr->manager_pass|escape}</div>
                        <div class="">
                            <input class="form-control" autocomplete="off" name="password" type="password" value="" placeholder="xxxxxxxx" />
                        </div>
                    </div>

                    <div class="mb-1">
                        <div class="heading_label">{$btr->manager_pass_repeat|escape}</div>
                        <div class="">
                            <input class="form-control" autocomplete="off" name="password_check" type="password" value="" placeholder="xxxxxxxx" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-6 col-md-12">
            <div class="boxed fn_toggle_wrap min_height_335px">
                <div class="heading_box">
                    {$btr->manager_settings|escape}
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="fa fn_icon_arrow fa-angle-down"></i></a>
                    </div>
                </div>
                <div class="toggle_body_wrap fn_card on">
                    <div class="mb-1">
                        <div class="heading_label" for="block_translit">{$btr->manager_language|escape}</div>
                        <select name="manager_lang" class="selectpicker">
                            {foreach $btr_languages as $name=>$label}
                                <option value="{$label}" {if $m->lang==$label}selected{/if}>
                                    <img src="../files/lang/{$label}.png"/>
                                    {$name|escape}
                                </option>
                            {/foreach}
                        </select>
                    </div>

                    <div class="mb-1">
                        <div class="heading_label" for="block_translit">{$btr->general_comment|escape}</div>
                        <div class="">
                            <input class="form-control" autocomplete="off" name="comment" type="text" value="{$m->comment|escape}" placeholder="{$btr->manager_example|escape}"/>
                        </div>
                    </div>

                    <div class="mb-1">
                        <div class="heading_label" for="block_translit">{$btr->manager_date|escape}</div>
                        <div class="">
                            <input class="form-control" autocomplete="off" name="" type="text" value="" placeholder="19.01.17|14:02"/>
                        </div>
                    </div>

                    <div class="mb-1">
                        <div class="heading_label">{$btr->manager_sidebar|escape}</div>
                        <div class="">
                            <select name="menu_status" class="selectpicker">
                                <option value="1" {if $m->menu_status == 1}selected=""{/if}>{$btr->manager_open|escape}</option>
                                <option value="0" {if $m->menu_status == 0}selected=""{/if}>{$btr->manager_closed|escape}</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="mb-1">
                        <div class="">
                            <button type="submit" class="btn btn_small btn_blue" name="reset_menu" value="1">
                                {include file='svg_icon.tpl' svgId='refresh_icon'}
                                <span>{$btr->manager_reset_menu|escape}</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    {*Параметры элемента*}
   <div class="row">
        <div class="col-lg-12 col-md-12">
            <div class="boxed fn_toggle_wrap min_height_230px">
                <div class="heading_box">
                    {$btr->manager_rights|escape}
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="fa fn_icon_arrow fa-angle-down"></i></a>
                    </div>
                    <span class="font_14 text_600">{$btr->manager_all_access|escape}</span>
                    <label class="switch switch-default">
                        <input class="switch-input fn_all_perms" value="" type="checkbox" />
                        <span class="switch-label"></span>
                        <span class="switch-handle"></span>
                    </label>
                </div>
                <div class="toggle_body_wrap on fn_card">
                    {foreach $permission as $title=>$items}
                        <div class="permission_block">
                            <div class="heading_box">{$btr->get_translation({$title})}</div>
                            <div class="permission_boxes row fn_perms_wrap">
                                {foreach $items as $key=>$item}
                                    <div class="col-xl-3 col-lg-4 col-md-6 {if $m->id==$manager->id}text-muted{/if}">
                                        <div class="permission_box">
                                            <span>{$item|escape}</span>
                                            <label class="switch switch-default">
                                                <input class="switch-input fn_item_perm" name="permissions[]" value="{$key}" type="checkbox" {if $m->permissions && in_array($key, $m->permissions)}checked{/if} {if $m->id==$manager->id}disabled{/if}  />
                                                <span class="switch-label"></span>
                                                <span class="switch-handle"></span>
                                            </label>
                                        </div>
                                    </div>
                                {/foreach}
                            </div>
                        </div>
                        <div class="col-xs-12 clearfix"></div>
                    {/foreach}
                </div>
                <div class="row">
                    <div class="col-lg-12 col-md-12 ">
                        <button type="submit" class="btn btn_small btn_blue float-md-right">
                            {include file='svg_icon.tpl' svgId='checked'}
                            <span>{$btr->general_apply|escape}</span>
                        </button>
                        {if $m->cnt_try >= 10}
                            <button type="submit" name="unlock_manager" class="btn btn_small btn_blue">
                                <i class="fa fa-magic"></i>
                                &nbsp; {$btr->manager_unlock|escape}
                            </button>
                        {/if}
                    </div>
                </div>
            </div>
        </div>
   </div>
</form>

<script>
    $(document).on("change", ".fn_all_perms", function () {
        if($(this).is(":checked")) {
            $('.fn_item_perm').each(function () {
                if(!$(this).is(":checked")) {
                    $(this).trigger("click");
                }
            });
        } else {
            $('.fn_item_perm').each(function () {
                if($(this).is(":checked")) {
                    $(this).trigger("click");
                }
            })
        }
    })
</script>