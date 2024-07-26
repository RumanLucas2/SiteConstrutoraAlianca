<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/logado.asp"-->
<!-- #include file="../inc/fn.asp"-->
<!-- #include file="inc.asp"-->

<%
	'Vari�vel recebe Id do usu�rio
	id_galeria = Request.QueryString("id_galeria")
	'Se a Id do usu�rio for vazia ou nula ou n�o for num�rica
	If id_galeria = "" Or IsNull(id_galeria) Or Not IsNumeric(id_galeria) Then
		id_galeria = 0	'Vari�vel da Id do usu�rio recebe "0"
	End If	'Finaliza Se a Id do usu�rio for vazia ou nula ou n�o for num�rica
	
	'Variavel login recebe E-mail do Usu�rio
	Nome = Request.Form("txtNome")
	
	'Cria objeto para Pastas
	Set FSO = Server.CreateObject("scripting.FileSystemObject")
	
	'inicia Recordset
	Set Rs = Server.CreateObject("ADODB.RecordSet")
	
	'Busca usu�rios que possuem E-mail igual ao do formul�rio
	Rs.Open "SELECT * FROM tbl_galeria WHERE Nome LIKE '%" & Nome & "%'", conexao, 1, 3
	
	'Se n�o for encontrado nenhum usu�rio
	If Rs.Eof Then
		Login = "ok"	'Vari�vel Login recebe valor "ok"
	Else
		Login = ""	'Vari�vel Login recebe valor nulo
	End If	'Finaliza Se n�o for encontrado nenhum usu�rio
	'Finaliza Recordset
	Rs.Close
	'Se vari�vel Login tiver valor = "ok"
	If Login = "ok" Then
		'Inicia Busca dos campos pela Id do usu�rio
		sql = "SELECT * FROM tbl_galeria WHERE id_galeria = " & id_galeria
		'Executa
		Rs.Open  sql, conexao, 1, 3
		'Se n�o for encontrado ningu�m
		If Rs.Eof Then
			Rs.ADDNew	'Adiciona novo registro
		End If	'Finaliza Se n�o for encontrado ningu�m
	
		'Adiciona valores do formul�rio
		Rs("nome")			= Request.Form("txtNome")
		Rs("id_empreendimento")	= Request.Form("txtEspetaculo")
		Rs("data_cadastro") = PrepareDAT2(Now,1) & " " & PrepareDAT2(Now,2)
		Rs("status")		= Request.Form("txtStatus")
		
		'Executa Update
		Rs.Update
		'Finaliza Recordset
		Rs.Close 
		Set Rs = Nothing
		
		'Verifica ultimo ID inserido
		Set Rs_max = Server.CreateObject("ADODB.Recordset")
		sql_max = "SELECT MAX(id_galeria) as id_galeria FROM tbl_galeria"
		Rs_max.Open sql_max, conexao
		
		'Se houver ID, gera-se seu relacionamento com o MENU
		if not Rs_max.eof then
			id_galeria = Rs_max("id_galeria")
		end if
		
		'Cria pasta
		FSO.CreateFolder(pasta & "\" & id_galeria)
		
		'Redireciona pra p�gina de Adicionar Novo Usu�rio com mensagem OK
		Response.Redirect "frm_add.asp?msg=ok"
	Else
		'Redireciona para p�gina de Adicionar Novo Usu�rio com mensagem ERRO
		Response.Redirect "frm_add.asp?msg=err"
	End If	'Finaliza Se vari�vel Login tiver valor = "ok"
	'Finaliza conexao
	conexao.close
	set conexao = nothing
%>