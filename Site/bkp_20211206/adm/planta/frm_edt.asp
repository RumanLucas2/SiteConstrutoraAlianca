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
		
	'Variável recebe valor Http
	msg = Request.QueryString("msg")
	'Se valor for igual a "ok"
	If msg = "ok" Then
		msg = "Registro Alterado com sucesso!"	'Variável recebe mensagem de sucesso
	End If	'Finaliza Se valor for igual a "ok"


	'Remove espaços da esquerda e da direita da Id do usuário e verifica se é igual a 0
	if ltrim(rtrim(id_galeria)) = 0 Then
		'Variáveis ficam vazias
		Nome  = ""
	Else
		'Inicia Recordset
		Set Rs = Server.CreateObject("ADODB.RecordSet")
		'Busca campos que contenham Id do usuário
		sql = "SELECT * FROM tbl_galeria_planta WHERE id_galeria = " & id_galeria
		'Executa
		Rs.Open sql, conexao
		'Se encontrar registro
		If Not Rs.Eof Then
			'Variáveis recebem valores
			Nome  = Rs("nome")
			Espetaculo = Rs("id_empreendimento")
			Status = Rs("Status")
		End If	'Finaliza Se encontrar registro
	End If	'Finaliza Remove espaços da esquerda e da direita da Id do usuário e verifica se é igual a 0
%>

</head>

<body>

<div id="global">

	<!-- #include file="../inc/header.asp"-->

	<!-- #include file="../inc/menu.asp"-->

    <!-- DIV CONTEUDO -->
    <div id="content">
    
        <h2><span></span>Galeria de Plantas | Editar</h2>
        <div class="content_divisao"></div>      
        
        <a href="lista.asp?lista=todos&amp;limpa=ok" class="content_link1">Listar Galerias</a></td>
        <i><%= msg %></i>

        <div class="content_divisao"></div>              
    
        <form name="formulario" action="act_edt.asp?id_galeria=<%= id_galeria %>" method='post'>
    	
        <form action="act_edt.asp?id=<%=id%>" method="post" enctype="multipart/form-data" name="formulario" onSubmit="return valida_noticia_edt(this);">
        
        <div class="form_entry">
            <div class="form_title"><h3>Empreendimentos</h3></div>
           	<select name="txtEspetaculo">
              <%
			  	sqlEspetaculo = "SELECT id_empreendimento, nome FROM tbl_empreendimento WHERE status = 1"
				Set RsEspetaculo = conexao.execute(sqlEspetaculo)
				
				if Not RsEspetaculo.EOF then
					
					Do While Not RsEspetaculo.EOF
					id_empreendimento = RsEspetaculo("id_empreendimento")
					nome_espetaculo = RsEspetaculo("nome")
			  %>
              <option value="<%=id_empreendimento%>" <% if  Espetaculo = id_empreendimento then response.write("selected") end if %>><%=nome_espetaculo%></option>
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