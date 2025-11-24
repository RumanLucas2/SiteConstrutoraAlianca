<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/logado.asp"-->
<!-- #include file="../inc/anti_injection.asp"-->
<%
	'Recebe do Http a Id do usuário
	id = Request.QueryString("id")
	'Se a Id do usuário for vazia ou nula ou não for numérica	
	If id = "" Or IsNull(id) Or Not IsNumeric(id) Then
		id = 0	'Variável da Id do usuário recebe "0"
	End If	'Finaliza Se a Id do usuário for vazia ou nula ou não for numérica	
	'Inicia Recordset
	Set Rs = Server.CreateObject("ADODB.RecordSet")
	'Busca todos os campos com a Id do usuário
	sql = "SELECT * FROM tbl_galeria_planta WHERE id_galeria = " & id
	'Executa
	Rs.Open  sql, conexao, 1, 3
	'Se não for encontrado nenhum usuário
	If Rs.Eof Then
		'Adiciona novo registro
		Rs.ADDNew
	End If	'Finaliza Se não for encontrado nenhum usuário
	'Adiciona valores do formulário
	Rs("status")			= ("0")
	'Executa Update
	Rs.Update
	'Finaliza Recordset
	Rs.Close 
	Set Rs = Nothing
	'Redireciona para página de edição com msg = "ok" e Id do usuário
	Response.Redirect "lista.asp"
	'Finaliza Conexao
	conexao.close
	set conexao = nothing
%>