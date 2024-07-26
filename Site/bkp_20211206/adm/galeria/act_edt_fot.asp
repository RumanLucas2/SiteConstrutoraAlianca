<!-- #include file="../inc/global.asp"-->  
<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/logado.asp"-->
<!-- #include file="../inc/fn.asp"-->
<%
	'Recebe do Http a Id do usuário
	id_galeria = Request.QueryString("id_galeria")
	'Se a Id do usuário for vazia ou nula ou não for numérica	
	If id_galeria = "" Or IsNull(id_galeria) Or Not IsNumeric(id_galeria) Then
		id_galeria= 0	'Variável da Id do usuário recebe "0"
	End If	'Finaliza Se a Id do usuário for vazia ou nula ou não for numérica	
	
	'Recebe do Http a Id do usuário
	id_foto = Request.QueryString("id_foto")
	'Se a Id do usuário for vazia ou nula ou não for numérica	
	If id_foto = "" Or IsNull(id_foto) Or Not IsNumeric(id_foto) Then
		id_foto = 0	'Variável da Id do usuário recebe "0"
	End If	'Finaliza Se a Id do usuário for vazia ou nula ou não for numérica	
	
	'Inicia Recordset
	Set Rs = Server.CreateObject("ADODB.RecordSet")
	'Busca todos os campos com a Id do usuário
	sql = "SELECT * FROM tbl_galeria_foto WHERE id_foto = " & id_foto
	'Executa
	Rs.Open  sql, conexao, 1, 3
	'Se não for encontrado nenhum usuário
	If Rs.Eof Then
		'Adiciona novo registro
		Rs.ADDNew
	End If	'Finaliza Se não for encontrado nenhum usuário
	'Adiciona no campo nome o valor do formulario
	Rs("nome")	= anti_inje(Request.Form("txtNome"))
	'Adiciona valores dos campos do formulário
	Rs("status") = Request.Form("txtStatus")
	'Executa Update
	Rs.Update
	'Finaliza Recordset
	Rs.Close 
	Set Rs = Nothing
	
	'Redireciona para página de edição com msg = "ok" e Id do usuário
	Response.Redirect "frm_edt_fot.asp?msg=ok&id_galeria=" & id_galeria & "&id_foto=" & id_foto
	'Finaliza Conexao
	conexao.close
	set conexao = nothing
%>