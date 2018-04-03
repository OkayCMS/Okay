{$wrapper = '' scope=parent}
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="-1">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Административная панель</title>

    <link href="design/css/okay.css" rel="stylesheet" type="text/css" />
    <link rel="icon" href="design/images/favicon.png" type="image/x-icon">
    <script src="design/js/jquery/jquery.js"></script>
</head>
<body>
<div class="container d-table">
    <div class="d-100vh-va-middle">
        <div class="row">
            <div class="col-md-10 offset-md-1">
                <div class="card-group">
                    <div class="card p-2">
                        <div class="card-block">
                            {if $error_message}
                                <div class="text-danger">
                                    {if $error_message == 'auth_wrong'}
                                        Неверно введены логин или пароль.
                                        {if $limit_cnt}<br>Осталось {$limit_cnt} попыт{$limit_cnt|plural:'ка':'ок':'ки'}{/if}
                                    {elseif $error_message == 'limit_try'}
                                        Вы исчерпали количество попыток на сегодня.
                                    {/if}
                                </div>
                            {/if}
                            {*Форма авторизации*}
                            <form method="post">
                                <input type=hidden name="session_id" value="{$smarty.session.id}">
                                {if $recovery_mod}
                                    <h1>Восстановление пароля</h1>
                                    <p class="text-muted">на сайте {$smarty.server.HTTP_HOST}</p>
                                    <div class="input-group mb-1">
                                        <span class="input-group-addon"><i class="icon-user"></i></span>
                                        <input name="new_login" value="" type="text" class="form-control" autofocus="" tabindex="1" placeholder="Username">
                                    </div>
                                    <div class="input-group mb-2">
                                        <span class="input-group-addon"><i class="icon-lock"></i></span>
                                        <input type="password" name="new_password" value="" tabindex="2" class="form-control" placeholder="Password">
                                    </div>
                                    <div class="input-group mb-2">
                                        <span class="input-group-addon"><i class="icon-lock"></i></span>
                                        <input type="password" name="new_password_check" value="" tabindex="3" class="form-control" placeholder="Password">
                                    </div>
                                    <div class="row mb-1">
                                        <div class="col-xs-6 float-xs-right text-xs-right">
                                            <button type="submit" value="login" class="btn btn-primary px-2" tabindex="3">Вход</button>
                                        </div>
                                    </div>
                                {else}
                                    <h1>Вход</h1>
                                    <p class="text-muted">В панель управления {$smarty.server.HTTP_HOST}</p>
                                    <div class="input-group mb-1">
                                        <span class="input-group-addon"><i class="icon-user"></i></span>
                                        <input name="login" value="{$login}" type="text" class="form-control" autofocus="" tabindex="1" placeholder="Username">
                                    </div>
                                    <div class="input-group mb-2">
                                        <span class="input-group-addon"><i class="icon-lock"></i></span>
                                        <input type="password" name="password" value="" tabindex="2" class="form-control" placeholder="Password">
                                    </div>
                                    <div class="row mb-1">
                                        <div class="col-xs-6 text-xs-left">
                                            <a class="btn btn-link px-0 fn_recovery" href="">Напомнить пароль</a>
                                        </div>
                                        <div class="col-xs-6 float-xs-right text-xs-right">
                                            <button type="submit" value="login" class="btn btn-primary px-2" tabindex="3">Вход</button>
                                        </div>
                                    </div>
                                {/if}
                            </form>
                            <div class="col-xs-12 p-h fn_recovery_wrap hidden px-0">
                                <div class="fn_success" style="display: none;margin-bottom:15px;">Сообщение отправлено на емейл администратору</div>
                                <label class="fn_recovery_label">Введите email администратора для восстановления пароля</label>
                                <input type="email" class="form-control mb-h fn_email" value="" name="recovery_email">
                                <button type="button" value="recovery" class="btn btn-primary px-2 fn_ajax_recover">Напомнить</button>
                            </div>
                        </div>
                    </div>
                    <div class="card card-inverse okay_bg py-3 hidden-md-down" style="width:50%">
                        <div class="card-block text-xs-center">
                            <div>
                                <p>
                                    <img src="design/images/system_logo.png" alt="OkayCMS" />
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    $(function () {
        $(document).on("click", ".fn_recovery", function (e) {
            e.preventDefault();
            $(".fn_recovery_wrap").toggleClass("hidden");
            return false;
        });
        $(document).on("click", ".fn_ajax_recover", function () {
            link = window.location.href;
            email = $(".fn_email").val();
            $(this).attr('disabled',true);
                $.ajax( {
                    url: link,
                    data: {
                        ajax_recovery : true,
                        recovery_email : email
                    },
                    method : 'get',
                    dataType: 'json',
                    success: function(data) {
                        if(data.send){
                            $(".fn_success").show();
                            $(".fn_recovery_label").remove();
                            $(".fn_email").remove();
                        }
                    }
                })
        });
    })
</script>
</body>
</html>
