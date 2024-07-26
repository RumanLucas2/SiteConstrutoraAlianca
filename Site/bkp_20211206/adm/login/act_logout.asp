<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/logado.asp"-->
<%
	'Recebe do servidor a data e o tempo atual
	strUltimo = now()
	'Limpa Sessão de erro
	Session("login_msg") = ""	
	'Inicia Recordset	
	set Rs = Server.CreateObject("ADODB.Recordset")
	'Atualiza Ultimo Acesso do usuario na tbl_users
	sql= "UPDATE tbl_usuario_adm SET ultimo_acesso ='" & strUltimo & "' WHERE usuarioID = " & Session("Codigo") & ""
	'Executa
	Rs.Open sql, conexao
		'Sessão que define se está logado retorna falso
	Session("logado") = False
	'Redireciona para página inicial
	response.Redirect("index.asp")
%>