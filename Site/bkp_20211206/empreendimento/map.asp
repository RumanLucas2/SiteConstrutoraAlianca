<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #include file = "../inc/conexao.asp" -->
<%
	'Id do usuário retirado do Http
	id = Request.QueryString("id")
	'Se Id do usuário for vazia ou nulo ou não for numérico
	if id = "" Or IsNull(id) Or Not IsNumeric(id) Then
		id = 0	'Variável da Id do usuário recebe 0
	End if	'Finaliza Se Id do usuário for vazia ou nulo ou não for numérico
	
	sqlEmp = "SELECT nome, endereco, bairro, cidade, estado, geolocalizacao FROM tbl_empreendimento WHERE status = 1 AND id_empreendimento = " & id & ""
	set RsEmp = conexao.execute(sqlEmp)
	
	if not RsEmp.EOF then
		nameEmp = RsEmp("nome")
		addressEmp = RsEmp("endereco")
		neighEmp = RsEmp("bairro")
		cityEmp = RsEmp("cidade")
		stateEmp = RsEmp("estado")
		geoEmp = split(RsEmp("geolocalizacao"), ",")
		
		latitude = geoEmp(0)
		longitude = geoEmp(1)
		
	end if
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>Map</title>
    
	<style type="text/css">
	  html { height: 100% }
	  body { height: 100%; margin: 0px; padding: 0px }
	  #map { height: 100% }
	</style>
    
    <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false"></script>

	<script>
    
    var latitude = '<%=latitude%>';
    var longitude = '<%=longitude%>';
    
    var rendererOptions = {draggable: true};
    var directionsDisplay = new google.maps.DirectionsRenderer(rendererOptions);;
    var directionsService = new google.maps.DirectionsService();
    
    var map;
    var marker;
    var mypoint = new google.maps.LatLng(latitude, longitude);
    
    function initialize() {
        
        var mapOptions = {
          zoom: 14,
          mapTypeId: google.maps.MapTypeId.ROADMAP,
          center: mypoint,
          zoomControl: true,
          streetViewControl:true,
          scrollwheel: true,
          draggable: true,
          maxZoom: 30,
          minZoom: 5,
          panControl:true,
          rotateControl:true
          
        };
    
        map = new google.maps.Map(document.getElementById('map'), mapOptions);
        directionsDisplay.setMap(map);
    
        google.maps.event.addListener(directionsDisplay, 'directions_changed', function() {
          computeTotalDistance(directionsDisplay.directions);
        });
        
    
        /* MARKER - NIPRO */
        var iconBase = '../img/global/';
        var iconShadow = {url: iconBase + 'icon_marker_alianca_shadow.png', anchor: new google.maps.Point(25, 60)};
    
        marker = new google.maps.Marker({
              map:map,
              icon: iconBase + 'icon_marker_alianca.png',
			  shadow: iconShadow,
              draggable:false,
              animation: google.maps.Animation.DROP,
              position: mypoint,
              title: '<%=nameEmp%>'
            });
		google.maps.event.addListener(marker, 'click', showInfo);
    }
    
    function showInfo() {
        infowindow.open(map,marker);
    }
	    
	var contentString = '<div id="content" style="font-family:Trebuchet MS">'+
            '<h3><%=nameEmp%></h3>'+
            '<div id="bodyContent" style="color:#333; font-size:12px;">'+
			'<p><%=addressEmp%> - <%=neighEmp%><br><%=cityEmp%> - <%=stateEmp%></p>'+
            '</div>'+
            '</div>';
	
    var infowindow = new google.maps.InfoWindow({
        content: contentString,
        maxWidth: 300,
        disableAutoPan:true 
    });
    
    var overview = new google.maps.OverviewMapControlOptions({
        opened:true	
    });
    
    
    </script>
    
</head>

<body onload="initialize()" style="padding:0; margin:0">
	<div id="map" style="width:100%; height:100%; overflow:hidden"></div>
</body>

</html>