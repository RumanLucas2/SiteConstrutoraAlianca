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
	
	'Id do usuário retirado do Http
	id_foto = Request.QueryString("id_foto")
	'Se Id do usuário for vazia ou nulo ou não for numérico
	if id_foto = "" Or IsNull(id_foto) Or Not IsNumeric(id_foto) Then
		id_foto = 0	'Variável da Id do usuário recebe 0
	End if	'Finaliza Se Id do usuário for vazia ou nulo ou não for numérico
	
	'Variável recebe valor Http
	msg = Request.QueryString("msg")
	'Se valor for igual a "ok"
	If msg = "ok" Then
		msg = "Registro Alterado com sucesso!"	'Variável recebe mensagem de sucesso
	End If	'Finaliza Se valor for igual a "ok"

	'Inicia Recordset
	Set Rs = Server.CreateObject("ADODB.RecordSet")
	'Busca campos que contenham Id do usuário
	sql = "SELECT * FROM tbl_galeria WHERE id_galeria = " & id_galeria
	'Executa
	Rs.Open sql, conexao
	'Se encontrar registro
	If Not Rs.Eof Then
		'Variáveis recebem valores
		Nome  = Rs("nome")
	End If	'Finaliza Se encontrar registro
	
		'Inicia Recordset
	Set RsF = Server.CreateObject("ADODB.RecordSet")
	'Busca campos que contenham Id do usuário
	sqlF = "SELECT * FROM tbl_galeria_foto WHERE id_foto = " & id_foto
	'Executa
	RsF.Open sqlF, conexao
	'Se encontrar registro
	If Not RsF.Eof Then
		'Variáveis recebem valores
		NomeF  	= RsF("nome")
		Status	= RsF("status")
	End If	'Finaliza Se encontrar registro

%>

</head>

<body>

<div id="global">

	<!-- #include file="../inc/header.asp"-->

	<!-- #include file="../inc/menu.asp"-->

    <!-- DIV CONTEUDO -->
    <div id="content">
    
        <h2><span></span><%=Nome%> | Editar Foto</h2>
        <div class="content_divisao"></div>      
        
        <a href="lista.asp?lista=todos&amp;limpa=ok" class="content_link1">Listar Categorias</a></td>
        <i><%= msg %></i>

        <div class="content_divisao"></div>              
    
        <form name="formulario" action="act_edt_fot.asp?id_galeria=<%=id_galeria%>&id_foto=<%=id_foto%>" method='post' onSubmit="return valida_secao(this);">
    
		<div class="form_entry">
            <div class="form_title"><h3>Nome</h3></div>
            <input type="text" name="txtNome" id="txtNome" maxlength="255" size="50" value="<%= NomeF %>" class="form_textarea" />
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