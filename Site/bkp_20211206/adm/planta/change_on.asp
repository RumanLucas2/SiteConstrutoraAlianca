<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/logado.asp"-->
<!-- #include file="../inc/anti_injection.asp"-->
<%
	'Recebe do Http a Id do usu�rio
	id = Request.QueryString("id")
	'Se a Id do usu�rio for vazia ou nula ou n�o for num�rica	
	If id = "" Or IsNull(id) Or Not IsNumeric(id) Then
		id = 0	'Vari�vel da Id do usu�rio recebe "0"
	End If	'Finaliza Se a Id do usu�rio for vazia ou nula ou n�o for num�rica	
	'Inicia Recordset
	Set Rs = Server.CreateObject("ADODB.RecordSet")
	'Busca todos os campos com a Id do usu�rio
	sql = "SELECT * FROM tbl_galeria_planta WHERE id_galeria = " & id
	'Executa
	Rs.Open  sql, conexao, 1, 3
	'Se n�o for encontrado nenhum usu�rio
	If Rs.Eof Then
		'Adiciona novo registro
		Rs.ADDNew
	End If	'Finaliza Se n�o for encontrado nenhum usu�rio
	'Adiciona valores do formul�rio
	Rs("status")			= ("0")
	'Executa Update
	Rs.Update
	'Finaliza Recordset
	Rs.Close 
	Set Rs = Nothing
	'Redireciona para p�gina de edi��o com msg = "ok" e Id do usu�rio
	Response.Redirect "lista.asp"
	'Finaliza Conexao
	conexao.close
	set conexao = nothing
%>