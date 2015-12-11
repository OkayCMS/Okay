$(function(){
    //если есть фильтр по цене, то есть смысл заморачиваться с аяксом
    if($('#slider-range').size()){
        //фильтр по цене
        var current_min = $('#p_min').val(),
            current_max = $('#p_max').val(),
            range_min   = $('#p_min').data('price'),
            range_max   = $('#p_max').data('price');
        $( "#slider-range" ).slider({
        	range: true,
        	min: range_min,
        	max: range_max,
        	values: [current_min, current_max],
        	slide: function( event, ui ) {
                //изменение видимых значений при движении ползунка
            	$('#selected_prices_min').html( ui.values[ 0 ] );
                $('#selected_prices_max').html( ui.values[ 1 ] );
            	$( "#p_min" ).val( ui.values[ 0 ] );
            	$( "#p_max" ).val( ui.values[ 1 ] );
        	},
            stop: function( event, ui ){
                //изменение видимых значений после остановки ползунка
                $('#selected_prices_min').html( ui.values[ 0 ] );
                $('#selected_prices_max').html( ui.values[ 1 ] );
                $( "#p_min" ).val( ui.values[ 0 ] );
            	$( "#p_max" ).val( ui.values[ 1 ] );
                //не учитываем постраничную навигацию даже страницу "Показать все" //число 5 взято с потолка - врядли у кого-то получится 99999 страниц с товарами 
                link = window.location.href.replace(/\/page-(\d{1,5}|all)/,'')
                //не учитываем только постраничную навигацию
                link = window.location.href.replace(/\/page-(\d{1,5})/,'')
                $.ajax({
                    url:link,
                    data: {ajax:1,'p[min]':$( "#p_min" ).val(),'p[max]':$( "#p_max" ).val()},
                    dataType:'json',
                    success: function(data){
                        $('#products_content').html(data.products_content);
                        $('.shpu_pagination').html(data.products_pagination);
                    }
                });
            }
    	});
        // Начальная установка всех видимых значений после инициализации слайдера
        $('#selected_prices_min').html($( "#slider-range" ).slider( "values", 0));
        $('#selected_prices_max').html($( "#slider-range" ).slider( "values", 1));
    	$( "#p_min" ).val($( "#slider-range" ).slider( "values", 0));
    	$( "#p_max" ).val($( "#slider-range" ).slider( "values", 1));
        // Если после фильтрации у нас осталось товаров на несколько страниц, то постраничную навигацию мы тоже проведем с помощью ajax чтоб не сбить фильтр по цене  
        $(document).on('click', '.shpu_pagination .is_ajax a', function(e){
            e.preventDefault();
            link = $(this).attr('href');
            send_min = send_max = null;
            if($( "#p_min" ).val() != range_min)
                send_min = $( "#p_min" ).val();
            if($( "#p_max" ).val() != range_min)
                send_max = $( "#p_max" ).val();
            $.ajax({
                url:link,
                data: {ajax:1,'p[min]':send_min,'p[max]':send_max},
                dataType:'json',
                success: function(data){
                    $('#products_content').html(data.products_content);
                    $('.shpu_pagination').html(data.products_pagination);
                }
            });
        });
    }
}); 