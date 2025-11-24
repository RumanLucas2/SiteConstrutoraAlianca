<!-- #include file="../inc/global.asp"-->  
<script language="javascript">
if ((navigator.userAgent.indexOf('iPhone') != -1) || (navigator.userAgent.indexOf('iPad') != -1))
{
	// PERMANEÇA NESTE LINK
} else {
	document.location = "index.asp";	
}
</script>
</head>
<body>

<div id="global">

	<% login_page = true %>    
	<!-- #include file="../inc/header.asp"-->
    
    <div class="login_column1">
    
    	<div class="login_column1_bg"></div>
    
    	<div class="login_text_box1">
        
	        <p>Por segurança o sistema<br />automaticamente registra em<br />nossa base de dados todos<br />os acessos a esta página.</p>
        
        </div>
    
    	<div class="login_text_box_line"></div>
        
        <div class="login_text_box3">
        
	        Seu IP: <span><%=request.ServerVariables("REMOTE_ADDR")%>
				<% dt=Now()
				formated_dt=day(dt)&"/"&month(dt)&"/"&year(dt)&" "&FormatDateTime(dt,3)
				%></span><br />
            Momento de Acesso: <span><%=formated_dt%></span>
        
        </div>
    
    </div>
    
    <div class="login_column2">
    
    	<div class="login_form">
        	
            <form action="act_login.asp" method="post" name="frmLogin" id="frmLogin">
            	<div class="text_box"><span>Login</span><input name="txtLogin" id="txtLogin" type="text" /></div>
            	<div class="text_box"><span>Senha</span><input name="txtSenha" type="password" id="txtSenha" style="width:300px"/></div>
                <div><input name="login" type="submit" value="OK" /></div>
        	</form>
            
            <% if (Session("login_msg") <> "") then 
				mensagem = Session("login_msg") 
			%>
            
            <div class="login_form_error"><% response.write(mensagem) %></div>
            
			<% end if %>
            
            
            <div class="login_bt_holder">
                <div class="login_bt_forgot"><a href="../senha/forgot.asp">Esqueci<br />minha senha</a></div>
                <div class="login_bt_contact"><a href="http://www.solopropaganda.com.br">Fale<br />conosco</a></div>
            </div>
            
        </div>
    
    </div>
        
</div>

<!-- #include file="../inc/scripts.asp"-->

</body>
</html>