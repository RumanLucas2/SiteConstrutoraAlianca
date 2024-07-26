<!-- #include file = "../inc/global.asp" -->
<!-- #include file = "../inc/conexao.asp" -->

<%
	'Id do usuário retirado do Http
	id = Request.QueryString("id")
	'Se Id do usuário for vazia ou nulo ou não for numérico
	if id = "" Or IsNull(id) Or Not IsNumeric(id) Then
		id = 0	'Variável da Id do usuário recebe 0
	End if	'Finaliza Se Id do usuário for vazia ou nulo ou não for numérico
	
	sqlEmp = "SELECT nome, conceito, frase, descricao, lazer, seguranca, diferencial, endereco, bairro, cidade, estado, geolocalizacao FROM tbl_empreendimento WHERE status = 1 AND id_empreendimento = " & id
	set RsEmp = conexao.execute(sqlEmp)
	
	if not RsEmp.EOF then
		nameEmp = RsEmp("nome")
		conceptEmp = RsEmp("conceito")
		phraseEmp = RsEmp("frase")
		descEmp = RsEmp("descricao")
		lazEmp = RsEmp("lazer")
		segEmp = RsEmp("seguranca")
		difEmp = RsEmp("diferencial")
		addressEmp = RsEmp("endereco")
		neighEmp = RsEmp("bairro")
		cityEmp = RsEmp("cidade")
		stateEmp = RsEmp("estado")
		geoEmp = RsEmp("geolocalizacao")
	end if
%>

</head>

<body>

<!-- GLOBAL -->
<div id="global">

	<!-- #include file = "../inc/header.asp" -->
    <!-- #include file = "../inc/banner_small.asp" -->
	
    <!-- FEATURE SESSION INTERN -->
    <div id="featured_session1_intern">
    	<div id="limiter">
            
            <h1><%=nameEmp%></h1>
            <p><%=phraseEmp%></p>
            
        </div>
    </div>
    
    <!-- FEATURE SESSION 2 -->
    <div id="featured_session2_intern" class="gallery">
        <div id="limiter">
        	
            <div class="tab">
                <div id="tab1" class="tab_unit on">INFORMAÇÕES</div>
            </div>
        	
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
                        <li style="background:url(../img/global/bg_frame2.png);"><div class="bg"></div><div class="img"><a href="../_file/galeria/<%=idGal%>/<%=idPhoto%>/<%=filePhoto%>" rel="prettyPhoto[gal]" title="<%=namePhoto%>"><img src="../_file/galeria/<%=idGal%>/<%=idPhoto%>/th/<%=filePhoto%>" border="0" /></a></div></li>
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
            
            <% if (conceptEmp <> "") then %>
            <h1>Conceito</h1>
            <div class="fontsize">
            	<a href="javascript:chanegeFontsize('less'); return false" class="changeFont">A-</a> |
    			<a href="javascript:chanegeFontsize('more'); return false" class="changeFont">A+</a>
            </div>
            <div class="division"></div>
            <div class="description"><p><%=conceptEmp%></p></div>
            <% end if %>
            
            <h1>Descrição</h1>                        
            <div class="division"></div>
            
            <div class="description">
			<% if (addressEmp <> "") then %><p><strong>Endereço:</strong> <%=addressEmp%> - <%=neighEmp%></p><% end if %>
            <% if (cityEmp <> "") then %><p><strong>Localização:</strong> <%=cityEmp%> - <%=stateEmp%></p><% end if %>
            <% if (descEmp <> "") then %><p><strong>Descrição:</strong><br /> <%=descEmp%></p><% end if %>
            <% if (lazEmp <> "") then %><p><strong>Lazer:</strong> <%=lazEmp%></p><% end if %>
            <% if (segEmp <> "") then %><p><strong>Segurança:</strong> <%=segEmp%></p><% end if %>
            <% if (difEmp <> "") then %><p><strong>Diferenciais:</strong> <%=difEmp%></p><% end if %>
            </div>
            
            <h1>Informações Adicionais</h1>
            <div class="division"></div>
            
            <div class="box1">
            	<h1>Localização</h1>
                <div class="bg"></div>
                <div class="img">
                    <iframe width="413" height="228" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="map.asp?id=<%=id%>"></iframe>
                </div>
            </div>
            
            <div class="box2 galery">
            	<h1>Planta</h1>
                <div class="bg"></div>
            	<div class="img">
                <%
					sqlGalPlan = "SELECT id_galeria, nome FROM tbl_galeria_planta WHERE id_empreendimento = " & id & ""
					set RsGalPlan = conexao.execute(sqlGalPlan)
					
					if RsGalPlan.EOF then
						Response.Write("Não existem plantas cadastradas")
					else
						
						contPlan = 0
						
						idGalPlan   = RsGalPlan("id_galeria")
						nameGalPlan = RsGalPlan("nome")
						
						sqlPhotoPlan  = "SELECT id_foto, nome, arquivo FROM tbl_galeria_planta_foto WHERE status = 1 AND id_galeria = " & idGalPlan & ""
						set RsPhotoPlan = conexao.execute(sqlPhotoPlan)
						if RsPhotoPlan.EOF then
							Response.Write("Não há fotos cadastradas.")
						else
						do while not RsPhotoPlan.EOF
							idPhotoPlan = RsPhotoPlan("id_foto")
							namePhotoPlan = RsPhotoPlan("nome")
							filePhotoPlan = RsPhotoPlan("arquivo")
							contPlan = contPlan + 1
				%>
					<% if contPlan = 1 then %>
                    <a href="../_file/planta/<%=idGalPlan%>/<%=idPhotoPlan%>/<%=filePhotoPlan%>" rel="prettyPhoto[plan]" title="<%=namePhotoPlan%>"><img src="../_file/planta/<%=idGalPlan%>/<%=idPhotoPlan%>/th/<%=filePhotoPlan%>" border="0" /></a>
               <% else %>
                    <a href="../_file/planta/<%=idGalPlan%>/<%=idPhotoPlan%>/<%=filePhotoPlan%>" rel="prettyPhoto[plan]" title="<%=namePhotoPlan%>"></a>
               <% end if %>
				<%
						RsPhotoPlan.MoveNext
						loop
						end if
					end if
				%>
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
