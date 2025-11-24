<!-- #include file = "../inc/global.asp" -->
<!-- #include file = "../inc/conexao.asp" -->

</head>

<body>

<!-- GLOBAL -->
<div id="global">
<script language="javascript">
  /*FECHAR BANNER*/
  function hideBanner(){
    document.getElementById("pop").style.display = "none";
  }
  function delayBanner(time){
    window.setTimeout("hideBanner();", time);
  }
</script>

<!-- STYLE DO POP -->
<style type="text/css">
  #pop {
    width: 100%;
    height: 100%;
    position: fixed;
    left: 0;
    top: 0;
    background: rgba(0,0,0,0.6);
    z-index: 99999999;
  }
    #pop .interno {
      width: 500px;
      height: 400px;
      position: absolute;
      left: 50%;
      top: 50%;
      margin: -145px 0 0 -260px;
      z-index: 2;
    }
     #pop a.infos {
        background: url(../_file/pop/pop.jpg) center center no-repeat;
        width: 100%;
        height: 100%;
        position: absolute;
        cursor: pointer;
        z-index: 3;
      }
      #pop button.fechar {
        position: absolute;
        right: 45px;
        top: 15px;
        width: 30px;
        height: 30px;
        z-index: 4;
        background: transparent;
        cursor: pointer;
        border: 0;
      }
		.closepop{
			width:25px;
			height:25px;
			position:absolute;
			z-index:50;
			top:-13px;
			right:-15px;
			background: url(../_file/pop/close.png) center center no-repeat;
			cursor:pointer;
		}
</style>

	<!-- #include file = "../inc/header.asp" -->
    <!-- #include file = "../inc/banner_large.asp" -->
	
    <!-- FEATURE SESSION 1 -->
    <div id="featured_session1" class="gallery">
   <!-- POP -->
   <div id="pop">
      <div class="interno">
      <div class="closepop" onclick="hideBanner();"></div>
         <a class="infos" href="http://www.construtoraalianca.com.br/_file/pop/anuncio.pdf" target="_blank" title="Campanha Medley 2014"></a>
         
      </div>
   </div>

    	<div id="limiter">

            <div class="box1">
                <h1>GROUP SOLUTIONS</h1>
                <p>A Group Solutions é uma holding que atua com incorporação, construção e administração condominial, através de suas empresas Solutions e Aliança.<br /><a href="http://www.groupsolutions.com.br" target="_blank" style="color:#FF3">+ Saiba mais</a></p>
            </div>
                
            <form name="form" action="../acompanhe/login.asp" method="post" onSubmit="return loginValidate(this);">
            <div class="box2">
                <h1>ACOMPANHE SUA OBRA</h1>
                <div class="inputs">
                    <input type="text" name="txtEmail" value="E-mail" onFocus="if (this.value=='E-mail') this.value='';" onBlur="if (this.value == '') {this.value='E-mail'}" />
                    <input type="password" name="txtPassword" value="Senha" onFocus="if (this.value=='Senha') this.value='';" onBlur="if (this.value == '') {this.value='Senha'}" />
                </div>
                <div class="submits"><input type="submit" value="" class="submit" /></div>
                <div id="msg_login"><i><%=session("msg_login")%></i></div>
            </div>
            </form>
                
        </div>
    </div>
    <!-- FEATURE SESSION 1 -->
       
    <!-- FEATURE SESSION 2 -->
    <div id="featured_session2">
        <div id="limiter">
            
            <%
				sqlType2 = "SELECT TOP 1 id_tipo, nome FROM tbl_empreendimento_tipo WHERE status = 1 ORDER BY id_tipo ASC"
				set RsType2 = conexao.execute(sqlType2)
			
				contFeat = 0
				
				if RsType2.EOF then
					Response.Write("Não há categorias cadastradas.")
				else		
				do while not RsType2.EOF
					idType = RsType2("id_tipo")
					nameType = RsType2("nome")
					contFeat = contFeat + 1
			%>
            
            <div id="feat<%=contFeat%>" <%if contFeat <> 1 then %>style="display:none"<%end if%>>
                <div class="titlefeat"><strong>DESTAQUES</strong></div>
                <div class="division"></div>
                <ul>
                <%
					sqlFeat = "SELECT TOP 4 id_empreendimento, nome, descricao, cidade FROM tbl_empreendimento WHERE status = 1 AND destaque = 1 AND id_tipo = "&idType&" ORDER BY id_empreendimento DESC"
					set RsFeat = conexao.execute(sqlFeat)
					
					if RsFeat.EOF then
						Response.Write("Não há empreendimentos cadastrados para esta categoria.")
					else
					do while not RsFeat.EOF
						
						idFeat= RsFeat("id_empreendimento")
						nameFeat = RsFeat("nome")
						descFeat = RsFeat("descricao")
						cityFeat = RsFeat("cidade")
						
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
						RsFeat.MoveNext
						loop
						end if
					%> 
                </ul>
            </div>            
            
            <%
				RsType2.MoveNext
				loop
				end if
			%>
            
        </div>
    </div>
    <!-- FEATURE SESSION 2 -->
    
</div>
<!-- GLOBAL -->

<!-- #include file = "../inc/footer.asp" -->
<!-- #include file = "../inc/script.asp" -->
</body>
</html>
