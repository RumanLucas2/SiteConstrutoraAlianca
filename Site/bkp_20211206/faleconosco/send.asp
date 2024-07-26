<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/fn.asp"-->
<!-- #include file="../inc/anti_injection.asp"-->
<%
	session.LCID = 1034

	'Cria Objeto Upload
	Set Upload = Server.CreateObject("Dundas.Upload.2")
	Upload.UseUniqueNames = false
	
	'Cria objeto para Pastas
	Set FSO = Server.CreateObject("scripting.FileSystemObject")
	
	tmp = Server.MapPath("../_file/tmp/")
	pasta = Server.MapPath("../_file/sat/")
	
	Upload.Save(tmp & "/" & "")
	
	tipo = Upload.Form("txtTipo")
	
	if (tipo = "1") then
		
		Set Rs = Server.CreateObject("ADODB.RecordSet")	
		sql = "SELECT * FROM tbl_contato WHERE id_contato = 0"
		Rs.Open  sql, conexao, 1, 3
		
		'Se não for encontrado
		If Rs.Eof Then
			Rs.ADDNew	'Adiciona novo registro
		End If	'Finaliza Se não for encontrado
			
		'Atribui valores
		Rs("autor")				= anti_inje(Upload.Form("txtAutor"))
		Rs("email")				= anti_inje(Upload.Form("txtEmail"))
		Rs("telefone")			= anti_inje(Upload.Form("txtTelefone"))
		Rs("assunto")			= anti_inje(Upload.Form("txtAssunto"))
		Rs("mensagem")			= anti_inje(nl2br(Upload.Form("txtMensagem")))
		Rs("data_cadastro")		= PrepareDAT2(Now,1) & " " & PrepareDAT2(Now,2)
		Rs("status")			= "1"
		
		'Executa Update
		Rs.Update
		
		'Finaliza Recordset
		Rs.Close
		Set Rs = Nothing
		conexao.Close
		Set conexao = nothing
		
		'Redireciona pra página de Adicionar Novo Usuário com mensagem OK
		if err <> 0 then
			session("msg_contact") = "Desculpe, ocorreu um erro no envio. Tente mais tarde."
			Response.Redirect("../faleconosco")
		else
			session("msg_contact") = "Obrigado! Sua mensagem foi enviada com sucesso."
			Response.Redirect("../faleconosco")
		end if
		
	else
		
		Dim novoNome
		Randomize
		novoNome = Replace((Rnd * 99999), ",", "")
		novoNome = Replace(novoNome, ".", "")
		
		nome_arquivo = Trim(Upload.GetFileName(Upload.Files(0).Path))
		extensao = right(nome_arquivo, 4)
		
		If extensao = "jpeg" Then
			extensao = ".jpg"
		End If
		
		novoNome = novoNome & extensao
		
		FSO.MoveFile tmp & "\" & nome_arquivo, pasta & "\" & novoNome
		
		Set Mail = Server.CreateObject("Persits.MailSender")
		Mail.From = "sat@construtoraalianca.com.br"
		Mail.FromName = "SAT"
		Mail.Host = "mail.construtoraalianca.com.br"
		Mail.Username = "sat@construtoraalianca.com.br"
		Mail.Password = "claudio010203"
		Mail.Port = 587
		Mail.IsHTML = True
		Mail.Subject = "Termo - Assist&ecirc;ncia T&eacute;cnica"
		Mail.Body = 	"<font size=2 color=#666666 face=Verdana><p>" &_
					"-------------------------------------------------------- <br />" &_
					"<strong>TERMO</strong> | ASSIST&Ecirc;NCIA T&Eacute;CNICA<br />" &_
					"-------------------------------------------------------- <br />" &_  			   
					"<p>Ol&aacute;<strong> Administrador</strong>," & "</p>" &_
					"<p>Um novo termo foi enviado." & "</p>" &_
					"<p>O arquivo encontra-se anexo para a an&aacute;lise." & "</p>" &_
					"<p><a href='http://www.construtoraalianca.com.br/_file/sat/" & novoNome & "'>CLIQUE AQUI<" & "</a></p>" &_
					"<br /><br />" &_
					"-------------------------------------------------------- <br />" &_
					"N&atilde;o responda este email. Ele foi gerado automaticamente. <br />" &_
					"-------------------------------------------------------- <br />" &_
					"Construtora Alian&ccedil;a - <a href='http://www.construtoraalianca.com.br'>www.construtoraalianca.com.br</a>" &_
					"</p></font>"
					
		Mail.AddAddress "sat@construtoraalianca.com.br"
		
		'Mail.AddAttachment FilePath & "\" & Fields("Attachment").FileName
		
		Mail.Send
					
		'Redireciona pra página de Adicionar Novo Usuário com mensagem OK
		if err <> 0 then
			session("msg_contact") = "Desculpe, ocorreu um erro no envio. Tente mais tarde."
			Response.Redirect("../faleconosco")
		else
			session("msg_contact") = "Obrigado! Sua mensagem foi enviada com sucesso."
			Response.Redirect("../faleconosco")
		end if
		
	end if
%>