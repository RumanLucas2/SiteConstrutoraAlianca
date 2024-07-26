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
	sql = "SELECT * FROM tbl_empreendimento WHERE id_empreendimento = 0"
	Rs.Open  sql, conexao, 1, 3
	
	'Se não for encontrado
	If Rs.Eof Then
		Rs.ADDNew	'Adiciona novo registro
	End If	'Finaliza Se não for encontrado
	
	'Atribui valores
	Rs("id_tipo")				= Request.Form("txtTipo")
	Rs("id_fase")				= Request.Form("txtFase")
	Rs("nome")					= anti_inje(Request.Form("txtNome"))
	Rs("frase")					= anti_inje(Request.Form("txtFrase"))
	Rs("conceito")				= anti_inje(nl2br(Request.Form("txtConceito")))
	Rs("descricao")				= anti_inje(nl2br(Request.Form("txtDescricao")))
	Rs("lazer")					= anti_inje(Request.Form("txtLazer"))
	Rs("seguranca")				= anti_inje(Request.Form("txtSeguranca"))
	Rs("diferencial")			= anti_inje(Request.Form("txtDiferencial"))
	Rs("endereco")				= anti_inje(Request.Form("txtEndereco"))
	Rs("bairro")				= anti_inje(Request.Form("txtBairro"))
	Rs("cidade")				= anti_inje(Request.Form("txtCidade"))
	Rs("estado")				= Request.Form("txtEstado")
	Rs("geolocalizacao")		= anti_inje(Request.Form("txtGeolocalizacao"))
	Rs("data_cadastro")			= PrepareDAT2(Now,1) & " " & PrepareDAT2(Now,2)
	Rs("destaque")				= Request.Form("txtDestaque")
	Rs("status")				= Request.Form("txtStatus")
	
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