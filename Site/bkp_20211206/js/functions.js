	// MUDA SENTIDO DA PAGINA
	function ChangePage(sSentido) {
		var pag = document.List.Pagina.value;
		switch (sSentido) {
			case 'P':	pag = parseInt(pag) - 1;
						break;
			case 'N': 	pag = parseInt(pag) + 1;
						break;
			case 'F': 	pag = 1;
						break;
			case 'L': 	pag = parseInt(document.List.UltimaPagina.value);
						break;
		}
		document.location.href = "lista.asp?Page=" + pag;
	}
	
	function ChangePageU(sSentido) {
		var pag = document.List.Pagina.value;
		switch (sSentido) {
			case 'P':	pag = parseInt(pag) - 1;
						break;
			case 'N': 	pag = parseInt(pag) + 1;
						break;
			case 'F': 	pag = 1;
						break;
			case 'L': 	pag = parseInt(document.List.UltimaPagina.value);
						break;
		}
		document.location.href = "lista.asp?Page=" + pag;
	}
	
	// MUDA SENTIDO DA PAGINA - USUARIOS
	function ChangePageU(sSentido) {
		var pag = document.List.Pagina.value;
		switch (sSentido) {
			case 'P':	pag = parseInt(pag) - 1;
						break;
			case 'N': 	pag = parseInt(pag) + 1;
						break;
			case 'F': 	pag = 1;
						break;
			case 'L': 	pag = parseInt(document.List.UltimaPagina.value);
						break;
		}
		document.location.href = "usuarios.asp?Page=" + pag;
	}
	
	// CONFIRMA EXCLUSÃO	
	function Excluir(){
		if(confirm("Confirma Exclusão?")){
					//Submeter formulário.
			document.selecao.submit();	
			return true;
		}
		else{
			return false;
		}
	 }
	 
	 // CONFIRMA GRAVAÇÃO	
	function Gravar(){
		if(confirm("Confirma Gravação?")){
					//Submeter formulário.
			document.selecao.submit();	
			return true;
		}
		else{
			return false;
		}
	 }
	 
	 // CONFIRMA INICIAR PROVA	
	function IniciarProva(){
		if(confirm("Tem certeza que deseja iniciar a prova?")){
					//Submeter formulário.
			document.prova.submit();	
			return true;
		}
		else{
			return false;
		}
	 }
	 
	// CONFIRMA EXCLUSÃO	
	function ExcluirSecao(){
		if(confirm("Deseja excluir essa seção, seus tópicos e suas mensagens?")){
					//Submeter formulário.
			document.selecao.submit();	
			return true;
		}
		else{
			return false;
		}
	 }
	 
	// CONFIRMA EXCLUSÃO	
	function ExcluirTopico(){
		if(confirm("Deseja excluir essa tópico e suas mensagens?")){
					//Submeter formulário.
			document.selecao.submit();	
			return true;
		}
		else{
			return false;
		}
	 }
	 
	 
	 // SELECIONA TODAS AS CHECKBOX
	 function CheckTodos() {
		var itens = document.selecao.length;
		var x = 0;
		while (x<itens) {
			if (document.selecao[x].type=="checkbox") {
					document.selecao[x].checked=true;
			}
		x++;		
		}
	}
	
	// LIMPA TODAS AS CHECKBOX
	function UncheckTodos() {
		var itens = document.selecao.length;
		var x = 0;
		while (x<itens) {
			if (document.selecao[x].type=="checkbox") {
					document.selecao[x].checked=0;
			}
		x++;		
		}
	}


	function valida_cal(new_material){
		
		var extensoesOk = ",.jpg,";
		var extensao = "," + new_material.txtArquivo.value.substr( new_material.txtArquivo.value.length - 4 ).toLowerCase() + ",";
		if(extensoesOk.indexOf( extensao ) == -1 ){ 
			alert(new_material.txtArquivo.value + "\nA extensão permitida para a Imagem de Exibição é: 'jpg'." );
			return false;
		}else {
			return true;
		} 
		
		if ( confirm ( 'Confima o envio das informações acima?' )) { return true; } else { return false; }
		
	}
	
	function valida_usuario(new_user)
	{
		if ( new_user.txtNome.value == '' ) {
			alert ( ' É necessário digitar o Nome' );
			new_user.txtNome.focus();
			new_user.txtNome.select();
			return false;
		}
		
		if( new_user.txtEmail.value.indexOf("@") == -1 || new_user.txtEmail.value.indexOf( "." ) ==-1 ) { 
			alert( ' Preencha corretamente o campo E-mail'); 
			new_user.txtEmail.focus(); 
			new_user.txtEmail.select();
			return false; 
		} 
		
		if ( new_user.txtLogin.value == '' ) {
			alert ( ' É necessário digitar o Login' );
			new_user.txtLogin.focus();
			new_user.txtLogin.select();
			return false;
		}
		
		if (( new_user.txtSenha.value == '' )||( new_user.txtSenha.value.length < 6 )) {
			alert ( ' É necessário digitar uma Senha de no mínimo 6 caracteres' );
			new_user.txtSenha.focus();
			new_user.txtSenha.select();
			return false;
		}
		
		if(new_user.txtSenha.value != new_user.txtSenha2.value){ 
			alert("senha e confirmacao diferentes") 
			//document.formulario.txtSenha2.focus();
			return false; 
		}
	
		if ( confirm ( 'Confima o envio das informações acima?' )) { return true; } else { return false; }
		
	}
	
	function valida_secao(new_secao)
	{
		if ( new_secao.txtNome.value == '' ) {
			alert ( ' É necessário digitar um Nome...' );
			new_secao.txtNome.focus();
			new_secao.txtNome.select();
			return false;
		}
		
		if ( confirm ( 'Confima o envio das informações acima?' )) { return true; } else { return false; }
		
	}
	
	function valida_categoria(new_categoria)
	{
		if ( new_categoria.txtNome.value == '' ) {
			alert ( ' É necessário digitar um Nome...' );
			new_categoria.txtNome.focus();
			new_categoria.txtNome.select();
			return false;
		}
		
		if ( confirm ( 'Confima o envio das informações acima?' )) { return true; } else { return false; }
		
	}
	
	function valida_usu_portal(new_usu)
	{
		if ( new_usu.txtMatricula.value == '' ) {
			alert ( ' É necessário digitar uma Matrícula...' );
			new_usu.txtMatricula.focus();
			new_usu.txtMatricula.select();
			return false;
		}
		
		if ( new_usu.txtNome.value == '' ) {
			alert ( ' É necessário digitar um Nome...' );
			new_usu.txtNome.focus();
			new_usu.txtNome.select();
			return false;
		}
		
		if ( confirm ( 'Confima o envio das informações acima?' )) { return true; } else { return false; }
		
	}
	
	
	function valida_sub(new_sub)
	{
		
		if ( new_sub.txtCategoria.value == '' ) {
			alert ( ' É necessário selecionar uma Categoria...' );
			new_sub.txtCategoria.focus();
			return false;
		}
		
		if ( new_sub.txtNome.value == '' ) {
			alert ( ' É necessário digitar um Nome...' );
			new_sub.txtNome.focus();
			new_sub.txtNome.select();
			return false;
		}
		
		if ( confirm ( 'Confima o envio das informações acima?' )) { return true; } else { return false; }
		
	}
	

	function valida_topico(new_topico)
	{
		if ( new_topico.txtAssunto.value == '' ) {
			alert ( ' É necessário digitar um Assunto...' );
			new_topico.txtAssunto.focus();
			new_topico.txtAssunto.select();
			return false;
		}
		
		if ( confirm ( 'Confima o envio das informações acima?' )) { return true; } else { return false; }
		
	}
	
	function valida_link(new_link)
	{
		if ( new_link.txtDescricao.value == '' ) {
			alert ( ' É necessário digitar um Nome...' );
			new_link.txtDescricao.focus();
			new_link.txtDescricao.select();
			return false;
		}
		
		if ( new_link.txtUrl.value == '' ) {
			alert ( ' É necessário digitar o Endereço do site...' );
			new_link.txtUrl.focus();
			new_link.txtUrl.select();
			return false;
		}
		
		if ( confirm ( 'Confima o envio das informações acima?' )) { return true; } else { return false; }
		
	}
	
	function valida_material(new_material)
	{
		if ( new_material.txtDescricao.value == '' ) {
			alert ( ' É necessário digitar um Nome...' );
			new_material.txtDescricao.focus();
			new_material.txtDescricao.select();
			return false;
		}
		
		if ( new_material.txtArquivo.value == '' ) {
			alert ( ' É necessário escolher um Arquivo...' );
			new_material.txtArquivo.focus();
			new_material.txtArquivo.select();
			return false;
		}
		
		var extensoesOk = ",.gif,.jpg,";
		var extensao = "," + new_material.txtArquivo2.value.substr( new_material.txtArquivo2.value.length - 4 ).toLowerCase() + ",";
		if (new_material.txtArquivo2.value != ""){
			if(extensoesOk.indexOf( extensao ) == -1 ){ 
				alert(new_material.txtArquivo2.value + "\nAs extensões permitidas para a Imagem de Exibição são: 'jpg' e 'gif'." );
				return false;
			}else {
				return true;
			} 
		}
		
		if ( confirm ( 'Confima o envio das informações acima?' )) { return true; } else { return false; }
		
	}
	
	function valida_material_ciclo(new_material)
	{
		
		if ( new_material.txtSubCategoria.value == '' ) {
			alert ( ' É necessário selecionar uma Sub-Categoria...' );
			new_material.txtSubCategoria.focus();
			return false;
		}
		
		if ( new_material.txtDescricao.value == '' ) {
			alert ( ' É necessário digitar um Nome...' );
			new_material.txtDescricao.focus();
			new_material.txtDescricao.select();
			return false;
		}
		
		if ( new_material.txtArquivo.value == '' ) {
			alert ( ' É necessário escolher um Arquivo...' );
			new_material.txtArquivo.focus();
			new_material.txtArquivo.select();
			return false;
		}
		
		var extensoesOk = ",.gif,.jpg,";
		var extensao = "," + new_material.txtArquivo2.value.substr( new_material.txtArquivo2.value.length - 4 ).toLowerCase() + ",";
		if (new_material.txtArquivo2.value != ""){
			if(extensoesOk.indexOf( extensao ) == -1 ){ 
				alert(new_material.txtArquivo2.value + "\nAs extensões permitidas para a Imagem de Exibição são: 'jpg' e 'gif'." );
				return false;
			}else {
				return true;
			} 
		}
		
		if ( confirm ( 'Confima o envio das informações acima?' )) { return true; } else { return false; }
		
	}
	
	function valida_noticia(new_noticia)
	{
		
		if ( new_noticia.txtTitulo.value == '' ) {
			alert ( ' É necessário digitar um Título...' );
			new_noticia.txtTitulo.focus();
			new_noticia.txtTitulo.select();
			return false;
		}
		
		/*if ( new_noticia.txtChamada.value == '' ) {
			alert ( ' É necessário digitar um Texto Curto...' );
			new_noticia.txtChamada.focus();
			new_noticia.txtChamada.select();
			return false;
		}
		
		if ( new_noticia.txtTexto.value == '' ) {
			alert ( ' É necessário digitar um Texto Longo...' );
			new_noticia.txtTexto.focus();
			new_noticia.txtTexto.select();
			return false;
		}
		
		if ( new_noticia.txtFonte.value == '' ) {
			alert ( ' É necessário digitar a Fonte...' );
			new_noticia.txtFonte.focus();
			new_noticia.txtFonte.select();
			return false;
		}*/
		
		var extensoesOk = ",.gif,.jpg,.swf,";
		
		var extensao = "," + new_noticia.txtImg1.value.substr( new_noticia.txtImg1.value.length - 4 ).toLowerCase() + ",";
		
		if (new_noticia.txtImg1.value != ""){
			if(extensoesOk.indexOf( extensao ) == -1 ){ 
				alert(new_noticia.txtImg1.value + "\nAs extensões permitidas para a Imagem de Exibição são: 'jpg' e 'gif'." );
				return false;
			}else {
				return true;
			} 
		}
		
		if ( confirm ( 'Confima o envio das informações acima?' )) { return true; } else { return false; }
		
	}
	function valida_noticia_edt(new_noticia)
	{
		/*
		if ( new_noticia.txtDescricao.value == '' ) {
			alert ( ' É necessário digitar um Título...' );
			new_noticia.txtDescricao.focus();
			new_noticia.txtDescricao.select();
			return false;
		}
		
		if ( new_noticia.txtChamada.value == '' ) {
			alert ( ' É necessário digitar um Texto Curto...' );
			new_noticia.txtChamada.focus();
			new_noticia.txtChamada.select();
			return false;
		}
		
		if ( new_noticia.txtTexto.value == '' ) {
			alert ( ' É necessário digitar um Texto Longo...' );
			new_noticia.txtTexto.focus();
			new_noticia.txtTexto.select();
			return false;
		}
		
		if ( new_noticia.txtFonte.value == '' ) {
			alert ( ' É necessário digitar a Fonte...' );
			new_noticia.txtFonte.focus();
			new_noticia.txtFonte.select();
			return false;
		}
		
		if (new_noticia.txtImg1.value != ""){
			var extensoesOk = ",.gif,.jpg,";
			var extensao = "," + new_noticia.txtImg1.value.substr( new_noticia.txtImg1.value.length - 4 ).toLowerCase() + ",";
			if(extensoesOk.indexOf( extensao ) == -1 ){ 
				alert(new_noticia.txtImg1.value + "\nAs extensões permitidas para a Imagem de Exibição são: 'jpg' e 'gif'." );
				return false;
			}else {
				return true;
			} 
		}*/
		
		if ( confirm ( 'Confima o envio das informações acima?' )) { return true; } else { return false; }
		
	}
	
	function valida_foto(new_foto)
	{
		/*
			if ( new_foto.txtDescricao.value == '' ) {
				alert ( ' É necessário digitar um Nome...' );
				new_foto.txtDescricao.focus();
				new_foto.txtDescricao.select();
				return false;
			}
		*/
		
		var extensoesOk = ",.gif,.jpg,";
		var extensao = "," + new_foto.txtImg1.value.substr( new_foto.txtImg1.value.length - 4 ).toLowerCase() + ",";
		if (new_foto.txtImg1.value == ""){
			alert("O campo Imagem de Exibição está vazio...");
			return false;
		}else if(extensoesOk.indexOf( extensao ) == -1 ){ 
			alert(new_foto.txtImg1.value + "\nAs extensões permitidas para a Imagem de Exibição são: 'jpg' e 'gif'." );
			return false;
		}else {
			return true;
		} 
		
		if ( confirm ( 'Confima o envio das informações acima?' )) { return true; } else { return false; }
		
	}
	
	function valida_foto_perfil(new_foto)
	{
	
		var extensoesOk = ",.gif,.jpg,";
		var extensao = "," + new_foto.txtArquivo.value.substr( new_foto.txtArquivo.value.length - 4 ).toLowerCase() + ",";
		if (new_foto.txtArquivo.value == ""){
			alert("O campo Foto está vazio...");
			return false;
		}else if(extensoesOk.indexOf( extensao ) == -1 ){ 
			alert(new_foto.txtArquivo.value + "\nAs extensões permitidas para a Imagem de Exibição são: 'jpg' e 'gif'." );
			return false;
		}else {
			return true;
		} 
		
		if ( confirm ( 'Confima o envio das informações acima?' )) { return true; } else { return false; }
		
	}
	
	function valida_video(new_video)
	{
		if ( new_video.txtDescricao.value == '' ) {
			alert ( ' É necessário digitar um Nome...' );
			new_video.txtDescricao.focus();
			new_video.txtDescricao.select();
			return false;
		}
		
		var extensoesOk = ",.gif,.jpg,";
		var extensao = "," + new_video.txtArquivo2.value.substr( new_video.txtArquivo2.value.length - 4 ).toLowerCase() + ",";
		if (new_video.txtArquivo2.value != ""){
			if(extensoesOk.indexOf( extensao ) == -1 ){ 
				alert(new_video.txtArquivo2.value + "\nAs extensões permitidas para a Imagem de Exibição são: 'jpg' e 'gif'." );
				return false;
			}else {
				return true;
			} 
		}
		if ( confirm ( 'Confima o envio das informações acima?' )) { return true; } else { return false; }
		
	}
	
