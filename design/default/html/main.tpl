{* Контент главной страницы *}
{* Канонический адрес страницы *}
{$canonical="" scope=parent}
{* @END Канонический адрес страницы *}
{* Рекомендуемые товары *}
{get_featured_products var=featured_products limit=4}
{if $featured_products}
	<div class="border-b-1-info p-y-1">
		<div class="container">
			{* Заголовок блока *}
			<div class="h1 m-b-1">
				<span data-language="{$translate_id['main_recommended_products']}">{$lang->main_recommended_products}</span>
			</div>
			{* @END Заголовок блока *}
			<div class="row">
				{foreach $featured_products as $product}
					<div class="col-md-4 col-lg-3">
						{include "tiny_products.tpl"}
					</div>
				{/foreach}
			</div>
		</div>
	</div>
{/if}
{* @END Рекомендуемые товары *}
{* Новинки *}
{get_new_products var=new_products limit=4}
{if $new_products}
	<div class="border-b-1-info p-y-1">
		<div class="container">
			{* Заголовок блока *}
			<div class="h1 m-b-1">
				<span data-language="{$translate_id['main_new_products']}">{$lang->main_new_products}</span>
			</div>
			{* @END Заголовок блока *}
			<div class="row">
				{foreach $new_products as $product}
					<div class="col-md-4 col-lg-3">
						{include "tiny_products.tpl"}
					</div>
				{/foreach}
			</div>
		</div>
	</div>
{/if}
{* @END Новинки *}
{* Акционные товары *}
{get_discounted_products var=discounted_products limit=4}
{if $discounted_products}
	<div class="border-b-1-info p-y-1">
		<div class="container">
			{* Заголовок блока *}
			<div class="h1 m-b-1">
				<span data-language="{$translate_id['main_action_goods']}">{$lang->main_action_goods}</span>
			</div>
			{* @END Заголовок блока *}
			<div class="row">
				{foreach $discounted_products as $product}
					<div class="col-md-4 col-lg-3">
						{include "tiny_products.tpl"}
					</div>
				{/foreach}
			</div>
		</div>
	</div>
{/if}
{* @END Акционные товары *}
{get_posts var=last_posts limit=3}
{if $page->body || $last_posts}
	<div class="bg-info border-b-1-info">
		<div class="container">
			<div class="row">
				{* Тело страницы *}
				{if $page->body}
					<div class="p-y-1 m-y-m1 m-y-0_md-down{if $last_posts} col-lg-6{else} col-lg-12{/if}">
						{* Заголовок блока *}
						<h1 class="h4 font-weight-bold">{$page->header}</h1>
						{* @END Заголовок блока *}
						{* Контент страницы *}
						{$page->body}
						{* @END Контент страницы *}
					</div>
				{/if}
				{* Тело страницы *}
				{* Список блога *}
				{if $last_posts}
					<div class="p-y-1 m-y-m1 m-y-0_md-down bg-white-md_down border-l-1-white-lg_up{if $page->body} col-lg-6{else} col-lg-12{/if}">
						<div class="h4 m-b-1 text-xs-center text-lg-left clearfix">
							{* Заголовок блока *}
							<span data-language="{$translate_id['main_news']}">{$lang->main_news}</span>
							{* @END Заголовок блока *}
							{* Ссылка на все посты *}
							<a class="h6 link-blue link-inverse pull-xs-right m-t-4px m-b-0 hidden-md-down" href="{$lang_link}blog" data-language="{$translate_id['main_all_news']}">{$lang->main_all_news}</a>
							{* @END Ссылка на все посты *}
						</div>
						<div class="row">
							{foreach $last_posts as $post}
								<div class="col-xs-12 col-md-3">
									<a class="blog-img" href="{$lang_link}blog/{$post->url}">
										{* Дата создания поста *}
										<div class="blog-data">{$post->date|date}</div>
										{* @END Дата создания поста *}
										{* Изображение поста *}
										{if $post->image}
											<img class="hidden-md-down" src="{$post->image|resize:162:77:false:$config->resized_blog_dir}" alt="{$post->name|escape}"/>
										{/if}
										{* @END Изображение поста *}
									</a>
								</div>
								<div class="col-xs-12 col-md-8 m-b-1-md_down">
									{* Название поста *}
									<div class="h5 font-weight-bold">
										<a class="link-black" href="{$lang_link}blog/{$post->url}" data-post="{$post->id}">{$post->name|escape}</a>
									</div>
									{* @END Название поста *}
									{* Краткое описание поста *}
									{if $post->annotation}
										<div class="blog-annotation">
											{$post->annotation}
											Lorem ipsum dolor sit amet, consectetur adipisicing elit. Aliquam assumenda beatae, corporis cum est et labore maxime modi molestiae nam necessitatibus perferendis perspiciatis quas quo quos repudiandae vero voluptatum. Dicta esse explicabo fugit, ipsa maxime perferendis quasi quidem voluptas voluptates?
										</div>
									{/if}
									{* @END Краткое описание поста *}
								</div>
							{/foreach}
						</div>
						{* Ссылка на все посты для моб. версии *}
						<div class="clearfix hidden-lg-up">
							<a class="h6 link-blue link-inverse pull-xs-right m-t-4px m-b-0" href="{$lang_link}blog">{$lang->main_all_news}</a>
						</div>
						{* @END Ссылка на все посты для моб. версии *}
					</div>
				{/if}
				{* @END Список блога *}
			</div>
		</div>
	</div>
{/if}
{* Список брендов *}
{get_brands var=all_brands}
{if $all_brands}
	<div class="container p-y-1">
		{* Заголовок блока *}
		<div class="h4 m-b-1">
			<span data-language="{$translate_id['main_brands']}">{$lang->main_brands}</span>
		</div>
		{* @END Заголовок блока *}
		<div class="fn-slick-carousel okaycms slick-carousel">
			{foreach $all_brands as $b}
				{* Если у бренда есть изображение *}
				{if $b->image}
					{* Изображение бренда *}
					<a href="{$lang_link}brands/{$b->url}" data-brand="{$b->id}">
						<img src="{$b->image|resize:183:183:false:$config->resized_brands_dir}" alt="{$b->name|escape}">
					</a>
					{* @END Изображение бренда *}
				{else}
					{* Название бренда *}
					<a href="{$lang_link}brands/{$b->url}" data-brand="{$b->id}">{$b->name}</a>
					{* @END Название бренда *}
				{/if}
			{/foreach}
		</div>
	</div>
{/if}
{* @END Список брендов *}