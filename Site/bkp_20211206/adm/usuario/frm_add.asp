<!-- #include file="../inc/global.asp"-->  
<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/logado.asp"-->

<%
	'Variável msg recebe valor do Http
	msg = Request.QueryString("msg")

	'Se msg tiver valor "ok"
	if msg = "ok" Then
		msg = "Cadastro efetuado com sucesso!"	'Variável recebe mensagem de sucesso
	Else if msg = "" then
			msg = ""	'msg se mantem vazia
		End if	'Finaliza Se msg tiver valor "ok"
	End if
	
	'Variável msg recebe valor do Http
	erro = Request.QueryString("erro")

	'Se msg tiver valor "ok"
	if erro = "sim" Then
		Nome		=	Session("nome")
		Email		=	Session("email")
		Senha		=	Session("senha")
		Status		=	Session("status")
	else
		Session("nome")		= ""
		Session("email")	= ""
		Session("senha")	= ""
		Session("status")	= ""
	end if
%>

</head>

<body>

<div id="global">

	<!-- #include file="../inc/header.asp"-->

	<!-- #include file="../inc/menu.asp"-->

    <!-- DIV CONTEUDO -->
    <div id="content">
    
        <h2><span></span>Clientes | Adicionar</h2>
        <div class="content_divisao"></div>      
        
        <a href="lista.asp?lista=todos&amp;limpa=ok" class="content_link1">Listar Todos</a></td>
        <i><%= msg %></i>

        <div class="content_divisao"></div>
        
    	<form action="act_add.asp?id=<%=id%>" method="post" name="formulario" onSubmit="return valida_noticia(this);">
		
        <div class="form_entry">
            <div class="form_title"><h3>Nome</h3></div>
            <input type="text" name="txtNome" maxlength="255" size="50" value="<%=Nome%>" class="form_textarea" />
        </div>
        
        <div class="form_entry">
            <div class="form_title"><h3>E-mail</h3></div>
            <input type="text" name="txtEmail" maxlength="255" size="50" value="<%=Email%>" class="form_textarea" />
        </div>
        
        <div class="form_entry">
            <div class="form_title"><h3>Senha</h3></div>
            <input type="text" name="txtSenha" maxlength="255" size="50" value="<%=Senha%>" class="form_textarea" />
        </div>
                
    	<div class="form_entry">
            <div class="form_title"><h3>Status</h3></div>
            <div class="form_textarea">
            <select name="txtStatus">
              <option value="1" <% if Status = 1 then response.write("selected") end if %>>ON</option>
              <option value="0" <% if Status = 0 then response.write("selected") end if %>>OFF</option>
            </select>
            </div>
        </div>

        <div class="content_bt_big"><a href="javascript:history.go(-1)">VOLTAR</a></div>
        
        <input type="submit" name="submit" value="Adicionar" class="form_bt_big" />
    
    </form>
            
    </div>
    
    <!-- DIV FOOTER -->
    <div id="rodape"><!--#include file="../inc/footer.asp"--></div>
    
</div>

</body>
</html>

<%
	conexao.close
	Set conexao = nothing
%>