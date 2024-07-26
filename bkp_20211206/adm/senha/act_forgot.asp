<!-- #include file="../inc/conexao.asp" -->
<!-- #include file="../inc/anti_injection.asp" -->
<%
	sEmail = request.form("txtEmail")

	Set Mail = Server.CreateObject("Persits.MailSender")
	Set Rs = server.CreateObject("ADODB.Recordset")
	sql = "SELECT * FROM tbl_usuarios_adm WHERE email = '" & sEmail & "'"
	Rs.Open sql, conexao	
	
	if Rs.eof then
		Session("forgot") = "E-mail não cadastrado"
		Response.Redirect("forgot.asp")
	else
	
		sNome  = Rs("nome")
		sSenha = Rs("senha")
		sBody  = "<font size=2 color=#666666 face=Verdana>Ol&aacute; " & sNome &_
							"<br><br>" &_
							"Voc&ecirc; (" & sEmail & ") solicitou ao <b>Painel de Controle</b> em " & Date() & " que lhe enviasse sua senha.<br>" &_
							"Gostar&iacute;amos de lembr&aacute;-lo que sua senha &eacute; pessoal e intransfer&iacute;vel." &_ 
							"<br><br>" &_
							"Senha: " & sSenha &_
							"<br><br>" &_
							"Data/Hora da solicita&ccedil;&atilde;o:" & Date() & " - " & Time() & "<br>" &_
							"<br><br>" &_
							"----------------------------------------------------------------" &_
							"<br>N&atilde;o responda este email. Ele foi gerado automaticamente.<br>" &_
							"----------------------------------------------------------------" &_
							"<br>" &_
							"Painel de Controle - <a href=http://www.dominio.com.br target=_blank>http://www.dominiodopainel.com.br</a></font>"
		
	
		
		Mail.Host = "mail.euelaeasofia.com.br"
		Mail.From = "esqueci@euelaeasofia.com.br" 
		Mail.FromName = "ADM" 
		Mail.AddAddress sEmail, sNome
		Mail.Subject = "Lembrete: senha solicitada" 
		Mail.IsHTML = True 
		Mail.Body = sBody 
		Mail.Send 
		
		if Err = 0 Then 
			Session("forgot") = ""
			Set Mail = Nothing
			Set Rs = nothing
			Set Conexao = nothing
			Session("forgot") = "Senha enviada!" 
			Response.redirect ("forgot.asp") 
		Else
			Set Mail = Nothing
			Set Rs = nothing
			Set Conexao = nothing
			Session("forgot") = "Erro no envio." 
			Response.redirect ("forgot.asp") 
		End If
	
		
	end if

%>