//	_________________________________________________________________________________________________________


	function AutoFormatDate(num) {
	// cf use: passThrough="onKeyDown='this.value=AutoFormatDate(this.value);'"
	tamanho = num.length;
	num = num.toString();
	var DateTemp = "";
	var checkstr = "0123456789/";
	
	for (i = 0; i < num.length; i++) {
		if (checkstr.indexOf(num.substr(i,1)) >= 0) {
			DateTemp = DateTemp + num.substr(i,1);
		}
	}
	
	num = DateTemp; // data com caracteres verificados
	
	if (window.event && window.event.keyCode == 8) { // backspace
		window.event.cancelBubble = false;
		window.event.returnValue = true;
		return num;
	
	} else {
	
		if (window.event && window.event.keyCode == 191 || window.event.keyCode == 111) {
			// keyCode '/' do alfa é 191;  '/' do numerico é 111
			// se o usuario digitar a barra, cancela, não inserindo 2 barras consecutivas
			window.event.cancelBubble = true;
			window.event.returnValue = false;
		}
		
		if (tamanho==2) // separa dia/mes
			return (num + '/')
		else if (tamanho==5) // separa mes/ano
			return (num + '/')
		else
			return num
		
	} // close else
	
	} // close function
	
	function show_calendar(str_target, str_datetime) {
		var arr_months = ["Janeiro", "Fevereiro", "Março", "Abril", "Maio", "Junho", "Julho", "Agosto", "Setembro", "Outubro", "Novembro", "Dezembro"];
		var week_days = ["Do", "Se", "Te", "Qu", "Qu", "Se", "Sa"];
		var n_weekstart = 1; // day week starts from (normally 0 or 1)
		var dt_datetime = (str_datetime == null || str_datetime =="" ?  new Date() : str2dt(str_datetime));
		var dt_prev_month = new Date(dt_datetime);
		dt_prev_month.setMonth(dt_datetime.getMonth()-1);
		var dt_next_month = new Date(dt_datetime);
		dt_next_month.setMonth(dt_datetime.getMonth()+1);
		var dt_firstday = new Date(dt_datetime);
		dt_firstday.setDate(1);
		dt_firstday.setDate(1-(7+dt_firstday.getDay()-n_weekstart)%7);
		var dt_lastday = new Date(dt_next_month);
		dt_lastday.setDate(0);
		
		// html generation (feel free to tune it for your particular application)
		// print calendar header
		var str_buffer = new String (
			"<html>\n"+
			"<head>\n"+
			"	<title>Calendário</title>\n"+
			"</head>\n"+
			"<body bottommargin=0 leftmargin=0 rightmargin=0 topmargin=0 rightmargin=0 marginheight=0 marginwidth=0 bgcolor=\"White\">\n"+
			"<table class=\"clsOTable\" cellspacing=\"0\" border=\"0\" width=\"100%\">\n"+
			"<tr><td bgcolor=\"#4682B4\">\n"+
			"<table cellspacing=\"1\" cellpadding=\"3\" border=\"0\" width=\"100%\">\n"+
			"<tr>\n	<td bgcolor=\"#4682B4\"><a style=\"color:white;text-decoration:none\" href=\"javascript:window.opener.show_calendar('"+
			str_target+"', '"+ dt2dtstr(dt_prev_month)+"'+document.cal.time.value);\">"+
			"\<b>&laquo;</b></a></td>\n"+
			"	<td align=center bgcolor=\"#4682B4\" colspan=\"5\">"+
			"<font color=\"white\" face=\"tahoma, verdana\" size=\"2\">"
			+arr_months[dt_datetime.getMonth()]+" "+dt_datetime.getFullYear()+"</font></td>\n"+
			"	<td bgcolor=\"#4682B4\" align=\"right\"><a style=\"color:white;text-decoration:none\" href=\"javascript:window.opener.show_calendar('"
			+str_target+"', '"+dt2dtstr(dt_next_month)+"'+document.cal.time.value);\">"+
			"\<b>&raquo;</b></a></td>\n</tr>\n"
		);
	
		var dt_current_day = new Date(dt_firstday);
		// print weekdays titles
		str_buffer += "<tr>\n";
		for (var n=0; n<7; n++)
			str_buffer += "	<td bgcolor=\"#87CEFA\">"+
			"<font color=\"white\" face=\"tahoma, verdana\" size=\"2\">"+
			week_days[(n_weekstart+n)%7]+"</font></td>\n";
		// print calendar table
		str_buffer += "</tr>\n";
		while (dt_current_day.getMonth() == dt_datetime.getMonth() ||
			dt_current_day.getMonth() == dt_firstday.getMonth()) {
			// print row heder
			str_buffer += "<tr>\n";
			for (var n_current_wday=0; n_current_wday<7; n_current_wday++) {
					if (dt_current_day.getDate() == dt_datetime.getDate() &&
						dt_current_day.getMonth() == dt_datetime.getMonth())
						// print current date
						str_buffer += "	<td bgcolor=\"#FFB6C1\" align=\"right\">";
					else if (dt_current_day.getDay() == 0 || dt_current_day.getDay() == 6)
						// weekend days
						str_buffer += "	<td bgcolor=\"#DBEAF5\" align=\"right\">";
					else
						// print working days of current month
						str_buffer += "	<td bgcolor=\"white\" align=\"right\">";
	
					if (dt_current_day.getMonth() == dt_datetime.getMonth())
						// print days of current month
						str_buffer += "<a href=\"javascript:window.opener."+str_target+
						".value='"+dt2dtstr(dt_current_day)+"'+document.cal.time.value; window.close();\">"+
						"<font color=\"black\" face=\"tahoma, verdana\" size=\"2\">";
					else 
						// print days of other months
						str_buffer += "<a href=\"javascript:window.opener."+str_target+
						".value='"+dt2dtstr(dt_current_day)+"'+document.cal.time.value; window.close();\">"+
						"<font color=\"gray\" face=\"tahoma, verdana\" size=\"2\">";
					str_buffer += dt_current_day.getDate()+"</font></a></td>\n";
					dt_current_day.setDate(dt_current_day.getDate()+1);
			}
			// print row footer
			str_buffer += "</tr>\n";
		}
		// print calendar footer
		str_buffer +=
			"<form name=\"cal\">\n<tr><td colspan=\"7\" bgcolor=\"#87CEFA\">"+
			"<input type=\"hidden\" name=\"time\" value=\""+dt2tmstr(dt_datetime)+
			"\"></td></tr>\n</form>\n" +
			"</table>\n" +
			"</tr>\n</td>\n</table>\n" +
			"</body>\n" +
			"</html>\n";
	
		var vWinCal = window.open("", "Calendario", 
			"width=200,height=195,status=no,resizable=yes,top=200,left=200");
		vWinCal.opener = self;
		var calc_doc = vWinCal.document;
		calc_doc.write (str_buffer);
		calc_doc.close();
	}
	// datetime parsing and formatting routimes. modify them if you wish other datetime format
	function str2dt (str_datetime) {
		var re_date = /^(\d+)\/(\d+)\/(\d+)/;
		 if (!re_date.exec(str_datetime))
			return alert("Formato de data inválido: "+ str_datetime);
		return (new Date (RegExp.$3, RegExp.$2-1, RegExp.$1, RegExp.$4, RegExp.$5, RegExp.$6));
	}
	function dt2dtstr (dt_datetime) {
		return (new String (
				dt_datetime.getDate()+"/"+(dt_datetime.getMonth()+1)+"/"+dt_datetime.getFullYear()));
	}
	function dt2tmstr (dt_datetime) {
		return (new String ());
	}
	
	//Verifica IMG para Cms
	
	function verifica_img(imagem,w,h,aceito){
		document.getElementById("verifica").src = "verifica.asp?imagem=" + imagem + "&w=" + w + "&h=" + h + "&aceito=" + aceito;
	}

