<link href="backend/design/js/admintooltip/styles/admin.css{if $css_version}?v={$css_version}{/if}" rel="stylesheet">

<div class="admTools">
    <a href="javascript:void(0);" class="openTools"></a>
    <p>{$btr->admintooltip_title_1}</p>
    <p class="tool-descr">{$btr->admintooltip_descr}</p>
    <a title="{$btr->admintooltip_go_to_admin}" href="backend/" class="admin_bookmark"></a>
    <p class="tool-title">{$btr->admintooltip_fast_edit}</p>
    <a title="{$btr->admintooltip_enable}" href="javascript:void(0);" class="changeTools"><span></span></a>
</div>

<div class="fn_tooltip tooltip"></div>

<a title="{$btr->admintooltip_go_to_admin}" href="backend/" class="top_admin_bookmark"></a>

{literal}
<script>
    $(function() {
        tooltip = $(".fn_tooltip");
        $(document).on('mouseleave', '.tooltip', function(){tooltipcanclose=true;setTimeout("close_tooltip();", 300);});
        $(document).on('mouseover', '.tooltip', function(){tooltipcanclose=false;});
        $(document).on('click', '.openTools', function() {
            $(this).closest('.admTools').toggleClass('open');
        });

        if(typeof(Storage) !== "undefined") {

            function setTools() {
                if ( localStorage.getItem("adminTooltip") == "set" ) {
                    $('[data-page], [data-category], [data-brand], [data-product], [data-post], [data-feature], [data-language], [data-languages]').on('mouseover', show_tooltip);
                    $('.changeTools').addClass('on').attr('title', '{/literal}{$btr->admintooltip_disable}{literal}');
                } else {
                    $('[data-page], [data-category], [data-brand], [data-product], [data-post], [data-feature], [data-language], [data-languages]').off('mouseover', show_tooltip);
                    $('.changeTools').removeClass('on').attr('title', '{/literal}{$btr->admintooltip_enable}{literal}');
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
        var lang = '&lang_id={/literal}{$language->id}{literal}';
        if(typeof  lang_id != 'undefined') {
            lang = '&lang_id=' + lang_id;
        }

        if(id = $(this).attr('data-page'))
        {
            tooltipcontent = "<a href='backend/index.php?module=PageAdmin&id="+id+"&return="+from+lang+"' class=admin_tooltip_edit>{/literal}{$btr->admintooltip_edit_page}{literal}</a>";
            tooltipcontent += "<a href='backend/index.php?module=PageAdmin&return="+from+lang+"' class=admin_tooltip_add>{/literal}{$btr->admintooltip_add_page}{literal}</a>";
        }

        if(id = $(this).attr('data-category'))
        {
            tooltipcontent = "<a href='backend/index.php?module=CategoryAdmin&id="+id+"&return="+from+lang+"' class=admin_tooltip_edit>{/literal}{$btr->admintooltip_edit_category}{literal}</a>";
            tooltipcontent += "<a href='backend/index.php?module=CategoryAdmin&return="+from+lang+"' class=admin_tooltip_add>{/literal}{$btr->admintooltip_add_category}{literal}</a>";
            tooltipcontent += "<a href='backend/index.php?module=ProductAdmin&category_id="+id+"&return="+from+lang+"' class=admin_tooltip_add>{/literal}{$btr->admintooltip_add_product}{literal}</a>";
        }

        if(id = $(this).attr('data-brand'))
        {
            tooltipcontent = "<a href='backend/index.php?module=BrandAdmin&id="+id+"&return="+from+lang+"' class=admin_tooltip_edit>{/literal}{$btr->admintooltip_edit_brand}{literal}</a>";
            tooltipcontent += "<a href='backend/index.php?module=BrandAdmin&return="+from+lang+"' class=admin_tooltip_add>{/literal}{$btr->admintooltip_add_brand}{literal}</a>";
        }

        if(id = $(this).attr('data-product'))
        {
            tooltipcontent = "<a href='backend/index.php?module=ProductAdmin&id="+id+"&return="+from+lang+"' class=admin_tooltip_edit>{/literal}{$btr->admintooltip_edit_product}{literal}</a>";
            tooltipcontent += "<a href='backend/index.php?module=ProductAdmin&category_id="+id+"&return="+from+lang+"' class=admin_tooltip_add>{/literal}{$btr->admintooltip_add_product}{literal}</a>";
        }

        if(id = $(this).attr('data-post'))
        {
            tooltipcontent = "<a href='backend/index.php?module=PostAdmin&id="+id+"&return="+from+lang+"' class=admin_tooltip_edit>{/literal}{$btr->admintooltip_edit_post}{literal}</a>";
        }

        if(id = $(this).attr('data-feature'))
        {
            tooltipcontent = "<a href='backend/index.php?module=FeatureAdmin&id="+id+"&return="+from+lang+"' class=admin_tooltip_edit>{/literal}{$btr->admintooltip_edit_feature}{literal}</a>";
            tooltipcontent += "<a href='backend/index.php?module=FeatureAdmin&return="+from+lang+"' class=admin_tooltip_add>{/literal}{$btr->admintooltip_add_feature}{literal}</a>";
        }

        if(id = $(this).attr('data-language'))
        {
            tooltipcontent = "<a href='backend/index.php?module=TranslationAdmin&id="+id+"&return="+from+lang+"' class=admin_tooltip_edit>{/literal}{$btr->admintooltip_edit_translarion}{literal}</a>";
        }

        if(id = $(this).attr('data-languages'))
        {
            tooltipcontent = "<a href='backend/index.php?module=LanguagesAdmin&return="+from+lang+"' class=admin_tooltip_edit>{/literal}{$btr->admintooltip_edit_language}{literal}</a>";
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
</script>
{/literal}
