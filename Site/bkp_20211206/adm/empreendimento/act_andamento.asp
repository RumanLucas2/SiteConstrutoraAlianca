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
		
	Set Rs = Server.CreateObject("ADODB.RecordSet")	
	sql = "SELECT * FROM tbl_empreendimento_andamento WHERE id_empreendimento = " & id
	Rs.Open  sql, conexao, 1, 3
	
	'Se não for encontrado
	If Rs.Eof Then
		Rs.ADDNew	'Adiciona novo registro
	End If	'Finaliza Se não for encontrado
	
	'Atribui valores
	Rs("id_empreendimento")	= id
	Rs("lancamento")	= anti_inje(Request.Form("txtLancamento"))
	Rs("terreno")		= anti_inje(Request.Form("txtTerreno"))
	Rs("fundacao")		= anti_inje(Request.Form("txtFundacao"))
	Rs("estrutura")		= anti_inje(Request.Form("txtEstrutura"))
	Rs("alvenaria")		= anti_inje(Request.Form("txtAlvenaria"))
	Rs("instalacao")	= anti_inje(Request.Form("txtInstalacao"))
	Rs("revestimento")	= anti_inje(Request.Form("txtRevestimento"))
	Rs("acabamento")	= anti_inje(Request.Form("txtAcabamento"))
	Rs("status")		= Request.Form("txtStatus")
	
	'Executa Update
	Rs.Update
	
	'Finaliza Recordset
	Rs.Close
	Set Rs = Nothing
	conexao.Close
	Set conexao = nothing
	
	'Redireciona pra página de Adicionar Novo Usuário com mensagem OK
	Response.Redirect "lista.asp"
%>