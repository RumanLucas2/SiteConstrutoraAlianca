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
		msg = "Cadastro efetuado com sucesso!"	'Variável recebe mensagem de sucesso
	Else if msg = "" then
			msg = ""	'msg se mantem vazia
		End if	'Finaliza Se msg tiver valor "ok"
	End if
	
	'Remove espaços da esquerda e da direita da Id do usuário e verifica se é igual a 0
	if ltrim(rtrim(id)) = 0 Then
		'Variáveis ficam vazias
		id_tipo			= ""
		id_fase			= ""
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
			id_tipo			= Rs("id_tipo")
			id_fase			= Rs("id_fase")
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
    
        <h2><span></span>Empreendimento | Visualizar</h2>
        <div class="content_divisao"></div>      
        
        <a href="lista.asp?lista=todos&amp;limpa=ok" class="content_link1">Listar Empreendimentos</a></td>

        <div class="content_divisao"></div>              
    		
            <div class="form_entry">
                <div class="form_title"><h3>Nome</h3></div>
                <div class="form_textarea"><%=nome%></div>
            </div>
            
            <div class="form_entry">
                <div class="form_title"><h3>Nome</h3></div>
                <div class="form_textarea"><%=nome%></div>
            </div>
            
            <div class="form_entry">
                <div class="form_title"><h3>Frase</h3></div>
                <div class="form_textarea"><%=frase%></div>
            </div> 
            
            <div class="form_entry">
                <div class="form_title"><h3>Conceito</h3></div>
                <div class="form_textarea"><%=conceito%></div>
            </div>
            
            <div class="form_entry">
                <div class="form_title"><h3>Descrição</h3></div>
                <div class="form_textarea"><%=descricao%></div>
            </div>
            
            <div class="form_entry">
                <div class="form_title"><h3>Lazer</h3></div>
                <div class="form_textarea"><%=lazer%></div>
            </div>
            
            <div class="form_entry">
                <div class="form_title"><h3>Segurança</h3></div>
                <div class="form_textarea"><%=seguranca%></div>
            </div>
            
            <div class="form_entry">
                <div class="form_title"><h3>Diferencial</h3></div>
                <div class="form_textarea"><%=diferencial%></div>
            </div> 
            
            <div class="form_entry">
                <div class="form_title"><h3>Endereço</h3></div>
                <div class="form_textarea"><%=endereco%></div>
            </div> 
            
            <div class="form_entry">
                <div class="form_title"><h3>Bairro</h3></div>
                <div class="form_textarea"><%=bairro%></div>
            </div> 
            
            <div class="form_entry">
                <div class="form_title"><h3>Cidade</h3></div>
                <div class="form_textarea"><%=cidade%></div>
            </div> 
            
            <div class="form_entry">
                <div class="form_title"><h3>Estado</h3></div>
                <div class="form_textarea"><%=estado%></div>
            </div> 
            
            <div class="form_entry">
                <div class="form_title"><h3>Geolocalização</h3></div>
                <div class="form_textarea"><%=geolocalizacao%></div>
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
                <div class="form_title"><h3>Destque</h3></div>
                <div class="form_textarea">
				<%if destaque = 1 then Response.Write "<span class='icon on'></span>" else Response.Write "<span class='icon off'></span>" end if %></div>
            </div> 
                 
            <div class="form_entry">
                <div class="form_title"><h3>Status</h3></div>
                <div class="form_textarea">
				<%if Status = 1 then Response.Write "<span class='icon on'></span>" else Response.Write "<span class='icon off'></span>" end if %></div>
            </div>              
            
            </form>
            
	        <div class="content_bt_big"><a href="javascript:history.go(-1)">VOLTAR</a></div>
            
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