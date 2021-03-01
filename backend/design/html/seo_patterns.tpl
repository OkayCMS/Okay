{$meta_title = $btr->seo_patterns_auto scope=global}

{*Название страницы*}
<div class="row">
    <div class="col-lg-6 col-md-6">
        <div class="heading_page">{$btr->seo_patterns_auto|escape}</div>
    </div>
    <div class="col-lg-4 col-md-3 text-xs-right float-xs-right"></div>
</div>

{*Вывод успешных сообщений*}
{if $message_success}
    <div class="row">
        <div class="col-lg-12 col-md-12 col-sm-12">
            <div class="boxed boxed_success">
                <div class="heading_box">
                    {if $message_success == 'saved'}{$btr->general_settings_saved|escape}{/if}
                </div>
                {if $smarty.get.return}
                    <a class="button" href="{$smarty.get.return}">{$btr->general_back|escape}</a>
                {/if}
            </div>
        </div>
    </div>
{/if}

{*Главная форма страницы*}
<form method="post" enctype="multipart/form-data">
    <input type=hidden name="session_id" value="{$smarty.session.id}">
    <input type="hidden" name="lang_id" value="{$lang_id}" />

    <div class="row">
        <div class="col-lg-12 col-md-12">
            <div class="boxed fn_toggle_wrap ">
                <div class="row">
                    {*Параметры элемента*}
                    <div class="col-lg-5 col-md-12">
                        <div class="heading_box">{$btr->seo_patterns_cat_name|escape}</div>
                        <div class="">
                            <div class="fn_preloader"></div>
                            <div>
                                <div class="seo_cateogories_wrap scrollbar-inner">
                                    <div class="seo_item fn_get_category" data-template_type="default">{$btr->seo_patterns_all_categories|escape}</div>
                                    {if $categories}
                                        {function name=category_seo}
                                            {foreach $cats as $cat}
                                                <div class="seo_item fn_get_category" data-template_type="category" data-category_id="{$cat->id}" style="padding-left: {$level*10}px" >{$cat->name|escape}</div>
                                                {category_seo cats=$cat->subcategories level=$level+1}
                                            {/foreach}
                                        {/function}
                                        {category_seo cats=$categories level=1}
                                    {/if}
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-7 col-md-12">
                        <div class="fn_result_ajax clearfix"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>
{* Подключаем Tiny MCE *}
{include file='tinymce_init.tpl'}
{* On document load *}

{literal}
<script>
    $(function() {

        toastr.options = {
            closeButton: true,
            newestOnTop: true,
            progressBar: true,
            positionClass: 'toast-top-right',
            preventDuplicates: false,
            onclick: null
        };
        msg = '';
        $(document).on("click", ".fn_get_category", function () {
            $(".fn_preloader ").addClass("ajax_preloader");
            $(".fn_get_category").removeClass("active");
            var elem = $(this),
                category_id = parseInt(elem.data("category_id")) ? parseInt(elem.data("category_id")) : null,
                template_type = elem.data("template_type"),
                action = "get",
                link = window.location.href,
                session_id = '{/literal}{$smarty.session.id}{literal}';

            $.ajax({
                url: link,
                method : 'post',
                data: {
                    ajax: 1,
                    session_id: session_id,
                    category_id: category_id,
                    template_type: template_type,
                    action : action,
                },
                dataType: 'json',
                success: function(data){
                    if(data.success) {
                        $(".fn_result_ajax").html(data.tpl);
                        toastr.success(msg, "Success");
                        elem.addClass("active");
                        $(".fn_preloader ").removeClass("ajax_preloader");
                    } else {
                        toastr.error(msg, "Error");
                        $(".fn_preloader ").removeClass("ajax_preloader");
                    }
                }
            });
        });

        $(document).on("click", ".fn_update_category", function () {
            $(".fn_preloader ").addClass("ajax_preloader ");
            var elem = $(this),
                category_id = parseInt(elem.data("category_id")) ? parseInt(elem.data("category_id")) : null,
                template_type = elem.data("template_type"),
                action = "set",
                link = window.location.href,
                session_id = '{/literal}{$smarty.session.id}{literal}';

            var auto_meta_title = '',
                auto_meta_keywords = '',
                auto_meta_desc = '',
                auto_description = '';

            auto_meta_title = $("input[name=auto_meta_title]").val();
            auto_meta_keywords = $("input[name=auto_meta_keywords]").val();
            auto_meta_desc = $("textarea[name=auto_meta_desc]").val();
            auto_description = $("textarea[name=auto_description]").val();

            $.ajax({
                url: link,
                method : 'post',
                data: {
                    ajax: 1,
                    session_id: session_id,
                    category_id: category_id,
                    template_type: template_type,
                    action : action,
                    auto_meta_title: auto_meta_title,
                    auto_meta_keywords: auto_meta_keywords,
                    auto_meta_desc: auto_meta_desc,
                    auto_description: auto_description,

                },
                dataType: 'json',
                success: function(data){
                    if(data.success) {
                        $(".fn_result_ajax").html(data.tpl);
                        toastr.success(msg, "Success");
                        $(".fn_preloader ").removeClass("ajax_preloader ");
                    } else {
                        toastr.error(msg, "Error");
                        $(".fn_preloader ").removeClass("ajax_preloader ");
                    }
                }
            });
           return false;
        });
    });
</script>
{/literal}
