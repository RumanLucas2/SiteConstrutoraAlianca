<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/logado.asp"-->
<%
	'Id do usu�rio retirado do Http
	id = Request.QueryString("id")
	
	'Atribui valor do campo "gravarid"
	checksEscolhidos = Request.Form("gravarid")
	
	' Verifica se h� registros na tabela de relacionamento
	sqlVerify = "SELECT * FROM tbl_empreendimento_usuario WHERE id_usuario = " & id & ""
	set RsVerify = conexao.execute(sqlVerify)
	
	' Se existir
	if not RsVerify.EOF then
		' Deleta tudo antes
		sqlVerify = "DELETE FROM tbl_empreendimento_usuario WHERE id_usuario = " & id & ""
		set RsVerify = conexao.execute(sqlVerify)
	end if

	'Se for vazia a vari�vel checkEscolhidos
	if checksEscolhidos = "" then
		Response.Redirect "lista.asp" 'Redireciona com vari�vel delete = "no"
	else
		'Vari�vel de Array recebe valores dos Check separado por v�rgula nas posi��es do vetor
		arrChecksEscolhidos = Split(checksEscolhidos, ",")
		'De c = 0 at� o total de posi��es do vetor fazer:
		For c = 0 To UBound(arrChecksEscolhidos)
			
			'Vari�vel recebe valor da posi��o c (n�mero do contador)
			escolhido = arrChecksEscolhidos( c )
			
			'Efetua Delete das mensagens
			sql = "INSERT INTO tbl_empreendimento_usuario (id_usuario, id_empreendimento, status) VALUES ('"&id&"', '"&escolhido&"', 1)"
			conexao.execute(sql)
			
		next 'Pr�xima instru��o
		'Redireciona para p�gina lista com delete = "ok"
		Response.Redirect "lista.asp?delete=rel"		
	end if	'Finaliza Se for vazia a vari�vel checkEscolhidos
	
	'Finaliza conexao
	conexao.close
	set conexao = nothing
%>

