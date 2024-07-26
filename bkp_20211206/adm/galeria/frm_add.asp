<!-- #include file="../inc/global.asp"-->  
<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/logado.asp"-->

<%
	'Id do usuário retirado do Http
	id_galeria = Request.QueryString("id_galeria")
	'Se Id do usuário for vazia ou nulo ou não for numérico
	if id_galeria = "" Or IsNull(id_galeria) Or Not IsNumeric(id_galeria) Then
		id_galeria = 0	'Variável da Id do usuário recebe 0
	End if	'Finaliza Se Id do usuário for vazia ou nulo ou não for numérico
		
	'Variável msg recebe valor do Http
	msg = Request.QueryString("msg")

	'Se msg tiver valor "ok"
	if msg = "ok" Then
		msg = "Cadastro efetuado com sucesso!"	'Variável recebe mensagem de sucesso
	Else
		if msg = "err" Then	'Se msg tiver valor "err"
			msg = "P&uacute;blico j&aacute; cadastrado!"	'Variável recebe mensagem de erro
		Else
			msg = ""	'msg se mantem vazia
		End if	'Finaliza Se msg tiver valor "err"
	End if	'Finaliza Se msg tiver valor "ok"
	
	'Remove espaços da esquerda e da direita da Id do usuário e verifica se é igual a 0
	if ltrim(rtrim(id_galeria)) = 0 Then
		'Variáveis ficam vazias
		Nome  = ""
	Else
		'Busca campos que contem a Id do usuario
		SQLSelect = "SELECT * FROM tbl_galeria WHERE id_galeria = " & id_galeria
		'Executa
		Set Rs = conexao.Execute(SQLSelect)
		'Se for encontrado usuário
		if Not Rs.Eof Then
			'Variáveis recebem valores do Recordset
			Nome  = Rs("Nome")
			Status = Rs("Status")
		End if	'Finaliza Se for encontrado usuário
	End if	'Finaliza Remove espaços da esquerda e da direita da Id do usuário e verifica se é igual a 0
%>

<script type="text/javascript">
	function validarForm(formulario,evento)
	{
	
		if (formulario.txtEspetaculo.value==""){
			alert("Selecione um Empreendimento");
			formulario.txtEspetaculo.focus();
			return false;
		}
		
		if ( confirm ( 'Confirma a inserção dessa galeria?' )) { return true; } else { return false; }
	}
</script>

</head>

<body>

<div id="global">

	<!-- #include file="../inc/header.asp"-->

	<!-- #include file="../inc/menu.asp"-->

    <!-- DIV CONTEUDO -->
    <div id="content">
    
        <h2><span></span>Galeria de Foto | Adicionar</h2>
        <div class="content_divisao"></div>      
        
        <a href="lista.asp?lista=todos&amp;limpa=ok" class="content_link1">Listar Galerias</a></td>
        <i><%= msg %></i>

        <div class="content_divisao"></div>              
    
        <form name="formulario" action="act_add.asp" method="post" onSubmit="return validarForm(this,event)">
    	 
        <div class="form_entry">
            <div class="form_title"><h3>Empreendimentos</h3></div>
           	<select name="txtEspetaculo">
              <option value="">Selecione o Empreendimento</option>              
              <%
			  	sqlEspetaculo = "SELECT id_empreendimento, nome FROM tbl_empreendimento WHERE status = 1"
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
            <input type="text" name="txtNome" id="txtNome" maxlength="255" size="50" value="<%= Nome %>" class="form_textarea" />
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