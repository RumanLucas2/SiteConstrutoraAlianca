<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/logado.asp"-->
<%
	'Vari�vel recebe Id do usu�rio
	UsuarioID = Request.QueryString("UsuarioID")
	'Se a Id do usu�rio for vazia ou nula ou n�o for num�rica
	If UsuarioID = "" Or IsNull(UsuarioID) Or Not IsNumeric(UsuarioID) Then
		UsuarioID = 0	'Vari�vel da Id do usu�rio recebe "0"
	End If	'Finaliza Se a Id do usu�rio for vazia ou nula ou n�o for num�rica
	'Variavel login recebe E-mail do Usu�rio
	Email = Request.Form("txtEmail")
	'inicia Recordset
	Set Rs = Server.CreateObject("ADODB.RecordSet")
	'Busca usu�rios que possuem E-mail igual ao do formul�rio
	Rs.Open "SELECT * FROM tbl_usuario_adm WHERE Email LIKE '%" & Email & "%'", conexao, 1, 3
	'Se n�o for encontrado nenhum usu�rio
	If Rs.Eof Then
		Login = "ok"	'Vari�vel Login recebe valor "ok"
	Else
		Login = ""	'Vari�vel Login recebe valor nulo
	End If	'Finaliza Se n�o for encontrado nenhum usu�rio
	'Finaliza Recordset
	Rs.Close
	'Se vari�vel Login tiver valor = "ok"
	If Login = "ok" Then
		'Inicia Busca dos campos pela Id do usu�rio
		sql = "SELECT * FROM tbl_usuario_adm WHERE UsuarioID = " & UsuarioID
		'Executa
		Rs.Open  sql, conexao, 1, 3
		'Se n�o for encontrado ningu�m
		If Rs.Eof Then
			Rs.ADDNew	'Adiciona novo registro
		End If	'Finaliza Se n�o for encontrado ningu�m
	
		'Adiciona valores do formul�rio
		Rs("Nome")				= Request.Form("txtNome")
		Rs("Email")				= Request.Form("txtEmail")
		Rs("Login")				= Request.Form("txtLogin")
		Rs("Senha")				= Request.Form("txtSenha")
		Rs("Status")			= Request.Form("txtStatus")
		'Recebe Data e Hora atual do servidor
		Rs("data_cadastro")		= Now
		'Inicia quantidade de acessos com 0
		Rs("quantidade_acesso") = 0	
		'Executa Update
		Rs.Update
		'Finaliza Recordset
		Rs.Close 
		Set Rs = Nothing
		'Redireciona pra p�gina de Adicionar Novo Usu�rio com mensagem OK
		Response.Redirect "frm_add.asp?msg=ok"
	Else
		'Redireciona para p�gina de Adicionar Novo Usu�rio com mensagem ERRO
		Response.Redirect "frm_add.asp?msg=err"
	End If	'Finaliza Se vari�vel Login tiver valor = "ok"
	'Finaliza conexao
	conexao.close
	set conexao = nothing
%>