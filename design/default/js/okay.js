/* Начальное кол-во для смены в карточке и корзине */
okay.amount = 1;

/* Аяксовая корзина */
$(document).on('submit', '.fn-variants.okaycms', function(e) {
	e.preventDefault();
	var variant,
		amount;
	/* Вариант */
	if($(this).find('input[name=variant]:checked').size() > 0 ) {
		variant = $(this).find('input[name=variant]:checked').val();
	} else if($(this ).find('input[name=variant]').size() > 0 ) {
		variant = $(this).find('input[name=variant]').val();
	} else if($(this).find('select[name=variant]').size() > 0 ) {
		variant = $(this).find('select[name=variant]').val();
	}
	/* Кол-во */
	if($(this).find('input[name=amount]').size()>0) {
		amount = $(this).find('input[name=amount]').val();
	} else {
		amount = 1;
	}
	/* ajax запрос */
	$.ajax( {
		url: "ajax/cart.php",
		data: {
			variant: variant,
			amount: amount
		},
		dataType: 'json',
		success: function(data) {
			$( '#cart_informer' ).html( data );
		}
	} );
	/* Улеталка */
	transfer( $('#cart_informer'), $(this) );
});

/* Смена варианта в превью товара и в карточке */
$(document).on('change', '.fn-variant.okaycms', function() {
	var selected = $( this ).children( ':selected' ),
		parent = selected.closest( '.fn-product' ),
		price = parent.find( '.fn-price' ),
		cprice = parent.find( '.fn-old_price' ),
		sku = parent.find( '.fn-sku' ),
		stock = parseInt( selected.data( 'stock' ) ),
		amount = parent.find( 'input[name="amount"]' ),
		camoun = parseInt( amount.val() );
	price.html( selected.data( 'price' ) );
	amount.data('max', stock);
	/* Количество товаров */
	if ( stock < camoun ) {
		amount.val( stock );
	} else if ( okay.amount > camoun ) {
		amount.val( okay.amount );
	}
    else if(isNaN(camoun)){
        amount.val( okay.amount );
    }
	/* Цены */
	if( selected.data( 'cprice' ) ) {
		cprice.html( selected.data( 'cprice' ) );
		cprice.parent().removeClass( 'hidden-xs-up' );
		if ( parent.hasClass( 'card' ) ) {
			cprice.parent().next().removeClass( 'col-xs-12' );
			cprice.parent().next().addClass( 'col-xs-6' );
		}
	} else {
		cprice.parent().addClass( 'hidden-xs-up' );
		if ( parent.hasClass( 'card' ) ) {
			cprice.parent().next().removeClass( 'col-xs-6' );
			cprice.parent().next().addClass( 'col-xs-12' );
		}
	}
	/* Артикул */
	if( typeof(selected.data( 'sku' )) != 'undefined' ) {
		sku.text( selected.data( 'sku' ) );
		sku.parent().removeClass( 'hidden-xs-up' );
	} else {
		sku.text( '' );
		sku.parent().addClass( 'hidden-xs-up' );
	}
	/* Предзаказ */
	if (stock == 0 && okay.is_preorder) {
		parent.find('.fn-is_preorder').removeClass('hidden-xs-up');
		parent.find('.fn-is_stock, .fn-not_preorder').addClass('hidden-xs-up');
	} else if (stock == 0 && !okay.is_preorder) {
		parent.find('.fn-not_preorder').removeClass('hidden-xs-up');
		parent.find('.fn-is_stock, .fn-is_preorder').addClass('hidden-xs-up');
	} else {
		parent.find('.fn-is_stock').removeClass('hidden-xs-up');
		parent.find('.fn-is_preorder, .fn-not_preorder').addClass('hidden-xs-up');
	}
});

