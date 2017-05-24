<html>
<title>{$settings->site_name}</title>
    <body>
    <div class="site_off_logo">
        <img src="{$config->root_url}/design/{$settings->theme}/images/logo.png">
    </div>
        <div class="site_off_text">
            {$settings->site_annotation}
        </div>
    </body>
</html>
{literal}
<style>
    .site_off_logo{
        display: flex;
        align-content: center;
        justify-content: center;
    }
    .site_off_text{
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 12px;
        font-size: 32px;
    }
</style>
{/literal}