<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/anti_injection.asp"-->
<%
	strLast = now()
	
	'Recupera valores dos formul�rios
	strEmail = anti_inje(request.form("txtEmail"))
	strPassword = anti_inje(request.form("txtPassword"))

	'Inicia Recordset
	set Rs = Server.CreateObject("ADODB.Recordset")
	'Busca Email na tbl_users
	sql = "SELECT * FROM tbl_usuario WHERE email = '" & strEmail & "'"
	Rs.Open sql, conexao
	
	If Rs.Eof Then 	'Se n�o for encontrado e-mail
		Session("msg_login") = "Desculpe. Usu�rio n�o encontrado."	'Sess�o de erro recebe mensagem
		Response.Redirect "../home/index.asp"	'Redireciona para p�gina inicial
	Else
		If Rs("senha") <> strPassword Then	'Se encontrar e-mail e senha estiver errada
			Session("msg_login") = "Senha inv�lida. Acesse ESQUECI MINHA SENHA para recuper�-la."	'Sess�o de erro recebe mensagem
			Response.Redirect "../home/index.asp"	'Redireciona para p�gina inicial
		Else
			If Rs("status") = 0 then	'Se usu�rio estiver inativo
				Session("msg_login") = "Por favor confirme seu cadastro atrav�s do seu e-mail."	'Sess�o de erro recebe mensagem
				Response.Redirect "../home/index.asp"	'Redireciona para p�gina inicial
			Else
				'Recuperar Quantidade de Acessos
				set RsAccess = Server.CreateObject("ADODB.Recordset")
				'Busca Id do usu�rio e quantidade de acesso pelo e-mail
				sqlAccess = "SELECT id_usuario, acesso FROM tbl_usuario WHERE email = '" & strEmail & "'"
				'Executa
				RsAccess.Open sqlAccess, conexao
				
				'Atribui valores
				strAccess = RsAccess("acesso")
				strAccess = strAccess + 1	
				strCod	  = RsAccess("id_usuario")
				
				'Inicia Recordset
				set RsUp = Server.CreateObject("ADODB.Recordset")
				'Atualiza quantidade de acessos do usu�rio
				sqlUp= "UPDATE tbl_usuario SET acesso ='" & strAccess & "', data_ultimoacesso = '" & strLast & "' WHERE id_usuario = " & strCod & ""
				'Executa
				RsUp.Open sqlUp, conexao
	
				'Usuario Logado
				Session("logged") 	= True
				'Trata nome do usu�rio
				usernameComplete	= Rs("nome")
				usernameSplit		= split(usernameComplete, " ")
				Session("usernameComplete") = usernameComplete
				Session("username") = usernameSplit(0)
				Session("iduser") 	= Rs("id_usuario")
							
				'Finaliza e Redireciona
				Response.Redirect "../acompanhe/"
			End If 'Finaliza Se usu�rio estiver inativo
		End If 'Finaliza Se encontrar e-mail e senha estiver errada
	End If 'Finaliza Se n�o for encontrado e-mail

	'Zera valores do Recordset e da Conexao	
	Rs.close
	set Rs = nothing		
	conexao.Close
	set conexao	= Nothing
%>