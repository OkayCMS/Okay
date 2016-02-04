$(function() {
    $("<div class='admTools'>\
    <a href='javascript:void(0);' class='openTools'></a>\
    <p>Инструмент настройки позволяет включить/выключить инструменты редактирования и войти в админ-панель.</p>\
    <p class='tool-descr'>Только вы видите этот инструмент из-за авторизации в качестве администратора; ваши посетители не видят панель конфигуратора.</p>\
    <a title='Войти в админ-панель' href='admin/' class='admin_bookmark'></a>\
    <p class='tool-title'>Быстрое редактирование</p>\
    <a title='Включить' href='javascript:void(0);' class='changeTools'><span></span></a>\
    </div>").appendTo('body');
    tooltip = $("<div class='tooltip'></div>").appendTo($('body'));
    $("<a title='Войти в админ-панель' href='admin/' class='top_admin_bookmark'></a>").appendTo('body');
    $(document).on('mouseleave', '.tooltip', function(){tooltipcanclose=true;setTimeout("close_tooltip();", 300);});
    $(document).on('mouseover', '.tooltip', function(){tooltipcanclose=false;});
    $(document).on('click', '.openTools', function() {
        $(this).closest('.admTools').toggleClass('open');
    });

    if(typeof(Storage) !== "undefined") {

        function setTools() {
            if ( localStorage.getItem("adminTooltip") == "set" ) {
                $('[data-page], [data-category], [data-brand], [data-product], [data-post], [data-feature], [data-language], [data-languages]').on('mouseover', show_tooltip);
                $('.changeTools').addClass('on').attr('title', 'Выключить');
            } else {
                $('[data-page], [data-category], [data-brand], [data-product], [data-post], [data-feature], [data-language], [data-languages]').off('mouseover', show_tooltip);
                $('.changeTools').removeClass('on').attr('title', 'Включить');
            }
        }

        setTools();

        $(document).on('click', '.changeTools', function() {
            if ( localStorage.getItem("adminTooltip") == "set" ) {
                localStorage.setItem("adminTooltip", "unset");
                setTools();
            } else {
                localStorage.setItem("adminTooltip", "set");
                setTools();
            }
        });

    } else {
        $('[data-page], [data-category], [data-brand], [data-product], [data-post], [data-feature], [data-language], [data-languages]').on('mouseover', show_tooltip);
    }
});

function show_tooltip()
{
    tooltipcanclose=false;
    tooltip.show();
    $(this).on('mouseleave', function(){tooltipcanclose=true;setTimeout("close_tooltip();", 500);});

    flip = !($(this).offset().left+tooltip.width()+25 < $('body').width());

    tooltip.css('top',  $(this).outerHeight() + 5 + $(this).offset().top + 'px');
    tooltip.css('left', ($(this).offset().left + $(this).outerWidth()*0.5 - (flip ? tooltip.width()-40 : 0)  + 0) + 'px');

    from = encodeURIComponent(window.location);
    tooltipcontent = '';

    if(id = $(this).attr('data-page'))
    {
        tooltipcontent = "<a href='backend/index.php?module=PageAdmin&id="+id+"&return="+from+"' class=admin_tooltip_edit>Редактировать страницу</a>";
        tooltipcontent += "<a href='backend/index.php?module=PageAdmin&return="+from+"' class=admin_tooltip_add>Добавить страницу</a>";
    }

    if(id = $(this).attr('data-category'))
    {
        tooltipcontent = "<a href='backend/index.php?module=CategoryAdmin&id="+id+"&return="+from+"' class=admin_tooltip_edit>Редактировать категорию</a>";
	    tooltipcontent += "<a href='backend/index.php?module=CategoryAdmin&return="+from+"' class=admin_tooltip_add>Добавить категорию</a>";
	    tooltipcontent += "<a href='backend/index.php?module=ProductAdmin&category_id="+id+"&return="+from+"' class=admin_tooltip_add>Добавить товар</a>";
    }

    if(id = $(this).attr('data-brand'))
    {
        tooltipcontent = "<a href='backend/index.php?module=BrandAdmin&id="+id+"&return="+from+"' class=admin_tooltip_edit>Редактировать бренд</a>";
	    tooltipcontent += "<a href='backend/index.php?module=BrandAdmin&return="+from+"' class=admin_tooltip_add>Добавить бренд</a>";
    }

    if(id = $(this).attr('data-product'))
    {
        tooltipcontent = "<a href='backend/index.php?module=ProductAdmin&id="+id+"&return="+from+"' class=admin_tooltip_edit>Редактировать товар</a>";
	    tooltipcontent += "<a href='backend/index.php?module=ProductAdmin&category_id="+id+"&return="+from+"' class=admin_tooltip_add>Добавить товар</a>";
    }

    if(id = $(this).attr('data-post'))
    {
        tooltipcontent = "<a href='backend/index.php?module=PostAdmin&id="+id+"&return="+from+"' class=admin_tooltip_edit>Редактировать новость</a>";
    }

    if(id = $(this).attr('data-feature'))
    {
        tooltipcontent = "<a href='backend/index.php?module=FeatureAdmin&id="+id+"&return="+from+"' class=admin_tooltip_edit>Редактировать свойство</a>";
	    tooltipcontent += "<a href='backend/index.php?module=FeatureAdmin&return="+from+"' class=admin_tooltip_add>Добавить свойство</a>";
    }

	if(id = $(this).attr('data-language'))
	{
		tooltipcontent = "<a href='backend/index.php?module=TranslationAdmin&id="+id+"&return="+from+"' class=admin_tooltip_edit>Редактировать перевод</a>";
	}

	if(id = $(this).attr('data-languages'))
	{
		tooltipcontent = "<a href='backend/index.php?module=LanguagesAdmin&return="+from+"' class=admin_tooltip_edit>Редактировать языки</a>";
	}

    $('.tooltip').html(tooltipcontent);
}

