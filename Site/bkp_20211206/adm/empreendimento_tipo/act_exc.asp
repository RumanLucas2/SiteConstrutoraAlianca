<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/logado.asp"-->
<%
	'Atribui valor do campo "excluirid"
	checksEscolhidos = Request.Form("excluirid")

	'Se for vazia a vari�vel checkEscolhidos
	if checksEscolhidos = "" then
		Response.Redirect "lista.asp?delete=no"	'Redireciona com vari�vel delete = "no"
	else
		'Vari�vel de Array recebe valores dos Check separado por v�rgula nas posi��es do vetor
		arrChecksEscolhidos = Split(checksEscolhidos, ",")
		'De c = 0 at� o total de posi��es do vetor fazer:
		For c = 0 To UBound(arrChecksEscolhidos)
			'Vari�vel recebe valor da posi��o c (n�mero do contador)
			escolhido = arrChecksEscolhidos( c )
			
			'Efetua Delete das mensagens
			sql = "DELETE FROM tbl_empreendimento_tipo WHERE id_tipo =" & escolhido
			'Executa
			conexao.execute(sql)
			
		next 'Pr�xima instru��o
		'Redireciona para p�gina lista com delete = "ok"
		Response.Redirect "lista.asp?delete=ok"		
	end if	'Finaliza Se for vazia a vari�vel checkEscolhidos
	'Finaliza conexao
	conexao.close
	set conexao = nothing
%>