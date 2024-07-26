<script type="text/javascript">
	
	$(document).ready(function () {
		$('#global').backstretch(["../img/global/bg_content.jpg"]);
		$(".gallery a[rel^='prettyPhoto']").prettyPhoto({animation_speed:'normal',theme:'facebook',slideshow:3000, autoplay_slideshow: false});
		$('.infinite_carousel').infiniteCarousel();
	});
	
	// FONT SIZE
	var size = 14;
	function chanegeFontsize(type){
		if (type=="more") {
			if(size<20) size+=1;
		} else {
			if(size>12) size-=1;
		}
		//document.getElementById('txt_body').style.fontSize = size+'px';
		//$('#description').css('font-size') = size+'px';
		$('.description').css('font-size', size+'px');
	}
</script>