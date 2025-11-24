<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/logado.asp"-->
<%
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
			
			'Efetua Delete das mensagens
			sql = "DELETE FROM tbl_empreendimento_tipo WHERE id_tipo =" & escolhido
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