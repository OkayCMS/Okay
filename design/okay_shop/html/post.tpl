{* Post page *}

{* The canonical address of the page *}
{if $type_post == "blog"}
    {$canonical="/blog/{$post->url}" scope=parent}
{else}
    {$canonical="/news/{$post->url}" scope=parent}
{/if}

{* The page heading *}
<h1 class="h1">
    <span data-post="{$post->id}">{$post->name|escape}</span>
</h1>

<div class="block padding">
    {* Post date *}
    <div class="post_date">
        <span>{$post->date|date:"d cFR Y, cD"}</span>
    </div>

    {* Post content *}
    {$post->description}

    {* Social share *}
    <div class="post_share">
        <div class="fn_share jssocials"></div>
    </div>

    {* Previous/Next posts *}
    {if $prev_post || $next_post}
        <nav>
            <ol class="pager row">
                <li class="col-xs-12{if $next_post} col-sm-6{else} col-sm-12{/if}">
                    {if $prev_post}
                        <a href="{$lang_link}{$type_post}/{$prev_post->url}">← <span>{$prev_post->name}</span></a>
                    {/if}
                </li>
                <li class="col-xs-12 col-sm-6">
                    {if $next_post}
                        <a href="{$lang_link}{$type_post}/{$next_post->url}"><span>{$next_post->name}</span> →</a>
                    {/if}
                </li>
            </ol>
        </nav>
    {/if}
</div>

<div id="comments">
    <div class="h2">
        <span data-language="post_comments">{$lang->post_comments}</span>
    </div>

    <div class="padding block">
        <div class="row">
            <div class="col-lg-7">
                {if $comments}
                    {function name=comments_tree level=0}
                        {foreach $comments as $comment}
                            
                            {* Comment anchor *}
                            <a name="comment_{$comment->id}"></a>

                            {* Comment list *}
                            <div class="comment_item{if $level > 0} admin_note{/if}">
                       
                                <div class="comment_header">
                                    {* Comment name *}
                                    <span class="comment_author">{$comment->name|escape}</span>
                                </div>
                           
                                {* Comment content *}
                                <div class="comment_content">
                                    {$comment->text|escape|nl2br}
                                </div>
                                <div class="comment_footer">
                                    {* Comment date *}
                                    <span class="comment_date">{$comment->date|date}, {$comment->date|time}</span>

                                    {* Comment status *}
                                    {if !$comment->approved}
                                    <span data-language="post_comment_status">({$lang->post_comment_status})</span>
                                    {/if}
                                </div>

                                 {if isset($children[$comment->id])}
                                    {comments_tree comments=$children[$comment->id] level=$level+1}
                                {/if}
                            </div>
                           
                        {/foreach}
                    {/function}
                    {comments_tree comments=$comments}
                {else}
                    <div class="no_comments">
                        <span data-language="post_no_comments">{$lang->post_no_comments}</span>
                    </div>
                {/if}
            </div>

            <div class="col-lg-5">
               {* Comment form *}
               <form id="fn_blog_comment" class="fn_validate_post"  method="post" action="">
                
                    <div class="h3">
                        <span data-language="post_write_comment">{$lang->post_write_comment}</span>
                    </div>

                    {* Form error messages *}
                    {if $error}
                        <div class="message_error">
                            {if $error=='captcha'}
                                <span data-language="form_error_captcha">{$lang->form_error_captcha}</span>
                            {elseif $error=='empty_name'}
                                <span data-language="form_enter_name">{$lang->form_enter_name}</span>
                            {elseif $error=='empty_comment'}
                                <span data-language="form_enter_comment">{$lang->form_enter_comment}</span>
                            {elseif $error=='empty_email'}
                                <span data-language="form_enter_email">{$lang->form_enter_email}</span>
                            {/if}
                        </div>
                    {/if}

                    <div class="row">
                        {* User's name *}
                        <div class="col-lg-6">
                            <div class="form_group">
                                <input class="form_input placeholder_focus" type="text" name="name" value="{$comment_name|escape}" >
                                <span class="form_placeholder">{$lang->form_name}*</span>
                            </div>
                        </div>
                        {* User's email *}
                        <div class="col-lg-6">
                            <div class="form_group">
                                <input class="form_input placeholder_focus" type="text" name="email" value="{$comment_email|escape}" />
                                <span class="form_placeholder">{$lang->form_email}</span>
                            </div>
                        </div>
                    </div>

                    {* User's comment *}
                    <div class="form_group">
                        <textarea class="form_textarea placeholder_focus" rows="3" name="text" >{$comment_text}</textarea>
                        <span class="form_placeholder">{$lang->form_enter_comment}*</span>
                    </div>

                    {* Captcha *}
                    {if $settings->captcha_post}
                        {if $settings->captcha_type == "v2"}
                             <div class="captcha row" style="">
                                 <div id="recaptcha1"></div>
                             </div>
                        {elseif $settings->captcha_type == "default"}
                            {get_captcha var="captcha_post"}
                             <div class="captcha">
                                  <div class="secret_number">{$captcha_post[0]|escape} + ? =  {$captcha_post[1]|escape}</div>
                                  <span class="form_captcha">
                                       <input class="form_input input_captcha placeholder_focus" type="text" name="captcha_code" value="" >
                                       <span class="form_placeholder">{$lang->form_enter_captcha}*</span>
                                  </span>
                             </div>
                        {/if}
                    {/if}
                   <input type="hidden" name="comment" value="1">

                   {* Submit button *}
                    <input class="button g-recaptcha" type="submit" name="comment" data-language="form_send" {if $settings->captcha_type == "invisible"}data-sitekey="{$settings->public_recaptcha_invisible}" data-badge='bottomleft' data-callback="onSubmitBlog"{/if} value="{$lang->form_send}">
               </form>
           </div>
       </div>
    </div>
</div>


{* Related products *}
{if $related_products}
    <div class="h2">
        <span data-language="product_recommended_products">{$lang->product_recommended_products}</span>
    </div>
        
    <div class="related clearfix">
        {foreach $related_products as $p}
            <div class="products_item no_padding col-sm-6 col-xl-3">
                {include "product_list.tpl" product = $p}
            </div>
        {/foreach}
    </div>
{/if}
