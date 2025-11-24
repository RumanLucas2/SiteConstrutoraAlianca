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
	sql = "SELECT * FROM tbl_empreendimento_tipo WHERE id_tipo = 0"
	
	'Executa
	Rs.Open  sql, conexao, 1, 3
	
	'Se não for encontrado ninguém
	If Rs.Eof Then
		Rs.ADDNew	'Adiciona novo registro
	End If	'Finaliza Se não for encontrado ninguém
	
	'Atribui valores
	Rs("nome")				= anti_inje(Request.Form("txtNome"))
	Rs("data_cadastro")		= PrepareDAT2(Now,1) & " " & PrepareDAT2(Now,2)
	Rs("status")			= Request.Form("txtStatus")
	
	'Executa Update
	Rs.Update
	'Finaliza Recordset
	Rs.Close 
		
	'Finaliza conexao
	conexao.close
	Set conexao = nothing
		
	'Redireciona pra página de Adicionar Novo Usuário com mensagem OK
	Response.Redirect "frm_add.asp?msg=ok"
			
%>