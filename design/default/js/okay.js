// Аяксовая корзина
$(document).on('submit', 'form.variants', function(e) {
	e.preventDefault();
	button = $(this).find('button[type="submit"]');
	if($(this).find('input[name=variant]').size()>0)
		variant = $(this).find('input[name=variant]').val();
	if($(this).find('select[name=variant]').size()>0)
		variant = $(this).find('select').val();
	amount = 1;
	if($(this).find('input[name=amount]').size()>0)
	    amount = $(this).find('input[name=amount]').val();
	$.ajax({
		url: "ajax/cart.php",
		data: {variant: variant, amount: amount},
		dataType: 'json',
		success: function(data){
			$('#cart_informer').html(data);
			if(button.attr('data-result-text'))
				button.text(button.attr('data-result-text'));
		}
	});
	var o1 = $(this).offset();
	var o2 = $('#cart_informer').offset();
	var dx = o1.left - o2.left;
	var dy = o1.top - o2.top;
	var distance = Math.sqrt(dx * dx + dy * dy);
	$(this).closest('.product').find('.image img').effect("transfer", { to: $("#cart_informer"), className: "transfer_class" }, distance);	
	$('.transfer_class').html($(this).closest('.product').find('.image').html());
	$('.transfer_class').find('img').css('height', '100%');
	return false;
});

function ajax_change_amount(object, variant_id) {
    var amount = $(object).val();
    var coupon_code = $('input[name="coupon_code"]').val();
    var delivery_id = $('input[name="delivery_id"]:checked').val();
    $.ajax({
        url: 'ajax/cart_ajax.php',
        data: {
            coupon_code: coupon_code,
            action: 'update_citem',
            variant_id: variant_id,
            amount: amount
        },
        dataType: 'json',
        success: function(data) {
            if(data.result == 1) {
                ajax_set_result(data);
                $('#deliveries_'+delivery_id).trigger('click');
            } else {
                $('#cart_informer').html(data.cart_informer);
                /*$('#content').html('<h1>Корзина пуста</h1>В корзине нет товаров');*/
                $('#content').html(data.content);
            }
        }
    });
}
function ajax_remove(object, variant_id) {
    var coupon_code = $('input[name="coupon_code"]').val();
    var delivery_id = $('input[name="delivery_id"]:checked').val();
    $.ajax({
        url: 'ajax/cart_ajax.php',
        data: {
            coupon_code: coupon_code,
            action: 'remove_citem',
            variant_id: variant_id
        },
        dataType: 'json',
        success: function(data) {
            if(data.result == 1) {
                ajax_set_result(data);
                $('#deliveries_'+delivery_id).trigger('click');
            } else {
                $('#cart_informer').html(data.cart_informer);
                /*$('#content').html('<h1>Корзина пуста</h1>В корзине нет товаров');*/
                $('#content').html(data.content);
            }
        }
    });
}
function ajax_coupon() {
    var coupon_code = $('input[name="coupon_code"]').val();
    var delivery_id = $('input[name="delivery_id"]:checked').val();
    $.ajax({
        url: 'ajax/cart_ajax.php',
        data: {
            coupon_code: coupon_code,
            action: 'coupon_apply'
        },
        dataType: 'json',
        success: function(data) {
            if(data.result == 1) {
                ajax_set_result(data);
                $('#deliveries_'+delivery_id).trigger('click');
            } else {
                $('#cart_informer').html(data.cart_informer);
                /*$('#content').html('<h1>Корзина пуста</h1>В корзине нет товаров');*/
                $('#content').html(data.content);
            }
        }
    });
}
function ajax_set_result(data) {
    $('#cart_informer').html(data.cart_informer);
    $('#content h1').text('Товаров в корзине - '+data.total_products);
    $('#purchases').replaceWith(data.cart_purchases);
    $('#ajax_deliveries').replaceWith(data.cart_deliveries);
}



// Аяксовый список избранного
$(document).on('click', 'a.wishlist', function(e){
    e.preventDefault();

    var button = $(this),
        action = $(this).hasClass('selected') ? 'delete' : '';
    $.ajax({
        url: "ajax/wishlist.php",
        data: {id: $(this).attr('rel'), action: action },
        dataType: 'json',
        success: function(data){
            /*mt1sk*/
            //$('#wishlist').html(data);
            $('#wishlist').html(data.info);
            $('#wishlist_amount').text(data.cnt);
            if (data.cnt > 0) {
                $('#wishlist_amount').closest('a').show();
            } else {
                $('#wishlist_amount').closest('a').hide();
            }
            /*/mt1sk*/
            (action == '') ? button.addClass('selected') : button.removeClass('selected');
            if(button.attr('data-result-text')) {
                text = button.html();
                button.html(button.attr('data-result-text'));
                button.attr('data-result-text', text);
            }
        }
    });
    if (!button.hasClass('selected')) {
        var o1 = $(this).offset();
        var o2 = $('#wishlist').offset();
        var dx = o1.left - o2.left;
        var dy = o1.top - o2.top;
        var distance = Math.sqrt(dx * dx + dy * dy);
        $(this).closest('.product').find('.image img').effect("transfer", { to: $("#wishlist"), className: "transfer_class" }, distance);
        $('.transfer_class').html($(this).closest('.product').find('.image').html());
        $('.transfer_class').find('img').css('height', '100%');
    }
    return false;
});

