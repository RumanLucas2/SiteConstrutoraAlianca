<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/logado.asp"-->
<%
	'Recebe do Http a Id do usu�rio
	id_galeria = Request.QueryString("id_galeria")
	'Se a Id do usu�rio for vazia ou nula ou n�o for num�rica	
	If id_galeria = "" Or IsNull(id_galeria) Or Not IsNumeric(id_galeria) Then
		id_galeria = 0	'Vari�vel da Id do usu�rio recebe "0"
	End If	'Finaliza Se a Id do usu�rio for vazia ou nula ou n�o for num�rica	
	'Inicia Recordset
	Set Rs = Server.CreateObject("ADODB.RecordSet")
	'Busca todos os campos com a Id do usu�rio
	sql = "SELECT * FROM tbl_galeria_planta WHERE id_galeria = " & id_galeria
	'Executa
	Rs.Open  sql, conexao, 1, 3
	'Se n�o for encontrado nenhum usu�rio
	If Rs.Eof Then
		'Adiciona novo registro
		Rs.ADDNew
	End If	'Finaliza Se n�o for encontrado nenhum usu�rio
	
	'Adiciona no campo nome o valor do formulario
	Rs("nome")			= Request.Form("txtNome")
	Rs("id_empreendimento")	= Request.Form("txtEspetaculo")
	Rs("status") 		= Request.Form("txtStatus")
	
	'Executa Update
	Rs.Update
	
	'Finaliza Recordset
	Rs.Close 
	Set Rs = Nothing
	
	'Redireciona para p�gina de edi��o com msg = "ok" e Id do usu�rio
	Response.Redirect "frm_edt.asp?msg=ok&id_galeria=" & id_galeria
	
	'Finaliza Conexao
	conexao.close
	set conexao = nothing
%>