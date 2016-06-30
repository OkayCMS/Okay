{* Левый сайдбар с фильтром, категориями и брендами *}
{* Вывод дерева категорий *}
{function name=catalog_tree}
	{if $categories}
		{* Первая итерация *}
		{if $level == 1}
			{* Заголовок блока *}
			<div class="h5 bg-info p-x-1 p-y-05">
				<span data-language="{$translate_id['features_categories']}">{$lang->features_categories}</span>
			</div>
			<div class="nav-catalog p-x-05 m-b-2">
		{* Последующие итерации *}
		{else}
			<div id="cat_{$parent_id}" class="collapse{if $collapse_trigger == true} in{/if}">
		{/if}
		{foreach $categories as $c}
			{if $c->visible}
				{* Если есть подкатегории *}
				{if $c->subcategories && $c->has_children_visible}
					<div class="nav-item">
						{* Кнопка раскрывающая категорию *}
						<button class="btn-catalog-collapse {if $category->id != $c->id} collapsed{/if}" type="button" data-toggle="collapse" data-target="#cat_{$c->id}" aria-expanded="{if $category->id != $c->id}true{else}false{/if}" aria-controls="cat_{$c->id}"></button>

						{* Название категории *}
						<a class="nav-link{if $category->id == $c->id} link-red fn-collapsed{/if}" href="{$lang_link}catalog/{$c->url}" data-category="{$c->id}">{$c->name|escape}</a>

						{* Если подкатегорий больше одной, для деления блока на 2 колонки *}
						{if $category->id == $c->id}
							{assign var='collapse' value=true}
						{else}
							{assign var='collapse' value=false}
						{/if}
						{if $c->subcategories|count > 1}
							{catalog_tree categories=$c->subcategories level=$level + 1 parent_id=$c->id two_col=true collapse_trigger=$collapse}
						{else}
							{catalog_tree categories=$c->subcategories level=$level + 1 parent_id=$c->id collapse_trigger=$collapse}
						{/if}
					</div>
				{* Если категория без подкатегорий *}
				{else}
					{* Название категории *}
					<div class="nav-item">
						<a class="nav-link{if $category->id == $c->id} link-red fn-collapsed{/if}" href="{$lang_link}catalog/{$c->url}" data-category="{$c->id}">{$c->name|escape}</a>
					</div>
				{/if}
			{/if}
		{/foreach}
		{* Первая итерация *}
		{if $level == 1}
			</div>
		{* Последующие итерации *}
		{else}
			</div>
		{/if}
	{/if}
{/function}
{catalog_tree categories=$categories level=1}

{* Аяксовый фильт по цене *}
{if $prices && $products|count > 0}
	{* Заголовок блока *}
	<div class="h5 bg-info p-x-1 p-y-05">
		<span data-language="{$translate_id['features_price']}">{$lang->features_price}</span>
	</div>
	<div class="m-b-2">
		<div class="row m-y-1 p-x-05">
			{* Минимальная цена товаров *}
			<div class="col-xs-6">
				<input id="fn-slider-min" name="p[min]" value="{($prices->current->min|default:$prices->range->min)|escape}" data-price="{$prices->range->min}" type="text" class="form-control">
			</div>

			{* Максимальная цена товаров *}
			<div class="col-xs-6">
				<input id="fn-slider-max" name="p[max]" value="{($prices->current->max|default:$prices->range->max)|escape}" data-price="{$prices->range->max}" type="text" class="form-control">
			</div>
		</div>
		{* Слайдер цен *}
		<div id="fn-slider-price" class="okaycms"></div>
	</div>
{/if}

{* Фильтр по брендам *}
{if $category->brands}
    {* Заголовок блока *}
    <div class="h5 bg-info p-x-1 p-y-05">
        <span data-language="{$translate_id['features_manufacturer']}">{$lang->features_manufacturer}</span>
    </div>
    <div class="m-b-2 p-x-05">
        {* Сброс всех брендов *}
        <div>
            <label class="c-input c-checkbox">
                <input onchange="window.location.href='{furl params=[brand=>null, page=>null]}'" type="checkbox"{if !$brand->id && !$smarty.get.b} checked{/if}/>
                <span class="c-indicator"></span>
                <span data-language="{$translate_id['features_all']}">{$lang->features_all}</span>
            </label>
        </div>
        {* Список брендов *}
        {foreach $category->brands as $b}
            <div>
                <label class="c-input c-checkbox" data-brand="{$b->id}">
                    <input onchange="window.location.href='{furl params=[brand=>$b->url, page=>null]}'" type="checkbox"{if $brand->id == $b->id || $smarty.get.b && in_array($b->id,$smarty.get.b)} checked{/if}/>
                    <span class="c-indicator"></span>
                    {$b->name|escape}
                </label>
            </div>
        {/foreach}
    </div>
{/if}
{* Фильтр по свойствам *}
{if $features}
    {foreach $features as $key=>$f}
	    {* Название свойства *}
	    <div class="h5 bg-info p-x-1 p-y-05" data-feature="{$f->id}">{$f->name}</div>
        <div class="m-b-2 p-x-05">
	        {* Сброс всех свойств *}
	        <div>
		        <label class="c-input c-checkbox">
			        <input onchange="window.location.href='{furl params=[$f->url=>null, page=>null]}'" type="checkbox"{if !$smarty.get.$key} checked{/if}/>
			        <span class="c-indicator"></span>
			        <span data-language="{$translate_id['features_all']}">{$lang->features_all}</span>
		        </label>
	        </div>
	        {* Значения свойств *}
            {foreach $f->options as $o}
	            <div>
		            <label class="c-input c-checkbox">
			            <input onchange="window.location.href='{furl params=[$f->url=>$o->translit, page=>null]}'" type="checkbox"{if $smarty.get.{$f@key} && in_array($o->translit,$smarty.get.{$f@key})} checked{/if}/>
			            <span class="c-indicator"></span>
			            {$o->value|escape}
		            </label>
	            </div>
            {/foreach}
        </div>
    {/foreach}
{/if}
{* @END Фильтр по свойствам *}
{* Просмотренные товары *}
{get_browsed_products var=browsed_products limit=20}
{if $browsed_products}
	<div class="h5 bg-info p-x-1 p-y-05 hidden-md-down">{$lang->features_browsed}</div>
	<div class="m-b-2 clearfix hidden-md-down">
		{foreach $browsed_products as $browsed_product}
			<div class="browsed-item">
				<a href="{$lang_link}products/{$browsed_product->url}">
					{if $browsed_product->image->filename}
						<img src="{$browsed_product->image->filename|resize:50:50}" alt="{$browsed_product->name|escape}" title="{$browsed_product->name|escape}">
					{else}
						<img width="50" height="50" src="design/{$settings->theme}/images/no_image.png" alt="{$browsed_product->name|escape}" title="{$browsed_product->name|escape}"/>
					{/if}
				</a>
			</div>
		{/foreach}
	</div>
{/if}