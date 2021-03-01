{$meta_title = $btr->seo_filter_patterns_auto scope=global}

{*Название страницы*}
<div class="row">
    <div class="col-lg-6 col-md-6">
        <div class="heading_page">{$btr->seo_filter_patterns_auto|escape}</div>
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
    <input type="hidden" name="ajax" value="1" />
    <input type="hidden" name="category_id" value="" />
    <input type="hidden" name="action" value="set" />

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
                                    {if $categories}
                                        {function name=category_seo}
                                            {foreach $cats as $cat}
                                                <div class="seo_item fn_get_category" data-category_id="{$cat->id}" style="padding-left: {$level*10}px" >{$cat->name|escape}</div>
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
    <div class="row">
        <div class="col-lg-12 col-md-12">
            <div class="boxed fn_toggle_wrap ">
                <div class="heading_box">
                    {$btr->settings_chpu_filter|escape}
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="fa fn_icon_arrow fa-angle-down"></i></a>
                    </div>
                </div>
                <div class="toggle_body_wrap on fn_card">
                    <div class="row">
                        <div class="col-lg-6 col-md-6">
                            <div class="heading_label">{$btr->max_filter_brands|escape}</div>
                            <div class="mb-1">
                                <input name="max_filter_brands" class="form-control" type="text" value="{$settings->max_filter_brands|escape}" />
                            </div>
                        </div>
                        <div class="col-lg-6 col-md-6">
                            <div class="heading_label">{$btr->max_filter_filter|escape}</div>
                            <div class="mb-1">
                                <input name="max_filter_filter" class="form-control" type="text" value="{$settings->max_filter_filter|escape}" />
                            </div>
                        </div>
                        <div class="col-lg-6 col-md-6">
                            <div class="heading_label">{$btr->max_filter_features_values|escape}</div>
                            <div class="mb-1">
                                <input name="max_filter_features_values" class="form-control" type="text" value="{$settings->max_filter_features_values|escape}" />
                            </div>
                        </div>
                        <div class="col-lg-6 col-md-6">
                            <div class="heading_label">{$btr->max_filter_features|escape}</div>
                            <div class="mb-1">
                                <input name="max_filter_features" class="form-control" type="text" value="{$settings->max_filter_features|escape}" />
                            </div>
                        </div>
                        <div class="col-lg-6 col-md-6">
                            <div class="heading_label">{$btr->max_filter_depth|escape}</div>
                            <div class="mb-1">
                                <input name="max_filter_depth" class="form-control" type="text" value="{$settings->max_filter_depth|escape}" />
                            </div>
                        </div>
                        <div class="col-lg-6 col-md-6 ">
                            <div class="heading_label">&nbsp;</div>
                            <button type="submit" class="btn btn_small btn_blue float-md-right fn_update_category" data-category_id="{$category->id}">
                                {include file='svg_icon.tpl' svgId='checked'}
                                <span>{$btr->general_apply|escape}</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>

<div class="fn_new_template hidden fn_template_block">
    <div class="boxed">
    <div class="row">
        <div class="col-md-6">
            <div class="heading_box fn_heading_box"></div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-6">
            <div class="row">
                <div class="col-md-12">
                    <div class="heading_label">H1</div>
                    <div class="mb-1">
                        <input name="seo_filter_patterns[h1][]" class="fn_auto_meta_h1 form-control mb-h fn_ajax_area" value="" />
                    </div>
                </div>
                <div class="col-md-12">
                    <div class="heading_label">Auto Meta-description</div>
                    <div class="mb-1">
                        <input name="seo_filter_patterns[meta_description][]" class="fn_auto_meta_desc form-control fn_ajax_area" value="" />
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="row">
                <div class="col-md-12">
                    <div class="heading_label">Auto Meta-title</div>
                    <div class="mb-1">
                        <input name="seo_filter_patterns[title][]" class="fn_auto_meta_title form-control mb-h fn_ajax_area" value="" />
                    </div>
                </div>
                <div class="col-md-12">
                    <div class="heading_label">Auto Meta-keywords</div>
                    <div class="mb-1">
                        <input name="seo_filter_patterns[keywords][]" class="fn_auto_meta_keywords form-control fn_ajax_area" value="" />
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-lg-12 col-md-12">
            <div class="heading_label">{$btr->seo_filter_patterns_ajax_description|escape}</div>
            <div class="mb-1">
                <textarea name="seo_filter_patterns[description][]" class="fn_auto_description form-control okay_textarea fn_ajax_area"></textarea>
            </div>
        </div>
    </div>
     <div class="row">
        <div class="col-md-12">
            <div class="pull-right">
                <button type="button" class="fn_delete_template btn btn_mini btn-danger float-md-right" >
                    {include file='svg_icon.tpl' svgId='delete'}
                    <span>{$btr->seo_filter_patterns_delete_template|escape}</span>
                </button>
            </div>
        </div>
     </div>
    <input name="seo_filter_patterns[type][]" class="fn_pattern_type form-control" value="" type="hidden" />
    <input name="seo_filter_patterns[feature_id][]" class="fn_feature_id form-control" value="" type="hidden" />
    </div>
