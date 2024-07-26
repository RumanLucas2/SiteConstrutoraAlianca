<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/logado.asp"-->
<%
	'Recebe do Http a Id do usuário
	id_galeria = Request.QueryString("id_galeria")
	'Se a Id do usuário for vazia ou nula ou não for numérica	
	If id_galeria = "" Or IsNull(id_galeria) Or Not IsNumeric(id_galeria) Then
		id_galeria = 0	'Variável da Id do usuário recebe "0"
	End If	'Finaliza Se a Id do usuário for vazia ou nula ou não for numérica	
	'Inicia Recordset
	Set Rs = Server.CreateObject("ADODB.RecordSet")
	'Busca todos os campos com a Id do usuário
	sql = "SELECT * FROM tbl_galeria_planta WHERE id_galeria = " & id_galeria
	'Executa
	Rs.Open  sql, conexao, 1, 3
	'Se não for encontrado nenhum usuário
	If Rs.Eof Then
		'Adiciona novo registro
		Rs.ADDNew
	End If	'Finaliza Se não for encontrado nenhum usuário
	
	'Adiciona no campo nome o valor do formulario
	Rs("nome")			= Request.Form("txtNome")
	Rs("id_empreendimento")	= Request.Form("txtEspetaculo")
	Rs("status") 		= Request.Form("txtStatus")
	
	'Executa Update
	Rs.Update
	
	'Finaliza Recordset
	Rs.Close 
	Set Rs = Nothing
	
	'Redireciona para página de edição com msg = "ok" e Id do usuário
	Response.Redirect "frm_edt.asp?msg=ok&id_galeria=" & id_galeria
	
	'Finaliza Conexao
	conexao.close
	set conexao = nothing
%>