/* Количество товара в карточке и корзине */
$( document ).on( 'click', '.fn-product-amount.okaycms span', function() {
	var input = $( this ).parent().find( 'input' ),
		action;
	if ( $( this ).hasClass( 'plus' ) ) {
		action = 'plus';
	} else if ( $( this ).hasClass( 'minus' ) ) {
		action = 'minus';
	}
	amount_change( input, action );
} );

/* Функция добавления / удаления в папку сравнения */
$(document).on('click', '.fn-comparison.okaycms', function(e){
	e.preventDefault();
	var button = $( this ),
		action = $( this ).hasClass( 'selected' ) ? 'delete' : 'add',
		product = parseInt( $( this ).data( 'id' ) );
	/* ajax запрос */
	$.ajax( {
		url: "ajax/comparison.php",
		data: { product: product, action: action },
		dataType: 'json',
		success: function(data) {
			$( '#comparison' ).html( data );
			/* Смена класса кнопки */
			if( action == 'add' ) {
                button.addClass( 'selected' );
			} else if( action == 'delete' ) {
                button.removeClass( 'selected' );
			}
			/* Смена тайтла */
			if( button.attr( 'title' ) ) {
				var text = button.data( 'result-text' ),
					title = button.attr( 'title' );
				button.data( 'result-text', title );
				button.attr( 'title', text );
			}
			/* Если находимся на странице сравнения - перезагрузить */
			if( $( '.fn-comparison_products' ).size() ) {
				window.location = window.location;
			}
		}
	} );
	/* Улеталка */
	if( !button.hasClass( 'selected' ) ) {
		transfer( $( '#comparison' ), $( this ) );
	}
});

/* Функция добавления / удаления в папку избранного */
$(document).on('click', '.fn-wishlist.okaycms', function(e){
	e.preventDefault();
	var button = $( this ),
		action = $( this ).hasClass( 'selected' ) ? 'delete' : '';
	/* ajax запрос */
	$.ajax( {
		url: "ajax/wishlist.php",
		data: { id: $( this ).data( 'id' ), action: action },
		dataType: 'json',
		success: function(data) {
			$( '#wishlist' ).html( data.info );
			/* Смена класса кнопки */
			if (action == '') {
				button.addClass( 'selected' )
			} else {
				button.removeClass( 'selected' )
			}
			/* Смена тайтла */
			if( button.attr( 'title' ) ) {
				var text = button.data( 'result-text' ),
					title = button.attr( 'title' );
				button.data( 'result-text', title );
				button.attr( 'title', text );
			}
			/* Если находимся на странице сравнения - перезагрузить */
			if( $( '.fn-wishlist-page' ).size() ) {
				window.location = window.location;
			}
		}
	} );
	/* Улеталка */
	if( !button.hasClass( 'selected' ) ) {
		transfer( $( '#wishlist' ), $( this ) );
	}
});

/* Отправка купона по нажатию на enter */
$( document ).on( 'keypress', '.fn-coupon.okaycms', function(e) {
	if( e.keyCode == 13 ) {
		e.preventDefault();
		ajax_coupon();
	}
} );

/* Отправка купона по нажатию на кнопку */
$( document ).on( 'click', '.fn-sub-coupon.okaycms', function(e) {
	ajax_coupon();
} );

