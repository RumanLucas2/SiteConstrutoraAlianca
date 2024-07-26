<!-- #include file = "../inc/global.asp" -->
<!-- #include file = "../inc/conexao.asp" -->
<script src="../js/jquery.maskedinput.min.js"></script>

<script type="text/javascript">
function goTipo(valor)
{
	if (valor == 1)
	{
		$('.form2').hide();
		$('.form1').show();
	}
	
	if (valor == 2)
	{
		$('.form2').show();
		$('.form1').hide();
		$('#msg_contact').text("");
	}
}

var SITE = SITE || {};

SITE.fileInputs = function() {
  var $this = $(this),
      $val = $this.val(),
      valArray = $val.split('\\'),
      newVal = valArray[valArray.length-1],
      $button = $this.siblings('.button'),
      $fakeFile = $this.siblings('.file-holder');
  if(newVal !== '') {
    $button.text('File Chosen');
    if($fakeFile.length === 0) {
      $button.after('<span class="file-holder">' + newVal + '</span>');
    } else {
      $fakeFile.text(newVal);
    }
  }
};

$(document).ready(function() {
  $('.file-wrapper input[type=file]').bind('change focus click', SITE.fileInputs);
});

</script>

<style type="text/css">
.file-wrapper {
    position: relative;
    display: inline-block;
    overflow: hidden;
    cursor: pointer;
}
.file-wrapper input {
    position: absolute;
    top: 0;
    right: 0;
    filter: alpha(opacity=1);
    opacity: 0.01;
    -moz-opacity: 0.01;
    cursor: pointer;
}
.file-wrapper .button {
    color: #fff;
    background: #c1232a;
    padding: 4px 18px;
    margin-right: 5px;  
    border-radius: 5px;
    -moz-border-radius: 5px;
    -webkit-border-radius: 5px;
    display: inline-block;
    font-weight: bold;
    cursor: pointer;
}
.file-holder{
    color: #000;
}
</style>

</head>

<body>

<!-- GLOBAL -->
<div id="global">

	<!-- #include file = "../inc/header.asp" -->
    <!-- #include file = "../inc/banner_large.asp" -->
	
    <!-- FEATURE SESSION INTERN -->
    <div id="featured_session1_intern">
    	<div id="limiter">
            <h1>FALE CONOSCO</h1>
            <p>Entre em contato através do formulário abaixo</p>
        </div>
    </div>
    
    <!-- FEATURE SESSION 2 -->
    <div id="featured_session2_intern" class="gallery">
        <div id="limiter">
            <br />
            <h1>Contato</h1>
            <div class="division"></div>
            
            <div class="description">
                <!-- FORM 1 -->
            	<div class="box1_form">
                
                	<% if session("msg_contact") <> "" then %>
					
						<h1><i><%=session("msg_contact")%></i></h1>
						<% session("msg_contact") = "" %>
					<% else %>
                		
                        <form name="form" id="form" action="send.asp" method="post" enctype="multipart/form-data" accept-charset="ISO-8859-1" onSubmit="return contactValidate(this);">
                        <div id="opcao">
                        	<input class="radio" type="radio" name="txtTipo" value="1" onclick="goTipo(1);" checked />&nbsp;Contato&nbsp;&nbsp;&nbsp;&nbsp;
                         	<input class="radio" type="radio" name="txtTipo" value="2" onclick="goTipo(2);" />&nbsp;Assistência Técnica
                        </div>
                		<h1>Selecione o tipo de contato:</h1>
                        
                        <div class="bg"></div>
                        <div class="form1">
                            <div class="input"><input class="text" type="text" name="txtAutor" /></div>
                            <div class="input"><input class="text" type="text" name="txtEmail" /></div>
                            <div class="input"><input class="text" type="text" name="txtTelefone" id="txtTelefone" maxlength="8" /></div>
                            <div class="input"><input class="text" type="text" name="txtAssunto" value="" /></div>
                            <div class="textarea"><textarea name="txtMensagem"></textarea></div>
                        </div>
                        
                        <div class="form2" style="display:none;">
                        <div class="passo" style="text-transform:uppercase; color:#333;"><strong>Siga os passos abaixo para enviar sua solicitação:</strong></div>
                        <div class="passo">1. Faça o Download do <strong><a href="../_file/sat/termo_sat.doc" style="text-decoration:underline; color:#333;">Termo de Solicitação de Assistência Técnica</a></strong>.</div>
                        <div class="passo">2. <strong>Preencha corretamente</strong> todos os campos do termo.</div>
                        <div class="passo">3. <strong>Envie o termo</strong> preenchido através do campo abaixo.</div>
                        <div class="passo">
                        	<div class="file-wrapper"><input type="file" name="Attachment" /><span class="button">Procurar Arquivo</span></div>
                        </div>
                        </div>
                        <div class="submit_btn"><input type="submit" value="" class="submit_form" /></div>
                        <div id="msg_contact"></div>
                  </form>
                    <% 
						session("msg_contact") = ""
						end if 
					%>
                </div>
             
            	<div class="box2" style="margin-right:0px;">
                    <h1>Localização</h1>
                    <div class="bg"></div>
                    <div class="img">
                        <iframe width="413" height="228" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="map.asp"></iframe>
                    </div>
                    
                    <div class="address">                       
                        <p>Rua Dom Pedro I, 346 - Cidade Nova<br />
                        Indaiatuba - SP<br />
                        (19) 3825-8969</p>
                        
                        <h1>Horário de Atendimento:</h1>
                        <p style="margin-top:-8px;">Segunda a Sexta-Feira das 9:00 às 17:00</p>
                        
                        <h1>Plantão de Vendas:</h1>
                        <p style="margin-top:-8px;">(19) 99176-6552</p>
                    </div>
                </div>
                
			</div>
            
        </div>
	</div>
	<!-- FEATURE SESSION 2 -->
    
</div>
<!-- GLOBAL -->

<script>
$(document).ready(function(e) {
	$("#txtTelefone").mask("(99) 9999-9999");
});
</script>

<!-- #include file = "../inc/footer.asp" -->
<!-- #include file = "../inc/script.asp" -->
</body>
</html>
