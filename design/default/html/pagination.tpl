{* Постраничная пагинация *}
{if $total_pages_num > 1}
	<ul class="pagination{if $ajax} is_ajax{/if}">
		{* Количество выводимых ссылок на страницы *}
		{$visible_pages = 5}
		{* По умолчанию начинаем вывод со страницы 1 *}
		{$page_from = 1}
		{* Если выбранная пользователем страница дальше середины "окна" - начинаем вывод уже не с первой *}
		{if $current_page_num > floor($visible_pages/2)}
			{$page_from = max(1, $current_page_num-floor($visible_pages/2)-1)}
		{/if}
		{* Если выбранная пользователем страница близка к концу навигации - начинаем с "конца-окно" *}
		{if $current_page_num > $total_pages_num-ceil($visible_pages/2)}
			{$page_from = max(1, $total_pages_num-$visible_pages-1)}
		{/if}
		{* До какой страницы выводить - выводим всё окно, но не более общего количества страниц *}
		{$page_to = min($page_from+$visible_pages, $total_pages_num-1)}
		{* Ссылка на предыдущую страницу *}
		{if $current_page_num > 1}
			<li class="page-item">
				<a class="page-link" href="{if $current_page_num == 2}{url page=null}{else}{url page=$current_page_num - 1}{/if}" aria-label="{$lang->pagination_prev}">
					<span aria-hidden="true">&laquo;</span>
					<span>{$lang->pagination_prev}</span>
				</a>
			</li>
		{else}
			<li class="page-item disabled">
				<span class="page-link" aria-label="{$lang->pagination_prev}">
					<span aria-hidden="true">&laquo;</span>
					<span>{$lang->pagination_prev}</span>
				</span>
			</li>
		{/if}
		{* @ Ссылка на предыдущую страницу *}
		{* Ссылка на 1 страницу *}
		{if $current_page_num == 1}
			<li class="page-item active">
				<span class="page-link">1</span>
			</li>
		{else}
			<li class="page-item">
				<a class="page-link" href="{url page=null}">1</a>
			</li>
		{/if}
		{* @END Ссылка на 1 страницу *}
		{* Страницы пагинации *}
		{section name=pages loop=$page_to start=$page_from}
			{* Номер текущей выводимой страницы *}
			{$p = $smarty.section.pages.index+1}
			{* Для крайних страниц "окна" выводим троеточие, если окно не возле границы навигации *}
			{if ($p == $page_from+1 && $p!=2) || ($p == $page_to && $p != $total_pages_num-1)}
				<li class="page-item">
					<a class="page-link" href="{url page=$p}">...</a>
				</li>
			{elseif $p==$current_page_num}
				<li class="page-item{if $p==$current_page_num} active{/if}">
					<span class="page-link">{$p}</span>
				</li>
			{else}
				<li class="page-item">
					<a class="page-link" href="{url page=$p}">{$p}</a>
				</li>
			{/if}
		{/section}
		{* @END Страницы пагинации *}
		{* Ссылка на последнююю страницу *}
		{if $current_page_num==$total_pages_num}
			<li class="page-item active">
				<span class="page-link">{$total_pages_num}</span>
			</li>
		{else}
			<li class="page-item">
				<a class="page-link" href="{url page=$total_pages_num}">{$total_pages_num}</a>
			</li>
		{/if}
		{* Ссылка на последнююю страницу *}
		{* Ссылка на все страницы *}
		<li class="page-item">
			<a class="page-link" href="{url page=all}" data-language="{$translate_id['pagination_all']}">{$lang->pagination_all}</a>
		</li>
		{* @END Ссылка на все страницы *}
		{* Ссылка на следующую страницу *}
		{if $current_page_num<$total_pages_num}
			<li class="page-item">
				<a class="page-link" href="{url page=$current_page_num+1}" aria-label="{$lang->pagination_next}">
					<span aria-hidden="true">&raquo;</span>
					<span>{$lang->pagination_next}</span>
				</a>
			</li>
		{else}
			<li class="page-item disabled">
				<span class="page-link" aria-label="{$lang->pagination_next}">
					<span aria-hidden="true">&raquo;</span>
					<span>{$lang->pagination_next}</span>
				</span>
			</li>
		{/if}
		{* @END Ссылка на следующую страницу *}
	</ul>
{/if}