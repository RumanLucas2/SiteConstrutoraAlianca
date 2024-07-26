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
		Status		=	Session("status")
	else
		Session("nome")			= ""
		Session("status")		= ""
	end if
%>

<script type="text/javascript">
	function validarForm(formulario,evento)
	{
	
		if (formulario.txtEspetaculo.value==""){
			alert("Selecione um Empreendimento");
			formulario.txtEspetaculo.focus();
			return false;
		}
		
		if ( confirm ( 'Confirma a inserção do banner?' )) { return true; } else { return false; }
	}
</script>

</head>

<body>

<div id="global">

	<!-- #include file="../inc/header.asp"-->

	<!-- #include file="../inc/menu.asp"-->

    <!-- DIV CONTEUDO -->
    <div id="content">
    
        <h2><span></span>Banner | Adicionar</h2>
        <div class="content_divisao"></div>      
        
        <a href="lista.asp?lista=todos&amp;limpa=ok" class="content_link1">Listar Todos</a></td>
        <i><%= msg %></i>

        <div class="content_divisao"></div>
        
    	<form action="act_add.asp?id=<%= id %>" method="post" enctype="multipart/form-data" name="formulario" onSubmit="return validarForm(this,event)">
        
        <div class="form_entry">
            <div class="form_title"><h3>Empreendimentos</h3></div>
           	<select name="txtEmpreendimento">
              <option value="">Selecione o Empreendimento</option>              
              <%
			  	sqlEspetaculo = "SELECT id_empreendimento, nome FROM tbl_empreendimento"
				Set RsEspetaculo = conexao.execute(sqlEspetaculo)
				
				if Not RsEspetaculo.EOF then
					
					Do While Not RsEspetaculo.EOF
					id_empreendimento = RsEspetaculo("id_empreendimento")
					nome_espetaculo = RsEspetaculo("nome")
			  %>
              <option value="<%=id_empreendimento%>"><%=nome_espetaculo%></option>
              <%
			  		RsEspetaculo.MoveNext
					Loop
				End if
			  %>
            </select>
        </div>
        
        <div class="form_entry">
            <div class="form_title"><h3>Nome</h3></div>
            <input type="text" name="txtNome" maxlength="255" size="50" value="<%= Nome %>" class="form_textarea" />
        </div>
	
    	<div class="form_entry">
            <div class="form_title"><h3>Imagem</h3></div>
            <div class="form_textarea">
            	<input name="txtArquivo" type="file" id="txtArquivo" size="36" />
            </div>
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
        
        <input name="submit" type="submit" value="Adicionar" class="form_bt_big" onClick="document.formulario.action='act_add.asp?id=<%=id%>&foto='+document.formulario.txtArquivo.value;document.formulario.submit()">
                  
    </form>
            
    </div>
    
    <!-- DIV FOOTER -->
    <div id="rodape"><!--#include file="../inc/footer.asp"--></div>
    
</div>

</body>
</html>

<%
	conexao.Close
	Set conexao = Nothing
%>