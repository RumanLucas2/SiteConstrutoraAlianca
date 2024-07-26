<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/logado.asp"-->
<%
	'Recebe do Http a Id do usuário
	UsuarioID = Request.QueryString("UsuarioID")
	'Se a Id do usuário for vazia ou nula ou não for numérica	
	If UsuarioID = "" Or IsNull(UsuarioID) Or Not IsNumeric(UsuarioID) Then
		UsuarioID = 0	'Variável da Id do usuário recebe "0"
	End If	'Finaliza Se a Id do usuário for vazia ou nula ou não for numérica	
	'Inicia Recordset
	Set Rs = Server.CreateObject("ADODB.RecordSet")
	'Busca todos os campos com a Id do usuário
	sql = "SELECT * FROM tbl_usuario_adm WHERE UsuarioID = " & UsuarioID
	'Executa
	Rs.Open  sql, conexao, 1, 3
	'Se não for encontrado nenhum usuário
	If Rs.Eof Then
		'Adiciona novo registro
		Rs.ADDNew
	End If	'Finaliza Se não for encontrado nenhum usuário
	'Adiciona no campo nome o valor do formulario
	Rs("Nome")	= Request.Form("txtNome")
	'Se campo senha do formulário não for vazio
	If Request.Form("txtSenha") <> "" Then
		'Campo Senha recebe valor do formulário
		Rs("Senha") = Request.Form("txtSenha")
	End If	'Finaliza Se campo senha do formulário não for vazio

	'Adiciona valores dos campos do formulário
	Rs("Status") = Request.Form("txtStatus")
	'Recebe Data e Hora atual do servidor
	Rs("data_cadastro")= Now
	'Executa Update
	Rs.Update
	'Finaliza Recordset
	Rs.Close 
	Set Rs = Nothing
	'Redireciona para página de edição com msg = "ok" e Id do usuário
	Response.Redirect "frm_edt.asp?msg=ok&UsuarioID=" & UsuarioID
	'Finaliza Conexao
	conexao.close
	set conexao = nothing
%>