<!-- #include file="../inc/global.asp"-->  
<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/logado.asp"-->
<!-- #include file="../inc/fn.asp"-->
<%
	'Recebe do Http a Id do usu�rio
	id_galeria = Request.QueryString("id_galeria")
	'Se a Id do usu�rio for vazia ou nula ou n�o for num�rica	
	If id_galeria = "" Or IsNull(id_galeria) Or Not IsNumeric(id_galeria) Then
		id_galeria= 0	'Vari�vel da Id do usu�rio recebe "0"
	End If	'Finaliza Se a Id do usu�rio for vazia ou nula ou n�o for num�rica	
	
	'Recebe do Http a Id do usu�rio
	id_foto = Request.QueryString("id_foto")
	'Se a Id do usu�rio for vazia ou nula ou n�o for num�rica	
	If id_foto = "" Or IsNull(id_foto) Or Not IsNumeric(id_foto) Then
		id_foto = 0	'Vari�vel da Id do usu�rio recebe "0"
	End If	'Finaliza Se a Id do usu�rio for vazia ou nula ou n�o for num�rica	
	
	'Inicia Recordset
	Set Rs = Server.CreateObject("ADODB.RecordSet")
	'Busca todos os campos com a Id do usu�rio
	sql = "SELECT * FROM tbl_galeria_foto WHERE id_foto = " & id_foto
	'Executa
	Rs.Open  sql, conexao, 1, 3
	'Se n�o for encontrado nenhum usu�rio
	If Rs.Eof Then
		'Adiciona novo registro
		Rs.ADDNew
	End If	'Finaliza Se n�o for encontrado nenhum usu�rio
	'Adiciona no campo nome o valor do formulario
	Rs("nome")	= anti_inje(Request.Form("txtNome"))
	'Adiciona valores dos campos do formul�rio
	Rs("status") = Request.Form("txtStatus")
	'Executa Update
	Rs.Update
	'Finaliza Recordset
	Rs.Close 
	Set Rs = Nothing
	
	'Redireciona para p�gina de edi��o com msg = "ok" e Id do usu�rio
	Response.Redirect "frm_edt_fot.asp?msg=ok&id_galeria=" & id_galeria & "&id_foto=" & id_foto
	'Finaliza Conexao
	conexao.close
	set conexao = nothing
%>