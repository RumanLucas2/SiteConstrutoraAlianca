$(function() {

	/*var mainColor = "#F00";
	
	var myElement = document.getElementById("content");
	myElement.style.color = "green";
	*/

	$('.form_textarea').autoResize();	
	
	
	// GALLERY

	$('div.content_gallery_thumb a.content_gallery_link').hover(function() 
	{
		var position = $(this).parent().find('.content_gallery_thumb_icon a.bt_edit').position();
		$('.content_gallery_thumb_icon a').stop(false,true).animate({ right : -135 }, 500, 'easeOutExpo');		
		
		if(position.left > 160)
		{
			$(this).parent().find('.content_gallery_thumb_icon a.bt_edit').stop(false,true).animate({ right : 0 }, 500, 'easeOutExpo');
			$(this).parent().find('.content_gallery_thumb_icon a.bt_delete').stop(false,true).animate({ right : 0 }, 800, 'easeOutExpo');
		}
	},
	function() 
	{
	});
		
});

jQuery(document).ready(function($)
{
	$(document).pngFix();
});