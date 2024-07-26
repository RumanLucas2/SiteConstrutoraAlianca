<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/logado.asp"-->
<%
	'Variável recebe Id do usuário
	UsuarioID = Request.QueryString("UsuarioID")
	'Se a Id do usuário for vazia ou nula ou não for numérica
	If UsuarioID = "" Or IsNull(UsuarioID) Or Not IsNumeric(UsuarioID) Then
		UsuarioID = 0	'Variável da Id do usuário recebe "0"
	End If	'Finaliza Se a Id do usuário for vazia ou nula ou não for numérica
	'Variavel login recebe E-mail do Usuário
	Email = Request.Form("txtEmail")
	'inicia Recordset
	Set Rs = Server.CreateObject("ADODB.RecordSet")
	'Busca usuários que possuem E-mail igual ao do formulário
	Rs.Open "SELECT * FROM tbl_usuario_adm WHERE Email LIKE '%" & Email & "%'", conexao, 1, 3
	'Se não for encontrado nenhum usuário
	If Rs.Eof Then
		Login = "ok"	'Variável Login recebe valor "ok"
	Else
		Login = ""	'Variável Login recebe valor nulo
	End If	'Finaliza Se não for encontrado nenhum usuário
	'Finaliza Recordset
	Rs.Close
	'Se variável Login tiver valor = "ok"
	If Login = "ok" Then
		'Inicia Busca dos campos pela Id do usuário
		sql = "SELECT * FROM tbl_usuario_adm WHERE UsuarioID = " & UsuarioID
		'Executa
		Rs.Open  sql, conexao, 1, 3
		'Se não for encontrado ninguém
		If Rs.Eof Then
			Rs.ADDNew	'Adiciona novo registro
		End If	'Finaliza Se não for encontrado ninguém
	
		'Adiciona valores do formulário
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
		'Redireciona pra página de Adicionar Novo Usuário com mensagem OK
		Response.Redirect "frm_add.asp?msg=ok"
	Else
		'Redireciona para página de Adicionar Novo Usuário com mensagem ERRO
		Response.Redirect "frm_add.asp?msg=err"
	End If	'Finaliza Se variável Login tiver valor = "ok"
	'Finaliza conexao
	conexao.close
	set conexao = nothing
%>