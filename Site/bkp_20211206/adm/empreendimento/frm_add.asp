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
	
		if (formulario.txtTipo.value==""){
			alert("Selecione uma Tipo de espetaculo");
			formulario.txtTipo.focus();
			return false;
		}
		
		if ( confirm ( 'Confirma a inserção desse empreendimento?' )) { return true; } else { return false; }
	}
</script>

</head>

<body>

<div id="global">

	<!-- #include file="../inc/header.asp"-->

	<!-- #include file="../inc/menu.asp"-->

    <!-- DIV CONTEUDO -->
    <div id="content">
    
        <h2><span></span>Empreendimento | Adicionar</h2>
        <div class="content_divisao"></div>      
        
        <a href="lista.asp?lista=todos&amp;limpa=ok" class="content_link1">Listar Todos</a></td>
        <i><%= msg %></i>

        <div class="content_divisao"></div>
        
    	<form action="act_add.asp" method="post" name="formulario" onSubmit="return validarForm(this,event)">
        
        <div class="form_entry">
            <div class="form_title"><h3>Tipo de Empreendimento</h3></div>
           	<select name="txtTipo">
              <option value="">Selecione o Tipo</option>              
              <%
			  	sqlTipo = "SELECT id_tipo, nome FROM tbl_empreendimento_tipo WHERE status = 1 ORDER BY nome ASC"
				Set RsTipo = conexao.execute(sqlTipo)
				
				if Not RsTipo.EOF then
					
					Do While Not RsTipo.EOF
					id_tipo = RsTipo("id_tipo")
					nome_tipo = RsTipo("nome")
			  %>
              <option value="<%=id_tipo%>"><%=nome_tipo%></option>
              <%
			  		RsTipo.MoveNext
					Loop
				End if
			  %>
            </select>
        </div>
        
        <div class="form_entry">
            <div class="form_title"><h3>Fase de Empreendimento</h3></div>
           	<select name="txtFase">
              <option value="">Selecione a Fase</option>              
              <%
			  	sqlFase = "SELECT id_fase, nome FROM tbl_empreendimento_fase WHERE status = 1 ORDER BY nome ASC"
				Set RsFase = conexao.execute(sqlFase)
				
				if Not RsFase.EOF then
					
					Do While Not RsFase.EOF
					id_fase = RsFase("id_fase")
					nome_fase = RsFase("nome")
			  %>
              <option value="<%=id_fase%>"><%=nome_fase%></option>
              <%
			  		RsFase.MoveNext
					Loop
				End if
			  %>
            </select>
        </div>
                
        <div class="form_entry">
            <div class="form_title"><h3>Nome</h3></div>
            <input type="text" name="txtNome" maxlength="255" value="<%=nome%>" class="form_textarea" />
        </div>

		<div class="form_entry">
            <div class="form_title"><h3>Frase</h3></div>
            <input type="text" name="txtFrase" maxlength="255" value="<%=frase%>" class="form_textarea" />
        </div>
        
        <div class="form_entry">
            <div class="form_title"><h3>Conceito</h3></div>
            <textarea name="txtConceito" wrap="soft" id="txtConceito" class="form_textarea"><%=conceito%></textarea>       
        </div>
        
        <div class="form_entry">
            <div class="form_title"><h3>Descrição</h3></div>
            <textarea name="txtDescricao" wrap="soft" id="txtDescricao" class="form_textarea"><%=descricao%></textarea>       
        </div>
        
        <div class="form_entry">
            <div class="form_title"><h3>Lazer</h3></div>
            <input type="text" name="txtLazer" maxlength="255" value="<%=lazer%>" class="form_textarea" />
        </div>
        
        <div class="form_entry">
            <div class="form_title"><h3>Segurança</h3></div>
            <input type="text" name="txtSeguranca" maxlength="255" value="<%=seguranca%>" class="form_textarea" />
        </div>
        
        <div class="form_entry">
            <div class="form_title"><h3>Diferencial</h3></div>
            <input type="text" name="txtDiferencial" maxlength="255" value="<%=diferencial%>" class="form_textarea" />
        </div>
        
        <div class="form_entry">
            <div class="form_title"><h3>Endereço</h3></div>
            <input type="text" name="txtEndereco" maxlength="255" value="<%=endereco%>" class="form_textarea" />
        </div>
        
        <div class="form_entry">
            <div class="form_title"><h3>Bairro</h3></div>
            <input type="text" name="txtBairro" maxlength="255" value="<%=bairro%>" class="form_textarea" />
        </div>
        
        <div class="form_entry">
            <div class="form_title"><h3>Cidade</h3></div>
            <input type="text" name="txtCidade" maxlength="255" value="<%=cidade%>" class="form_textarea" />
        </div>
        
        <div class="form_entry">
            <div class="form_title"><h3>Estado</h3></div>
            <div class="form_textarea">
                <select name="txtEstado">
                    <option value=''></option>
                    <option value='AC'>AC</option>
                    <option value='AL'>AL</option>
                    <option value='AM'>AM</option>
                    <option value='AP'>AP</option>
                    <option value='BA'>BA</option>
                    <option value='CE'>CE</option>
                    <option value='DF'>DF</option>
                    <option value='ES'>ES</option>
                    <option value='GO'>GO</option>
                    <option value='MA'>MA</option>
                    <option value='MS'>MS</option>
                    <option value='MT'>MT</option>
                    <option value='MG'>MG</option>
                    <option value='PA'>PA</option>
                    <option value='PB'>PB</option>
                    <option value='PE'>PE</option>
                    <option value='PI'>PI</option>
                    <option value='PR'>PR</option>
                    <option value='RJ'>RJ</option>
                    <option value='RN'>RN</option>
                    <option value='RS'>RS</option>
                    <option value='RO'>RO</option>
                    <option value='RR'>RR</option>
                    <option value='SC'>SC</option>
                    <option value='SE'>SE</option>
                    <option value='SP'>SP</option>
                    <option value='TO'>TO</option>
              	</select>
        	</div>
        </div>
        
        <div class="form_entry">
            <div class="form_title"><h3>GeoLocalização</h3></div>
            <input type="text" name="txtGeolocalizacao" maxlength="255" value="<%=geolocalizacao%>" class="form_textarea" />
        </div>
		
        <div class="form_entry">
            <div class="form_title"><h3>Destaque</h3></div>
            <div class="form_textarea">
            <select name="txtDestaque">
              <option value="1" <% if destaque = 1 then response.write("selected") end if %>>ON</option>
              <option value="0" <% if destaque = 0 then response.write("selected") end if %>>OFF</option>
            </select>
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