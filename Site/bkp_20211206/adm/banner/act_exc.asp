<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/logado.asp"-->
<!-- #include file="inc.asp"-->
<%
	'Inicia objeto para manipular pastas e arquivos	
	Set FSO = Server.CreateObject("scripting.FileSystemObject")

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

			if(FSO.FolderExists(pasta & "\" & trim(escolhido))) then
				'Deleta pasta
				FSO.DeleteFolder pasta & "\" & trim(escolhido), true
			end if
			
			'Efetua Delete das mensagens
			sql = "DELETE FROM tbl_banner WHERE id_banner =" & escolhido
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