//_________________________________________________________________________________________________________________________________

//MENU

	/*over = function() {
		var sfEls = document.getElementById("nav").getElementsByTagName("LI");
		for (var i=0; i<sfEls.length; i++) {
			sfEls[i].onmouseover=function() {
				this.className+=" over";
			}
			sfEls[i].onmouseout=function() {
				this.className=this.className.replace(new RegExp(" over\\b"), "");
			}
		}
	}

	if (window.attachEvent) window.attachEvent("onload", over);*/
	
	//MENU
	
	// ******************************************************************
	// This function accepts a string variable and verifies if it is a
	// proper date or not. It validates format matching either
	// mm-dd-yyyy or mm/dd/yyyy. Then it checks to make sure the month
	// has the proper number of days, based on which month it is.
	
	// The function returns true if a valid date, false if not.
	// ******************************************************************
	
	function isDate(dateStr) {
	
	var datePat = /^(\d{1,2})(\/|)(\d{1,2})(\/|)(\d{4})$/;
	var matchArray = dateStr.match(datePat); // is the format ok?
	
	if (matchArray == null) {
		alert("A data deve possuir o formato dd/mm/yyyy.");
		return false;
	}
	
	day 	= matchArray[1];
	month 	= matchArray[3]; // p@rse date into variables
	year 	= matchArray[5];
	
	if (month < 1 || month > 12) { // check month range
		alert("O Mês deve estar com valor entre 1 e 12.");
		return false;
	}
	
	if (day < 1 || day > 31) {
		alert("O Dia deve estar com valor entre 1 e 31.");
		return false;
	}
	
	if ((month==4 || month==6 || month==9 || month==11) && day==31) {
		alert("Mês "+month+" não possui 31 dias!")
		return false;
	}
	
	if (month == 2) { // check for february 29th
		var isleap = (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0));
		if (day > 29 || (day==29 && !isleap)) {
			alert("Fevereiro " + year + " não possui " + day + " dias!");
			return false;
		}
	}
		return true; // date is valid
	}
