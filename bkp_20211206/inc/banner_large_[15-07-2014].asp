<script type="text/javascript">

	$(document).ready(function(){
			bannerResizable();	
	});
		
	window.onresize = function(){
		bannerResizable();
	}
		
	function bannerResizable(){
		var bannerWidth = $(window).width();
		if (bannerWidth <= 1920){
			var val_left = (1920 - bannerWidth) / 2;
			document.getElementById('mybanner').style.marginLeft = '-' + val_left + 'px';
		}
	}
	
	jQuery(function() {

		jQuery('#allinone_bannerRotator_classic').allinone_bannerRotator({
			skin: 'classic', // tipo de visual
			width: 1920, // largura
			height: 440, // altura
			width100Proc:false, // forçar 100% de largura
			height100Proc:false,
			autoPlay:5, // tocar automatico
			defaultEffect:'topBottomDroppingStripes', // efeito padrão
			responsive:false, // leitura automatica da largura browser
			thumbsWrapperMarginBottom:10, // distancia dos thumbs
			showPreviewThumbs:true, // mostra thumbs ao passar o mouse
			showBottomNav:true,
			autoHideNavArrows:false,
			showNavArrows:false,
			showCircleTimer:false,
			origWidth:0,
			origHeight:0,
			autoHideBottomNav:false,
			enableTouchScreen:false
			/*
			skin:'classic'
			width:1920
			height:600
			width100Proc:true,
			height100Proc:true
			randomizeImages:true
			firstImg:0
			numberOfStripes:20
			numberOfRows:5
			numberOfColumns:10
			defaultEffect:'random'
			effectDuration:0.5
			autoPlay:4 or false
			loop:true
			target:"_blank"
			showAllControllers:true
			showNavArrows:true
			showOnInitNavArrows:true
			autoHideNavArrows:true
			showBottomNav:true
			showOnInitBottomNav:true
			autoHideBottomNav:true
			showPreviewThumbs:true
			enableTouchScreen:true
			absUrl:""
			showCircleTimer:true
			showCircleTimerIE8IE7:true
			circleRadius:10
			circleLineWidth:4
			circleColor:"#FF0000"
			circleAlpha:100
			behindCircleColor:"#000000"
			behindCircleAlpha:50
			responsive:true
			responsiveRelativeToBrowser:true
			origWidth:0
			origHeight:0
			thumbsWrapperMarginBottom:0
			windowOrientationScreenSize0:0
			windowOrientationScreenSize90:0
			windowOrientationScreenSize_90:0
			windowCurOrientation:0
			*/
		});		
	});
</script>

<!-- banners -->
<div id="banner">
    <div id="mybanner">    
        <div id="allinone_bannerRotator_classic" style="display:none;" class="mybanner">
            <ul class="allinone_bannerRotator_list">
            <li data-bottom-thumb="../_file/banner/palazzo_thumb.jpg" class="banner_images" data-link="http://www.construtoraalianca.com.br/_file/pop/anuncio.pdf" data-target="_self"><img src="../_file/banner/palazzo.jpg" /></li>
            <%
				sqlBanner = "SELECT id_banner, foto FROM tbl_banner WHERE status = 1 AND destaque = 1 ORDER BY data_cadastro DESC"
				set RsBanner = conexao.execute(sqlBanner)
				if RsBanner.EOF then
					Response.Write("Não há banners cadastrados")
				else
				do while not RsBanner.EOF
					
					idBanner = RsBanner("id_banner")
					fotoBanner = RsBanner("foto")
			%>
                <li data-bottom-thumb="../_file/banner/<%=idBanner%>/th/<%=fotoBanner%>" class="banner_images"><img src="../_file/banner/<%=idBanner%>/<%=fotoBanner%>" /></li>
            <%
				RsBanner.MoveNext
				loop
				end if
			%>
            </ul>
        </div>
    </div>
</div>