</div>

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

        var new_template = $('.fn_new_template').clone();
        $('.fn_new_template').remove();

        var new_templates_counter = 0;

        $(document).on("click", ".fn_delete_template", function () {
            $(this).closest('.fn_template_block').fadeOut(200, function() {
                $(this).remove();
            });
        });

        $(document).on("click", ".fn_add_seo_template", function () {
            var template = new_template.clone(),
                pattern_type_elem = $('.fn_pattern_type'),
                pattern_type_class = pattern_type = pattern_type_elem.children(':selected').val(),
                feature_elem = $('.fn_features'),
                feature_id   = feature_elem.children(':selected').val();

            if (pattern_type == 'feature' && feature_id) {
                pattern_type_class += '_'+feature_id;
            }

            if ($('.fn_'+pattern_type_class).size() > 0) {
                toastr.error(msg, "Template already exists");
            } else {
                template.addClass('fn_'+pattern_type_class);
                template.find('.fn_heading_box').text(
                        '{/literal}{$btr->seo_filter_patterns_category}{literal} '
                        +pattern_type_elem.children(':selected').text()
                        +(feature_id ? ' ('+feature_elem.children(':selected').text()+')' : '')
                );

                template.find('.fn_pattern_type').val(pattern_type);
                if (feature_id) {
                    template.find('.fn_feature_id').val(feature_id);
                }

                template.removeClass('hidden');
                new_templates_counter++;
                $('.fn_templates').append(template);
            }
        });

        $(document).on("change", ".fn_pattern_type", function () {
            var elem = $(this),
                category_elem = $('.fn_get_category.active'),
                pattern_type = elem.children(':selected').val(),
                category_id = parseInt(category_elem.data("category_id")) ? parseInt(category_elem.data("category_id")) : null,
                action = "get_features",
                link = window.location.href,
                session_id = '{/literal}{$smarty.session.id}{literal}';

            if (pattern_type == 'brand') {
                $('.fn_features').prop('disabled', true).addClass('hidden').children(':first').prop('selected', true);
            } else if (pattern_type == 'feature') {
                $.ajax({
                    url: link,
                    method : 'post',
                    data: {
                        ajax: 1,
                        session_id: session_id,
                        category_id: category_id,
                        action : action,
                    },
                    dataType: 'json',
                    success: function(data){
                        if(data.success && data.features) {
                            var features_html = '<option value="">{/literal}{$btr->seo_filter_patterns_all_features|escape}{literal}</option>';
                            for(var i=0; i<data.features.length; i++) {
                                var feature = data.features[i];
                                features_html += '<option value="'+feature.id+'">'+feature.name+'</option>';
                            }
                            $('.fn_features').html(features_html).prop('disabled', false).removeClass('hidden');
                        }
                    }
                });
            }
        });

        $(document).on("click", ".fn_get_category", function () {
            $(".fn_preloader ").addClass("ajax_preloader");
            $(".fn_get_category").removeClass("active");
            var elem = $(this),
                category_id = parseInt(elem.data("category_id")) ? parseInt(elem.data("category_id")) : null,
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
                action = "set",
                link = window.location.href,
                session_id = '{/literal}{$smarty.session.id}{literal}';

            $('input[name="category_id"]').val(category_id);
            $('input[name="action"]').val(action);

            $.ajax({
                url: link,
                method : 'post',
                data: $(this).closest('form').serialize(),
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