function close_tooltip()
{
    if(tooltipcanclose)
    {
        tooltipcanclose=false;
        tooltip.hide();
    }
}

function SetTooltips() {
    elements = document.getElementsByTagName("body")[0].getElementsByTagName("*");

    for (i = 0; i <elements.length; i++)
    {
        tooltip = elements[i].getAttribute('tooltip');
        if(tooltip)
        {
            elements[i].onmouseout = function(e) {tooltipcanclose=true;setTimeout("CloseTooltip();", 1000);};
            switch(tooltip)
            {
                case 'product':
                    elements[i].onmouseover = function(e) {AdminProductTooltip(this,  this.getAttribute('product_id'));tooltipcanclose=false;}
                    break;
                case 'hit':
                    elements[i].onmouseover = function(e) {AdminHitTooltip(this,  this.getAttribute('product_id'));tooltipcanclose=false;tooltipcanclose=false;}
                    break;
                case 'category':
                    elements[i].onmouseover = function(e) {AdminCategoryTooltip(this,  this.getAttribute('category_id'));tooltipcanclose=false;}
                    break;
                case 'news':
                    elements[i].onmouseover = function(e) {AdminNewsTooltip(this,  this.getAttribute('news_id'));tooltipcanclose=false;}
                    break;
                case 'article':
                    elements[i].onmouseover = function(e) {AdminArticleTooltip(this,  this.getAttribute('article_id'));tooltipcanclose=false;}
                    break;
                case 'page':
                    elements[i].onmouseover = function(e) {AdminPageTooltip(this,  this.getAttribute('id')); tooltipcanclose=false;}
                    break;
                case 'currency':
                    elements[i].onmouseover = function(e) {AdminCurrencyTooltip(this); tooltipcanclose=false;}
                    break;
            }
        }
    }
}


function ShowTooltip(i, content) {

    tooltip = document.getElementById('tooltip');

    document.getElementById('tooltip').innerHTML = content;
    tooltip.style.display = 'block';

    var xleft=0;
    var xtop=0;
    o = i;

    do {
        xleft += o.offsetLeft;
        xtop  += o.offsetTop;

    } while (o=o.offsetParent);

    xwidth  = i.offsetWidth  ? i.offsetWidth  : i.style.pixelWidth;
    xheight = i.offsetHeight ? i.offsetHeight : i.style.pixelHeight;

    bwidth =  tooltip.offsetWidth  ? tooltip.offsetWidth  : tooltip.style.pixelWidth;

    w = window;

    xbody  = document.compatMode=='CSS1Compat' ? w.document.documentElement : w.document.body;
    dwidth = xbody.clientWidth  ? xbody.clientWidth   : w.innerWidth;
    bwidth = tooltip.offsetWidth ? tooltip.offsetWidth  : tooltip.style.pixelWidth;

    flip = !( 25 + xleft + bwidth < dwidth);

    tooltip.style.top  = xheight - 3 + xtop + 'px';
    tooltip.style.left = (xleft - (flip ? bwidth : 0)  + 25) + 'px';

    return false;
}
