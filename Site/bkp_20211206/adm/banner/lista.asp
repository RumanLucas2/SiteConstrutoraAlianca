<!-- #include file="../inc/global.asp"-->  
<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/logado.asp"-->
<!-- #include file="inc.asp"-->
<!-- #include file="../inc/anti_injection.asp"-->
  
</head>

<%	
	'Atribui valores do endereço Http
	Lista = anti_inje(Request.QueryString("lista"))
	Ordena = anti_inje(Request.QueryString("ordena"))
	Limpa = anti_inje(Request.QueryString("limpa"))
	Page = anti_inje(Request.QueryString("Page"))
	delete = anti_inje(Request.QueryString("delete"))
	'Verifica Metodo POST
	if Request.ServerVariables("REQUEST_METHOD") = "POST" Then
		Session("Busca") = anti_inje(Trim(Request.Form("Busca")))
	End if 'Finaliza Verifica Metodo POST
	
	'Se variavel delete do Http possuir "ok"
	if delete = "ok" Then 'Se possuir valor ok
		delete = "Registro(s) Excluído(s) com Sucesso!" 'delete recebe mensagem
	Else 
		if delete = "no" then 'Se possuir valor "no"
			delete = "Nenhum registro selecionado!" 'delete recebe mensagem
		end if	'Finaliza Se possuir valor "no"
	End if 'Finaliza Se possuir valor ok

	'Se lista for vazia
	if Lista = "" Then
		Num = 10 'Variavel Num recebe 25 -> Lista 25 registros
	Else
		Num = 5000 'Variavel Num recebe 5000 -> Lista 5000 valores
	End if 'Finaliza Se lista for vazia
	
	'Se limpa for "ok"
	if Limpa = "ok" Then
		Session("Busca") = "" 'Sessão de  Busca recebe valor nulo
	End if	'Finaliza Se limpa for "ok"
	
	'Se Sessão Busca for vazia
	if Session("Busca") = "" Then
		Nome_SQL = ""	'Variavel Nome_SQL recebe valor nulo
	Else
		'Monta variável de filtro para SQL futura
		Nome_SQL = "WHERE nome LIKE '%" & Session("Busca") & "%' "
	End if	'Finaliza Se Sessão Busca for vazia
	
	'Se variável Ordena for vazia
	if Ordena = "" Then
		Ordena = "data_cadastro DESC"	'Variável Ordena recebe valor "Nome"
	End if 'Finaliza Se variável Ordena for vazia
	
	'Inicia Recordset
	Set Rs = Server.CreateObject("ADODB.RecordSet")

	'Set do ponteiro do recordset
	RS.CursorLocation = 3

	'Numero de registro a exibir-se
	Rs.PageSize = Num
	
	'Inicia comando de busca
	sql =	"SELECT * FROM tbl_banner " & Nome_SQL & " ORDER BY " & Ordena & ""
	'Executa
	Rs.Open	sql, conexao, 3, 3
	
	'Se variável Page for vazia ou não for numérica
	if Page = "" Or Not IsNumeric(Page) Then
		Page = 1	'Variável Page recebe valor "1"
	Else
		Page = CInt(Page)	'Variável Page recebe Variável convertida para tipo Double
		if Page < 1 Then	'Se página for menor que 1
			Page = 1	'Variável Page recebe valor "1"
		Else
			if Page > Rs.PageCount Then	'Se variável Page for maior que Total de páginas do Recordset
				Page = Rs.PageCount 	'Variável Page recebe Total de páginas do Recordset
			end if
		End if	'Finaliza Se página for menor que 1
	End if	'Finaliza Se variável Page for vazia ou não for numérica

%>

<body>

