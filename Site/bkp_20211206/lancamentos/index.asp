<!-- #include file = "../inc/global.asp" -->
<!-- #include file = "../inc/anti_injection.asp" -->
<!-- #include file = "../inc/conexao.asp" -->

<%
	Session.LCID = 1034

	'Atribui valores do endereço Http
	Page = anti_inje(Request.QueryString("Page"))
	Ordena = anti_inje(Request.QueryString("ordena"))

	'Se lista for vazia
	if Lista = "" Then
		Num = 8 'Lista 25 registros
	Else
		Num = 5000 'Variavel Num recebe 5000 -> Lista 5000 valores
	End if 'Finaliza Se lista for vazia
	 	
	'Inicia Recordset
	Set Rs = Server.CreateObject("ADODB.RecordSet")
	Rs.PageSize = Num
	
	'Inicia comando de busca
	sql =	"SELECT * FROM tbl_empreendimento WHERE (id_fase = 1 OR id_fase = 2) AND status = 1 ORDER BY data_cadastro DESC"
	'Executa
	Rs.Open	sql, conexao, 3, 3
	
	'Se variável Page for vazia ou não for numérica
	if Page = "" Or Not IsNumeric(Page) Then
		Page = 1	'Variável Page recebe valor "1"
	Else
		Page = CDbl(Page)	'Variável Page recebe Variável convertida para tipo Double
		if Page < 1 Then	'Se página for menor que 1
			Page = 1	'Variável Page recebe valor "1"
		Else
			if Page > Rs.PageCount Then	'Se variável Page for maior que Total de páginas do Recordset
				Page = Rs.PageCount 	'Variável Page recebe Total de páginas do Recordset
			end if
		End if	'Finaliza Se página for menor que 1
	End if	'Finaliza Se variável Page for vazia ou não for numérica
%>

</head>

<body>

<!-- GLOBAL -->
<div id="global">

	<!-- #include file = "../inc/header.asp" -->
    <!-- #include file = "../inc/banner_large.asp" -->
	
    <!-- FEATURE SESSION INTERN -->
    <div id="featured_session1_intern">
    	<div id="limiter">
            <h1>LANÇAMENTOS</h1>
            <p>Veja abaixo os empreendimentos em fase de lançamento</p>
        </div>
    </div>
    <!-- FEATURE SESSION INTERN -->
       
    <!-- FEATURE SESSION 2 -->
    <div id="featured_session2">
        <div id="limiter">
            
            <div>
                <ul>
                	<%				
						if Rs.EOF then
					%>
							Não há empreendimentos cadastrados para esta categoria.
					<%
                    	else
						Rs.AbsolutePage = Page
						Do While Not Rs.EOF AND Rs.AbsolutePage = Page
							
							idFeat= Rs("id_empreendimento")
							nameFeat = Rs("nome")
							descFeat = Rs("descricao")
							cityFeat = Rs("cidade")
							
							sqlGal = "SELECT a.id_galeria, a.id_empreendimento, b.id_foto, b.arquivo FROM tbl_galeria a LEFT OUTER JOIN tbl_galeria_foto b ON a.id_galeria = b.id_galeria " &_
									"WHERE a.id_empreendimento = " & idFeat & " " &_
									"ORDER BY b.data_cadastro ASC"
							
							set RsGal = conexao.execute(sqlGal)
							if not RsGal.EOF then
								idGal = RsGal("id_galeria")
								idFoto = RsGal("id_foto")
								fotoGal = RsGal("arquivo")
							end if
					%>
                    <li>
                        <div class="frame" onClick="location.href='../empreendimento/?id=<%=idFeat%>'">
                            <div class="icon"></div>
                            <div class="img"><img src="../_file/galeria/<%=idGal%>/<%=idFoto%>/th/<%=fotoGal%>" /></div>
                            <div class="bg"></div>
                        </div>
                        <div class="title"><%=nameFeat%></div>
                        <div class="localbox"><strong>Localização:</strong> <%=cityFeat%></div>
                        <div class="description"><%=descFeat%></div>
                        <div class="more" onClick="location.href='../empreendimento/?id=<%=idFeat%>'">Veja +</div>
                    </li>
                    <%
						Rs.MoveNext
						loop
						end if
					%> 
                </ul>
                
            </div>            
            
            <!--#include file="../inc/pagination.asp"-->
            
        </div>
    </div>
    <!-- FEATURE SESSION 2 -->
    
</div>
<!-- GLOBAL -->

<!-- #include file = "../inc/footer.asp" -->
<!-- #include file = "../inc/script.asp" -->
</body>
</html>
