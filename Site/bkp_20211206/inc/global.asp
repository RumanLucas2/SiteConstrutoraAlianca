<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>

<%
	 pagina_url = Request.ServerVariables("URL")
	 pagina_url_array = Split(pagina_url, "/")
	 pagina_atual = pagina_url_array(ubound(pagina_url_array) - 1)
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Aliança Engenharia e Incorpora&ccedil;&atilde;o</title>

<!-- FAVICON -->
<link rel="shortcut icon" type="image/x-icon" href="../img/favicon.ico">

<!-- CSS -->
<link type="text/css" rel="stylesheet" href="../css/global.css" />

<!-- CSS Banner-->
<link href="../css/allinone_bannerRotator.css" rel="stylesheet" type="text/css">

<script type="text/javascript">
	menuatual = '<%=pagina_atual%>';
</script>

<!-- JS -->
<script type="text/javascript" src="../js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="../js/jquery.easing.1.3.js"></script>
<script type="text/javascript" src="../js/jquery.backstretch.js"></script>
<script type="text/javascript" src="../js/infinitecarousel.js"></script>
<script type="text/javascript" src="../js/jquery-ui-1.8.16.custom.min.js"></script>
<script type="text/javascript" src="../js/jquery.ui.touch-punch.min.js"></script>
<script type="text/javascript" src="../js/allinone_bannerRotator.js"></script>
<script type="text/javascript" src="../js/functions.js"></script>
<script type="text/javascript" src="../js/action.js"></script>

<!-- PRETTY PHOTO -->
<link type="text/css" rel="stylesheet" href="../css/prettyPhoto.css" />
<script type="text/javascript" src="../js/jquery.prettyPhoto.js"></script>

<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-39948972-6', 'construtoraalianca.com.br');
  ga('send', 'pageview');

</script>