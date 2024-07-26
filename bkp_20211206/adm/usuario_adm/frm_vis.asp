<!-- #include file="../inc/global.asp"-->  
<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/logado.asp"-->

<%
	'Id do usu�rio retirado do Http
	UsuarioID = Request.QueryString("UsuarioID")
	'Se Id do usu�rio for vazia ou nulo ou n�o for num�rico
	if UsuarioID = "" Or IsNull(UsuarioID) Or Not IsNumeric(UsuarioID) Then
		UsuarioID = 0	'Vari�vel da Id do usu�rio recebe 0
	End if	'Finaliza Se Id do usu�rio for vazia ou nulo ou n�o for num�rico
	
	'Vari�vel recebe valor Http
	msg = Request.QueryString("msg")
	'Se valor for igual a "ok"
	If msg = "ok" Then
		msg = "Registro Alterado com sucesso!"	'Vari�vel recebe mensagem de sucesso
	End If	'Finaliza Se valor for igual a "ok"


	'Remove espa�os da esquerda e da direita da Id do usu�rio e verifica se � igual a 0
	if ltrim(rtrim(UsuarioID)) = 0 Then
		'Vari�veis ficam vazias
		Nome  = ""
		Login  = ""
		Email = ""
		Senha = ""
		ConfirmaSenha = ""
	Else
		'Inicia Recordset
		Set Rs = Server.CreateObject("ADODB.RecordSet")
		'Busca campos que contenham Id do usu�rio
		sql = "SELECT * FROM tbl_usuario_adm WHERE UsuarioID = " & UsuarioID
		'Executa
		Rs.Open sql, conexao
		'Se encontrar registro
		If Not Rs.Eof Then
			'Vari�veis recebem valores
			Nome  = Rs("Nome")
			Email = Rs("Email")
			Login = Rs("Login")
			Status = Rs("Status")
		End If	'Finaliza Se encontrar registro
	End If	'Finaliza Remove espa�os da esquerda e da direita da Id do usu�rio e verifica se � igual a 0
%>

</head>

<body>

<div id="global">

	<!-- #include file="../inc/header.asp"-->

	<!-- #include file="../inc/menu.asp"-->

    <!-- DIV CONTEUDO -->
    <div id="content">
    
        <h2><span></span>Usu&aacute;rios | Visualizar</h2>
        <div class="content_divisao"></div>      
        
        <a href="lista.asp?lista=todos&amp;limpa=ok" class="content_link1">Listar Usu&aacute;rios</a></td>
        <i><%= delete %></i>

        <div class="content_divisao"></div>              
    
		<div class="form_entry">
                <div class="form_title"><h3>Nome</h3></div>
                <div class="form_textarea"><%= Nome %></div>
        </div>
        
        <div class="form_entry">
                <div class="form_title"><h3>Email</h3></div>
                <div class="form_textarea"><%= Email %></div>
        </div>
        
        <div class="form_entry">
                <div class="form_title"><h3>Login</h3></div>
                <div class="form_textarea"><%= Login %></div>
        </div>
        
		<div class="form_entry">
            <div class="form_title"><h3>Senha</h3></div>
            <input type="password" name="txtSenha" id="txtSenha" maxlength="255" disabled="disabled" size="50" value="<%= Senha %>" class="form_textarea" />
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
        <input name="submit" type="submit" value="Alterar" class="form_bt_big" />
                  
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