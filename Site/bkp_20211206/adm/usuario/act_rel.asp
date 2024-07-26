<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/logado.asp"-->
<%
	'Id do usuário retirado do Http
	id = Request.QueryString("id")
	
	'Atribui valor do campo "gravarid"
	checksEscolhidos = Request.Form("gravarid")
	
	' Verifica se há registros na tabela de relacionamento
	sqlVerify = "SELECT * FROM tbl_empreendimento_usuario WHERE id_usuario = " & id & ""
	set RsVerify = conexao.execute(sqlVerify)
	
	' Se existir
	if not RsVerify.EOF then
		' Deleta tudo antes
		sqlVerify = "DELETE FROM tbl_empreendimento_usuario WHERE id_usuario = " & id & ""
		set RsVerify = conexao.execute(sqlVerify)
	end if

	'Se for vazia a variável checkEscolhidos
	if checksEscolhidos = "" then
		Response.Redirect "lista.asp" 'Redireciona com variável delete = "no"
	else
		'Variável de Array recebe valores dos Check separado por vírgula nas posições do vetor
		arrChecksEscolhidos = Split(checksEscolhidos, ",")
		'De c = 0 até o total de posições do vetor fazer:
		For c = 0 To UBound(arrChecksEscolhidos)
			
			'Variável recebe valor da posição c (número do contador)
			escolhido = arrChecksEscolhidos( c )
			
			'Efetua Delete das mensagens
			sql = "INSERT INTO tbl_empreendimento_usuario (id_usuario, id_empreendimento, status) VALUES ('"&id&"', '"&escolhido&"', 1)"
			conexao.execute(sql)
			
		next 'Próxima instrução
		'Redireciona para página lista com delete = "ok"
		Response.Redirect "lista.asp?delete=rel"		
	end if	'Finaliza Se for vazia a variável checkEscolhidos
	
	'Finaliza conexao
	conexao.close
	set conexao = nothing
%>