/* Document ready */
$(function(){

	/* Обратный звонок */
	$('.fn-callback.okaycms').fancybox({
		padding: 0
	});

	/* Инициализация баннера */
    $('.fn-slick-banner_group1.okaycms').slick({
		infinite: true,
		speed: 500,
		slidesToShow: 1,
		slidesToScroll: 1,
        swipeToSlide : true,
		dots: true,
		arrows: false,
		adaptiveHeight: true,
		autoplaySpeed: 8000,
		autoplay: true
	});

	/* Инициализация доп. фото в карточке */
	$(".fn-slick-images.okaycms").slick({
		infinite: false,
		speed: 500,
		slidesToShow: 4,
		slidesToScroll: 1,
        swipeToSlide : true,
		arrows: true,
		responsive: [
			{
				breakpoint: 481,
				settings: {
					slidesToShow: 2
				}
			}
		]
	});

	/* Зум картинок в карточке */
	$(".fn-zoom.okaycms").fancybox({
		prevEffect: 'fade',
		nextEffect: 'fade',
		loop: false
	});

	/* Инициализация карусели */
	$(".fn-slick-carousel.okaycms").slick({
		infinite: true,
		speed: 500,
		slidesToShow: 6,
		slidesToScroll: 1,
        swipeToSlide : true,
		arrows: true,
		responsive: [
			{
				breakpoint: 992,
				settings: {
					slidesToShow: 3
				}
			}
		]
	});

	/* Аяксовый фильтр по цене */
	if( $( '#fn-slider-price.okaycms' ).size() ) {
		var slider_all = $( '#fn-slider-min, #fn-slider-max' ),
			slider_min = $( '#fn-slider-min' ),
			slider_max = $( '#fn-slider-max' ),
			current_min = slider_min.val(),
			current_max = slider_max.val(),
			range_min = slider_min.data( 'price' ),
			range_max = slider_max.data( 'price' ),
			link = window.location.href.replace( /\/page-(\d{1,5})/, '' ),
			ajax_slider = function() {
				$.ajax( {
					url: link,
					data: {
						ajax: 1,
						'p[min]': slider_min.val(),
						'p[max]': slider_max.val()
					},
					dataType: 'json',
					success: function(data) {
						$( '#fn-products_content' ).html( data.products_content );
						$( '.shpu_pagination' ).html( data.products_pagination );
						$('#fn-products_sort').html(data.products_sort);
                        $('.ajax_wait').remove();
					}
				} )
			};
		link = link.replace(/\/sort-([a-zA-Z_]+)/, '');

		$( '#fn-slider-price.okaycms' ).slider( {
			range: true,
			min: range_min,
			max: range_max,
			values: [current_min, current_max],
			slide: function(event, ui) {
				slider_min.val( ui.values[0] );
				slider_max.val( ui.values[1] );
			},
			stop: function(event, ui) {
				slider_min.val( ui.values[0] );
				slider_max.val( ui.values[1] );
                $('.col-lg-9').append('<div class="ajax_wait"></div>');
				ajax_slider();
			}
		} );

		slider_all.on( 'change', function() {
			$( "#fn-slider-price.okaycms" ).slider( 'option', 'values', [slider_min.val(), slider_max.val()] );
			ajax_slider();
		} );

		// Если после фильтрации у нас осталось товаров на несколько страниц, то постраничную навигацию мы тоже проведем с помощью ajax чтоб не сбить фильтр по цене
		$( document ).on( 'click', '.shpu_pagination .is_ajax a,#fn-products_sort .is_ajax a', function(e) {
			e.preventDefault();
            $('.col-lg-9').append('<div class="ajax_wait"></div>');
			var link = $(this).attr( 'href' ),
				send_min = $("#fn-slider-min").val();
				send_max = $("#fn-slider-max").val();
			$.ajax( {
				url: link,
				data: { ajax: 1, 'p[min]': send_min, 'p[max]': send_max },
				dataType: 'json',
				success: function(data) {
					$( '#fn-products_content' ).html( data.products_content );
					$( '.shpu_pagination' ).html( data.products_pagination );
					$('#fn-products_sort').html(data.products_sort);
                    $('.ajax_wait').remove();
				}
			} );
		} );
	}

	/* Автозаполнитель поиска */
	$( ".fn-search.okaycms" ).autocomplete( {
		serviceUrl: 'ajax/search_products.php',
		minChars: 1,
		noCache: false,
		onSelect: function(suggestion) {
			$( "#fn-search" ).submit();
		},
		formatResult: function(suggestion, currentValue) {
			var reEscape = new RegExp( '(\\' + ['/', '.', '*', '+', '?', '|', '(', ')', '[', ']', '{', '}', '\\'].join( '|\\' ) + ')', 'g' );
			var pattern = '(' + currentValue.replace( reEscape, '\\$1' ) + ')';
			return "<div>" + (suggestion.data.image ? "<img align=absmiddle src='" + suggestion.data.image + "'> " : '') + "<a href=" + suggestion.lang + "products/" + suggestion.data.url + '>' + suggestion.value.replace( new RegExp( pattern, 'gi' ), '<strong>$1<\/strong>' ) + '<\/a>' + "</div>" + "<span>" + suggestion.price + "</span>";
		}
	} );

	/* Слайдер в сравнении */
	if( $( '.fn-comparison_products.okaycms' ).size() ) {
		var productsCount = parseInt( $( '.fn-comparison_products' ).data( 'products' ) );
		if( $( '.fn-comparison_products > .col-lg-4' ).size() > productsCount ) {
			$( '.fn-comparison_products' ).slick( {
				infinite: false,
				speed: 500,
				slidesToShow: productsCount,
				slidesToScroll: 1,
				arrows: true
			} );
		}
		resize_comparison();
		$( '.fancy_zoom' ).fancybox();
	}

	/* Показать / скрыть одинаковые характеристики в сравнении */
	$( document ).on( 'click', '.fn-show.okaycms a', function(e) {
		e.preventDefault();
		$( '.fn-show.okaycms a.active' ).removeClass( 'active' );
		$( this ).addClass( 'active' );
		if( $( this ).hasClass( 'unique' ) ) {
			$( '.cell.not_unique' ).hide();
		} else {
			$( '.cell.not_unique' ).show();
		}
	} );

	/* Если мы в подкатегории разворачивать категории родителей */
	if( $( '.fn-collapsed' ).size() ) {
		$( '.fn-collapsed' ).parent( '.nav-item' ).parents( '.nav-item' ).children( '.btn-catalog-collapse' ).removeClass('collapsed');
		$( '.fn-collapsed' ).parent( '.nav-item' ).parents( '.nav-item' ).children( '.collapse' ).addClass('in');
	}

	/* Рейтинг товара */
	$('.product_rating').rater({ postHref: 'ajax/rating.php' });

	/* Переключатель способа оплаты */
	$( document ).on( 'click', '[name="payment_method_id"]', function() {
		$( '[name="payment_method_id"]' ).parent().removeClass( 'active' );
		$( this ).parent().addClass( 'active' );
	} )
});

