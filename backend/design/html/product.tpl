{if $product->id}
    {$meta_title = $product->name scope=parent}
{else}
    {$meta_title = $btr->product_new scope=parent}
{/if}

{*Название страницы*}
<div class="row">
    <div class="col-lg-12 col-md-12">
        <div class="wrap_heading">
            <div class="box_heading heading_page">
                {if !$product->id}
                    {$btr->product_add|escape}
                {else}
                    {$product->name|escape}
                {/if}
            </div>
            {if $product->id && !empty($product->url)}
                <div class="box_btn_heading">
                    <a class="btn btn_small btn-info add" target="_blank" href="../{$lang_link}products/{$product->url}" >
                        {include file='svg_icon.tpl' svgId='icon_desktop'}
                        <span>{$btr->general_open|escape}</span>
                    </a>
                </div>
            {/if}
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
                        {$btr->product_added|escape}
                    {elseif $message_success=='updated'}
                        {$btr->product_updated|escape}
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
                    {if $message_error=='url_exists'}
                        {$btr->product_exists|escape}
                    {elseif $message_error=='empty_name'}
                        {$btr->general_enter_title|escape}
                    {elseif $message_error == 'empty_url'}
                        {$btr->general_enter_url|escape}
                    {elseif $message_error == 'url_wrong'}
                        {$btr->general_not_underscore|escape}
                    {elseif $message_error == 'empty_categories'}
                        {$btr->product_no_category|escape}
                    {else}
                        {$message_error|escape}
                    {/if}
                </div>
            </div>
        </div>
    </div>
{/if}

