{$meta_title = $btr->settings_general_sites scope=parent}

{*Название страницы*}
<div class="row">
    <div class="col-lg-7 col-md-7">
        <div class="heading_page">{$btr->settings_general_sites|escape}</div>
    </div>
    <div class="col-lg-5 col-md-5 text-xs-right float-xs-right"></div>
</div>

{*Вывод успешных сообщений*}
{if $message_success}
    <div class="row">
        <div class="col-lg-12 col-md-12 col-sm-12">
            <div class="boxed boxed_success">
                <div class="heading_box">
                    {if $message_success == 'saved'}
                        {$btr->general_settings_saved|escape}
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

{*Главная форма страницы*}
<form method="post" enctype="multipart/form-data">
    <input type=hidden name="session_id" value="{$smarty.session.id}">

    <div class="row">
        <div class="col-lg-12 col-md-12">
            <div class="boxed fn_toggle_wrap min_height_335px">
                <div class="heading_box">
                    {$btr->settings_general_options|escape}
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="fa fn_icon_arrow fa-angle-down"></i></a>
                    </div>
                </div>
                {*Параметры элемента*}
                <div class="toggle_body_wrap on fn_card">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="heading_label">{$btr->settings_general_sitename|escape}</div>
                            <div class="mb-1">
                                <input name="site_name" class="form-control" type="text" value="{$settings->site_name|escape}" />
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="heading_label">{$btr->settings_general_date|escape}</div>
                            <div class="mb-1">
                                <input name="date_format" class="form-control" type="text" value="{$settings->date_format|escape}" />
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="heading_label">{$btr->settings_general_email|escape}</div>
                            <div class="mb-1">
                                <input name="admin_email" class="form-control" type="text" value="{$settings->admin_email|escape}" />
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="heading_label">{$btr->settings_general_shutdown|escape}</div>
                            <div class="mb-1">
                                <select name="site_work" class="selectpicker">
                                    <option value="on" {if $settings->site_work == "on"}selected{/if}>{$btr->settings_general_turn_on|escape}</option>
                                    <option value="off" {if $settings->site_work == "off"}selected{/if}>{$btr->settings_general_turn_off|escape}</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-xs-12">
                            <div class="heading_label">{$btr->settings_general_tech_message|escape}</div>
                            <div class="">
                                <textarea name="site_annotation" class="form-control okay_textarea">{$settings->site_annotation|escape}</textarea>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    {*Логотип сайта*}
    <div class="row">
        <div class="col-lg-12 col-md-12">
            <div class="boxed fn_toggle_wrap ">
                <div class="heading_box">
                    {$btr->settings_general_site_logo|escape}
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="fa fn_icon_arrow fa-angle-down"></i></a>
                    </div>
                </div>
                <div>
                    {$btr->settings_general_allow_ext|escape}
                    {if $allow_ext}
                        {foreach $allow_ext as $img_ext}
                            <span class="tag tag-info">{$img_ext|escape}</span>
                        {/foreach}
                    {/if}
                </div>
                <div class="toggle_body_wrap on fn_card">
                    <div class="row">
                        <div class="col-lg-6 col-md-6">
                            <div class="boxed">
                                {if $settings->site_logo}
                                    <div class="fn_parent_image txt_center">
                                        <div class="banner_image fn_image_wrapper text-xs-center">
                                            <a href="javascript:;" class="fn_delete_item remove_image"></a>
                                            <input type="hidden" name="site_logo" value="{$settings->site_logo|escape}">
                                            <img class="watermark_image" src="{$config->root_url}/design/{$settings->theme}/images/{$settings->site_logo}" alt="" />
                                        </div>
                                    </div>
                                {else}
                                    <div class="fn_parent_image"></div>
                                {/if}

                                <div class="fn_upload_image dropzone_block_image text-xs-center {if $settings->site_logo} hidden{/if}">
                                    <i class="fa fa-plus font-5xl" aria-hidden="true"></i>
                                    <input class="dropzone_image" name="site_logo" type="file" />
                                </div>
                                <div class="image_wrapper fn_image_wrapper fn_new_image text-xs-center">
                                    <a href="javascript:;" class="fn_delete_item delete_image remove_image"></a>
                                    <input type="hidden" name="site_logo" value="{$settings->site_logo|escape}">
                                    <img src="" alt="" />
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
        <div class="col-lg-12 col-md-12">
            <div class="boxed fn_toggle_wrap min_height_210px">
                <div class="heading_box">
                    {$btr->settings_general_capcha|escape}
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="fa fn_icon_arrow fa-angle-down"></i></a>
                    </div>
                </div>
                <div class="toggle_body_wrap on fn_card">
                    <div class="boxed boxed_attention">
                        <div class="">
                            {$btr->settings_capcha_help1|escape} <a class="link_white" target="_blank" rel="nofollow" href="https://www.google.com/recaptcha/admin#list">{$btr->settings_capcha_help2|escape}</a>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-xl-3 col-lg-4 col-md-6">
                            <div class="heading_label">{$btr->settings_type_capcha|escape}</div>
                            <div class="mb-1">
                                <select name="captcha_type" class="selectpicker">
                                    <option value="default" {if $settings->captcha_type == "default"}selected{/if}>{$btr->captcha_default}</option>
                                    <option value="v3" {if $settings->captcha_type == "v3"}selected{/if}>reCAPTCHA V3</option>
                                    <option value="v2" {if $settings->captcha_type == "v2"}selected{/if}>reCAPTCHA V2</option>
                                    <option value="invisible" {if $settings->captcha_type == "invisible"}selected{/if}>reCAPTCHA Invisible</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="permission_block">
                        <div class="permission_boxes row">
                            <div class="col-xl-3 col-lg-4 col-md-6">
                                <div class="permission_box">
                                    <span>{$btr->settings_general_product|escape}</span>
                                    <label class="switch switch-default">
                                        <input class="switch-input" name="captcha_product" value='1' type="checkbox" {if $settings->captcha_product}checked=""{/if}/>
                                        <span class="switch-label"></span>
                                        <span class="switch-handle"></span>
                                    </label>
                                </div>
                            </div>

                            <div class="col-xl-3 col-lg-4 col-md-6">
                                <div class="permission_box">
                                    <span>{$btr->settings_general_blog|escape}</span>
                                    <label class="switch switch-default">
                                        <input class="switch-input" name="captcha_post" value='1' type="checkbox" {if $settings->captcha_post}checked=""{/if}/>
                                        <span class="switch-label"></span>
                                        <span class="switch-handle"></span>
                                    </label>
                                </div>
                            </div>

                            <div class="col-xl-3 col-lg-4 col-md-6">
                                <div class="permission_box">
                                    <span>{$btr->settings_general_cart|escape}</span>
                                    <label class="switch switch-default">
                                        <input class="switch-input" name="captcha_cart" value='1' type="checkbox" {if $settings->captcha_cart}checked=""{/if}/>
                                        <span class="switch-label"></span>
                                        <span class="switch-handle"></span>
                                    </label>
                                 </div>
                            </div>

                            <div class="col-xl-3 col-lg-4 col-md-6">
                                <div class="permission_box">
                                    <span>{$btr->settings_general_register|escape}</span>
                                    <label class="switch switch-default">
                                        <input class="switch-input" name="captcha_register" value='1' type="checkbox" {if $settings->captcha_register}checked=""{/if}/>
                                        <span class="switch-label"></span>
                                        <span class="switch-handle"></span>
                                    </label>
                                </div>
                            </div>

                            <div class="col-xl-3 col-lg-4 col-md-6">
                                <div class="permission_box">
                                    <span>{$btr->settings_general_contact_form|escape}</span>
                                    <label class="switch switch-default">
                                        <input class="switch-input" name="captcha_feedback" value='1' type="checkbox" {if $settings->captcha_feedback}checked=""{/if}/>
                                        <span class="switch-label"></span>
                                        <span class="switch-handle"></span>
                                    </label>
                                </div>
                            </div>

                            <div class="col-xl-3 col-lg-4 col-md-6">
                                <div class="permission_box">
                                    <span>{$btr->settings_general_callback|escape}</span>
                                    <label class="switch switch-default">
                                        <input class="switch-input" name="captcha_callback" value='1' type="checkbox" {if $settings->captcha_callback}checked=""{/if}/>
                                        <span class="switch-label"></span>
                                        <span class="switch-handle"></span>
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-6 col-md-12">
                            <div class="boxed">
                                <div class="heading_box">
                                    reCAPTCHA V2
                                 </div>
                                <div class="">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="heading_label">{$btr->recaptcha_key|escape}</div>
                                            <div class="mb-1">
                                                <input name="public_recaptcha" class="form-control" type="text" value="{$settings->public_recaptcha|escape}" />
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="heading_label">{$btr->recaptcha_secret_key|escape}</div>
                                            <div class="mb-1">
                                                <input name="secret_recaptcha" class="form-control" type="text" value="{$settings->secret_recaptcha|escape}" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-6 col-md-12">
                            <div class="boxed">
                                <div class="heading_box">
                                    reCAPTCHA invisible
                                </div>
                                <div class="">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="heading_label">{$btr->recaptcha_key|escape}</div>
                                            <div class="mb-1">
                                                <input name="public_recaptcha_invisible" class="form-control" type="text" value="{$settings->public_recaptcha_invisible|escape}" />
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="heading_label">{$btr->recaptcha_secret_key|escape}</div>
                                            <div class="mb-1">
                                                <input name="secret_recaptcha_invisible" class="form-control" type="text" value="{$settings->secret_recaptcha_invisible|escape}" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-lg-6 col-md-12">
                            <div class="boxed">
                                <div class="heading_box">
                                    reCAPTCHA V3
                                 </div>
                                <div class="">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="heading_label">{$btr->recaptcha_key|escape}</div>
                                            <div class="mb-1">
                                                <input name="public_recaptcha_v3" class="form-control" type="text" value="{$settings->public_recaptcha_v3|escape}" />
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="heading_label">{$btr->recaptcha_secret_key|escape}</div>
                                            <div class="mb-1">
                                                <input name="secret_recaptcha_v3" class="form-control" type="text" value="{$settings->secret_recaptcha_v3|escape}" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-6 col-md-12">
                            <div class="boxed">
                                <div class="heading_box">
                                    {$btr->recaptcha_v3_scores|escape}
                                </div>
                                <div class="">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <div class="heading_label">{$btr->recaptcha_scores_product|escape}</div>
                                            <div class="mb-1">
                                                <input name="recaptcha_scores[product]" class="form-control" type="text" value="{$settings->recaptcha_scores['product']|escape}" />
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="heading_label">{$btr->recaptcha_scores_cart|escape}</div>
                                            <div class="mb-1">
                                                <input name="recaptcha_scores[cart]" class="form-control" type="text" value="{$settings->recaptcha_scores['cart']|escape}" />
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="heading_label">{$btr->recaptcha_scores_other|escape}</div>
                                            <div class="mb-1">
                                                <input name="recaptcha_scores[other]" class="form-control" type="text" value="{$settings->recaptcha_scores['other']|escape}" />
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    {* Карта в контактах*}
    <div class="row">
        <div class="col-lg-12 col-md-12">
            <div class="boxed fn_toggle_wrap">
                <div class="heading_box">
                    {$btr->settings_general_iframe_map|escape}
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="fa fn_icon_arrow fa-angle-down"></i></a>
                    </div>
                </div>
                {*Параметры элемента*}
                <div class="toggle_body_wrap on fn_card">
                    <div class="row">
                        <div class="col-xs-12">
                            <div class="heading_label">{$btr->settings_general_iframe_message|escape}</div>
                            <div class="">
                                <textarea name="iframe_map_code" class="form-control okay_textarea">{$settings->iframe_map_code}</textarea>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="row">
        <div class="col-lg-12 col-md-12">
            <div class="boxed fn_toggle_wrap min_height_210px">
                <div class="heading_box">
                    {$btr->settings_general_gathering_data}
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="fa fn_icon_arrow fa-angle-down"></i></a>
                    </div>
                </div>
                <div class="toggle_body_wrap on fn_card">
                    <div class="permission_block">
                        <div class="permission_boxes row">
                            <div class="col-xl-12 col-lg-12 col-md-12">
                                <div class="permission_box">
                                    <span>{$btr->settings_general_gather_enabled}</span>
                                    <label class="switch switch-default">
                                        <input class="switch-input" name="gather_enabled" value='1' type="checkbox" {if $settings->gather_enabled}checked=""{/if}/>
                                        <span class="switch-label"></span>
                                        <span class="switch-handle"></span>
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-xs-12 clearfix"></div>
                </div>
                <div class="row">
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
</form>
