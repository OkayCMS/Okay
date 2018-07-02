{if $banners_image->id}
    {$meta_title = $banners_image->name scope=parent}
{else}
    {$meta_title = $btr->banners_image_add_banner  scope=parent}
{/if}
{*Название страницы*}
<div class="row">
    <div class="col-lg-12 col-md-12">
        <div class="wrap_heading">
            <div class="box_heading heading_page">
                {if !$banners_image->id}
                     {$btr->banners_image_add_banner|escape}
                {else}
                    {$banners_image->name|escape}
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
                        {$btr->banners_image_added|escape}
                    {elseif $message_success=='updated'}
                        {$btr->banners_image_updated|escape}
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

{*Главная форма страницы*}
<form method="post" enctype="multipart/form-data" class="fn_fast_button">
    <input type=hidden name="session_id" value="{$smarty.session.id}">
    <input type="hidden" name="lang_id" value="{$lang_id}" />
    <div class="row">
        <div class="col-lg-12 col-md-12 col-sm-12">
            <div class="boxed">
                <div class="row d_flex">
                    {*Название элемента сайта*}
                    <div class="col-lg-10 col-md-9 col-sm-12">
                        <div class="heading_label">
                            {$btr->general_name|escape}
                        </div>
                        <div class="form-group">
                            <input class="form-control" name="name" type="text" value="{$banners_image->name|escape}"/>
                            <input name="id" type="hidden" value="{$banners_image->id|escape}"/>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-3 col-sm-12">
                        <div class="activity_of_switch">
                            <div class="activity_of_switch_item"> {* row block *}
                                <div class="okay_switch clearfix">
                                    <label class="switch_label">{$btr->general_enable|escape}</label>
                                    <label class="switch switch-default">
                                        <input class="switch-input" name="visible" value='1' type="checkbox" id="visible_checkbox" {if $banners_image->visible || !$banners_image->id}checked=""{/if}/>
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
    <div class="row">
        <div class="col-lg-6 col-md-12 pr-0">
            <div class="boxed fn_toggle_wrap min_height_230px">
                <div class="heading_box">
                    {$btr->general_image|escape}
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="fa fn_icon_arrow fa-angle-down"></i></a>
                    </div>
                </div>
                <div class="toggle_body_wrap fn_card on text-xs-center">
                    <input type="hidden" class="fn_accept_delete" name="delete_image" value="">
                        <div class="banner_image text-xs-center">
                            {if $banners_image->image}
                                <a href="javascript:;" class="fn_delete_banner remove_image"></a>
                                <img class="admin_banner_images" src="{$banners_image->image|resize:465:265:false:$config->resized_banners_images_dir}" alt="" />
                            {/if}
                        </div>
                        <div class="fn_upload_image dropzone_block_image text-xs-center {if $banners_image->image} hidden{/if}">
                            <i class="fa fa-plus font-5xl" aria-hidden="true"></i>
                            <input class="dropzone_banner" name="image" type="file" />
                        </div>
                </div>
            </div>
        </div>

        {*Параметры элемента*}
        <div class="col-lg-6 col-md-12">
            <div class="boxed fn_toggle_wrap min_height_230px">
                <div class="heading_box">
                    {$btr->banners_image_param|escape}
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="fa fn_icon_arrow fa-angle-down"></i></a>
                    </div>
                </div>
                <div class="toggle_body_wrap on fn_card">
                    <div class="">
                        <div class="heading_label" >{$btr->general_banner_group|escape}</div>
                        <select name="banner_id" class="selectpicker mb-1">
                            {foreach $banners as $banner}
                              <option value="{$banner->id}" {if $banners_image->banner_id == $banner->id}selected{/if}>{$banner->name|escape}</option>
                            {/foreach}
                        </select>
                    </div>

                    <div class="">
                        <div class="heading_label">{$btr->banners_image_url|escape}</div>
                        <div class="">
                          <input name="url" class="form-control" type="text" value="{$banners_image->url|escape}" />
                        </div>
                    </div>

                    <div class="">
                        <div class="heading_label">{$btr->banners_image_alt|escape}</div>
                        <div class="">
                          <input name="alt" class="form-control" type="text" value="{$banners_image->alt|escape}" />
                        </div>
                    </div>

                    <div class="">
                        <div class="heading_label">{$btr->banners_image_title|escape}</div>
                        <div class="">
                          <input name="title" class="form-control" type="text" value="{$banners_image->title|escape}" />
                        </div>
                    </div>

                    <div class="">
                        <div class="heading_label">{$btr->banners_image_description|escape}</div>
                        <div class="">
                          <textarea name="description" class="form-control okay_textarea ">{$banners_image->description|escape}</textarea>
                        </div>
                    </div>
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
<script>
    $(document).on("click", ".fn_delete_banner",function () {
       $(this).closest(".banner_image").find("img").remove();
       $(this).remove();
       $(".fn_upload_image ").removeClass("hidden");
        $(".fn_accept_delete").val(1);
    });

    if(window.File && window.FileReader && window.FileList) {

        $(".fn_upload_image").on('dragover', function (e){
            e.preventDefault();
            $(this).css('background', '#bababa');
        });
        $(".fn_upload_image").on('dragleave', function(){
            $(this).css('background', '#f8f8f8');
        });
        function handleFileSelect(evt){
            var files = evt.target.files; // FileList object
            // Loop through the FileList and render image files as thumbnails.
            for (var i = 0, f; f = files[i]; i++) {
                // Only process image files.
                if (!f.type.match('image.*')) {
                    continue;
                }
                var reader = new FileReader();
                // Closure to capture the file information.
                reader.onload = (function(theFile) {
                    return function(e) {
                        // Render thumbnail.
                        $("<a href='javascript:;' class='fn_delete_banner remove_image'></a><img class='admin_banner_images' onerror='$(this).closest(\"div\").remove();' src='"+e.target.result+"' />").appendTo("div.banner_image ");
                        $(".fn_upload_image").addClass("hidden");
                    };
                })(f);
                // Read in the image file as a data URL.
                reader.readAsDataURL(f);
            }
            $(".fn_upload_image").removeAttr("style");
        }
        $(document).on('change','.dropzone_banner',handleFileSelect);
    }
</script>