/* Обновление блоков: cart_informer, cart_purchases, cart_deliveries */
function ajax_set_result(data) {
	$( '#cart_informer' ).html( data.cart_informer );
	$( '#fn-purchases' ).html( data.cart_purchases );
	$( '#fn-ajax_deliveries' ).html( data.cart_deliveries );
}

/* Аяксовое изменение кол-ва товаров в корзине */
function ajax_change_amount(object, variant_id) {
	var amount = $( object ).val(),
		coupon_code = $( 'input[name="coupon_code"]' ).val(),
		delivery_id = $( 'input[name="delivery_id"]:checked' ).val(),
		payment_id = $( 'input[name="payment_method_id"]:checked' ).val();
	/* ajax запрос */
	$.ajax( {
		url: 'ajax/cart_ajax.php',
		data: {
			coupon_code: coupon_code,
			action: 'update_citem',
			variant_id: variant_id,
			amount: amount
		},
		dataType: 'json',
		success: function(data) {
			if( data.result == 1 ) {
				ajax_set_result( data );
				$( '#deliveries_' + delivery_id ).trigger( 'click' );
				$( '#payment_' + delivery_id + '_' + payment_id ).trigger( 'click' );
			} else {
				$( '#cart_informer' ).html( data.cart_informer );
				$( '#fn-content' ).html( data.content );
			}
		}
	} );
}

