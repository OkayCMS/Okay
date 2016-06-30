<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="-1">
    <title>{$meta_title}</title>
    <link rel="icon" href="design/images/favicon.png" type="image/x-icon">
    <link href="design/css/style.css" rel="stylesheet" type="text/css" />
    <script src="design/js/jquery/jquery.js"></script>
    <script src="design/js/jquery/jquery.form.js"></script>
    <script src="design/js/jquery/jquery-ui.min.js"></script>
    <link rel="stylesheet" type="text/css" href="design/js/jquery/jquery-ui.css" media="screen" />
    <meta name="viewport" content="width=1024">

</head>
<body>
{if $smarty.get.module == "ProductAdmin"
    || $smarty.get.module == "CategoryAdmin"
    || $smarty.get.module == "BrandAdmin"
    || $smarty.get.module == "PostAdmin"
    || $smarty.get.module == "PageAdmin"}
<script>
    $(window).on("load", function() {
        var title = $("input[name='meta_title']"),
            keywords = $("input[name='meta_keywords']"),
            desc = $("textarea[name='meta_description']");
        number = title.val().length;
        $(".count_title_symbol").html(number);
        $(".word_title").html(title.val().split(/[\s\.\?]+/).length);

        number = keywords.val().length;
        $(".count_keywords_symbol").html(number);
        $(".word_keywords").html(keywords.val().split(/[\s\.\?]+/).length);

        number = desc.text().length;
        $(".count_desc_symbol").html(number);
        $(".word_desc").html(desc.val().split(/[\s\.\?]+/).length);

        title.keyup(function count() {
            number = title.val().length;
            $(".count_title_symbol").html(number);
            total_words=$(this).val().split(/[\s\.\?]+/).length;
            $(".word_title").html(total_words);
        });
        keywords.keyup(function count() {
            number = keywords.val().length;
            $(".count_keywords_symbol").html(number);
            total_words=$(this).val().split(/[\s\.\?]+/).length;
            $(".word_keywords").html(total_words);
        });
        desc.keyup(function count() {
            number = desc.val().length;
            $(".count_desc_symbol").html(number);
            total_words=$(this).val().split(/[\s\.\?]+/).length;
            $(".word_desc").html(total_words);
        });

        $('input,textarea,select, a.delete').bind('keyup change click',function(){
           $('.fast_save').show();
        });

        $('.fast_save').on('click',function(){
           $('input[type=submit]').first().trigger('click');
        });
    });
</script>
{/if}
<a href='{$config->root_url}/{$lang_link}' class='admin_bookmark'></a>

<div class="container">

    <div class="left">
        {include file="left.tpl"}
    </div>

    <div id="main">
        <ul id="tab_menu">
            {$smarty.capture.tabs}
        </ul>
        <div id="middle">
            {$content}
        </div>
        <div id="footer">
            <span>&copy; 2016</span>
            <a href='http://okay-cms.com'>Okay {$config->version}</a>
            <span>Вы вошли как {$manager->login}.</span>
            <a href='{$config->root_url}?logout' id="logout">Выход</a>
        </div>
    </div>
</div>

<div class="fast_save">
    <input class="button_green button_save" type="submit" name="" value="Сохранить"/>
</div>
</body>
</html>

