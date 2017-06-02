{* Title *}
{if $topic->id}
    {$meta_title = $topic->header|escape scope=parent}
{else}
    {$meta_title = $btr->topic_new scope=parent}
{/if}

{*Название страницы*}
<div class="row">
    <div class="col-lg-7 col-md-7">
        <div class="wrap_heading">
            <div class="box_heading heading_page">
                {if $topic->id}
                    {$btr->topic_number} {$topic->id|escape} ({$topic->spent_time|balance}) - {$comments_count}
                {else}
                    {$btr->topic_new|escape}
                {/if}
            </div>
            <div class="box_btn_heading">
                <a class="btn btn_small btn-info" href="{url module=SupportAdmin}">
                    {include file='svg_icon.tpl' svgId='return'}
                    <span>{$btr->general_back|escape}</span>
                </a>
            </div>
        </div>
    </div>
</div>

{*Вывод ошибок*}
{if $message_error}
    <div class="row">
        <div class="col-lg-12 col-md-12 col-sm-12">
            <div class="boxed boxed_warning">
                <div class="heading_box">
                    {if $message_error == 'domain_not_found'}
                        {$btr->support_no_domain|escape}
                    {elseif $message_error == 'domain_disabled'}
                        {$btr->support_domain_blocked|escape}
                    {elseif $message_error == 'wrong_key'}
                        {$btr->support_wrong_keys|escape}
                    {elseif $message_error == 'topic_not_found'}
                        {$btr->topic_no_theme|escape}
                    {elseif $message_error == 'topic_closed'}
                        {$btr->topic_closed|escape}
                    {elseif $message_error == 'localhost'}
                        {$btr->support_local|escape}
                    {elseif $message_error == 'empty_comment'}
                        {$btr->support_empty_comment|escape}
                    {elseif $message_error == 'empty_name'}
                        {$btr->support_empty_name|escape}
                    {else}
                        {$message_error|escape}
                    {/if}
                </div>
            </div>
        </div>
    </div>
{/if}


{*Главная форма страницы*}
<form class="fn_form_list" method="post">
    <input type="hidden" name="session_id" value="{$smarty.session.id}">

    <div class="row">
        <div class="col-lg-12 col-md-12">
            <div class="boxed fn_toggle_wrap ">
                <div class="">
                    {if $topic->id}
                        {$topic->header|escape}{if $topic->status=='closed'} (Closed){/if}
                        <span class="text_500">
                            ({$topic->created|date} {$topic->created|time})
                        </span>
                    {else}
                        <input class="name" name="header" type="text" value="{$topic_header|escape}"/>
                    {/if}
                    <input name="id" type="hidden" value="{$topic->id|escape}"/>
                </div>
                <div class="toggle_body_wrap on fn_card">
                    <div class="row">
                         <div class="col-lg-12 col-md-12 col-sm 12">
                            {include file='pagination.tpl'}
                        </div>
                        <div class="col-lg-12 col-md-12 col-sm-12">
                            {if $comments}
                                <div class="okay_list">
                                    {*Шапка таблицы*}
                                    <div class="okay_list_head">
                                        <div class="okay_list_heading okay_list_topic_name">{$btr->general_name|escape}</div>
                                        <div class="okay_list_heading okay_list_topic_message">{$btr->topic_message|escape}</div>
                                        <div class="okay_list_heading okay_list_topic_time">{$btr->topic_spent_time|escape}</div>
                                    </div>
                                    {*Параметры элемента*}
                                    <div class="okay_list_body">
                                        {foreach $comments as $comment}
                                            <div class="fn_row okay_list_body_item">
                                                <div class="okay_list_row">
                                                    <div class="okay_list_boding okay_list_topic_name">
                                                        <div class="text_dark text_600 mb-q mr-1 {if $comment->is_support}text-primary{/if}">
                                                            {if $comment->is_support}Support: {/if}
                                                            {$comment->manager|escape}
                                                        </div>
                                                        {$btr->support_last_answer|escape}
                                                        {if $topic->last_comment}
                                                            <span class="tag tag-default">{$comment->created|date} {$comment->created|time}</span>
                                                        {/if}
                                                    </div>

                                                    <div class="okay_list_boding okay_list_topic_message">
                                                        {$comment->text|escape}
                                                    </div>

                                                    <div class="okay_list_boding okay_list_topic_time {if $comment->spent_time < 0}text-success{/if}">
                                                        {$comment->spent_time|balance}
                                                    </div>
                                                </div>
                                            </div>
                                        {/foreach}
                                    </div>
                                </div>
                            {else}
                                <div class="heading_box mt-1">
                                    <div class="text_grey">Нет сообщений</div>
                                </div>
                            {/if}

                            {if $topic->status!='closed'}
                                <div class="heading_label mt-2">
                                    {$btr->topic_message|escape}
                                </div>
                                <div class="mb-1">
                                    <textarea class="form-control okay_textarea" name="comment_text">{$topic_message|escape}</textarea>
                                </div>
                                <div class="row">
                                    <div class="col-lg-12 col-md-12 fn_action_block">
                                        {if $topic->id}
                                            <button type="submit" class="btn btn_small btn-danger" name="close_topic" value="1">
                                                <span>{$btr->topic_close|escape}</span>
                                            </button>
                                        {/if}
                                        <button type="submit" class="btn btn_small btn_blue float-md-right" name="new_message" value="1">
                                            <span>{$btr->topic_send|escape}</span>
                                        </button>
                                    </div>
                                </div>
                            {/if}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</form>