function amount_change(input, action) {
    var max_val = parseFloat(input.data('max')), 
        curr_val = parseFloat(input.val()),
        step = 1;
    if(action == 'plus') {
        input.val(Math.min(max_val, Math.max(1, curr_val+step)));
    } else if(action == 'minus') {
        input.val(Math.min(max_val, Math.max(1,(curr_val-step))));
    } else if(action == 'keyup') {
        input.val(Math.min(max_val, Math.max(1, curr_val)));
    }
    /*if (total_cprice && total_cprice != 0 && total_cprice != '0,00') {
        parent_form.find(".compare_price .value").html((total_cprice * input.val()).toFixed(2));
    }
    parent_form.find(".price .value").html((total_price * input.val()).toFixed(2));*/
}

$(document).ready( function(){

	//Количество товара в карточке
    $('#product_amount span').click(function(){
        var amount_input = $(this).closest('#product_amount').find('input');
        amount_change(amount_input, $(this).hasClass('plus') ? 'plus' : ($(this).hasClass('minus') ? 'minus' : ''));
    });


    //Количество товара в корзине
    $(document).on('click', '#cart_amount .minus', function(){
        $(this).next('input').val(parseInt($(this).next('input').val())-1).trigger('change');
    });
            
    $(document).on('click', '#cart_amount .plus', function(){
        $(this).prev('input').val(parseInt($(this).prev('input').val())+1).trigger('change');
    });


	//Зум картинок
	$("a.zoom").fancybox({
		prevEffect	: 'fade',
		nextEffect	: 'fade'
	});
	

}); 

$(function(){
	/* Функция добавления/удаления в папку сравнения */
	$(document).on('click', '.comparison_button', function(e){
		e.preventDefault();
		var button = $(this), action = $(this).hasClass('add') ? 'add' : 'delete', product = parseInt($(this).data('id'));
		$.ajax({
			url: "ajax/comparison.php",
			data: {product: product,action: action},
			dataType: 'json',
			success: function(data){
				$('#comparison_informer').html(data);
				if(action == 'add' && typeof(button.data('delete')) != 'undefined'){
					button.removeClass('add').html(button.data('delete'));
				}else if(action == 'delete' && typeof(button.data('add')) != 'undefined'){
					button.addClass('add').html(button.data('add'));
				}
				/* Если находимся на странице сравнения - перезагрузить */
				if($('.comparison_products').size()){
					window.location = window.location;
				}
			}
		});
        if (button.hasClass('add')) {
            var o1 = $(this).offset();
            var o2 = $('#comparison_anim').offset();
            var dx = o1.left - o2.left;
            var dy = o1.top - o2.top;
            var distance = Math.sqrt(dx * dx + dy * dy);
            $(this).closest('.product').find('.image img').effect("transfer", { to: $("#comparison_anim"), className: "transfer_class" }, distance);
            $('.transfer_class').html($(this).closest('.product').find('.image').html());
            $('.transfer_class').find('img').css('height', '100%');
        }
	});

	/* Проверка количества добавленных товаров и при превышении его максимально заданного числа включение слайдера */
    if($('.comparison_products').size() && $('.comparison_product').size()){
        var productsCount = parseInt($('.comparison_products').data('products'))>0 ? parseInt($('.comparison_products').data('products')) : 2;
        if($('.comparison_product').size()<productsCount)
            productsCount = $('.comparison_product').size();
        var itemWidth = Math.floor(($('.comparison_products').width())/productsCount);
        $('.comparison_product').width(itemWidth);
        if($('.comparison_product').size()>productsCount){
            $('.comparison_slider').slick({
                infinite: true,
                speed: 500,
                slidesToShow: 2,
                slidesToScroll: 1,
                arrows:true,
                prevArrow :'.comparison_prev',
                nextArrow :'.comparison_next'

            });
        }
        resize_comparison();
        $('.fancy_zoom').fancybox();
    }

	/* Показать/скрыть одинаковые характеристики */
	$('.comparison_options_show').click(function(e){
		e.preventDefault();
		$('.comparison_options_show.active').removeClass('active');
		$(this).addClass('active');
		if($(this).hasClass('unique')){
			$('.comparison_content .cell.not_unique').hide();
		}else{
			$('.comparison_content .cell.not_unique').show();
		}
	});
	
});

/* Формирование ровных строчек для характеристик */
var resize_comparison = function () {
	if ($('[data-use]').size()) {
		$('[data-use]').each(function () {
			var use = '.' + $(this).data('use');
			var minHeight = $(this).height();
			if ($(use).size()) {
				$(use).each(function () {
					if ($(this).height() >= minHeight) {
						minHeight = $(this).height();
					}
				});
				$(use).height(minHeight);
				if (use == '.cprs_image') {
					$('.comparison_prev,.comparison_next').height(minHeight);
				}
			}
		});
	}
};

$(window).load(resize_comparison);
/*
$(window).resize(resize_comparison);*/
