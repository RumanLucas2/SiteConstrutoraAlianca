<!-- #include file="../inc/global.asp"-->  
<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/logado.asp"-->
<!-- #include file="inc.asp"-->

<%
	'Id do usu�rio retirado do Http
	id = Request.QueryString("id")
	'Se Id do usu�rio for vazia ou nulo ou n�o for num�rico
	if id = "" Or IsNull(id) Or Not IsNumeric(id) Then
		id = 0	'Vari�vel da Id do usu�rio recebe 0
	End if	'Finaliza Se Id do usu�rio for vazia ou nulo ou n�o for num�rico

	'Vari�vel msg recebe valor do Http
	msg = Request.QueryString("msg")

	'Se msg tiver valor "ok"
	if msg = "ok" Then
		msg = "Cadastro efetuado com sucesso!"	'Vari�vel recebe mensagem de sucesso
	Else if msg = "" then
			msg = ""	'msg se mantem vazia
		End if	'Finaliza Se msg tiver valor "ok"
	End if
	
	'Remove espa�os da esquerda e da direita da Id do usu�rio e verifica se � igual a 0
	if ltrim(rtrim(id)) = 0 Then
		'Vari�veis ficam vazias
		id_empreendimento 	= ""
		nome  			= ""
		foto			= ""
		DataCad			= ""
		Status			= ""
	Else
		'Inicia Recordset
		Set Rs = Server.CreateObject("ADODB.RecordSet")
		'Busca campos que contenham Id do usu�rio
		sql = "SELECT * FROM tbl_banner WHERE id_banner = " & id
		'Executa
		Rs.Open sql, conexao
		'Se encontrar registro
		If Not Rs.Eof Then
			'Vari�veis recebem valores
			id_empreendimento	= Rs("id_empreendimento")
			nome  			= Rs("nome")
			foto			= Rs("foto")
			DataCad			= Rs("data_cadastro")
			Status			= Rs("status")
		End If	'Finaliza Se encontrar registro
	End If	'Finaliza Remove espa�os da esquerda e da direita da Id do usu�rio e verifica se � igual a 0
		
%>

</head>

<body>

<div id="global">

	<!-- #include file="../inc/header.asp"-->

	<!-- #include file="../inc/menu.asp"-->

    <!-- DIV CONTEUDO -->
    <div id="content">
    
        <h2><span></span>Banner | Visualizar</h2>
        <div class="content_divisao"></div>      
        
        <a href="lista.asp?lista=todos&amp;limpa=ok" class="content_link1">Listar Banners</a></td>

        <div class="content_divisao"></div>              
    		
            <div class="form_entry">
                <div class="form_title"><h3>Empreendimento</h3></div>
                <%
					sqlEspetaculo = "SELECT nome FROM tbl_empreendimento WHERE id_empreendimento =" & id_empreendimento
					Set RsEspetaculo = conexao.execute(sqlEspetaculo)
					
					If Not RsEspetaculo.EOF Then
						nome_espetaculo = RsEspetaculo("nome")
					End if
				%>
                <div class="form_textarea"><%=nome_espetaculo %></div>
            </div>
            
            <div class="form_entry">
                <div class="form_title"><h3>Nome</h3></div>
                <div class="form_textarea"><%= nome %></div>
            </div>            

            <div class="form_entry">
                <div class="form_title"><h3>Imagem</h3></div>
                <div class="form_textarea"><% if foto <> "" then %><img name="Arquivo" src="<%= pastav & "/" & id & "/" & foto %>" alt=""><% else response.write "Nenhuma imagem adicionada." end if %></div>
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
                <div class="form_title"><h3>Status</h3></div>
                <div class="form_textarea">
				<%if Status = 1 then Response.Write "<span class='icon on'></span>" else Response.Write "<span class='icon off'></span>" end if %>	</div>
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