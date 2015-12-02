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
            <span>&copy; 2014</span> 
            <a href='http://okay-cms.com'>Okay {$config->version}</a>
            <span>Вы вошли как {$manager->login}.</span>
            <a href='{$config->root_url}?logout' id="logout">Выход</a>
        </div>
    </div>
</div>
</body>
</html>

{literal}
<script>
    $(function() {

        if($.browser.opera)
            $("#logout").hide();

        $("#logout").click( function(event) {
            event.preventDefault();

            if($.browser.msie)
            {
                try{document.execCommand("ClearAuthenticationCache");}
                catch (exception){}
                window.location.href='/';
            }
            else
            {
                $.ajax({
                    url: $(this).attr('href'),
                    username: '',
                    password: '',
                    complete: function () {
                        window.location.href='/';
                    },
                    beforeSend : function(req) {
                        req.setRequestHeader('Authorization', 'Basic');
                    }
                });
            }
        });
        {/literal}

    });
</script>
