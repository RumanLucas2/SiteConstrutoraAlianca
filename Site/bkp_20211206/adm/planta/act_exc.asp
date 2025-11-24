<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/logado.asp"-->
<!-- #include file="inc.asp"-->
<%
	'Inicia objeto para manipular pastas e arquivos	
	Set FSO = Server.CreateObject("scripting.FileSystemObject")

	'Atribui valor do campo "excluirid"
	checksEscolhidos = Request.Form("excluirid")

	'Se for vazia a variável checkEscolhidos
	if checksEscolhidos = "" then
		Response.Redirect "lista.asp?delete=no"	'Redireciona com variável delete = "no"
	else
		'Variável de Array recebe valores dos Check separado por vírgula nas posições do vetor
		arrChecksEscolhidos = Split(checksEscolhidos, ",")
		'De c = 0 até o total de posições do vetor fazer:
		For c = 0 To UBound(arrChecksEscolhidos)
			
			'Variável recebe valor da posição c (número do contador)
			escolhido = arrChecksEscolhidos( c )
					
			'Verifica se existe caminho da foto
			IF FSO.FolderExists(pasta & "\" & escolhido) THEN
				'Deleta pasta
				FSO.DeleteFolder pasta & "\" & escolhido, true
			END IF
			
			'Efetua Delete do código
			sql = "Delete FROM tbl_galeria_planta WHERE id_galeria =" & escolhido
			'Executa
			conexao.execute(sql)
		next 'Próxima instrução
		'Redireciona para página lista com delete = "ok"
		Response.Redirect "lista.asp?delete=ok"		
	end if	'Finaliza Se for vazia a variável checkEscolhidos
	'Finaliza conexao
	conexao.close
	set conexao = nothing
%>

