<!-- #include file="../inc/global.asp"-->  
<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/logado.asp"-->
<!-- #include file="../inc/anti_injection.asp"-->

<%
	'Id do usuário retirado do Http
	id = Request.QueryString("id")
	'Se Id do usuário for vazia ou nulo ou não for numérico
	if id = "" Or IsNull(id) Or Not IsNumeric(id) Then
		id = 0	'Variável da Id do usuário recebe 0
	End if	'Finaliza Se Id do usuário for vazia ou nulo ou não for numérico

	sql = "SELECT id_empreendimento, nome FROM tbl_empreendimento WHERE status = 1 ORDER BY nome ASC"
	set Rs = conexao.execute(sql)

	ativo = false
%>

</head>

<body>	

<div id="global">

	<!-- #include file="../inc/header.asp"-->

	<!-- #include file="../inc/menu.asp"-->

    <!-- DIV CONTEUDO -->
    <div id="content">
    
        <h2><span></span>Empreendimentos | Relacionar</h2>
        <div class="content_divisao"></div>      
            
    	<form name="selecao" id="selecao" action="act_rel.asp?id=<%=id%>" method="POST">
                
        <table class="content_table">
            <tr>
                <th><div class="content_table_title_arrow"></div><strong>Empreendimentos</strong></th>
            </tr>
        	
			<%
				'Se não encontrar registro
				if Rs.Eof then
			%>
        
            <tr>
                <td colspan="6"><h3>Nenhum registro encontrado.</h3></td>
            </tr>

			<%
                else
                    
                    Do While Not Rs.EOF
                    
					ativo = false
					
                    id_empreendimento 	= Rs("id_empreendimento")
                    nomeEmp 			= Rs("nome")
					
					sqlVerify = "SELECT id FROM tbl_empreendimento_usuario WHERE id_usuario = " & id & " AND id_empreendimento = "& id_empreendimento &""
					set RsVerify = conexao.execute(sqlVerify)
					
					if not RsVerify.EOF then
						ativo = true
					else
						ativo = false
					end if
			%>                            
            <tr class="content_table_line1">
                <td><%=nomeEmp%></td>            
                <td align="right">
                	<input type="Checkbox" name="gravarid" class="styled" id="<%=id_empreendimento%>" value="<%=id_empreendimento%>" <% if (ativo = true) then %>checked="checked" <% end if %> />
                </td>
            </tr>
            
			<%
                	Rs.MoveNext
                	loop
                end if
            %>

        </table>
        
        <div style="margin-top: 25px">
            <a onMouseUp="javascript: CheckTodos()" class="content_link1">Selecionar Todos</a> | 
            <a onMouseUp="javascript: UncheckTodos()" class="content_link1">Limpar Todos</a>
		</div>
        
        <div class="content_bt_big"><a href="javascript:history.go(-1)">VOLTAR</a></div>
        
        <input type="submit" name="submit" value="Gravar" class="form_bt_big" />
        
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