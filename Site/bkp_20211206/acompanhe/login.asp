<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/anti_injection.asp"-->
<%
	strLast = now()
	
	'Recupera valores dos formulários
	strEmail = anti_inje(request.form("txtEmail"))
	strPassword = anti_inje(request.form("txtPassword"))

	'Inicia Recordset
	set Rs = Server.CreateObject("ADODB.Recordset")
	'Busca Email na tbl_users
	sql = "SELECT * FROM tbl_usuario WHERE email = '" & strEmail & "'"
	Rs.Open sql, conexao
	
	If Rs.Eof Then 	'Se não for encontrado e-mail
		Session("msg_login") = "Desculpe. Usuário não encontrado."	'Sessão de erro recebe mensagem
		Response.Redirect "../home/index.asp"	'Redireciona para página inicial
	Else
		If Rs("senha") <> strPassword Then	'Se encontrar e-mail e senha estiver errada
			Session("msg_login") = "Senha inválida. Acesse ESQUECI MINHA SENHA para recuperá-la."	'Sessão de erro recebe mensagem
			Response.Redirect "../home/index.asp"	'Redireciona para página inicial
		Else
			If Rs("status") = 0 then	'Se usuário estiver inativo
				Session("msg_login") = "Por favor confirme seu cadastro através do seu e-mail."	'Sessão de erro recebe mensagem
				Response.Redirect "../home/index.asp"	'Redireciona para página inicial
			Else
				'Recuperar Quantidade de Acessos
				set RsAccess = Server.CreateObject("ADODB.Recordset")
				'Busca Id do usuário e quantidade de acesso pelo e-mail
				sqlAccess = "SELECT id_usuario, acesso FROM tbl_usuario WHERE email = '" & strEmail & "'"
				'Executa
				RsAccess.Open sqlAccess, conexao
				
				'Atribui valores
				strAccess = RsAccess("acesso")
				strAccess = strAccess + 1	
				strCod	  = RsAccess("id_usuario")
				
				'Inicia Recordset
				set RsUp = Server.CreateObject("ADODB.Recordset")
				'Atualiza quantidade de acessos do usuário
				sqlUp= "UPDATE tbl_usuario SET acesso ='" & strAccess & "', data_ultimoacesso = '" & strLast & "' WHERE id_usuario = " & strCod & ""
				'Executa
				RsUp.Open sqlUp, conexao
	
				'Usuario Logado
				Session("logged") 	= True
				'Trata nome do usuário
				usernameComplete	= Rs("nome")
				usernameSplit		= split(usernameComplete, " ")
				Session("usernameComplete") = usernameComplete
				Session("username") = usernameSplit(0)
				Session("iduser") 	= Rs("id_usuario")
							
				'Finaliza e Redireciona
				Response.Redirect "../acompanhe/"
			End If 'Finaliza Se usuário estiver inativo
		End If 'Finaliza Se encontrar e-mail e senha estiver errada
	End If 'Finaliza Se não for encontrado e-mail

	'Zera valores do Recordset e da Conexao	
	Rs.close
	set Rs = nothing		
	conexao.Close
	set conexao	= Nothing
%>