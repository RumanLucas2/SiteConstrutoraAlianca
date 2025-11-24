<!-- #include file = "../inc/global.asp" -->
<!-- #include file = "../inc/anti_injection.asp" -->
<!-- #include file = "../inc/logged.asp"-->
<!-- #include file = "../inc/conexao.asp" -->

<%	
	sql =	"SELECT a.id_empreendimento, a.nome, a.descricao, a.cidade FROM tbl_empreendimento a LEFT OUTER JOIN tbl_empreendimento_usuario b ON a.id_empreendimento = b.id_empreendimento " &_
			"WHERE b.id_usuario = " & session("iduser") & " " &_
			"ORDER BY a.data_cadastro DESC"
																		
	set Rs = conexao.execute(sql)
%>

</head>

<body>

<!-- #include file = "../inc/profile.asp" -->

<!-- GLOBAL -->
<div id="global">

	<!-- #include file = "../inc/header.asp" -->
    <!-- #include file = "../inc/banner_large.asp" -->
	
    <!-- FEATURE SESSION INTERN -->
    <div id="featured_session1_intern">
    	<div id="limiter">
            <h1>ACOMPANHE SUA OBRA</h1>
        </div>
    </div>
    <!-- FEATURE SESSION INTERN -->
       
    <!-- FEATURE SESSION 2 -->
    <div id="featured_session2">
        <div id="limiter">
            <br />
            <h1>Selecione abaixo a obra desejada</h1>
            <div class="division"></div>
            <div>
                <ul>
                	<%				
						if Rs.EOF then
							Response.Write("Ainda não há empreendimentos cadastrados para este usuário.")
						else
						do while not Rs.EOF
							
							idFeat= Rs("id_empreendimento")
							nameFeat = Rs("nome")
							descFeat = Rs("descricao")
							cityFeat = Rs("cidade")
							
							sqlGal = "SELECT a.id_galeria, a.id_empreendimento, b.id_foto, b.arquivo FROM tbl_galeria a LEFT OUTER JOIN tbl_galeria_foto b ON a.id_galeria = b.id_galeria " &_
									"WHERE a.id_empreendimento = " & idFeat & " " &_
									"ORDER BY a.data_cadastro DESC"
							
							set RsGal = conexao.execute(sqlGal)
							if not RsGal.EOF then
								idGal = RsGal("id_galeria")
								idFoto = RsGal("id_foto")
								fotoGal = RsGal("arquivo")
							end if
					%>
                    <li>
                        <div class="frame" onClick="location.href='../acompanhe/det.asp?id=<%=idFeat%>'">
                            <div class="icon"></div>
                            <div class="img"><img src="../_file/galeria/<%=idGal%>/<%=idFoto%>/th/<%=fotoGal%>" /></div>
                            <div class="bg"></div>
                        </div>
                        <div class="title"><%=nameFeat%></div>
                        <div class="localbox"><strong>Localização:</strong> <%=cityFeat%></div>
                        <div class="description"><%=descFeat%></div>
                        <div class="more" onClick="location.href='../acompanhe/det.asp?id=<%=idFeat%>'">Veja +</div>
                    </li>
                    <%
						Rs.MoveNext
						loop
						end if
					%> 
                </ul>
                
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
