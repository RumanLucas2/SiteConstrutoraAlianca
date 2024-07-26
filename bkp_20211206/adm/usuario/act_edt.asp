<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/fn.asp"-->
<!-- #include file="../inc/logado.asp"-->

<%
	'Variável recebe Id do usuário
	id = Request.QueryString("id")
	'Se a Id do usuário for vazia ou nula ou não for numérica
	If id = "" Or IsNull(id) Or Not IsNumeric(id) Then
		id = 0	'Variável da Id do usuário recebe "0"
	End If	'Finaliza Se a Id do usuário for vazia ou nula ou não for numérica
	
	'inicia Recordset
	Set Rs = Server.CreateObject("ADODB.RecordSet")
	'Inicia Busca dos campos pela Id
	
	sql = "UPDATE tbl_usuario SET nome = '" & anti_inje(Request.Form("txtNome")) & "', " &_
	"nome = '" & Request.Form("txtNome") & "' " &_
	"email = '" & Request.Form("txtEmail") & "' " &_
	"senha = '" & Request.Form("txtSenha") & "' " &_
	"status = '" & Request.Form("txtStatus") & "' " &_									
	"WHERE id_usuario = " & id
	Rs.Open  sql, conexao, 1, 3
	
	'Finaliza conexao
	conexao.close
	Set conexao = nothing
	
	'Redireciona pra página de Adicionar Novo Usuário com mensagem OK
	Response.Redirect "frm_edt.asp?msg=ok&id=" & id
%>