{*Главная форма страницы*}
<form method="post" id="product" enctype="multipart/form-data" class="clearfix fn_fast_button">
    <input type=hidden name="session_id" value="{$smarty.session.id}">
    <input type="hidden" name="lang_id" value="{$lang_id}" />

    <div class="row">
        <div class="col-xs-12">
            <div class="boxed">
                {*Название элемента сайта*}
                <div class="row d_flex">
                    <div class="col-lg-10 col-md-9 col-sm-12">
                        <div class="heading_label">
                            {$btr->general_name|escape}
                        </div>
                        <div class="form-group">
                            <input class="form-control" name="name" type="text" value="{$product->name|escape}"/>
                            <input id="product_id" name="id" type="hidden" value="{$product->id|escape}"/>
                        </div>
                        <div class="row">
                            <div class="col-xs-12 col-lg-6 col-md-10">
                                <div class="">
                                    <div class="input-group">
                                        <span class="input-group-addon">URL</span>
                                        <input name="url" class="fn_meta_field form-control fn_url {if $product->id}fn_disabled{/if}" {if $product->id}readonly=""{/if} type="text" value="{$product->url|escape}" />
                                        <input type="checkbox" id="block_translit" class="hidden" value="1" {if $product->id}checked=""{/if}>
                                        <span class="input-group-addon fn_disable_url">
                                            {if $product->id}
                                                <i class="fa fa-lock"></i>
                                            {else}
                                                <i class="fa fa-lock fa-unlock"></i>
                                            {/if}
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-2 col-md-3 col-sm-12">
                        <div class="activity_of_switch">
                            <div class="activity_of_switch_item"> {* row block *}
                                <div class="okay_switch clearfix">
                                    <label class="switch_label">{$btr->general_enable|escape}</label>
                                    <label class="switch switch-default">
                                        <input class="switch-input" name="visible" value='1' type="checkbox" id="visible_checkbox" {if $product->visible}checked=""{/if}/>
                                        <span class="switch-label"></span>
                                        <span class="switch-handle"></span>
                                    </label>
                                </div>
                            </div>
                            <div class="activity_of_switch_item"> {* row block *}
                                <div class="okay_switch clearfix">
                                    <label class="switch_label">{$btr->general_bestseller|escape}</label>
                                    <label class="switch switch-default">
                                        <input class="switch-input" name="featured" value="1" type="checkbox" id="featured_checkbox" {if $product->featured}checked=""{/if}/>
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

    {*Изображения товара*}
    <div class="row">
        <div class="col-lg-8 col-md-12 pr-0 ">
            <div class="boxed fn_toggle_wrap min_height_230px">
                <div class="heading_box">
                    {$btr->product_images|escape}
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="fa fn_icon_arrow fa-angle-down"></i></a>
                    </div>
                </div>

                <div class="toggle_body_wrap fn_card on ">
                    <ul class="fn_droplist_wrap product_images_list clearfix sortable" data-image="product">
                        <li class="fn_dropzone dropzone_block">
                            <i class="fa fa-plus font-5xl" aria-hidden="true"></i>
                            <input type="file" name="dropped_images[]" multiple class="dropinput">
                        </li>
                        {foreach $product_images as $image}
                            <li class="product_image_item {if $image@first}first_image{/if} {if $image@iteration > 4}fn_toggle_hidden hidden{/if} fn_sort_item">
                                <button type="button" class="fn_remove_image remove_image"></button>
                                <i class="move_zone">
                                    {if $image}
                                         <img class="product_icon" src="{$image->filename|resize:300:120}" alt=""/>
                                    {else}
                                        <img class="product_icon" src="design/images/no_image.png" width="40">
                                    {/if}
                                   <input type=hidden name='images[]' value="{$image->id}">
                                </i>
                            </li>
                        {/foreach}
                        <li class="fn_new_image_item product_image_item fn_sort_item">
                            <button type="button" class="fn_remove_image remove_image"></button>
                            <img src="" alt=""/>
                            <input type=hidden name='images_urls[]' value="">
                        </li>
                    </ul>
                    {if $product_images|count > 4}
                        <div class="show_more_images fn_show_images">{$btr->product_images_all|escape}</div>
                    {/if}
                </div>
            </div>
        </div>

        {*Параметры элемента*}
        <div class="col-lg-4 col-md-12 ">
            <div class="boxed fn_toggle_wrap min_height_230px">
                <div class="heading_label">
                    {$btr->general_brand|escape}
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="icon-arrow-down"></i></a>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-12 toggle_body_wrap on fn_card ">
                        <select name="brand_id" class="selectpicker mb-1{if !$brands} hidden{/if} fn_meta_brand" data-live-search="true">
                            <option value="0" {if !$product->brand_id}selected=""{/if} data-brand_name="">{$btr->general_not_set|escape}</option>
                            {foreach $brands as $brand}
                                <option value="{$brand->id}" {if $product->brand_id == $brand->id}selected=""{/if} data-brand_name="{$brand->name|escape}">{$brand->name|escape}</option>
                            {/foreach}
                        </select>
                        <div class="heading_label">{$btr->general_category|escape}</div>
                        <div id="product_cats">
                            {assign var ='first_category' value=reset($product_categories)}
                            <select class="selectpicker  mb-1 fn_product_category fn_meta_categories" data-live-search="true">
                                <option value="0" selected="" disabled="" data-category_name="">{$btr->product_select_category}</option>
                                {function name=category_select level=0}
                                    {foreach $categories as $category}
                                        <option value="{$category->id}" {if $category->id == $first_category->id}selected{/if} data-category_name="{$category->name|escape}">{section sp $level}- {/section}{$category->name|escape}</option>
                                        {category_select categories=$category->subcategories level=$level+1}
                                    {/foreach}
                                {/function}
                                {category_select categories=$categories}
                            </select>
                            <div id="sortable_cat" class="fn_product_categories_list">
                                {foreach $product_categories as $product_category}
                                    <div class="fn_category_item product_category_item {if $product_category@first}first_category{/if}">
                                        <span class="product_cat_name">{$product_category->name|escape}</span>
                                        <label class="fn_delete_product_cat fa fa-times" for="id_{$product_category->id}"></label>
                                        <input id="id_{$product_category->id}" type="checkbox" value="{$product_category->id}" data-cat_name="{$product_category->name|escape}" checked="" name="categories[]">
                                    </div>
                                {/foreach}
                            </div>
                            <div class="fn_category_item fn_new_category_item product_category_item">
                                <span class="product_cat_name"></span>
                                <label class="fn_delete_product_cat fa fa-times" for=""></label>
                                <input id="" type="checkbox" value="" name="categories[]" data-cat_name="">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    {*Варианты товара*}
    <div class="row">
        <div class="col-lg-12 col-md-12 ">
            <div class="boxed fn_toggle_wrap match_matchHeight_true">
                <div class="heading_box">
                    {$btr->general_options|escape}
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="fa fn_icon_arrow fa-angle-down"></i></a>
                    </div>
                </div>

                <div class="variants_wrapper fn_card">
                    <div class="okay_list variants_list scrollbar-variant">
                        <div class="okay_list_body sortable variants_listadd">
                            {foreach $product_variants as $variant}
                                <div class="okay_list_body_item variants_list_item ">
                                    <div class="okay_list_row">
                                        <div class="okay_list_boding variants_item_drag">
                                            <div class="heading_label"></div>
                                            <div class="move_zone">
                                                {include file='svg_icon.tpl' svgId='drag_vertical'}
                                            </div>
                                        </div>
                                        <div class="okay_list_boding variants_item_sku">
                                            <div class="heading_label">{$btr->general_sku|escape}</div>
                                            <input class="variant_input" name="variants[sku][]" type="text" value="{$variant->sku|escape}"/>
                                        </div>
                                        <div class="okay_list_boding variants_item_name">
                                            <div class="heading_label">{$btr->general_option_name|escape}</div>
                                            <input name="variants[id][]" type="hidden" value="{$variant->id|escape}" />
                                            <input class="variant_input" name="variants[name][]" type="text" value="{$variant->name|escape}" />
                                        </div>
                                        <div class="okay_list_boding variants_item_price">
                                            <div class="heading_label">{$btr->general_price|escape}</div>
                                            <input class="variant_input" name="variants[price][]" type="text" value="{$variant->price|escape}"/>
                                        </div>
                                        <div class="okay_list_boding variants_item_discount">
                                            <div class="heading_label">{$btr->general_old_price|escape}</div>
                                            <input class="variant_input" name="variants[compare_price][]" type="text" value="{$variant->compare_price|escape}"/>
                                        </div>
                                        <div class="okay_list_boding variants_item_currency">
                                            <div class="heading_label">{$btr->general_currency|escape}</div>
                                            <select name="variants[currency_id][]" class="selectpicker">
                                                {foreach $currencies as $c}
                                                    <option value="{$c->id}" {if $c->id == $variant->currency_id}selected=""{/if}>{$c->code|escape}</option>
                                                {/foreach}
                                            </select>
                                        </div>
                                        <div class="okay_list_boding variants_item_weight">
                                            <div class="heading_label">{$btr->general_weight|escape}</div>
                                            <input class="variant_input" name="variants[weight][]" type="text" value="{$variant->weight|escape}"/>
                                        </div>
                                        <div class="okay_list_boding variants_item_amount">
                                            <div class="heading_label">{$btr->general_qty|escape}</div>
                                            <input class="variant_input" name="variants[stock][]" type="text" value="{if $variant->infinity || $variant->stock == ''}∞{else}{$variant->stock|escape}{/if}"/>
                                        </div>
                                        <div class="okay_list_boding variants_item_units">
                                            <div class="heading_label">{$btr->products_variant_units|escape}</div>
                                            <input class="variant_input" name="variants[units][]" type="text" value="{$variant->units|escape}"/>
                                        </div>
                                    </div>
                                    <div class="okay_list_row">
                                        <div class="okay_list_boding variants_item_drag"></div>
                                        <div class="okay_list_boding variants_item_yandex">
                                            <div class="okay_switch clearfix">
                                                <div class="heading_label">{$btr->general_add_xml_short|escape}</div>
                                                <label class="switch switch-default switch-pill switch-primary-outline-alt">
                                                    <input class="switch-input" name="feed[{$variant->id|escape}]" value="1" type="checkbox" {if $variant->feed}checked=""{/if}/>
                                                    <span class="switch-label"></span>
                                                    <span class="switch-handle"></span>
                                                </label>
                                            </div>
                                        </div>
                                        <div class="okay_list_boding variants_item_file fn_file_wrap">
                                            <div class="heading_label">{$btr->general_digital_product|escape}</div>
                                            <input type="file" name="attachment[]" />
                                            <input type="hidden" name="delete_attachment[]" />
                                            {if $variant->attachment}
                                                <span class=fn_attachment_name>{$variant->attachment|truncate:25:'...':false:true}</span>
                                                <button data-hint="{$btr->general_delete_file|escape}" type="button" class="btn_close delete_grey fn_remove_attach hint-top-middle-t-info-s-small-mobile  hint-anim">
                                                    {include file='svg_icon.tpl' svgId='delete'}
                                                </button>
                                            {/if}
                                        </div>
                                        {if !$variant@first}
                                            <div class="okay_list_boding okay_list_close remove_variant">
                                                <button data-hint="{$btr->general_delete_product|escape}" type="button" class="btn_close fn_remove_variant hint-bottom-right-t-info-s-small-mobile  hint-anim">
                                                    {include file='svg_icon.tpl' svgId='delete'}
                                                </button>
                                             </div>
                                        {/if}
                                    </div>
                                </div>
                            {/foreach}
                            <div class="okay_list_body_item variants_list_item fn_new_row_variant">
                                <div class="okay_list_row ">
                                    <div class="okay_list_boding variants_item_drag">
                                        <div class="heading_label"></div>
                                        <div class="move_zone">
                                            {include file='svg_icon.tpl' svgId='drag_vertical'}
                                        </div>
                                    </div>
                                    <div class="okay_list_boding variants_item_sku">
                                        <div class="heading_label">{$btr->general_sku|escape}</div>
                                        <input class="variant_input" name="variants[sku][]" type="text" value=""/>
                                    </div>
                                    <div class="okay_list_boding variants_item_name">
                                        <div class="heading_label">{$btr->general_option_name|escape}</div>
                                        <input name="variants[id][]" type="hidden" value="" />
                                        <input class="variant_input" name="variants[name][]" type="text" value="" />
                                    </div>
                                    <div class="okay_list_boding variants_item_price">
                                        <div class="heading_label">{$btr->general_price|escape}</div>
                                        <input class="variant_input" name="variants[price][]" type="text" value=""/>
                                    </div>
                                    <div class="okay_list_boding variants_item_discount">
                                        <div class="heading_label">{$btr->general_old_price|escape}</div>
                                        <input class="variant_input" name="variants[compare_price][]" type="text" value=""/>
                                    </div>
                                    <div class="okay_list_boding variants_item_currency">
                                        <div class="heading_label">{$btr->general_currency|escape}</div>
                                        <select name="variants[currency_id][]" class="selectpicker">
                                            {foreach $currencies as $c}
                                                <option value="{$c->id}" >{$c->code|escape}</option>
                                            {/foreach}
                                        </select>
                                    </div>
                                    <div class="okay_list_boding variants_item_weight">
                                        <div class="heading_label">{$btr->general_weight|escape}</div>
                                        <input class="variant_input" name="variants[weight][]" type="text" value=""/>
                                    </div>
                                    <div class="okay_list_boding variants_item_amount">
                                        <div class="heading_label">{$btr->general_qty|escape}</div>
                                        <input class="variant_input" name="variants[stock][]" type="text" value=""/>
                                    </div>
                                    <div class="okay_list_boding variants_item_units">
                                        <div class="heading_label">{$btr->products_variant_units|escape}</div>
                                        <input class="variant_input" name="variants[units][]" type="text" value=""/>
                                    </div>
                                </div>
                                <div class="okay_list_row">
                                    <div class="okay_list_boding variants_item_drag"></div>
                                    <div class="okay_list_boding variants_item_file">
                                        <div class="heading_label">{$btr->general_digital_product|escape}</div>
                                        <input type="file" name="attachment[]" />
                                        <input type="hidden" name="delete_attachment[]" />
                                        <span class=fn_attachment_name></span>
                                    </div>
                                    <div class="okay_list_boding okay_list_close remove_variant">
                                        <button data-hint="{$btr->general_delete_product|escape}" type="button" class="btn_close fn_remove_variant hint-bottom-right-t-info-s-small-mobile  hint-anim">
                                            {include file='svg_icon.tpl' svgId='delete'}
                                        </button>
                                     </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="box_btn_heading mt-1">
                        <button type="button" class="btn btn_mini btn-info fn_add_variant">
                            {include file='svg_icon.tpl' svgId='plus'}
                            <span>{$btr->product_add_option|escape}</span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    {*Промо-изображения товара*}
    <div class="row">
        <div class="col-lg-8 col-md-12 pr-0 ">
            <div class="boxed fn_toggle_wrap min_height_230px">
                <div class="heading_box">
                    {$btr->product_promotions|escape}
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="fa fn_icon_arrow fa-angle-down"></i></a>
                    </div>
                </div>
                <div class="toggle_body_wrap on fn_card">
                    <ul class="fn_droplist_wrap product_images_list clearfix sortable" data-image="special">
                        <li class="fn_dropzone dropzone_block">
                            <i class="fa fa-plus font-5xl" aria-hidden="true"></i>
                            <input type="file" name="spec_dropped_images[]" multiple class="dropinput">
                        </li>
                        {if $special_images|count > 0}
                            {foreach $special_images as $special}
                                <li class="product_image_item {if $special@iteration > 4}fn_toggle_hidden hidden{/if} fn_sort_item {if $product->special == $special->filename}product_special{/if}">
                                    <button type="button" class=" fn_remove_image remove_image"></button>
                                    <i class="move_zone">
                                        <img class="product_icon" title="{$special->name}" src="../{$config->special_images_dir}{$special->filename}" alt="{$special->filename}" />
                                        <span class="fn_change_special change_special" data-origin="{$btr->general_select|escape}" data-result="{$btr->general_unselect|escape}">
                                            {if $product->special == $special->filename}
                                                {$btr->general_unselect|escape}
                                            {else}
                                                {$btr->general_select|escape}
                                            {/if}
                                        </span>
                                        <input type="radio" name="special" value="{$special->filename|escape}" class="hidden" {if $product->special == $special->filename}checked{/if}>
                                    </i>
                                    <input type="hidden" name="spec_images[]" value="{$special->id}" />
                                </li>
                            {/foreach}
                        {/if}
                        <li class="fn_new_spec_image_item product_image_item fn_sort_item">
                            <button type="button" class="fn_remove_image remove_image"></button>
                            <img src="" alt=""/>
                            <input type="hidden" name='spec_images_urls[]' value="" />
                            <i class="move_zone fa fa-arrows font-2xl"></i>
                        </li>
                    </ul>
                    {if $special_images|count > 4}
                        <div class="show_more_images fn_show_images">{$btr->product_images_all|escape}</div>
                    {/if}
                </div>
            </div>
        </div>
        {*Рейтинг*}
        <div class="col-lg-4 col-md-12">
            <div class="boxed fn_toggle_wrap min_height_230px">
                <div class="heading_box">
                    {$btr->product_rating|escape}
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="fa fn_icon_arrow fa-angle-down"></i></a>
                    </div>
                </div>
                <div class="toggle_body_wrap on fn_card">
                    <div class="heading_label">
                        {$btr->product_rating_value|escape}
                        <span class="font-weight-bold fn_show_rating">{$product->rating}</span>
                    </div>
                    <div class="raiting_boxed">
                        <input class="fn_rating_value" type="hidden" value="{$product->rating}" name="rating" />
                        <input class="fn_rating range_input" type="range" min="1" max="5" step="0.1" value="{$product->rating}" />

                        <div class="raiting_range_number">
                            <span class="float-xs-left">1</span>
                            <span class="float-xs-right">5</span>
                        </div>
                    </div>
                    <div class="heading_label">
                        {$btr->product_rating_number|escape}
                        <input type="text" class="form-control" name="votes" value="{$product->votes}">
                    </div>
                </div>
            </div>
        </div>
    </div>

    {*Свойства товара*}
    <div class="row">
        <div class="col-lg-6 col-md-12 pr-0 ">
            <div class="boxed fn_toggle_wrap min_height_210px">
            <div class="heading_box">
                {$btr->product_features|escape}
                <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                    <a class="btn-minimize" href="javascript:;" ><i class="fa fn_icon_arrow fa-angle-down"></i></a>
                </div>
                {if $lang_id != $main_lang_id}
                    <div class="boxed boxed_attention mt-h mb-0">
                        {$btr->product_features_values_change_notice}
                    </div>
                {/if}
            </div>
            <div class="toggle_body_wrap on fn_card">
                <div class="features_wrap fn_features_wrap">
                    {foreach $features as $feature}
                        <div class="fn_feature_block_{$feature->id}">
                            {assign var="feature_id" value=$feature->id}
                            {foreach $features_values.$feature_id as $feature_value}
                                <div class="feature_row clearfix">
                                    <div class="feature_name{if !$feature_value@first} additional_values{/if}">
                                        {if $feature_value@first}
                                            <span title="{$feature->name|escape}">
                                                <a href="index.php?module=FeatureAdmin&id={$feature->id}" target="_blank">
                                                    {$feature->name|escape}
                                                </a>
                                            </span>
                                        {/if}
                                    </div>
                                    <div class="feature_value">
                                        <input class="feature_input fn_auto_option" data-id="{$feature_id}" type="text" name="features_values_text[{$feature_id}][]" value="{$feature_value->value|escape}"{if $lang_id != $main_lang_id} readonly{/if}/>
                                        <input class="fn_value_id_input" type="hidden" name="features_values[{$feature_id}][]" value="{$feature_value->id}"/>
                                        <button type="button" class="btn btn_mini{if $feature_value@first} btn-info fn_add{else} btn-danger fn_remove{/if} fn_feature_multi_values feature_multi_values">
                                            <span class="fn_plus" {if !$feature_value@first}style="display: none;"{/if}>
                                                {include file='svg_icon.tpl' svgId='plus'}
                                            </span>
                                            <span class="fn_minus" {if $feature_value@first}style="display: none;"{/if}>
                                                {include file='svg_icon.tpl' svgId='minus'}
                                            </span>
                                        </button>
                                    </div>
                                </div>
                            {foreachelse}
                                <div class="feature_row clearfix">
                                    <div class="feature_name">
                                        <span title="{$feature->name|escape}">
                                            <a href="index.php?module=FeatureAdmin&id={$feature->id}" target="_blank">
                                                {$feature->name|escape}
                                            </a>
                                        </span>
                                    </div>
                                    <div class="feature_value">
                                        <input class="feature_input fn_auto_option" data-id="{$feature_id}" type="text" name="features_values_text[{$feature_id}][]" value=""{if $lang_id != $main_lang_id} readonly{/if}/>
                                        <input class="fn_value_id_input" type="hidden" name="features_values[{$feature_id}][]" value=""/>
                                        <button type="button" class="btn btn_mini btn-info fn_add fn_feature_multi_values feature_multi_values">
                                            <span class="fn_plus">
                                                {include file='svg_icon.tpl' svgId='plus'}
                                            </span>
                                            <span class="fn_minus" style="display: none">
                                                {include file='svg_icon.tpl' svgId='minus'}
                                            </span>
                                        </button>
                                    </div>
                                </div>
                            {/foreach}
                        </div>
                    {/foreach}
                    <div class="fn_new_feature">
                        <div class="new_feature_row clearfix">
                            <div class="wrap_inner_new_feature">
                                <input type="text" class="new_feature new_feature_name" name="new_features_names[]" placeholder="{$btr->product_features_enter|escape}" />
                                <input type="text" class="new_feature new_feature_value"  name="new_features_values[]" placeholder="{$btr->product_features_value_enter|escape}"/>
                            </div>
                            <span class="fn_delete_feature btn_close delete_feature">
                                {include file='svg_icon.tpl' svgId='delete'}
                            </span>
                        </div>
                    </div>
                    <div class="fn_new_feature_category">
                        <div class="feature_row clearfix">
                            <div class="feature_name">
                                <span title="" class="fn_feature_name">
                                    <a href="" target="_blank"></a>
                                </span>
                            </div>
                            <div class="feature_value">
                                <input class="feature_input fn_auto_option" data-id="" type="text" name="" value=""{if $lang_id != $main_lang_id} readonly{/if}/>
                                <input class="fn_value_id_input" type="hidden" name="" value=""/>
                                <button type="button" class="btn btn_mini btn-info fn_add fn_feature_multi_values feature_multi_values">
                                    <span class="fn_plus">
                                        {include file='svg_icon.tpl' svgId='plus'}
                                    </span>
                                    <span class="fn_minus" style="display: none">
                                        {include file='svg_icon.tpl' svgId='minus'}
                                    </span>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="box_btn_heading mt-1">
                    <button type="button" class="btn btn_mini btn-info fn_add_feature">
                    {include file='svg_icon.tpl' svgId='plus'}
                    <span>{$btr->product_feature_add|escape}</span>
                    </button>
                </div>
            </div>
        </div>
        </div>

        {*Связанные товары*}
        <div class="col-lg-6 col-md-12">
            <div class="boxed fn_toggle_wrap min_height_210px">
                <div class="heading_box">
                    {$btr->general_recommended|escape}
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="fa fn_icon_arrow fa-angle-down"></i></a>
                    </div>
                </div>
                <div class="toggle_body_wrap on fn_card fn_sort_list">
                    <div class="okay_list ok_related_list">
                        <div class="okay_list_body related_products sortable">
                            {foreach $related_products as $related_product}
                                <div class="fn_row okay okay_list_body_item fn_sort_item">
                                    <div class="okay_list_row">
                                        <div class="okay_list_boding okay_list_drag move_zone">
                                            {include file='svg_icon.tpl' svgId='drag_vertical'}
                                        </div>
                                        <div class="okay_list_boding okay_list_related_photo">
                                            <input type="hidden" name=related_products[] value='{$related_product->id}'>
                                            <a href="{url module=ProductAdmin id=$related_product->id}">
                                                {if $related_product->images[0]}
                                                    <img class="product_icon" src='{$related_product->images[0]->filename|resize:40:40}'>
                                                {else}
                                                    <img class="product_icon" src="design/images/no_image.png" width="40">
                                                {/if}
                                            </a>
                                        </div>
                                        <div class="okay_list_boding okay_list_related_name">
                                            <a class="link" href="{url module=ProductAdmin id=$related_product->id}">{$related_product->name|escape}</a>
                                        </div>
                                        <div class="okay_list_boding okay_list_close">
                                            <button data-hint="{$btr->general_delete_product|escape}" type="button" class="btn_close fn_remove_item hint-bottom-right-t-info-s-small-mobile  hint-anim">
                                                {include file='svg_icon.tpl' svgId='delete'}
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            {/foreach}
                            <div id="new_related_product" class="fn_row okay okay_list_body_item fn_sort_item" style='display:none;'>
                                <div class="okay_list_row">
                                    <div class="okay_list_boding okay_list_drag move_zone">
                                        {include file='svg_icon.tpl' svgId='drag_vertical'}
                                    </div>
                                    <div class="okay_list_boding okay_list_related_photo">
                                        <input type="hidden" name="related_products[]" value="">
                                        <img class=product_icon src="">
                                    </div>
                                    <div class="okay_list_boding okay_list_related_name">
                                        <a class="link related_product_name" href=""></a>
                                    </div>
                                    <div class="okay_list_boding okay_list_close">
                                        <button data-hint="{$btr->general_delete_product|escape}" type="button" class="btn_close fn_remove_item hint-bottom-right-t-info-s-small-mobile  hint-anim">
                                            {include file='svg_icon.tpl' svgId='delete'}
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="heading_label">{$btr->general_recommended_add|escape}</div>
                    <div class="autocomplete_arrow">
                        <input type=text name=related id="related_products" class="form-control" placeholder='{$btr->general_add_product|escape}'>
                    </div>
                </div>
            </div>

        </div>
    </div>

    {*Метаданные товара*}
    <div class="row">
        <div class="col-lg-12 col-md-12">
            <div class="boxed match fn_toggle_wrap">
                <div class="heading_box">
                    {$btr->general_metatags|escape}
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="fa fn_icon_arrow fa-angle-down"></i></a>
                    </div>
                </div>
                <div class="toggle_body_wrap on fn_card row">
                    <div class="col-lg-6 col-md-6">
                        <div class="heading_label" >Meta-title <span id="fn_meta_title_counter"></span></div>
                        <input name="meta_title" class="form-control fn_meta_field mb-h" type="text" value="{$product->meta_title|escape}" />
                        <div class="heading_label" >Meta-keywords</div>
                        <input name="meta_keywords" class="form-control fn_meta_field mb-h" type="text" value="{$product->meta_keywords|escape}" />
                    </div>

                    <div class="col-lg-6 col-md-6 pl-0">
                        <div class="heading_label" >Meta-description <span id="fn_meta_description_counter"></span></div>
                        <textarea name="meta_description" class="form-control okay_textarea fn_meta_field">{$product->meta_description|escape}</textarea>
                    </div>
                </div>
            </div>
        </div>
    </div>

    {*Описание элемента*}
    <div class="row">
        <div class="col-lg-12 col-md-12">
            <div class="boxed match fn_toggle_wrap tabs">
                <div class="heading_tabs">
                    <div class="tab_navigation">
                        <a href="#tab1" class="heading_box tab_navigation_link">{$btr->general_short_description|escape}</a>
                        <a href="#tab2" class="heading_box tab_navigation_link">{$btr->general_full_description|escape}</a>
                    </div>
                    <div class="toggle_arrow_wrap fn_toggle_card text-primary">
                        <a class="btn-minimize" href="javascript:;" ><i class="icon-arrow-down"></i></a>
                    </div>
                </div>
                <div class="toggle_body_wrap on fn_card">
                    <div class="tab_container">
                        <div id="tab1" class="tab">
                            <textarea name="annotation" id="annotation" class="editor_small">{$product->annotation|escape}</textarea>
                        </div>
                        <div id="tab2" class="tab">
                            <textarea id="fn_editor" name="description" class="editor_large fn_editor_class">{$product->description|escape}</textarea>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-12 col-md-12 mt-1">
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
{* Подключаем Tiny MCE *}
{include file='tinymce_init.tpl'}
{* On document load *}
{literal}
    <script src="design/js/autocomplete/jquery.autocomplete-min.js"></script>
    <script src="design/js/chosen/chosen.jquery.js"></script>
    <link rel="stylesheet" type="text/css" href="design/js/chosen/chosen.min.css" media="screen" />
