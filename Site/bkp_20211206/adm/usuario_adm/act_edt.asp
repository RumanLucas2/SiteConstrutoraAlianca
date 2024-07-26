<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/logado.asp"-->
<%
	'Recebe do Http a Id do usu�rio
	UsuarioID = Request.QueryString("UsuarioID")
	'Se a Id do usu�rio for vazia ou nula ou n�o for num�rica	
	If UsuarioID = "" Or IsNull(UsuarioID) Or Not IsNumeric(UsuarioID) Then
		UsuarioID = 0	'Vari�vel da Id do usu�rio recebe "0"
	End If	'Finaliza Se a Id do usu�rio for vazia ou nula ou n�o for num�rica	
	'Inicia Recordset
	Set Rs = Server.CreateObject("ADODB.RecordSet")
	'Busca todos os campos com a Id do usu�rio
	sql = "SELECT * FROM tbl_usuario_adm WHERE UsuarioID = " & UsuarioID
	'Executa
	Rs.Open  sql, conexao, 1, 3
	'Se n�o for encontrado nenhum usu�rio
	If Rs.Eof Then
		'Adiciona novo registro
		Rs.ADDNew
	End If	'Finaliza Se n�o for encontrado nenhum usu�rio
	'Adiciona no campo nome o valor do formulario
	Rs("Nome")	= Request.Form("txtNome")
	'Se campo senha do formul�rio n�o for vazio
	If Request.Form("txtSenha") <> "" Then
		'Campo Senha recebe valor do formul�rio
		Rs("Senha") = Request.Form("txtSenha")
	End If	'Finaliza Se campo senha do formul�rio n�o for vazio

	'Adiciona valores dos campos do formul�rio
	Rs("Status") = Request.Form("txtStatus")
	'Recebe Data e Hora atual do servidor
	Rs("data_cadastro")= Now
	'Executa Update
	Rs.Update
	'Finaliza Recordset
	Rs.Close 
	Set Rs = Nothing
	'Redireciona para p�gina de edi��o com msg = "ok" e Id do usu�rio
	Response.Redirect "frm_edt.asp?msg=ok&UsuarioID=" & UsuarioID
	'Finaliza Conexao
	conexao.close
	set conexao = nothing
%>