/* Функция изменения количества товаров */
function amount_change(input, action) {
	var max_val,
		curr_val = parseFloat( input.val() ),
		step = 1,
		id = input.data('id');
        if(isNaN(curr_val)){
            curr_val = okay.amount;
        }

	/* Если включен предзаказ макс. кол-во товаров ставим 50 */
	if ( input.parent().hasClass('fn-is_preorder')) {
		max_val = 50;
	} else {
		max_val = parseFloat( input.data( 'max' ) )
	}
	/* Изменение кол-ва товара */
	if( action == 'plus' ) {
		input.val( Math.min( max_val, Math.max( 1, curr_val + step ) ) );
		input.trigger('change');
	} else if( action == 'minus' ) {
		input.val( Math.min( max_val, Math.max( 1, (curr_val - step) ) ) );
		input.trigger('change');
	} else if( action == 'keyup' ) {
		input.val( Math.min( max_val, Math.max( 1, curr_val ) ) );
		input.trigger('change');
	}
	okay.amount = parseInt( input.val() );
	/* в корзине */
	if( $('div').is('#fn-purchases') && ( (max_val != curr_val && action == 'plus' ) || ( curr_val != 1 && action == 'minus' ) ) ) {
        ajax_change_amount( input, id );
	}
}

/* Функция анимации добавления товара в корзину */
function transfer(informer, thisEl) {
	var o1 = thisEl.offset(),
		o2 = informer.offset(),
		dx = o1.left - o2.left,
		dy = o1.top - o2.top,
		distance = Math.sqrt(dx * dx + dy * dy);

	thisEl.closest( '.fn-transfer' ).find( '.fn-img' ).effect( "transfer", {
		to: informer,
		className: "transfer_class"
	}, distance );

	var container = $( '.transfer_class' );
	container.html( thisEl.closest( '.fn-transfer' ).find( '.fn-img' ).parent().html() );
	container.find( '*' ).css( 'display', 'none' );
	container.find( '.fn-img' ).css( {
		'display': 'block',
		'height': '100%',
		'z-index': '2',
		'position': 'relative'
	} );
}

/* Аяксовый купон */
function ajax_coupon() {
	var coupon_code = $('input[name="coupon_code"]').val(),
		delivery_id = $('input[name="delivery_id"]:checked').val(),
		payment_id = $('input[name="payment_method_id"]:checked').val();
	/* ajax запрос */
	$.ajax( {
		url: 'ajax/cart_ajax.php',
		data: {
			coupon_code: coupon_code,
			action: 'coupon_apply'
		},
		dataType: 'json',
		success: function(data) {
			if( data.result == 1 ) {
				ajax_set_result( data );
				$( '#deliveries_' + delivery_id ).trigger( 'click' );
				$( '#payment_' + delivery_id + '_' + payment_id ).trigger( 'click' );
			} else {
				$( '#cart_informer' ).html( data.cart_informer );
				$( '#fn-content' ).html( data.content );
			}
		}
	} );
}

/* Изменение способа доставки */
function change_payment_method($id) {
	$( "#fn-delivery_payment_" + $id + " [name='payment_method_id']" ).first().trigger('click');
	$( ".fn-delivery_payment" ).hide();
	$( "#fn-delivery_payment_" + $id ).show();
	$( 'input[name="delivery_id"]' ).parent().removeClass( 'active' );
	$( '#deliveries_' + $id ).parent().addClass( 'active' );
}

/* Аяксовое удаление товаров в корзине */
function ajax_remove(variant_id) {
	var coupon_code = $('input[name="coupon_code"]').val(),
		delivery_id = $('input[name="delivery_id"]:checked').val(),
		payment_id = $('input[name="payment_method_id"]:checked').val();
	/* ajax запрос */
	$.ajax( {
		url: 'ajax/cart_ajax.php',
		data: {
			coupon_code: coupon_code,
			action: 'remove_citem',
			variant_id: variant_id
		},
		dataType: 'json',
		success: function(data) {
			if( data.result == 1 ) {
				ajax_set_result( data );
				$( '#deliveries_' + delivery_id ).trigger( 'click' );
				$( '#payment_' + delivery_id + '_' + payment_id ).trigger( 'click' );
			} else {
				$( '#cart_informer' ).html( data.cart_informer );
				$( '#fn-content' ).html( data.content );
			}
		}
	} );
}

