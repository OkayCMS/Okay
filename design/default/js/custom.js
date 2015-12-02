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

    $(document).on('change', '.variants select[name=variant]', function() {
        var selected = $(this).children(':selected'),
            parent = selected.closest('form.variants'),
            price = parent.find('.price span'),
            cprice = parent.find('.old_price span'),
            sku = $(this).closest('.product').find('.sku span'),
            stock = selected.data('stock'),
            button = parent.find('button[type=submit]');
        
        price.html(selected.data('price'));
        if(typeof(selected.data('cprice')) != 'undefined') {
            cprice.html(selected.data('cprice'));
            cprice.parent().removeClass('hidden');
        } else {
            cprice.parent().addClass('hidden');
        }
        if(typeof(selected.data('sku')) != 'undefined') {
            sku.html(selected.data('sku'));
            sku.parent().removeClass('hidden');
        } else {
            sku.parent().addClass('hidden');
        }
        
        /*Предзаказ*/
        if (stock > 0) {
            parent.find('p.not_in_stock').hide();
            button.text(button.data('in_cart'));            
            if (!is_preorder) {
                button.show();
            }
        } else {
            parent.find('p.not_in_stock').show();
            button.text(button.data('preorder'));            
            if (!is_preorder) {
                button.hide();
            }
        }
        
        /*Max amount*/
        var max = (stock > 0 ? stock : (is_preorder ? max_order_amount : 0)),
            amount = parent.find('#product_amount input');
        amount.data('max', max);
        amount_change(amount, 'keyup');
    });
    $('select[name=variant]').each(function() {
        $(this).trigger('change');
    });
    
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