<script>
    $(window).on("load", function() {

        $(document).on("click", ".fn_show_images",function () {
           $(this).prev().find($(".fn_toggle_hidden")).toggleClass("hidden");
        });
        // Удаление товара
        $(document).on( "click", ".fn_remove_item", function() {
            $(this).closest(".fn_row").fadeOut(200, function() { $(this).remove(); });
            return false;
        });
        $(".chosen").chosen('chosen-select');

        $(document).on("input", ".fn_rating", function () {
            $(".fn_show_rating").html($(this).val());
            $(".fn_rating_value").val($(this).val());
        });

        var image_item_clone = $(".fn_new_image_item").clone(true);
        $(".fn_new_image_item").remove();
        var new_image_tem_clone = $(".fn_new_spec_image_item").clone(true);
        $(".fn_new_spec_image_item").remove();
        // Или перетаскиванием
        if(window.File && window.FileReader && window.FileList) {

            $(".fn_dropzone").on('dragover', function (e){
                e.preventDefault();
                $(this).css('background', '#bababa');
            });
            $(".fn_dropzone").on('dragleave', function(){
                $(this).css('background', '#f8f8f8');
            });

            function handleFileSelect(evt){
                dropInput = $(this).closest(".fn_droplist_wrap").find("input.dropinput:last").clone();
                var parent = $(this).closest(".fn_droplist_wrap");
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
                            if(parent.data('image') == "product"){
                                var clone_item = image_item_clone.clone(true);
                            } else if(parent.data('image') == "special") {
                                var clone_item = new_image_tem_clone.clone(true);
                            }
                            clone_item.find("img").attr("onerror",'');
                            clone_item.find("img").attr("src", e.target.result);
                            clone_item.find("input").val(theFile.name);
                            clone_item.appendTo(parent);
                            temp_input =  dropInput.clone();
                            parent.find("input.dropinput").hide();
                            parent.find(".fn_dropzone").append(temp_input);
                        };
                    })(f);
                    // Read in the image file as a data URL.
                    reader.readAsDataURL(f);
                }
                $(".fn_dropzone").removeAttr("style");
            }
            $(document).on('change','.dropinput',handleFileSelect);
        }
        $(document).on("click", ".fn_remove_image", function () {
            $(this).closest("li").remove();
        });
        $(document).on("click", ".fn_change_special", function () {
            if($(this).closest('li').hasClass("product_special")) {
                $(this).closest("ul").find("input[type=radio]").attr("checked", false);
                $(this).closest("li").removeClass("product_special");
                $(this).text($(this).data("origin"));
            } else {
                $(this).closest("ul").find("input[type=radio]").attr("checked", false);
                $(this).closest("li").removeClass("product_special");
                $(this).closest("li").find("input[type=radio]").attr("checked", true).click();
                $(this).closest("ul").find("li").removeClass("product_special");
                $(this).closest("li").addClass("product_special");
                $(this).text($(this).data("result"));
            }

        });
        $(document).on("click",".fn_remove_variant",function () {
            $(this).closest(".variants_list_item ").fadeOut(200);
            $(this).closest(".variants_list_item ").remove();
        });

        // Удалить файл к варианту
        $(document).on("click", ".fn_remove_attach", function () {
            closest = $(this).closest(".fn_file_wrap");
            closest.find(".fn_attachment_name").hide("slow");
            $(this).hide("slow");
            closest.find("input[name*=delete_attachment]").val("1");
            return false;
        });

        // Добавление варианта
        var variant = $(".fn_new_row_variant").clone(false);
        $(".fn_new_row_variant").remove();
        variant.find('.bootstrap-select').replaceWith(function() { return $('select', this); });
        $(document).on("click", ".fn_add_variant", function () {
           var variant_clone = variant.clone(true);
           variant_clone.find("select").selectpicker();
           variant_clone.removeClass("hidden").removeClass("fn_new_row_variant");
           $(".variants_listadd").append(variant_clone);
            return false;
        });

        var clone_cat = $(".fn_new_category_item").clone();
        $(".fn_new_category_item").remove();
        clone_cat.removeClass("fn_new_category_item");
        $(document).on("change", ".fn_product_category select", function () {
            var clone = clone_cat.clone();
            clone.find("label").attr("for","id_"+$(this).find("option:selected").val());
            clone.find("span").html($(this).find("option:selected").data("category_name"));
            clone.find("input").attr("id","id_"+$(this).find("option:selected").val());
            clone.find("input").val($(this).find("option:selected").val());
            clone.find("input").attr("checked",true);
            clone.find("input").attr("data-cat_name",$(this).find("option:selected").data("category_name"));
            $(".fn_product_categories_list").append(clone);
            if ($(".fn_category_item").size() == 1) {
                change_product_category();
            }
        });
        $(document).on("click", ".fn_delete_product_cat", function () {
            var item = $(this).closest(".fn_category_item"),
                is_first = item.hasClass("first_category");
            item.remove();
            if (is_first && $(".fn_category_item").size() > 0) {
                change_product_category();
            }
        });

        var el = document.getElementById('sortable_cat');
        var sortable = Sortable.create(el, {
            handle: ".product_cat_name",  // Drag handle selector within list items
            sort: true,  // sorting inside list
            animation: 150,  // ms, animation speed moving items when sorting, `0` — without animation

            ghostClass: "sortable-ghost",  // Class name for the drop placeholder
            chosenClass: "sortable-chosen",  // Class name for the chosen item
            dragClass: "sortable-drag",  // Class name for the dragging item
            scrollSensitivity: 30, // px, how near the mouse must be to an edge to start scrolling.
            scrollSpeed: 10, // px
            // Changed sorting within list
            onUpdate: function (evt) {
                change_product_category();
            }
        });

        function change_product_category() {
            var wrapper = $(".fn_product_categories_list");
            var first_category = wrapper.find("div.fn_category_item:first input").val();
            wrapper.find("div.first_category").removeClass("first_category");
            wrapper.find("div.fn_category_item:first ").addClass("first_category");
            set_meta();
            show_category_features(first_category);
        }

        var new_feature_category = $(".fn_new_feature_category").clone(true);
        $(".fn_new_feature_category").remove();
        new_feature_category.removeClass("fn_new_feature_category");
        function show_category_features(category_id)
        {
            $("div.fn_features_wrap").empty();
            $.ajax({
                url: "ajax/get_features.php",
                data: {category_id: category_id, product_id: $("#product_id").val()},
                dataType: 'json',
                success: function(data){
                    for(i=0; i<data.length; i++)
                    {
                        feature = data[i];
                        for (var iv=0; iv<feature.values.length; iv++) {
                            var new_line = new_feature_category.clone(true);
                            new_line.addClass('fn_feature_block_'+feature.id);
                            new_line.find(".fn_feature_name").attr('title', feature.name);
                            new_line.find(".fn_feature_name a").text(feature.name).attr('href', "index.php?module=FeatureAdmin&id="+feature.id);
                            var value = new_line.find(".fn_auto_option"),
                                id_input = new_line.find(".fn_value_id_input");
                            value.data('id', feature.id);
                            value.val(feature.values[iv].value);
                            value.attr('name', "features_values_text["+feature.id+"][]");
                            id_input.attr('name', "features_values["+feature.id+"][]");
                            id_input.val(feature.values[iv].id)
                            {/literal}
                            {if $lang_id == $main_lang_id}
                            {literal}
                                value.devbridgeAutocomplete({
                                    serviceUrl:'ajax/options_autocomplete.php',
                                    minChars:0,
                                    orientation:'auto',
                                    params: {feature_id:feature.id},
                                    noCache: false,
                                    onSelect:function(suggestion){
                                        id_input.val(suggestion.data.id);
                                        $(this).trigger('change');
                                    },
                                    onSearchStart:function(params){
                                        id_input.val("");
                                    }
                                });
                            {/literal}
                            {/if}
                            {literal}
                            if (iv > 0) {
                                new_line.find(".fn_feature_multi_values")
                                    .removeClass("fn_add")
                                    .removeClass("btn-info")
                                    .addClass("fn_remove")
                                    .addClass("btn-danger");
                                new_line.find(".fn_plus").hide();
                                new_line.find(".fn_minus").show();
                                new_line.find(".feature_name").html("").addClass("additional_values");
                            }

                            new_line.appendTo("div.fn_features_wrap");
                        }
                    }
                }
            });
            return false;
        }

        {/literal}
        {if $lang_id == $main_lang_id}
        {literal}
        $(document).on("click",".fn_feature_multi_values.fn_add", function () {
            var feature_id  = $(this).closest(".feature_value").find(".fn_auto_option").data("id"),
                new_value   = new_feature_category.clone(true),
                value_input = new_value.find(".fn_auto_option"),
                id_input    = new_value.find(".fn_value_id_input");
            value_input.data("id", feature_id);
            value_input.val("");
            value_input.attr('name', "features_values_text["+feature_id+"][]");
            id_input.attr("name", "features_values["+feature_id+"][]");

            new_value.find(".feature_name").html("").addClass("additional_values");
            new_value.find(".fn_feature_multi_values")
                .removeClass("fn_add")
                .removeClass("btn-info")
                .addClass("fn_remove")
                .addClass("btn-danger");
            new_value.find(".fn_plus").hide();
            new_value.find(".fn_minus").show();

            value_input.devbridgeAutocomplete({
                serviceUrl:'ajax/options_autocomplete.php',
                minChars:0,
                params: {feature_id:feature_id},
                noCache: false,
                onSelect:function(suggestion){
                    id_input.val(suggestion.data.id);
                    $(this).trigger('change');
                },
                onSearchStart:function(params){
                    id_input.val("");
                }
            });
            new_value.appendTo(".fn_feature_block_"+feature_id).fadeIn('slow');
            return false;
        });

        $(document).on("click",".fn_feature_multi_values.fn_remove",function () {
            $(this).closest(".feature_row").remove();
        });

        // Автодополнение свойств
        $(".fn_auto_option").each(function() {
            var feature_id = $(this).data("id"),
                id_input = $(this).closest(".feature_value").find(".fn_value_id_input");
            $(this).devbridgeAutocomplete({
                serviceUrl:'ajax/options_autocomplete.php',
                minChars:0,
                params: {feature_id:feature_id},
                noCache: false,
                onSelect:function(suggestion){
                    id_input.val(suggestion.data.id);
                    $(this).trigger('change');
                },
                onSearchStart:function(params){
                    id_input.val("");
                }
            });
        });
        {/literal}
        {/if}
        {literal}

        // Добавление нового свойства товара
        var new_feature = $(".fn_new_feature").clone(true);
        $(".fn_new_feature").remove();
        new_feature.removeClass("fn_new_feature");
        $(document).on("click",".fn_add_feature",function () {
            $(new_feature).clone(true).appendTo(".features_wrap").fadeIn('slow');
            return false;
        });
        $(document).on("click",".fn_delete_feature",function () {
           $(this).parent().remove();
        });

        // Добавление связанного товара
        var new_related_product = $('#new_related_product').clone(true);
        $('#new_related_product').remove();
        new_related_product.removeAttr('id');
        $("input#related_products").devbridgeAutocomplete({
            serviceUrl:'ajax/search_products.php',
            minChars:0,
            orientation:'auto',
            noCache: false,
            onSelect:
                function(suggestion){
                    $("input#related_products").val('').focus().blur();
                    new_item = new_related_product.clone().appendTo('.related_products');
                    new_item.find('a.related_product_name').html(suggestion.data.name);
                    new_item.find('a.related_product_name').attr('href', 'index.php?module=ProductAdmin&id='+suggestion.data.id);
                    new_item.find('input[name*="related_products"]').val(suggestion.data.id);
                    if(suggestion.data.image)
                        new_item.find('img.product_icon').attr("src", suggestion.data.image);
                    else
                        new_item.find('img.product_icon').remove();
                    new_item.show();
                },
            formatResult:
                function(suggestions, currentValue){
                    var reEscape = new RegExp('(\\' + ['/', '.', '*', '+', '?', '|', '(', ')', '[', ']', '{', '}', '\\'].join('|\\') + ')', 'g');
                    var pattern = '(' + currentValue.replace(reEscape, '\\$1') + ')';
                    return "<div>" + (suggestions.data.image?"<img align=absmiddle src='"+suggestions.data.image+"'> ":'') + "</div>" +  "<span>" + suggestions.value.replace(new RegExp(pattern, 'gi'), '<strong>$1<\/strong>') + "</span>";
                }

        });
        // infinity
        $("input[name*=variant][name*=stock]").focus(function() {
            if($(this).val() == '∞')
                $(this).val('');
            return false;
        });

        $("input[name*=variant][name*=stock]").blur(function() {
            if($(this).val() == '')
                $(this).val('∞');
        });
    });
</script>
{/literal}