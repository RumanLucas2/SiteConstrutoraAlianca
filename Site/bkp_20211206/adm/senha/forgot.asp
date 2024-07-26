<!-- #include file="../inc/global.asp"-->  

	<script language="javascript">

		function valida_forgot(form){
			
			if( form.txtEmail.value.indexOf("@") == -1 || form.txtEmail.value.indexOf( "." ) ==-1 ) { 
				alert( ' Preencha corretamente o campo E-mail...'); 
				form.txtEmail.focus(); 
				form.txtEmail.select();
				return false; 
			} 
			
			if ( confirm ( 'Confima o envio das informações acima?' )) { return true; } else { return false; }
			
		}

	</script>
  
	<% if (Session("forgot") <> "") then mensagem = Session("forgot") end if%>  
  
</head>	
<body>

<div id="global">

	<% login_page = true %>
	<!-- #include file="../inc/header.asp"-->    
	
    <div class="login_column1">
    
    	<div class="login_column1_bg"></div>
    
    	<div class="login_text_box4">
        
	        <p><h2>Esqueceu sua senha?</h2>
            Digite ao lado o e-mail<br />para solicitar sua senha.</p>
        
        </div>
    
    </div>
    
    <div class="login_column2">
    
    	<div class="login_form">
        	
            <form action="act_forgot.asp" method="post" enctype="application/x-www-form-urlencoded" name="frmForgot" id="frmForgot" onSubmit="return valida_forgot(this);">
            	<div class="text_box"><span>E-mail</span><input type="text" name="txtEmail" id="txtEmail" /></div>
                <label><input name="login" type="submit" value="OK" /></label>
        	</form>
            
            <%= mensagem %>
            
        </div>
    
    </div>
        
</div>

<!-- #include file="../inc/scripts.asp"-->

</body>
</html>