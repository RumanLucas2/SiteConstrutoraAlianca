<!-- #include file="../inc/global.asp"-->  
<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/logado.asp"-->

<%
	'Id do usuário retirado do Http
	UsuarioID = Request.QueryString("UsuarioID")
	'Se Id do usuário for vazia ou nulo ou não for numérico
	if UsuarioID = "" Or IsNull(UsuarioID) Or Not IsNumeric(UsuarioID) Then
		UsuarioID = 0	'Variável da Id do usuário recebe 0
	End if	'Finaliza Se Id do usuário for vazia ou nulo ou não for numérico
	
	'Variável msg recebe valor do Http
	msg = Request.QueryString("msg")

	'Se msg tiver valor "ok"
	if msg = "ok" Then
		msg = "Cadastro efetuado com sucesso!"	'Variável recebe mensagem de sucesso
	Else
		if msg = "err" Then	'Se msg tiver valor "err"
			msg = "Email j&aacute; cadastrado!"	'Variável recebe mensagem de erro
		Else
			msg = ""	'msg se mantem vazia
		End if	'Finaliza Se msg tiver valor "err"
	End if	'Finaliza Se msg tiver valor "ok"
	
	'Remove espaços da esquerda e da direita da Id do usuário e verifica se é igual a 0
	if ltrim(rtrim(UsuarioID)) = 0 Then
		'Variáveis ficam vazias
		Nome  = ""
		Email = ""
		Login = ""
		Senha = ""
		ConfirmaSenha = ""
	Else
		'Busca campos que contem a Id do usuario
		SQLSelect = "SELECT * FROM tbl_usuario_adm WHERE UsuarioID = " & UsuarioID
		'Executa
		Set Rs = Conn.Execute(SQLSelect)
		'Se for encontrado usuário
		if Not Rs.Eof Then
			'Variáveis recebem valores do Recordset
			Nome  = Rs("Nome")
			Email = Rs("Email")
			Login = Rs("Login")
			Status = Rs("Status")
		End if	'Finaliza Se for encontrado usuário
	End if	'Finaliza Remove espaços da esquerda e da direita da Id do usuário e verifica se é igual a 0
%>

</head>

<body>

<div id="global">

	<!-- #include file="../inc/header.asp"-->

	<!-- #include file="../inc/menu.asp"-->

    <!-- DIV CONTEUDO -->
    <div id="content">
    
        <h2><span></span>Usuários | Adicionar</h2>
        <div class="content_divisao"></div>      
        
        <a href="lista.asp?lista=todos&amp;limpa=ok" class="content_link1">Listar Usu&aacute;rios</a></td>
        <i><%= msg %></i>

        <div class="content_divisao"></div>              
    
        <form name="formulario" action="act_add.asp?edit=<%= edit %>&UsuarioID=<%= UsuarioID %>" method="post" onSubmit="return valida_usuario(this);">
    
		<div class="form_entry">
            <div class="form_title"><h3>Nome</h3></div>
            <input type="text" name="txtNome" id="txtNome" maxlength="255" size="50" value="<%= Nome %>" class="form_textarea" />
        </div>          
		<div class="form_entry">
            <div class="form_title"><h3>E-mail</h3></div>
            <input type="text" name="txtEmail" id="txtEmail" maxlength="255" size="50" value="<%= Email %>" class="form_textarea" />      
        </div>
        <div class="form_entry">
            <div class="form_title"><h3>Login</h3></div>
            <input type="text" name="txtLogin" id="txtLogin" maxlength="255" size="50" value="<%= Login %>" class="form_textarea" />      
        </div>
		<div class="form_entry">
            <div class="form_title"><h3>Senha</h3></div>
            <input type="password" name="txtSenha" id="txtSenha" maxlength="255" size="50" value="<%= Senha %>" class="form_textarea" />
        </div>
        <div class="form_entry">
            <div class="form_title"><h3>Confirmar Senha</h3></div>
            <input type="password" name="txtSenha2" id="txtSenha2" maxlength="255" size="50" class="form_textarea" />
        </div>
		<div class="form_entry">
            <div class="form_title"><h3>Status</h3></div>
            <div class="form_textarea">
            <select name="txtStatus">
              <option value="1" <% if Status = "1" then response.write("selected") end if %>>ON</option>
              <option value="0" <% if Status = "0" then response.write("selected") end if %>>OFF</option>
            </select>
            </div>
        </div>

        <div class="content_bt_big"><a href="javascript:history.go(-1)">VOLTAR</a></div>
        <input name="submit" type="submit" value="Adicionar" class="form_bt_big" />
                  
    </form>
            
    </div>
    
    <!-- DIV FOOTER -->
    <div id="rodape"><!--#include file="../inc/footer.asp"--></div>
    
</div>

</body>
</html>
<%
	conexao.close
	set conexao = nothing
%>