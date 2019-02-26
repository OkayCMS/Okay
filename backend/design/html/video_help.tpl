<div class="box_adswitch">

    {*Импорт товаров*}
    {if $smarty.get.module == 'ImportAdmin'}
        <a class="btn_admin btn_vid_help" target="_blank" href="https://youtu.be/B0PnB-8VMcs">
            {include file='svg_icon.tpl' svgId='video_icon'}
            <span class="btn_vid_help_text quickview_hidden">{$btr->video_help}</span>
        </a>

    {*SEO товаров или автоматизация SEO*}
    {elseif $smarty.get.module == 'SeoPatternsAdmin'}
        <a class="btn_admin btn_vid_help" target="_blank" href="https://youtu.be/5TfYmhwncss">
            {include file='svg_icon.tpl' svgId='video_icon'}
            <span class="btn_vid_help_text quickview_hidden">{$btr->video_help}</span>
        </a>

    {*Настройка сайта*}
    {elseif $smarty.get.module == 'SettingsGeneralAdmin'}
        <a class="btn_admin btn_vid_help" target="_blank" href="https://youtu.be/l5xHrK52Rqw">
            {include file='svg_icon.tpl' svgId='video_icon'}
            <span class="btn_vid_help_text quickview_hidden">{$btr->video_help}</span>
        </a>

    {*Настройка уведомлений*}
    {elseif $smarty.get.module == 'SettingsNotifyAdmin'}
        <a class="btn_admin btn_vid_help" target="_blank" href="https://youtu.be/VtM8xV4J84s">
            {include file='svg_icon.tpl' svgId='video_icon'}
            <span class="btn_vid_help_text quickview_hidden">{$btr->video_help}</span>
        </a>

    {*Настройка каталога*}
    {elseif $smarty.get.module == 'SettingsCatalogAdmin'}
        <a class="btn_admin btn_vid_help" target="_blank" href="https://youtu.be/pfSCyAgWdU0">
            {include file='svg_icon.tpl' svgId='video_icon'}
            <span class="btn_vid_help_text quickview_hidden">{$btr->video_help}</span>
        </a>

    {*Способы оплаты*}
    {elseif $smarty.get.module == 'PaymentMethodsAdmin' || $smarty.get.module == 'PaymentMethodAdmin'}
        <a class="btn_admin btn_vid_help" target="_blank" href="https://youtu.be/1MfdlulArkA">
            {include file='svg_icon.tpl' svgId='video_icon'}
            <span class="btn_vid_help_text quickview_hidden">{$btr->video_help}</span>
        </a>

    {*Способы доставки*}
    {elseif $smarty.get.module == 'DeliveriesAdmin' || $smarty.get.module == 'DeliveryAdmin'}
        <a class="btn_admin btn_vid_help" target="_blank" href="https://youtu.be/W1qEAb0RbD4">
            {include file='svg_icon.tpl' svgId='video_icon'}
            <span class="btn_vid_help_text quickview_hidden">{$btr->video_help}</span>
        </a>

    {*Менеджеры*}
    {elseif $smarty.get.module == 'ManagersAdmin'}
        <a class="btn_admin btn_vid_help" target="_blank" href="https://youtu.be/2SdCZ9NmVPM">
            {include file='svg_icon.tpl' svgId='video_icon'}
            <span class="btn_vid_help_text quickview_hidden">{$btr->video_help}</span>
        </a>

    {*Валюты*}
    {elseif $smarty.get.module == 'CurrencyAdmin'}
        <a class="btn_admin btn_vid_help" target="_blank" href="https://youtu.be/CZPSSlnjXFs">
            {include file='svg_icon.tpl' svgId='video_icon'}
            <span class="btn_vid_help_text quickview_hidden">{$btr->video_help}</span>
        </a>

    {*Покупатели, подписчики *}
    {elseif $smarty.get.module == 'SubscribeMailingAdmin'}
        <a class="btn_admin btn_vid_help" target="_blank" href="https://youtu.be/dl53ep5e8XE">
            {include file='svg_icon.tpl' svgId='video_icon'}
            <span class="btn_vid_help_text quickview_hidden">{$btr->video_help}</span>
        </a>

    {*Настройка заказов*}
    {elseif $smarty.get.module == 'OrderSettingsAdmin'}
        <a class="btn_admin btn_vid_help" target="_blank" href="https://youtu.be/zGU9mDfdUqM">
            {include file='svg_icon.tpl' svgId='video_icon'}
            <span class="btn_vid_help_text quickview_hidden">{$btr->video_help}</span>
        </a>

    {*Список заказов *}
    {elseif $smarty.get.module == 'OrdersAdmin'}
        <a class="btn_admin btn_vid_help" target="_blank" href="https://youtu.be/fh6XnFrchAc">
            {include file='svg_icon.tpl' svgId='video_icon'}
            <span class="btn_vid_help_text quickview_hidden">{$btr->video_help}</span>
        </a>

    {*Работа с заказом *}
    {elseif $smarty.get.module == 'OrderAdmin'}
        <a class="btn_admin btn_vid_help" target="_blank" href="https://youtu.be/-mkBI-Q6Snk">
            {include file='svg_icon.tpl' svgId='video_icon'}
            <span class="btn_vid_help_text quickview_hidden">{$btr->video_help}</span>
        </a>

    {*Работа со списком товаров*}
    {elseif $smarty.get.module == 'ProductsAdmin'}
        <a class="btn_admin btn_vid_help" target="_blank" href="https://youtu.be/IETA0dyLaOE">
            {include file='svg_icon.tpl' svgId='video_icon'}
            <span class="btn_vid_help_text quickview_hidden">{$btr->video_help}</span>
        </a>

    {*Товары*}
    {elseif $smarty.get.module == 'ProductAdmin'}
        <a class="btn_admin btn_vid_help" target="_blank" href="https://youtu.be/i1wZ130rsq8">
            {include file='svg_icon.tpl' svgId='video_icon'}
            <span class="btn_vid_help_text quickview_hidden">{$btr->video_help}</span>
        </a>

    {*Список страниц*}
    {elseif $smarty.get.module == 'PagesAdmin'}
        <a class="btn_admin btn_vid_help" target="_blank" href="https://youtu.be/4paNOW__dR0">
            {include file='svg_icon.tpl' svgId='video_icon'}
            <span class="btn_vid_help_text quickview_hidden">{$btr->video_help}</span>
        </a>

    {*Обратный звонок*}
    {elseif $smarty.get.module == 'CallbacksAdmin'}
        <a class="btn_admin btn_vid_help" target="_blank" href="https://youtu.be/0-SA7NFszFg">
            {include file='svg_icon.tpl' svgId='video_icon'}
            <span class="btn_vid_help_text quickview_hidden">{$btr->video_help}</span>
        </a>

    {*Купоны*}
    {elseif $smarty.get.module == 'CouponsAdmin'}
        <a class="btn_admin btn_vid_help" target="_blank" href="https://youtu.be/U6vhBPOB5lY">
            {include file='svg_icon.tpl' svgId='video_icon'}
            <span class="btn_vid_help_text quickview_hidden">{$btr->video_help}</span>
        </a>

    {*Комментарии*}
    {elseif $smarty.get.module == 'CommentsAdmin'}
        <a class="btn_admin btn_vid_help" target="_blank" href="https://youtu.be/ozO8CyXeW7Y">
            {include file='svg_icon.tpl' svgId='video_icon'}
            <span class="btn_vid_help_text quickview_hidden">{$btr->video_help}</span>
        </a>

    {*Категории*}
    {elseif $smarty.get.module == 'CategoriesAdmin' || $smarty.get.module == 'CategoryAdmin'}
        <a class="btn_admin btn_vid_help" target="_blank" href="https://youtu.be/B0oc25RkE3U">
            {include file='svg_icon.tpl' svgId='video_icon'}
            <span class="btn_vid_help_text quickview_hidden">{$btr->video_help}</span>
        </a>

    {*Бренды*}
    {elseif $smarty.get.module == 'BrandsAdmin' || $smarty.get.module == 'BrandsAdmin'}
        <a class="btn_admin btn_vid_help" target="_blank" href="https://youtu.be/-vxM0bR8yHg">
            {include file='svg_icon.tpl' svgId='video_icon'}
            <span class="btn_vid_help_text quickview_hidden">{$btr->video_help}</span>
        </a>

    {*Блог*}
    {elseif $smarty.get.module == 'BlogAdmin' || $smarty.get.module == 'PostAdmin'}
        <a class="btn_admin btn_vid_help" target="_blank" href="https://youtu.be/JnhkMaI9Tto">
            {include file='svg_icon.tpl' svgId='video_icon'}
            <span class="btn_vid_help_text quickview_hidden">{$btr->video_help}</span>
        </a>

    {*Создание группы и баннера*}
    {elseif $smarty.get.module == 'BannersAdmin' || $smarty.get.module == 'BannerAdmin' || $smarty.get.module == 'BannersImagesAdmin' || $smarty.get.module == 'BannersImageAdmin'}
        <a class="btn_admin btn_vid_help" target="_blank" href="https://youtu.be/S9AkoK6sQP4">
            {include file='svg_icon.tpl' svgId='video_icon'}
            <span class="btn_vid_help_text quickview_hidden">{$btr->video_help}</span>
        </a>

    {*Seo – синонимы свойства*}
    {elseif $smarty.get.module == 'FeaturesAliasesAdmin'}
        <a class="btn_admin btn_vid_help" target="_blank" href="https://youtu.be/cK42rT3-MpE">
            {include file='svg_icon.tpl' svgId='video_icon'}
            <span class="btn_vid_help_text quickview_hidden">{$btr->video_help}</span>
        </a>

    {*Seo – seo фильтров*}
    {elseif $smarty.get.module == 'SeoFilterPatternsAdmin'}
        <a class="btn_admin btn_vid_help" target="_blank" href="https://youtu.be/jkPemJqETJg">
            {include file='svg_icon.tpl' svgId='video_icon'}
            <span class="btn_vid_help_text quickview_hidden">{$btr->video_help}</span>
        </a>

    {*Seo - Пользовательские скрипты *}
    {elseif $smarty.get.module == 'SettingsCounterAdmin'}
        <a class="btn_admin btn_vid_help" target="_blank" href="https://youtu.be/nabCRKyzSTA">
            {include file='svg_icon.tpl' svgId='video_icon'}
            <span class="btn_vid_help_text quickview_hidden">{$btr->video_help}</span>
        </a>

    {*Seo – robots.txt*}
    {elseif $smarty.get.module == 'RobotsAdmin'}
        <a class="btn_admin btn_vid_help" target="_blank" href="https://youtu.be/Mx05vxRQ-nM">
            {include file='svg_icon.tpl' svgId='video_icon'}
            <span class="btn_vid_help_text quickview_hidden">{$btr->video_help}</span>
        </a>

    {else}
        {*<a class="btn_admin btn_vid_help " href="https://www.youtube.com/channel/UCxqbdarNc5wJVw2PM6Q4HUQ">
            {include file='svg_icon.tpl' svgId='video_icon'}
            <span class="btn_vid_help_text quickview_hidden">{$btr->video_help}</span>
        </a>*}
    {/if}

</div>