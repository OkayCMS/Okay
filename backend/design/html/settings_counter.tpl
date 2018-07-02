{$meta_title = $btr->counters_title scope=parent}

{*Название страницы*}
<div class="row">
    <div class="col-lg-7 col-md-7">
        <div class="heading_page">{$btr->counters_title|escape}</div>
    </div>
    <div class="col-lg-5 col-md-5 float-xs-right"></div>
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
<form method="post" enctype="multipart/form-data" class="fn_fast_button">
    <input type=hidden name="session_id" value="{$smarty.session.id}">

    <div class="row">
        <div class="col-lg-12 col-md-12">
            <div class="boxed fn_toggle_wrap">

                <div class="toggle_body_wrap on fn_card">

                    <div class="boxed boxed_attention">
                        <div class="text_box mt-0">
                            {$btr->counters_info|escape}
                        </div>
                    </div>

                    <div class="fn_counters_list">
                        {if $counters}
                            {foreach $counters as $c}
                                <div class="boxed fn_row">
                                    <div class="row ">
                                        <div class="col-md-6">
                                            <div class="row">
                                                <div class="col-md-12">
                                                    <div class="heading_label">{$btr->counters_counter_name|escape}</div>
                                                    <div class="mb-1">
                                                        <input name="counters[name][]" class="form-control mb-h" value="{$c->name|escape}" />
                                                    </div>
                                                </div>
                                                <div class="col-md-12">
                                                    <div class="heading_label">{$btr->counters_counter_position|escape}</div>
                                                    <div class="mb-1">
                                                        <select name="counters[position][]" class="selectpicker">
                                                            <option value="head"{if $c->position == 'head'} selected{/if}>{$btr->counters_position_head|escape}</option>
                                                            <option value="body_top"{if $c->position == 'body_top'} selected{/if}>{$btr->counters_position_body_top|escape}</option>
                                                            <option value="body_bottom"{if $c->position == 'body_bottom'} selected{/if}>{$btr->counters_position_body_bottom|escape}</option>
                                                        </select>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="row">
                                                <div class="col-md-12">
                                                    <div class="heading_label">{$btr->counters_counter_code|escape}</div>
                                                    <div class="mb-1">
                                                        <textarea name="counters[code][]" class="form-control okay_textarea">{$c->code|escape}</textarea>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-lg-12 col-md-12 ">
                                            <button type="button" class="btn btn_mini btn-danger float-md-right fn_delete_counter">
                                                {include file='svg_icon.tpl' svgId='delete'}
                                                <span>{$btr->general_delete|escape}</span>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            {/foreach}
                        {/if}
                    </div>

                    <div class="fn_new_counter boxed hidden fn_row">
                        <div class="row ">
                            <div class="col-md-6">
                                <div class="row">
                                    <div class="col-md-12">
                                        <div class="heading_label">{$btr->counters_counter_name|escape}</div>
                                        <div class="mb-1">
                                            <input name="counters[name][]" class="form-control mb-h" value="" />
                                        </div>
                                    </div>
                                    <div class="col-md-12">
                                        <div class="heading_label">{$btr->counters_counter_position|escape}</div>
                                        <div class="mb-1">
                                            <select name="counters[position][]" class="selectpicker">
                                                <option value="head"{if $c->position == 'head'} selected{/if}>{$btr->counters_position_head|escape}</option>
                                                <option value="body_top"{if $c->position == 'body_top'} selected{/if}>{$btr->counters_position_body_top|escape}</option>
                                                <option value="body_bottom"{if $c->position == 'body_bottom'} selected{/if}>{$btr->counters_position_body_bottom|escape}</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="row">
                                    <div class="col-md-12">
                                        <div class="heading_label">{$btr->counters_counter_code|escape}</div>
                                        <div class="mb-1">
                                            <textarea name="counters[code][]" class="form-control okay_textarea"></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-lg-12 col-md-12 ">
                                <button type="button" class="btn btn_mini btn-danger float-md-right fn_delete_counter">
                                    {include file='svg_icon.tpl' svgId='delete'}
                                    <span>{$btr->general_delete|escape}</span>
                                </button>
                            </div>
                        </div>
                    </div>


                    <div class="box_btn_heading mt-1">
                        <button type="button" class="btn btn_mini btn-info fn_add_counter">
                            {include file='svg_icon.tpl' svgId='plus'}
                            <span>{$btr->counters_add_counter|escape}</span>
                        </button>
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
    </div>
</form>

{literal}
<script>

    $(document).on( "click", ".fn_delete_counter", function() {
        $(this).closest(".fn_row").fadeOut(200, function() { $(this).remove(); });
        return false;
    });

    $(window).on("load", function() {
        var counter = $(".fn_new_counter").clone(false);
        $(".fn_new_counter").remove();
        counter.find('.bootstrap-select').replaceWith(function() { return $('select', this); });
        $(document).on("click", ".fn_add_counter", function () {
            var counter_clone = counter.clone(true);
            counter_clone.find("select").selectpicker();
            counter_clone.removeClass("hidden").removeClass("fn_new_counter");
            $(".fn_counters_list").append(counter_clone);
            return false;
        });
    });

</script>
{/literal}