<div id="global">

	<!-- #include file="../inc/header.asp"-->

	<!-- #include file="../inc/menu.asp"-->

    <!-- DIV CONTEUDO -->
    <div id="content">
    
        <h2><span></span>Banners</h2>
        <div class="content_divisao"></div>      
        
        <a href="frm_add.asp?lista=todos&amp;limpa=ok" class="content_link1">Novo Banner</a> | 
        <a href="lista.asp?lista=todos&amp;limpa=ok" class="content_link1">Listar Todos</a>

        <form name="formbusca" action="lista.asp?lista=todos" method="post" class="form_style1">
             <div class="content_title1 oswald">BUSCA&nbsp;</div>
             <input type="Text" name="Busca" value="<%= Session("Busca") %>" />
             <input name="submit" type="submit" value="Procurar" />
        </form>

		<%  if(delete <> "") then
				Response.Write("<div class='content_divisao'></div>")
				Response.Write(delete)
			end if
		%>

        <div class="content_divisao"></div>              
        
        <form name="selecao" id="selecao" action="act_exc.asp" method="POST">
        
       	<table class="content_table">
            <tr>
                <th><div class="content_table_title_arrow"></div><strong>Foto</strong></th>
                <th><div class="content_table_title_arrow"></div><a href="lista.asp?Ordena=id_empreendimento"><strong>Empreendimento</strong></a></th>
                <th><div class="content_table_title_arrow"></div><a href="lista.asp?Ordena=datacadastro"><strong>Cadastro</strong></a></th>
                <th><div class="content_table_title_arrow"></div><a href="lista.asp?Ordena=status"><strong>Status</strong></a></th>
                <th colspan="3"><div class="content_table_title_arrow"></div><a href="lista.asp?Ordena=destaque"><strong>Destaque</strong></a></th>
            </tr>
        
		<%
            'Se não for encontrado nenhum registro
            If Rs.EOF Then
        %>
        
        <tr>
        	<td colspan="4"><h3>Nenhum registro encontrado.</h3></td>
        </tr>

        <%
			Else
				
				Rs.AbsolutePage = Page
				Do While Not Rs.EOF AND Rs.AbsolutePage = Page
				
				id = Rs("id_banner")
				id_empreendimento = Rs("id_empreendimento")
				foto = Rs("foto")
		%>
        
        <tr class="content_table_line1">
            
            <td style="padding:0px; margin:0px;">
            	<img src="<%= pastav & "\" & id & "\th\" & foto %>" alt="" name="Thumb" width="50" id="Thumb">
            </td>
            
            <td onClick="location.href='frm_vis.asp?id=<%=Rs("id_banner")%>'">
            	<%
					sqlEspetaculo = "SELECT nome FROM tbl_empreendimento WHERE id_empreendimento = " & id_empreendimento
					Set RsEspetaculo = conexao.Execute(sqlEspetaculo)
					
					if not RsEspetaculo.EOF then
					
					nome_espetaculo = RsEspetaculo("nome")
				%>
                	<%=nome_espetaculo%>
                    
            	<% end if %>
            </td> 
		
            <td>
           		<%
					dataCad = Rs("data_cadastro")
					strDataCad = Day(dataCad) & "/" & Month(dataCad) & "/" & Year(dataCad)
					response.write(strDataCad)
				%>
            </td>
           
           	<td>
          		<% if Rs("status") = 1 then %>
               		<a href="change_on.asp?id=<%= Rs("id_banner") %>"><span class="icon on"></span></a>
                <% else %>
                	<a href="change_off.asp?id=<%= Rs("id_banner") %>"><span class="icon off"></span></a>
                <% end if %>
			</td>
            
            <td>
          		<% if Rs("destaque") = 1 then %>
               		<a href="destaque_on.asp?id=<%= Rs("id_banner") %>"><span class="icon on"></span></a>
                <% else %>
                	<a href="destaque_off.asp?id=<%= Rs("id_banner") %>"><span class="icon off"></span></a>
                <% end if %>
			</td>
            
            <td>
                <a href="frm_edt.asp?edit=ok&id=<%= Rs("id_banner") %>" class="icon edit"><span class="displace">Editar</span></a>
                <a href="frm_vis.asp?id=<%=Rs("id_banner")%>" class="icon visualize"><span class="displace">Visualizar</span></a>
            </td>
         	
            <td align="right">
            	<input type="Checkbox" name="excluirid" value="<%= Rs("id_banner") %>" class="styled" />
                <!-- class="styled" -->
            </td>
            
       	</tr>
        
		<%
            Rs.MoveNext
        	Loop
        %>

        </table>
        
        <div style="margin-top: 25px">
            <a onMouseUp="javascript: CheckTodos()" class="content_link1">Selecionar Todos</a> | 
            <a onMouseUp="javascript: Excluir();" class="content_link1">Excluir</a>
    	</div>
        
        </form>

        <div class="content_divisao"></div>      

		<div style="width: 100%; text-align: center;">
        <form name="List" action="" method="GET">
            <% If Page <> 1 Then %>
            <a class="entlink" href="javascript: ChangePage('F');"><span class="icon first"></span></a><a class="entlink" href="javascript: ChangePage('P');"><span class="icon previous"></span></a>
            <% Else %>
            <span class="icon first_off"></span><span class="icon previous_off"></span>
            <% End If %>
            <span style="margin: 0px 10px;">P&Aacute;GINA <%= Page %> DE <%= Rs.PageCount %></span>
            <% If Page <> Rs.PageCount Then %>
            <a class="entlink" href="javascript: ChangePage('N');"><span class="icon next"></span></a><a class="entlink" href="javascript: ChangePage('L');"><span class="icon last"></span></a>
            <% Else %>
            <span class="icon next_off"></span><span class="icon last_off"></span>
            <% End If %>
            <input type="hidden" name="Pagina" value="<%= Page %>" id="Hidden1" />
            <input type="hidden" name="UltimaPagina" value="<%= Rs.PageCount %>" id="Hidden2" />
        </form>
        </div>
        
        <%
            End If
        %>
        
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