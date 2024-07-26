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
		tipo			= ""
		fase			= ""
		nome  			= ""
		frase			= ""
		conceito		= ""
		descricao		= ""
		lazer			= ""
		seguranca		= ""
		diferencial		= ""
		endereco		= ""
		bairro			= ""
		cidade			= ""
		estado			= ""
		geolocalizacao	= ""
		datacad			= ""
		destaque		= ""
		status			= ""
	Else
		'Inicia Recordset
		Set Rs = Server.CreateObject("ADODB.RecordSet")
		'Busca campos que contenham Id do usuário
		sql = "SELECT * FROM tbl_empreendimento WHERE id_empreendimento = " & id
		'Executa
		Rs.Open sql, conexao
		'Se encontrar registro
		If Not Rs.Eof Then
			'Variáveis recebem valores
			tipo			= Rs("id_tipo")
			fase			= Rs("id_fase")
			nome  			= Rs("nome")
			frase			= Rs("frase")
			conceito		= Rs("conceito")
			descricao		= Rs("descricao")
			lazer			= Rs("lazer")
			seguranca		= Rs("seguranca")
			diferencial		= Rs("diferencial")
			endereco		= Rs("endereco")
			bairro			= Rs("bairro")
			cidade			= Rs("cidade")
			estado			= Rs("estado")
			geolocalizacao	= Rs("geolocalizacao")
			datacad			= Rs("data_cadastro")
			destaque		= Rs("destaque")
			status			= Rs("status")
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
    
        <h2><span></span>Empreendimento | Editar</h2>
        <div class="content_divisao"></div>      
        
        <a href="lista.asp?lista=todos&amp;limpa=ok" class="content_link1">Listar Todos</a></td>
        <i><%= msg %></i>

        <div class="content_divisao"></div>              
    
        <form action="act_edt.asp?id=<%=id%>" method="post" name="formulario" onSubmit="return valida_noticia_edt(this);">
    	
        <div class="form_entry">
            <div class="form_title"><h3>Tipo</h3></div>
           	<select name="txtTipo">
              	<%
			  		sqlTipo = "SELECT id_tipo, nome FROM tbl_empreendimento_tipo WHERE status = 1 ORDER BY nome ASC"
					Set RsTipo = conexao.execute(sqlTipo)
				
					if Not RsTipo.EOF then
					
						Do While Not RsTipo.EOF
						id_tipo 	= RsTipo("id_tipo")
						nome_tipo = RsTipo("nome")
			  	%>
              		<option value="<%=id_tipo%>" <% if (id_tipo = tipo) then response.write("selected=""selected""") end if %>><%=nome_tipo%> - <%=nome_tipo%></option>
              	<%
			  		RsTipo.MoveNext
					Loop
					End if
			  	%>
            </select>
        </div>
        
        <div class="form_entry">
            <div class="form_title"><h3>Fase</h3></div>
           	<select name="txtFase">
              	<%
			  		sqlFase = "SELECT id_fase, nome FROM tbl_empreendimento_fase WHERE status = 1 ORDER BY nome ASC"
					Set RsFase = conexao.execute(sqlFase)
				
					if Not RsFase.EOF then
					
						Do While Not RsFase.EOF
						id_fase   = RsFase("id_fase")
						nome_fase = RsFase("nome")
			  	%>
              		<option value="<%=id_fase%>" <% if (id_fase = fase) then response.write("selected=""selected""") end if %>><%=nome_fase%> - <%=nome_fase%></option>
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
                    <option value='AC' <% if estado = "AC" then response.write("selected") end if %>>AC</option>
                    <option value='AL' <% if estado = "AL" then response.write("selected") end if %>>AL</option>
                    <option value='AM' <% if estado = "AM" then response.write("selected") end if %>>AM</option>
                    <option value='AP' <% if estado = "AP" then response.write("selected") end if %>>AP</option>
                    <option value='BA' <% if estado = "BA" then response.write("selected") end if %>>BA</option>
                    <option value='CE' <% if estado = "CE" then response.write("selected") end if %>>CE</option>
                    <option value='DF' <% if estado = "DF" then response.write("selected") end if %>>DF</option>
                    <option value='ES' <% if estado = "ES" then response.write("selected") end if %>>ES</option>
                    <option value='GO' <% if estado = "GO" then response.write("selected") end if %>>GO</option>
                    <option value='MA' <% if estado = "MA" then response.write("selected") end if %>>MA</option>
                    <option value='MS' <% if estado = "MS" then response.write("selected") end if %>>MS</option>
                    <option value='MT' <% if estado = "MT" then response.write("selected") end if %>>MT</option>
                    <option value='MG' <% if estado = "MG" then response.write("selected") end if %>>MG</option>
                    <option value='PA' <% if estado = "PA" then response.write("selected") end if %>>PA</option>
                    <option value='PB' <% if estado = "PB" then response.write("selected") end if %>>PB</option>
                    <option value='PE' <% if estado = "PE" then response.write("selected") end if %>>PE</option>
                    <option value='PI' <% if estado = "PI" then response.write("selected") end if %>>PI</option>
                    <option value='PR' <% if estado = "PR" then response.write("selected") end if %>>PR</option>
                    <option value='RJ' <% if estado = "RJ" then response.write("selected") end if %>>RJ</option>
                    <option value='RN' <% if estado = "RN" then response.write("selected") end if %>>RN</option>
                    <option value='RS' <% if estado = "RS" then response.write("selected") end if %>>RS</option>
                    <option value='RO' <% if estado = "RO" then response.write("selected") end if %>>RO</option>
                    <option value='RR' <% if estado = "RR" then response.write("selected") end if %>>RR</option>
                    <option value='SC' <% if estado = "SC" then response.write("selected") end if %>>SC</option>
                    <option value='SE' <% if estado = "SE" then response.write("selected") end if %>>SE</option>
                    <option value='SP' <% if estado = "SP" then response.write("selected") end if %>>SP</option>
                    <option value='TO' <% if estado = "TO" then response.write("selected") end if %>>TO</option>
              	</select>
        	</div>
        </div>
        
        <div class="form_entry">
            <div class="form_title"><h3>GeoLocalização</h3></div>
            <input type="text" name="txtGeolocalizacao" maxlength="255" value="<%=geolocalizacao%>" class="form_textarea" />
        </div>
        
		<div class="form_entry">
            <div class="form_title"><h3>Data de Cadastro</h3></div>
            <div class="form_textarea">
			<%
				strDataCad = Day(DataCad) & "/" & Month(DataCad) & "/" & Year(DataCad) & " - " & Hour(DataCad) & ":" & Minute(DataCad)
				response.write(strDataCad)			
			 %>
             </div>
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
	Set conexao = nothing
%>