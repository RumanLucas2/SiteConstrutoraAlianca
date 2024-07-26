<!-- #include file="../inc/global.asp"-->  
<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/logado.asp"-->
<!-- #include file="../inc/fn.asp"-->
<!-- #include file="inc.asp"-->
<%
	'Inicia objeto para manipular pastas e arquivos	
	Set FSO = Server.CreateObject("scripting.FileSystemObject")

	'Recebe id da galeria e da foto a excluir
	id_galeria = Request.QueryString("id_galeria")
	'Se a Id do usu�rio for vazia ou nula ou n�o for num�rica	
	If id_galeria = "" Or IsNull(id_galeria) Or Not IsNumeric(id_galeria) Then
		id_galeria = 0	'Vari�vel da Id do usu�rio recebe "0"
	End If	'Finaliza Se a Id do usu�rio for vazia ou nula ou n�o for num�rica	
	
	id_foto = Request.QueryString("id_foto")
	'Se a Id do usu�rio for vazia ou nula ou n�o for num�rica	
	If id_foto = "" Or IsNull(id_foto) Or Not IsNumeric(id_foto) Then
		id_foto = 0	'Vari�vel da Id do usu�rio recebe "0"
	End If	'Finaliza Se a Id do usu�rio for vazia ou nula ou n�o for num�rica	

	'Verifica se existe caminho da foto
	IF FSO.FolderExists(pasta & "\" & trim(id_galeria) & "\" & trim(id_foto)) THEN
		'Deleta pasta
		FSO.DeleteFolder pasta & "\" & trim(id_galeria) & "\" & trim(id_foto), true
	END IF

	'Efetua Delete das mensagens
	sql = "DELETE FROM tbl_galeria_foto WHERE id_foto =" & id_foto
	'Executa
	conexao.execute(sql)
			
	'Redireciona para p�gina lista com delete = "ok"
	Response.Redirect "lista_fot.asp?delete=ok&id_galeria=" & id_galeria
	
	'Finaliza conexao
	conexao.close
	set conexao = nothing
%>