<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/anti_injection.asp"-->
<%
	strUltimo = now()
	
	'Recupera valores dos formul�rios
	strLogin = anti_inje(request.form("txtLogin"))
	strSenha = anti_inje(request.form("txtSenha"))

	'Inicia Recordset
	set Rs = Server.CreateObject("ADODB.Recordset")
	'Busca Email na tbl_users
	sql = "SELECT * FROM tbl_usuario_adm WHERE Login = '" & strLogin & "'"
	Rs.Open sql, conexao
	
	If Rs.Eof Then 	'Se n�o for encontrado e-mail
		Session("login_msg") = "Login n�o encontrado."	'Sess�o de erro recebe mensagem
		Response.Redirect "index.asp"	'Redireciona para p�gina inicial
	Else
		If Rs("Senha") <> strSenha Then	'Se encontrar e-mail e senha estiver errada
			Session("login_msg") = "Senha inv�lida."	'Sess�o de erro recebe mensagem
			Response.Redirect "index.asp"	'Redireciona para p�gina inicial
		Else
			If Rs("Status") = 0 then	'Se usu�rio estiver inativo
				Session("login_msg") = "Usu�rio Inativo."	'Sess�o de erro recebe mensagem
				Response.Redirect "index.asp"	'Redireciona para p�gina inicial
			Else
				'Recuperar Quantidade de Acessos
				set RsQtd = Server.CreateObject("ADODB.Recordset")
				'Busca Id do usu�rio e quantidade de acesso pelo e-mail
				sqlQtd = "SELECT usuarioID, quantidade_acesso FROM tbl_usuario_adm WHERE Login = '" & strLogin & "'"
				'Executa
				RsQtd.Open sqlQtd, conexao
				
				'Atribui valores
				strAcessos = RsQtd("quantidade_acesso")
				strAcessos = strAcessos + 1	
				strCodigo  = RsQtd("usuarioID")
				
				'Inicia Recordset
				set RsUp = Server.CreateObject("ADODB.Recordset")
				'Atualiza quantidade de acessos do usu�rio
				sqlUp= "UPDATE tbl_usuario_adm SET quantidade_acesso ='" & strAcessos & "', ultimo_acesso = '" & strUltimo & "' WHERE usuarioID = " & strCodigo & ""
				'Executa
				RsUp.Open sqlUp, conexao
	
				'Usuario Logado
				Session("logado") = True
				Session("Nome")   = Rs("Nome")
				Session("Codigo") = Rs("usuarioID")
							
				'Finaliza e Redireciona
				Response.Redirect "main.asp"
			End If 'Finaliza Se usu�rio estiver inativo
		End If 'Finaliza Se encontrar e-mail e senha estiver errada
	End If 'Finaliza Se n�o for encontrado e-mail

	'Zera valores do Recordset e da Conexao	
	Rs.close
	set Rs = nothing		
	conexao.Close
	set conexao	= Nothing
	
%>