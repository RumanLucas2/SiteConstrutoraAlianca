<!-- #include file = "../inc/global.asp" -->
<!-- #include file = "../inc/conexao.asp" -->
<!-- #include file = "../inc/logged.asp" -->

<%
	'Id do usuário retirado do Http
	id = Request.QueryString("id")
	'Se Id do usuário for vazia ou nulo ou não for numérico
	if id = "" Or IsNull(id) Or Not IsNumeric(id) Then
		id = 0	'Variável da Id do usuário recebe 0
	End if	'Finaliza Se Id do usuário for vazia ou nulo ou não for numérico
	
	sqlEmp = "SELECT a.lancamento, a.terreno, a.fundacao, a.estrutura, a.alvenaria, a.instalacao, a.revestimento, a.acabamento, b.nome FROM tbl_empreendimento_andamento a LEFT OUTER JOIN tbl_empreendimento b " &_
	"ON a.id_empreendimento = b.id_empreendimento " &_
	"WHERE a.status = 1 AND a.id_empreendimento = " & id & ""
	set RsEmp = conexao.execute(sqlEmp)
	
	if Not RsEmp.EOF then
		nameEmp 	= RsEmp("nome")
		lancamento 	= RsEmp("lancamento")
		terreno 	= RsEmp("terreno")
		fundacao 	= RsEmp("fundacao")
		estrutura 	= RsEmp("estrutura")
		alvenaria 	= RsEmp("alvenaria")
		instalacao 	= RsEmp("instalacao")
		revestimento = RsEmp("revestimento")
		acabamento 	= RsEmp("acabamento")
	end if
%>

<script>
	$(function() {
		$(".meter > span").each(function() {
			$(this)
				.data("origWidth", $(this).width())
				.width(0)
				.animate({
					width: $(this).data("origWidth")
				}, 1200);
		});
	});
</script>

</head>

<body>

<!-- #include file = "../inc/profile.asp" -->

<!-- GLOBAL -->
<div id="global">
    
	<!-- #include file = "../inc/header.asp" -->
    <!-- #include file = "../inc/banner_small.asp" -->
    
    <!-- FEATURE SESSION INTERN -->
    <div id="featured_session1_intern">
        <div id="limiter">    
            <h1><%=nameEmp%></h1>
            <p><a href="javascript:window.history.back();" style="color:#FF3;">Obras</a> > <%=nameEmp%></p>            
        </div>
    </div>
    
    <!-- FEATURE SESSION 2 -->
    <div id="featured_session2_intern" class="gallery">
        <div id="limiter">
			<br />
            <h1>FASES DA OBRA</h1>                        
            <div class="division"></div>
            
            <div class="description">
                
                <%
					if RsEmp.EOF then
						Response.Write("Ainda não foram cadastrado os dados dessa obra.")
					else
						nameEmp 	= RsEmp("nome")
						lancamento 	= RsEmp("lancamento")
						terreno 	= RsEmp("terreno")
						fundacao 	= RsEmp("fundacao")
						estrutura 	= RsEmp("estrutura")
						alvenaria 	= RsEmp("alvenaria")
						instalacao 	= RsEmp("instalacao")
						revestimento = RsEmp("revestimento")
						acabamento 	= RsEmp("acabamento")
				%>
                
                <table width="100%">
                	<tr>
                		<td width="20%"></td>
                        <td width="80%"></td>
                    </tr>
                    <tr>
                		<td><h2>LANÇAMENTO</h2></td>
                        <td><div class="meter"><span style="width: <%=lancamento%>%;"><%=lancamento%>%</span></div></td>
                    </tr>
                    <tr>
                    	<td><h2>PREPARO DO TERRENO</h2></td>
                        <td><div class="meter"><span style="width: <%=terreno%>%"><%=terreno%>%</span></div></td>
                    </tr>
                   	<tr>
                    	<td><h2>FUNDAÇÃO</h2></td>
                        <td><div class="meter"><span style="width: <%=fundacao%>%"><%=fundacao%>%</span></div></td>
                    </tr>
                    <tr>
                    	<td><h2>ESTRUTURA</h2></td>
                        <td><div class="meter"><span style="width: <%=estrutura%>%"><%=estrutura%>%</span></div></td>
                    </tr>
                    <tr>
                    	<td><h2>ALVENARIA</h2></td>
                        <td><div class="meter"><span style="width: <%=alvenaria%>%"><%=alvenaria%>%</span></div></td>
                    </tr>
                    <tr>
                    	<td><h2>INSTALAÇÃO</h2></td>
                        <td><div class="meter"><span style="width: <%=instalacao%>%"><%=instalacao%>%</span></div></td>
                    </tr>
                    <tr>
                    	<td><h2>REVESTIMENTO</h2></td>
                        <td><div class="meter"><span style="width: <%=revestimento%>%"><%=revestimento%>%</span></div></td>
                    </tr>
                    <tr>
                    	<td><h2>ACABAMENTO</h2></td>
                        <td><div class="meter"><span style="width: <%=acabamento%>%"><%=acabamento%>%</span></div></td>
                    </tr>
                    </tr>
                </table>
                <% end if %>
            </div>
            
            <h1>Galeria de Fotos</h1>
            <div class="division"></div>
            
            <div class="galery">
            
                <!-- CAROUSEL -->
                <div class="infinite_carousel unselectable">
                    <div class="wrapper">  
                        <ul>
                        <%
							sqlGal = "SELECT id_galeria, nome FROM tbl_galeria WHERE id_empreendimento = " & id & ""
							set RsGal = conexao.execute(sqlGal)
							
							if RsGal.EOF then
								Response.Write("Não existem galerias cadastradas")
							else
								idGal = RsGal("id_galeria")
								nameGal = RsGal("nome")
								
								sqlPhoto  = "SELECT id_foto, nome, arquivo FROM tbl_galeria_foto WHERE status = 1 AND id_galeria = " & idGal & ""
								set RsPhoto = conexao.execute(sqlPhoto)
								if RsPhoto.EOF then
									Response.Write("Não há fotos cadastradas.")
								else
								do while not RsPhoto.EOF
									idPhoto = RsPhoto("id_foto")
									namePhoto = RsPhoto("nome")
									filePhoto = RsPhoto("arquivo")
						%>
                        <li style="background:url(../img/global/bg_frame2.png);"><div class="bg"></div><div class="img"><a href="../_file/galeria/<%=idGal%>/<%=idPhoto%>/<%=filePhoto%>" rel="prettyPhoto[gal]"><img src="../_file/galeria/<%=idGal%>/<%=idPhoto%>/th/<%=filePhoto%>" border="0" /></a></div></li>
                        <%
								RsPhoto.MoveNext
								loop
								end if
							end if
						%>
                        </ul>  
                    </div>
                </div>
                                
            </div>
            
        </div>
	</div>
	<!-- FEATURE SESSION 2 -->
    
</div>
<!-- GLOBAL -->

<!-- #include file = "../inc/footer.asp" -->
<!-- #include file = "../inc/script.asp" -->
</body>
</html>