/* Формирование ровных строчек для характеристик */
function resize_comparison() {
	var minHeightHead = 0;
	$('.fn-resize' ).each(function(){
		if( $(this ).height() > minHeightHead ) {
			minHeightHead = $(this ).height();
		}
	});
	$('.fn-resize' ).height(minHeightHead);
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
			}
		});
	}
}

/* В сравнении выравниваем строки */
$( window ).load( resize_comparison );

/* Звёздный рейтинг товаров */
$.fn.rater = function (options) {
	var opts = $.extend({}, $.fn.rater.defaults, options);
	return this.each(function () {
		var $this = $(this);
		var $on = $this.find('.rating_starOn');
		var $off = $this.find('.rating_starOff');
		opts.size = $on.height();
		if (opts.rating == undefined) opts.rating = $on.width() / opts.size;

		$off.mousemove(function (e) {
			var left = e.clientX - $off.offset().left;
			var width = $off.width() - ($off.width() - left);
			width = Math.ceil(width / (opts.size / opts.step)) * opts.size / opts.step;
			$on.width(width);
		}).hover(function (e) { $on.addClass('rating_starHover'); }, function (e) {
			$on.removeClass('rating_starHover'); $on.width(opts.rating * opts.size);
		}).click(function (e) {
			var r = Math.round($on.width() / $off.width() * (opts.units * opts.step)) / opts.step;
			$off.unbind('click').unbind('mousemove').unbind('mouseenter').unbind('mouseleave');
			$off.css('cursor', 'default'); $on.css('cursor', 'default');
			opts.id = $this.attr('id');
			$.fn.rater.rate($this, opts, r);
		}).css('cursor', 'pointer'); $on.css('cursor', 'pointer');
	});
};

$.fn.rater.defaults = {
	postHref: location.href,
	units: 5,
	step: 1
};

$.fn.rater.rate = function ($this, opts, rating) {
	var $on = $this.find('.rating_starOn');
	var $off = $this.find('.rating_starOff');
	$off.fadeTo(600, 0.4, function () {
		$.ajax({
			url: opts.postHref,
			type: "POST",
			data: 'id=' + opts.id + '&rating=' + rating,
			complete: function (req) {
				if (req.status == 200) { /* success */
					opts.rating = parseFloat(req.responseText);

					if (opts.rating > 0) {
						opts.rating = parseFloat(req.responseText);
						$off.fadeTo(200, 0.1, function () {
							$on.removeClass('rating_starHover').width(opts.rating * opts.size);
							var $count = $this.find('.rating_count');
							$count.text(parseInt($count.text()) + 1);
							$this.find('.rating_value').text(opts.rating.toFixed(1));
							$off.fadeTo(200, 1);
						});
					}
					else
					if (opts.rating == -1) {
						$off.fadeTo(200, 0.6, function () {
							$this.find('.rating_text').text('Ошибка');
						});
					}
					else {
						$off.fadeTo(200, 0.6, function () {
							$this.find('.rating_text').text('Вы уже голосовали!');
						});
					}
				} else { /* failure */
					alert(req.responseText);
					$on.removeClass('rating_starHover').width(opts.rating * opts.size);
					$this.rater(opts);
					$off.fadeTo(2200, 1);
				}
			}
		});
	});
};
$('.card .fn-variant').focus(function() {
    $(this).parents('.card').addClass('hover');
    $('.card .fn-variant').one('change', function() {
        $(this).parents('.card').removeClass('hover');
        $(this).blur();
    });
});
$('.card .fn-variant').blur(function() {
    $(this).parents('.card').removeClass('hover');
});