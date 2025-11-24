<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/logado.asp"-->
<!-- #include file="../inc/fn.asp"-->
<!-- #include file="inc.asp"-->

<%
	'Variável recebe Id do usuário
	id_galeria = Request.QueryString("id_galeria")
	'Se a Id do usuário for vazia ou nula ou não for numérica
	If id_galeria = "" Or IsNull(id_galeria) Or Not IsNumeric(id_galeria) Then
		id_galeria = 0	'Variável da Id do usuário recebe "0"
	End If	'Finaliza Se a Id do usuário for vazia ou nula ou não for numérica
	
	'Variavel login recebe E-mail do Usuário
	Nome = Request.Form("txtNome")
	
	'Cria objeto para Pastas
	Set FSO = Server.CreateObject("scripting.FileSystemObject")
	
	'inicia Recordset
	Set Rs = Server.CreateObject("ADODB.RecordSet")
	
	'Busca usuários que possuem E-mail igual ao do formulário
	Rs.Open "SELECT * FROM tbl_galeria WHERE Nome LIKE '%" & Nome & "%'", conexao, 1, 3
	
	'Se não for encontrado nenhum usuário
	If Rs.Eof Then
		Login = "ok"	'Variável Login recebe valor "ok"
	Else
		Login = ""	'Variável Login recebe valor nulo
	End If	'Finaliza Se não for encontrado nenhum usuário
	'Finaliza Recordset
	Rs.Close
	'Se variável Login tiver valor = "ok"
	If Login = "ok" Then
		'Inicia Busca dos campos pela Id do usuário
		sql = "SELECT * FROM tbl_galeria WHERE id_galeria = " & id_galeria
		'Executa
		Rs.Open  sql, conexao, 1, 3
		'Se não for encontrado ninguém
		If Rs.Eof Then
			Rs.ADDNew	'Adiciona novo registro
		End If	'Finaliza Se não for encontrado ninguém
	
		'Adiciona valores do formulário
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
		
		'Redireciona pra página de Adicionar Novo Usuário com mensagem OK
		Response.Redirect "frm_add.asp?msg=ok"
	Else
		'Redireciona para página de Adicionar Novo Usuário com mensagem ERRO
		Response.Redirect "frm_add.asp?msg=err"
	End If	'Finaliza Se variável Login tiver valor = "ok"
	'Finaliza conexao
	conexao.close
	set conexao = nothing
%>