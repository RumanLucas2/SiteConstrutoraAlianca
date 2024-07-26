<!-- #include file="../inc/global.asp"-->  
<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/logado.asp"-->

<%
	'Id do usuário retirado do Http
	id = Request.QueryString("id")
	'Se Id do usuário for vazia ou nulo ou não for numérico
	if id = "" Or IsNull(id) Or Not IsNumeric(id) Then
		id = 0	'Variável da Id do usuário recebe 0
	End if	'Finaliza Se Id do usuário for vazia ou nulo ou não for numérico

	'Variável msg recebe valor do Http
	msg = Request.QueryString("msg")

	'Se msg tiver valor "ok"
	if msg = "ok" Then
		msg = "Cadastro alterado com sucesso!"	'Variável recebe mensagem de sucesso
	Else if msg = "" then
			msg = ""	'msg se mantem vazia
		End if	'Finaliza Se msg tiver valor "ok"
	End if
	
	'Remove espaços da esquerda e da direita da Id do usuário e verifica se é igual a 0
	if ltrim(rtrim(id)) = 0 Then
		'Variáveis ficam vazias
		Nome  		= ""
		Email  		= ""
		Senha  		= ""
		DataCad		= ""
		Status		= ""
	Else
		'Inicia Recordset
		Set Rs = Server.CreateObject("ADODB.RecordSet")
		'Busca campos que contenham Id do usuário
		sql = "SELECT * FROM tbl_usuario WHERE id_usuario = " & id
		'Executa
		Rs.Open sql, conexao
		'Se encontrar registro
		If Not Rs.Eof Then
			'Variáveis recebem valores
			Nome  		= Rs("nome")
			Email  		= Rs("email")
			Senha  		= Rs("senha")
			DataCad		= Rs("data_cadastro")
			Status		= Rs("status")
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
    
        <h2><span></span>Cliente | Editar</h2>
        <div class="content_divisao"></div>      
        
        <a href="lista.asp?lista=todos&amp;limpa=ok" class="content_link1">Listar Todos</a></td>
        <i><%= msg %></i>

        <div class="content_divisao"></div>              
    
        <form action="act_edt.asp?id=<%=id%>" method="post" name="formulario" onSubmit="return valida_noticia_edt(this);">
    
		<div class="form_entry">
            <div class="form_title"><h3>Nome</h3></div>
            <input type="text" name="txtNome" maxlength="255" value="<%=Nome%>" class="form_textarea" />
        </div>
        
        <div class="form_entry">
            <div class="form_title"><h3>E-mail</h3></div>
            <input type="text" name="txtEmail" maxlength="255" value="<%=Email%>" class="form_textarea" />
        </div>
        
        <div class="form_entry">
            <div class="form_title"><h3>Senha</h3></div>
            <input type="text" name="txtSenha" maxlength="255" value="<%=Senha%>" class="form_textarea" />
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
        
         <input name="submit" type="submit" value="Alterar" class="form_bt_big" />
                  
    </form>
            
    </div>
    
    <!-- DIV FOOTER -->
    <div id="rodape"><!--#include file="../inc/footer.asp"--></div>
    
</div>

</body>
</html>
<%
	Rs.Close
	Set Rs = Nothing
	conexao.close
	Set conexao = nothing
%>