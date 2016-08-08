{$wrapper = '' scope=parent}
<html>
<title>Административная панель</title>
<link rel="icon" href="design/images/favicon.png" type="image/x-icon">
    <body>
        <style type="text/css" scoped>
            @import url(https://fonts.googleapis.com/css?family=Roboto:400,500,700&subset=latin,cyrillic);
            body {
                padding: 0;
                margin: 0;
                text-align: center;
                font-size: 14px;
                font-family: 'Roboto', sans-serif;
                background-color: #e4e5e5;
            }
            #system_logo {
                height: 120px;
                background-color: #091A33;
            }
            .heading {
                display: block;
                font-weight: bold;
                font-size: 24px;
                color: #243541;
                margin: 24px 0 17px;
            }
            form {
                display: inline-block;
                background-color: #f7f7f7;
                padding: 22px 25px;
                border: 1px solid #56b9ff;
                margin-bottom: 15px;
                width: 250px;
            }
            .form_group {
                text-align: left;
                margin-bottom: 12px;
            }
            .form_group label {
                display: inline-block;
                width: 60px;
                font-weight: 300;
            }
            .form_group input {
                height: 24px;
                width: 180px;
                padding: 0 5px;
                background: #fff;
                border: 1px solid #d0d0d0;
            }
            input:focus {
                outline: none;
            }
            .button {
                background: #ffcc00;
                margin-top: 10px;
                border: none;
                border-radius: 2px;
                padding: 9px 31px;
                font-size: 16px;
                color:#353b3e;
                cursor: pointer;
                -webkit-transition: all 0.3s ease;
                -moz-transition: all 0.3s ease;
                -o-transition: all 0.3s ease;
                transition: all 0.3s ease;
            }
            .button:hover {
                color: #fff;
                background: #56b9ff;
            }
            .message_error {
                background-color: #a70606;
                padding: 12px;
                color: #fff;
                margin-bottom: 20px;
            }
            .recovery {
                color: #243541;
                margin-right: 5px;
            }
            .recovery:hover {
                text-decoration: none;
            }
        </style>
        <div id="system_logo">
            <img src="design/images/system_logo.png" alt="OkayCMS" />
        </div>
        {if !$manager}
        <h2 class="heading">ВХОД В СИСТЕМУ</h2>
        {if $error_message}
            <div class="message_error">
                {if $error_message == 'auth_wrong'}
                    Неверно введены логин или пароль.
                    {if $limit_cnt}<br>Осталось {$limit_cnt} попыт{$limit_cnt|plural:'ка':'ок':'ки'}{/if}
                {elseif $error_message == 'limit_try'}
                    Вы исчерпали количество попыток на сегодня.
                {/if}
            </div>
        {/if}
        <form method="post">
            <input type=hidden name="session_id" value="{$smarty.session.id}">
            <div class="form_group">
                <label>Логин:</label>
                <input type="text" name="login" value="{$login}" autofocus="" tabindex="1">
            </div>
            <div class="form_group">
                <label>Пароль:</label>
                <input type="password" name="password" value="" tabindex="2">
            </div>
            <div>
                <a class="recovery" href="{$config->root_url}/password.php">Напомнить пароль</a>
                <input class="button" type="submit" value="Войти" tabindex="3">
            </div>
            
        </form>
        
    {else}
        <a href="javascript:;">Выйти ...</a>
    {/if}
    </body>
</html>