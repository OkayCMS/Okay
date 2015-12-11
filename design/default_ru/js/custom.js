$(document).ready(function() {
    
    $('.drop').on('click', function() {
        $(this).next('.dropdown').slideToggle(300);
        if ($(this).hasClass('active')) {
            $(this).removeClass('active');
        } else {
            $(this).addClass('active');
        }
    });

    $('.banner1').slick({
        infinite: true,
        speed: 500,
        slidesToShow: 1,
        slidesToScroll: 1,
        dots:true,
        arrows:true,
        autoplay:true,
        autoplaySpeed:3000
    });

    $("#all_brands").slick({
        infinite: true,
        speed: 500,
        slidesToShow: 5,
        slidesToScroll: 1,
        arrows:true,
    });

    if($(".images a").size()>4) {
        $(".images").slick({
            infinite: true,
            speed: 500,
            slidesToShow: 4,
            slidesToScroll: 1,
            arrows:true,
        });
    }

    if($("#test li").size()>3) {
        $("#test").slick({
            infinite: true,
            speed: 500,
            slidesToShow: 3,
            slidesToScroll: 1,
            arrows:true,
        });
    }
    
    //Меню каталога
    $('#catalog_menu .switch').on('click', function() {
        $(this).next('.submenu').slideToggle(300);
        if ($(this).hasClass('active')) {
            $(this).removeClass('active');
        } else {
            $(this).addClass('active');
        }
    });
    $('#catalog_menu .selected').parents('.parent').addClass('opened').find('.switch').addClass('active');
    
    
    //Табы
    var nav = $('.tabs').find('.tab_navigation');
    var tabs = $('.tabs').find('.tab_container');
    
    if(nav.children('.selected').size() > 0) {
        $(nav.children('.selected').attr("href")).show();
        tabs.css('height', tabs.children($(nav.children('.selected')).attr("href")).outerHeight());
    } else {
        nav.children().first().addClass('selected');
        tabs.children().first().show();
        tabs.css('height', tabs.children().first().outerHeight());
    }
    
    $('.tab_navigation a').on('click', function(e) {
        e.preventDefault();
        if($(this).hasClass('selected')) {
            return true;
        }
        tabs.children().hide();
        nav.children().removeClass('selected');
        $(this).addClass('selected');
        $($(this).attr("href")).fadeIn(200);
        tabs.css('height', tabs.children($(this).attr("href")).outerHeight());
    });
    
    
    //Выравнивание по высоте
    $('#products_content .inner').matchHeight();
    $('#featured_products .inner').matchHeight();
    $('#new_products .inner').matchHeight();
    $('#discounted_products .inner').matchHeight();
    
    $('#products_content .product_name').matchHeight();
    $('#featured_products .product_name').matchHeight();
    $('#new_products .product_name').matchHeight();
    $('#discounted_products .product_name').matchHeight();
});