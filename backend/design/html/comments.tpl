{* Title *}
{$meta_title=$btr->general_comments scope=parent}

{*Название страницы*}
<div class="row">
    <div class="col-lg-7 col-md-7">
        <div class="wrap_heading">
            <div class="box_heading heading_page">
                {if !$type}
                    {$btr->general_comments} - {$comments_count}
                {elseif $type=='product'}
                    {$btr->general_comments} {$btr->comments_to_products|escape} - {$comments_count}
                {elseif $type=='blog'}
                    {$btr->general_comments} {$btr->comments_to_articles|escape} - {$comments_count}
                {elseif $type=='news'}
                    {$btr->general_comments} {$btr->comments_to_news|escape} - {$comments_count}
                {/if}
            </div>
        </div>
    </div>
</div>

{*Блок фильтров*}
<div class="boxed fn_toggle_wrap">
    <div class="row">
        <div class="col-lg-12 col-md-12">
            <div class="boxed_sorting">
                <div class="row">
                    <div class="col-lg-3 col-md-3 col-sm-12">
                        <select class="selectpicker form-control" onchange="location = this.value;">
                            <option value="{url type=null}" {if !$type}selected{/if}>{$btr->comments_all|escape}</option>
                            <option value="{url keyword=null type=product}" {if $type == 'product'}selected{/if}>{$btr->comments_to_products|escape}</option>
                            <option value="{url keyword=null type=blog}" {if $type == 'blog'}selected{/if}>{$btr->comments_to_articles|escape}</option>
                            <option value="{url keyword=null type=news}" {if $type == 'news'}selected{/if}>{$btr->comments_to_news|escape}</option>
                        </select>
                    </div>
                </div>
            </div>
        </div>
    </div>
    {if $comments}
        <div class="row">
        {*Главная форма страницы*}
        <div class="col-lg-12 col-md-12 col-sm-12">
            <form class="fn_form_list" method="post">
                <input type="hidden" name="session_id" value="{$smarty.session.id}">
                <div class="post_wrap okay_list">
                    {*Шапка таблицы*}
                    <div class="okay_list_head">
                        <div class="okay_list_heading okay_list_check">
                            <input class="hidden_check fn_check_all" type="checkbox" id="check_all_1" name="" value=""/>
                            <label class="okay_ckeckbox" for="check_all_1"></label>
                        </div>
                        <div class="okay_list_heading okay_list_comments_name">{$btr->general_comments|escape}</div>
                        <div class="okay_list_heading okay_list_comments_btn"></div>
                        <div class="okay_list_heading okay_list_close"></div>
                    </div>
                    {*Параметры элемента*}
                    <div class="okay_list_body">
                        {function name=comments_tree level=0}
                            {foreach $comments as $comment}
                                <div class="fn_row okay_list_body_item {if $level > 0}admin_note2{/if}">
                                    <div class="okay_list_row">

                                        <div class="okay_list_boding okay_list_check">
                                            <input class="hidden_check" type="checkbox" id="id_{$comment->id}" name="check[]" value="{$comment->id}"/>
                                            <label class="okay_ckeckbox" for="id_{$comment->id}"></label>
                                        </div>

                                        <div class="okay_list_boding okay_list_comments_name {if $level > 0}admin_note{/if}">
                                            <div class="okay_list_text_inline mb-q mr-1">
                                                <span class="text_dark text_bold">{$btr->general_name|escape} </span> {$comment->name|escape}
                                            </div>
                                            {if $comment->email}
                                                <div class="okay_list_text_inline mb-q">
                                                    <span class="text_dark text_bold">Email: </span>  {$comment->email|escape}
                                                </div>
                                            {/if}
                                            <div class="mb-q">
                                                <span class="text_dark text_bold">{$btr->general_message|escape}</span>
                                                 {$comment->text|escape|nl2br}
                                            </div>
                                            <div class="">
                                                {$btr->comments_left|escape} <span class="tag tag-default">{$comment->date|date} | {$comment->date|time}</span>
                                                {$btr->comments_to_the|escape} {if $comment->type == "product"}
                                                    {$btr->comments_product|escape}  <a href="../products/{$comment->product->url|escape}" target="_blank">{$comment->product->name|escape}</a>
                                                {elseif $comment->type == "blog"}
                                                    {$btr->comments_article|escape} <a href="../blog/{$comment->post->url|escape}" target="_blank">{$comment->post->name|escape}</a>
                                                {elseif $comment->type == "news"}
                                                    {$btr->comments_news|escape} <a href="../news/{$comment->post->url|escape}" target="_blank">{$comment->post->name|escape}</a>
                                                {/if}
                                            </div>
                                            <div class="hidden-md-up mt-q">
                                                {if !$comment->approved}
                                                    <button type="button" class="btn btn_small btn-outline-warning fn_ajax_action {if $comment->approved}fn_active_class{/if}" data-module="comment" data-action="approved" data-id="{$comment->id}" onclick="$(this).hide();">
                                                        {$btr->general_approve|escape}
                                                    </button>
                                                {/if}
                                                <div class="answer_wrap {if $level > 0 || !$comment->approved}hidden{/if}">
                                                    <button type="button" data-parent_id="{$comment->id}" data-user_name="{$comment->name|escape}" data-toggle="modal" data-target="#answer_popup" class="btn btn_small btn-outline-info fn_answer">
                                                        {$btr->general_answer|escape}
                                                    </button>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="okay_list_boding okay_list_comments_btn">
                                            {if !$comment->approved}
                                                <button type="button" class="btn btn_small btn-outline-warning fn_ajax_action {if $comment->approved}fn_active_class{/if}" data-module="comment" data-action="approved" data-id="{$comment->id}" onclick="$(this).hide();">
                                                    {$btr->general_approve|escape}
                                                </button>
                                            {/if}
                                            <div class="answer_wrap fn_answer_btn" {if $level > 0 || !$comment->approved}style="display: none;"{/if}>
                                                <button type="button" data-parent_id="{$comment->id}" data-user_name="{$comment->name|escape}" data-toggle="modal" data-target="#answer_popup" class="btn btn_small btn-outline-info fn_answer">
                                                    {$btr->general_answer|escape}
                                                </button>
                                            </div>
                                        </div>

                                        <div class="okay_list_boding okay_list_close">
                                            {*delete*}
                                            <button data-hint="{$btr->comments_delete|escape}" type="button" class="btn_close fn_remove hint-bottom-right-t-info-s-small-mobile  hint-anim" data-toggle="modal" data-target="#fn_action_modal" onclick="success_action($(this));">
                                                {include file='svg_icon.tpl' svgId='delete'}
                                            </button>
                                        </div>

                                    </div>
                                    {if isset($children[$comment->id])}
                                        {comments_tree comments=$children[$comment->id] level=$level+1}
                                    {/if}
                                </div>

                            {/foreach}
                        {/function}
                        {comments_tree comments=$comments}
                    </div>

                    {*Блок массовых действий*}
                    <div class="okay_list_footer fn_action_block">
                        <div class="okay_list_foot_left">
                            <div class="okay_list_heading okay_list_check">
                                <input class="hidden_check fn_check_all" type="checkbox" id="check_all_2" name="" value=""/>
                                <label class="okay_ckeckbox" for="check_all_2"></label>
                            </div>
                            <div class="okay_list_option">
                                <select name="action" class="selectpicker">
                                    <option value="approve">{$btr->general_approve|escape}</option>
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
        </div>
        <div class="row">
            <div class="col-lg-12 col-md-12 col-sm 12 txt_center">
                {include file='pagination.tpl'}
            </div>
        </div>
    </div>
    {else}
        <div class="heading_box mt-1">
            <div class="text_grey">{$btr->comments_no|escape}</div>
        </div>
    {/if}
