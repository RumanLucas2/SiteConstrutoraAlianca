<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>

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
    
    var latitude = '-23.08405';
    var longitude = '-47.201099';
    
    var rendererOptions = {draggable: true};
    var directionsDisplay = new google.maps.DirectionsRenderer(rendererOptions);;
    var directionsService = new google.maps.DirectionsService();
    
    var map;
    var marker;
    var mypoint = new google.maps.LatLng(latitude, longitude);
    
    function initialize() {
        
        var mapOptions = {
          zoom: 12,
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
              title: 'Aliança'
            });
		google.maps.event.addListener(marker, 'click', showInfo);
    }
    
    function showInfo() {
        infowindow.open(map,marker);
    }
	    
	var contentString = '<div id="content" style="font-family:Trebuchet MS">'+
            '<h3>Aliança</h3>'+
            '<div id="bodyContent" style="color:#333; font-size:12px;">'+
			'<p>Rua Dom Idelfonso Stehle, 987 - Cidade Nova - Indaiatuba - SP</p>'+
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