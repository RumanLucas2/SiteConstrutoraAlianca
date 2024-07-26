<!-- #include file="../inc/global.asp"-->  
<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/logado.asp"-->
<!-- #include file="../inc/fn.asp"-->
<!-- #include file="inc.asp"-->

<%
	id_galeria = anti_inje(request.QueryString("id_galeria"))
	
	'Variável msg recebe valor do Http
	msg = Request.QueryString("msg")

	'Se msg tiver valor "ok"
	if msg = "ok" Then
		msg = "Cadastro efetuado com sucesso!"	'Variável recebe mensagem de sucesso
	Else if msg = "" then
			msg = ""	'msg se mantem vazia
		End if	'Finaliza Se msg tiver valor "ok"
	End if
	
	'Inicia Recordset
	Set RsG = Server.CreateObject("ADODB.RecordSet")
	sqlG =	"SELECT * FROM tbl_galeria WHERE id_galeria = " & id_galeria
	'Executa
	RsG.Open sqlG, conexao
	
	IF NOT RsG.eof THEN
		nome_galeria = RsG("nome")
	END IF
	
	RsG.Close
	Set RsG = nothing
	
	'Inicia Recordset
	Set Rs = Server.CreateObject("ADODB.RecordSet")
	sql =	"SELECT * FROM tbl_galeria_foto WHERE id_galeria = " & id_galeria & " ORDER BY id_foto ASC"
	'Executa
	Rs.Open	sql, conexao
	
%>

</head>

<body>

<div id="global">

	<!-- #include file="../inc/header.asp"-->

	<!-- #include file="../inc/menu.asp"-->

    <!-- DIV CONTEUDO -->
    <div id="content">
    
        <h2><span></span>Galeria de Foto | Fotos / <%=nome_galeria%></h2>
        <div class="content_divisao"></div>      
        
        <a href="lista.asp?lista=todos&amp;limpa=ok" class="content_link1">Listar Galerias</a></td>
        <i><%= msg %></i>

        <div class="content_divisao"></div>              
    
          <form action="act_add_fot.asp?id_galeria=<%=id_galeria%>" method="post" enctype="multipart/form-data" name="formulario" onSubmit="return valida_foto(this);">
    
		<div class="form_entry">
            <div class="form_title"><h3>Nome</h3></div>
            <input type='text' name='txtNome' maxlength='255' size='50' value="" class="form_textarea" />
        </div>
        <div class="form_entry">
            <div class="form_title"><h3>Foto</h3></div>
            <div class="form_textarea">
            <input name="txtArquivo" type="file" id="txtArquivo" size="36">
            </div>
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
        <input name="submit" type="submit" value="Adicionar" onClick="document.formulario.action='act_add_fot.asp?id_galeria=<%=id_galeria%>&txtStatus='+document.formulario.txtStatus.value;document.formulario.submit()" class="form_bt_big" />
                  
    </form>
     
     <p style="clear:both; padding-top:15px"></p>

     <form name="selecao" id="selecao" action="act_exc_fot.asp" method="POST">
        <table class="content_table">
            <tr>
                <th><div class="content_table_title_arrow"></div><strong>FOTO</strong></th>
                <th><div class="content_table_title_arrow"></div><strong>LEGENDA</strong></th>
                <th colspan="3"><div class="content_table_title_arrow"></div><strong>Status</strong></th>
            </tr>
            
            <%
		  		'Se não for encontrado nenhum registro
				If Rs.EOF Then
			%>
          
          <tr>
            <td height="60" colspan="2" class="txt_cms_erro">Nenhum registro encontrado!</td>
          </tr>
          
		  <%
			Else
				
				Do While Not Rs.EOF
				
				Nome 		= Rs("nome")
				Arquivo		= Rs("arquivo")
				Status		= Rs("status")
				ID			= Rs("id_foto")
			%>
            
          <tr>
            <td align="left">
			<% if Arquivo <> "" then %>
            <img name="imagem" src="<% response.write(pastav & id_galeria & "/" & ID & "/th/" & Arquivo) %>" style="border:8px solid #DADADA;"  />
			<% end if %>
            </td>
            <td><%=Nome%></td>
            <td><% if Status = "1" then response.write("Ativo") else response.write("Inativo") end if%></td>
            <td><a href="frm_edt_fot.asp?id_galeria=<%=id_galeria%>&id_foto=<%=ID%>" class="icon edit"><span class="displace">Editar</span></a></td>
            <td><a href="act_exc_fot.asp?id_galeria=<%=id_galeria%>&id_foto=<%=ID%>" class="icon delete"><span class="displace">Excluir</span></a></td>
          </tr>
          <%
			Rs.MoveNext
			Loop
			End if			
		%>
            
        </table>
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