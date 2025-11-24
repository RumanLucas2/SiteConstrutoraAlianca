<!-- #include file="../inc/global.asp"-->  
<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/logado.asp"-->

<%	
	'Limpa Sessão de erro
	Session("login_msg") = ""	
	'Inicia Recordset
	set Rs = Server.CreateObject("ADODB.Recordset")
	'Busca campos da Id do usuário
	sql = "SELECT * FROM tbl_usuario_adm WHERE usuarioID = " & session("Codigo")
	'Executa
	Rs.Open sql, conexao
%>

</head>

<body>

<div id="global">

	<!-- #include file="../inc/header.asp"-->

	<!-- #include file="../inc/menu.asp"-->

    <!-- DIV CONTEUDO -->
    <div id="content">
    
        <h2><span></span>Painel de Controle</h2>
        <div class="content_divisao"></div>      
        
    	<p><strong>
			<script language="JavaScript">
                <!-- 
                today = new Date()
                if(today.getMinutes() < 10){ 
                pad = "0"}
                else 
                pad = "";
                document.write ;if((today.getHours() >=6) && (today.getHours() <=9)){ 
                document.write("Bom dia") 
                }
                if((today.getHours() >=10) && (today.getHours() <=11)){
                document.write("Bom dia")
                }
                if((today.getHours() >=12) && (today.getHours() <=17)){
                document.write("Boa tarde") 
                } 
                if((today.getHours() >=18) && (today.getHours() <=23)){
                document.write("Boa noite") 
                }
                if((today.getHours() >=0) && (today.getHours() <=3)){
                document.write("Boa noite") 
                }
                if((today.getHours() >=4) && (today.getHours() <=5)){
                document.write("Boa noite")
                }
                // -->
            </script>
            <% response.write(Session("Nome")) %>
        </strong>
        </p>
       
       	<div style="margin-top: 20px;">
            <p><strong>Acesso n&ordm;:</strong></p>
			<p><%= Rs("quantidade_acesso") %></p>
        </div>

		<% if (Rs("quantidade_acesso") > 1) then %>

       	<div style="margin-top: 20px;">
            <p><strong>&Uacute;ltimo Acesso:</strong></p>
            <p> 
				<%	
                dataAcesso = Rs("ultimo_acesso")
                horaAcesso = Rs("ultimo_acesso")
                strDataAcesso = Day(dataAcesso) & "/" & Month(dataAcesso) & "/" & Year(dataAcesso)
                strHoraAcesso = Hour(HoraAcesso) & ":" & Minute(HoraAcesso) & ":" & Second(HoraAcesso)
                %>
                <%= strDataAcesso %>
                &agrave;s
                <%= strHoraAcesso %>
            </p>
        </div>

	    <% end if %>
    
    <!-- DIV FOOTER -->
    <div id="rodape"><!--#include file="../inc/footer.asp"--></div>
    
</div>

</body>
</html>
<%
	Rs.Close
	Set Rs = Nothing
	conexao.close
	set conexao = nothing
%>