</div>

{*Форма ответа на сообщение*}
<div id="answer_popup" class="modal fade show" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="card-header">
                <div class="heading_modal">{$btr->general_answer|escape}</div>
            </div>
            <div class="modal-body">
                <form class="form-horizontal " method="post">
                    <input type="hidden" name="session_id" value="{$smarty.session.id}">
                    <input id="fn_parent_id" type="hidden" name="parent_id" value="" />
                    <div class="form-group">
                        <textarea id="fn_comment_area" class="form-control okay_textarea" placeholder="{$btr->general_enter_answer|escape}" name="text" rows="10" cols="50"></textarea>
                    </div>
                    <button type="submit" name="comment_answer" value="1" class="btn btn_small btn_blue mx-h">
                        {include file='svg_icon.tpl' svgId='checked'}
                        <span>{$btr->general_answer|escape}</span>
                   </button>

                    <button type="button" class="btn btn_small btn-danger mx-h" data-dismiss="modal">
                        {include file='svg_icon.tpl' svgId='delete'}
                        <span>{$btr->general_cancel|escape}</span>
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>
{literal}
<script>
$(function() {
    $('.fn_answer').on('click',function(){
        $('#fn_parent_id').val($(this).data('parent_id'));
        $('#fn_comment_area').html($(this).data('user_name')+', ');
    });
});

</script>
{/literal}
