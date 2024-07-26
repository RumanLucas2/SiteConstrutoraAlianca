<!-- #include file="../inc/global.asp"-->  
<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/logado.asp"-->

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
		Autor  		= ""
		Email  		= ""
		Telefone  	= ""
		Assunto  	= ""
		Mensagem	= ""
		Data		= ""
		
	Else
		'Inicia Recordset
		Set Rs = Server.CreateObject("ADODB.RecordSet")
		'Busca campos que contenham Id do usu�rio
		sql = "SELECT * FROM tbl_contato WHERE id_contato = " & id
		'Executa
		Rs.Open sql, conexao
		'Se encontrar registro
		If Not Rs.Eof Then
			'Vari�veis recebem valores
			Autor  		= Rs("autor")
			Email  		= Rs("email")
			Telefone  	= Rs("telefone")
			Assunto  	= Rs("assunto")
			Mensagem	= Rs("mensagem")
			Data		= Rs("data_cadastro")
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
    
        <h2><span></span>Contato | Visualizar</h2>
        <div class="content_divisao"></div>      
        
        <a href="lista.asp?lista=todos&amp;limpa=ok" class="content_link1">Listar Contatos</a></td>
        <i><%= delete %></i>

        <div class="content_divisao"></div>              
                  
            <div class="form_entry">
                <div class="form_title"><h3>Autor</h3></div>
                <div class="form_textarea"><%= Autor %></div>
            </div>
            
            <div class="form_entry">
                <div class="form_title"><h3>E-mail</h3></div>
                <div class="form_textarea"><%= Email %></div>
            </div>
            
            <div class="form_entry">
                <div class="form_title"><h3>Telefone</h3></div>
                <div class="form_textarea"><%= Telefone %></div>
            </div>
            
            <div class="form_entry">
                <div class="form_title"><h3>Assunto</h3></div>
                <div class="form_textarea"><%= Assunto %></div>
            </div>  
                        
            <div class="form_entry">
                <div class="form_title"><h3>Mensagem</h3></div>
                <div class="form_textarea"><%= Mensagem %></div>
            </div>
            <div class="form_entry">
                <div class="form_title"><h3>Data de Contato</h3></div>
                <div class="form_textarea">
				<% 
				DataRes = Day(Data) & "/" & Month(Data) & "/" & Year(Data) & " - " & Hour(Data) & ":" & Minute(Data)
				response.write(DataRes)	
				%>
                </div>
            </div>
            
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