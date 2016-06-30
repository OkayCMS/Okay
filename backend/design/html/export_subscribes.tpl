{* Вкладки *}
{capture name=tabs}
    {if in_array('users', $manager->permissions)}
        <li>
            <a href="index.php?module=UsersAdmin">Пользователи</a>
        </li>
    {/if}
    {if in_array('groups', $manager->permissions)}
        <li>
            <a href="index.php?module=GroupsAdmin">Группы</a>
        </li>
    {/if}
    {if in_array('coupons', $manager->permissions)}
        <li>
            <a href="index.php?module=CouponsAdmin">Купоны</a>
        </li>
    {/if}
    <li class="active">
        <a href="index.php?module=SubscribeMailingAdmin">Подписчики</a>
    </li>

{/capture}
{$meta_title='Экспорт подписчиков' scope=parent}

<script src="{$config->root_url}/backend/design/js/piecon/piecon.js"></script>
<script>
var in_process=false;
var keyword='{$keyword|escape}';
var sort='{$sort|escape}';

{literal}	

$(function() {

	// On document load
	$('input#start').click(function() {
 
 		Piecon.setOptions({fallback: 'force'});
 		Piecon.setProgress(0);
    	$("#progressbar").progressbar({ value: 0 });
 		
    	$("#start").hide('fast');
		do_export();
    
	});
  
	function do_export(page)
	{
		page = typeof(page) != 'undefined' ? page : 1;

		$.ajax({
				url: "ajax/export_subscribes.php",
				data: {page:page, keyword:keyword, sort:sort},
				dataType: 'json',
				success: function(data){
				
				if(data && !data.end)
				{
    				Piecon.setProgress(Math.round(100*data.page/data.totalpages));
					$("#progressbar").progressbar({ value: 100*data.page/data.totalpages });
					do_export(data.page*1+1);
				}
				else
				{	
    				Piecon.setProgress(100);
					$("#progressbar").hide('fast');
					window.location.href = 'files/export_users/subscribes.csv';

				}
				},
				error:function(xhr, status, errorThrown) {	
				alert(errorThrown+'\n'+xhr.responseText);
			}  				
  				
		});
	
	}
});
{/literal}
</script>

<style>
	.ui-progressbar-value { background-image: url(design/images/progress.gif); background-position:left; border-color: #009ae2;}
	#progressbar{ clear: both; height:29px; }
	#result{ clear: both; width:100%;}
	#download{ display:none;  clear: both; }
</style>


{if $message_error}
    <!-- Системное сообщение -->
    <div class="message message_error">
        <span>
        {if $message_error == 'no_permission'}Установите права на запись в папку {$export_files_dir}
        {else}{$message_error}{/if}
        </span>
    </div>
    <!-- Системное сообщение (The End)-->
{/if}


<div>
	<h1>Экспорт подписчиков</h1>
	{if $message_error != 'no_permission'}
	    <div id='progressbar'></div>
	    <input class="button_green" id="start" type="button" name="" value="Экспортировать" />
	{/if}
</div>
 
