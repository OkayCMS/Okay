<table id="diagram">
    <tr>
        <td>Динамика</td>
        <td class="query_position">Средняя</td>
        <td class="query_position">1-10</td>
        <td class="query_position">11-30</td>
        <td class="query_position">31-50</td>
        <td class="query_position">51-100</td>
        <td class="query_position">100+</td>
    </tr>
    {if $qd_summary > 0}
    <tr class="diagram_row">
        <td>
            <div><i class="d_up"></i>({$qd_summary->up_position})
                <div class="help_visor">
                    <div class="visor_inner">
                        <span>Количество запросов, улучшивших свои позиции в выдаче</span>
                    </div>
                </div>
            </div>
            <div><i class="d_equal"></i>({$qd_summary->stay_position})
                <div class="help_visor">
                    <div class="visor_inner">
                        <span>Количество запросов, не изменивших свои позиции в выдаче</span>
                    </div>
                </div>
            </div>
            <div><i class="d_down"></i>({$qd_summary->down_position})
                <div class="help_visor">
                    <div class="visor_inner">
                        <span>Количество запросов, ухудшивших свои позиции в выдаче</span>
                    </div>
                </div>
            </div>
        </td>
        <td class="query_position"><div>{$qd_summary->avg}{if $qd_summary->up_avg != 0}{if $qd_summary->up_avg > 0}<i class="d_down"></i>{else}<i class="d_up"></i>{/if}<span class="topvisor_abs">{abs($qd_summary->up_avg)}</span>{/if}</div></td>
        <td class="query_position"><div>{$qd_summary->count10}{if $qd_summary->up10 != 0}{if $qd_summary->up10 > 0}<i class="d_up"></i>{else}<i class="d_down"></i>{/if}<span class="topvisor_abs">{abs($qd_summary->up10)}</span>{/if}</div></td>
        <td class="query_position"><div>{$qd_summary->count30}{if $qd_summary->up30 != 0}{if $qd_summary->up30 > 0}<i class="d_up"></i>{else}<i class="d_down"></i>{/if}<span class="topvisor_abs">{abs($qd_summary->up30)}</span>{/if}</div></td>
        <td class="query_position"><div>{$qd_summary->count50}{if $qd_summary->up50 != 0}{if $qd_summary->up50 > 0}<i class="d_up"></i>{else}<i class="d_down"></i>{/if}<span class="topvisor_abs">{abs($qd_summary->up50)}</span>{/if}</div></td>
        <td class="query_position"><div>{$qd_summary->count100}{if $qd_summary->up100 != 0}{if $qd_summary->up100 > 0}<i class="d_up"></i>{else}<i class="d_down"></i>{/if}<span class="topvisor_abs">{abs($qd_summary->up100)}</span>{/if}</div></td>
        <td class="query_position"><div>{$qd_summary->count10000}{if $qd_summary->up10000 != 0}{if $qd_summary->up10000 > 0}<i class="d_up"></i>{else}<i class="d_down"></i>{/if}<span class="topvisor_abs">{abs($qd_summary->up10000)}</span>{/if}</div></td>
    </tr>
    {/if}
</table>



<div class="row head_row clearfix">
    <div class="col col_1"></div>
    <div class="col col_2">Запросы({$queries_dynamics->total})</div>
    <div class="col col_3 slider slider1">
        <div class="query_frequency">Частота</div>
        <div class="query_frequency">"Частота"</div>
        <div class="query_frequency">"!Частота"</div>
    </div>
    <div class="col col_4 slider slider3">
        {foreach $queries_dynamics->scheme->dates as $item}
            <div class="query_position">{$item->date|date} ({$item->top_percent|escape}%)</div>
        {/foreach}
    </div>
    <div class="col col_5"></div>
</div>

{assign var="pos" value=" "}
{if $queries_dynamics->total > 0}
    {foreach $queries_dynamics->phrases as $q}
        <div class="row dyn_row clearfix">
            <div class="col col_1">
                <a href="javascript:;" class="delete_query" data-id="{$q->id}"></a>
            </div>
            <div class="col col_2">
                <p>{$q->phrase|escape}</p>
            </div>
            <div class="col col_3 slider slider2">
                <div class="query_frequency">{$q->frequency1|escape}</div>
                <div class="query_frequency">{$q->frequency2|escape}</div>
                <div class="query_frequency">{$q->frequency3|escape}</div>
            </div>
            
            <div class="col col_4 slider slider4">
                {foreach $q->dates as $item}
                    {$pos = $pos|cat:$item->position|cat:','}
                    <div class="query_position">{$item->position|escape}</div>
                {/foreach}
            </div>
            <div class="col col_5">
                <a href="javascript:;" class="graph_create" data-name="{$q->phrase|escape}" data-pos="{$pos}"></a>
            </div> 
        </div>
        {$pos = ''}
    {/foreach}

    <div class="row">
        {section name=pages loop=ceil($queries_dynamics->total/100)+1 start=1}
            <a href="javascript:;" class="topvisor_pagination ajax_freeze" data-page="{$smarty.section.pages.index}">{$smarty.section.pages.index}</a>
        {/section}
    </div>
{/if}



<script>
$(function(){
 
    $('.slider1').slick({
        infinite: false,
        slidesToShow: 1,
        slidesToScroll: 1,
        asNavFor: '.slider2'
    });

    $('.slider2').slick({
        infinite: false,
        slidesToShow: 1,
        slidesToScroll: 1,
        arrows:false
    });

    $('.slider3').slick({
        infinite: false,
        speed: 500,
        slidesToShow: 4,
        slidesToScroll: 1,
        asNavFor: '.slider4',
    });

    $('.slider4').slick({
        infinite: false,
        speed: 500,
        slidesToShow: 4,
        slidesToScroll: 1,
        arrows:false
    }); 

     $('.col').matchHeight();
});
</script>

