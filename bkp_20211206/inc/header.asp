<!-- TOP -->
<div id="top">
    <div class="pattern"></div>
    <div class="logo" onclick="location.href='../home/'"><img src="../img/global/logo_size1.png" border="0" /></div>
    <div class="menu">
    	<%
			Select Case pagina_atual
				Case "empresa"
					Response.Write("<div class=""arrow"" style=""margin-left:110px;""></div>")
				Case "lancamentos"
					Response.Write("<div class=""arrow"" style=""margin-left:220px;""></div>")
				Case "andamento"
					Response.Write("<div class=""arrow"" style=""margin-left:365px;""></div>")
				Case "entregues"
					Response.Write("<div class=""arrow"" style=""margin-left:495px;""></div>")
				Case "empreendedores"
					Response.Write("<div class=""arrow"" style=""margin-left:610px;""></div>")
				Case "faleconosco"
					Response.Write("<div class=""arrow"" style=""margin-left:740px;""></div>")
				Case Else
					Response.Write("<div class=""arrow"" style=""margin-left:110px;""></div>")
			End Select
		%>
        
        <ul>
            <li id="empresa" onclick="location.href='../empresa'" <%if pagina_atual = "empresa" then %> style="color:#FF3;"<%end if%>>A EMPRESA</li>
            <li id="lancamentos" onclick="location.href='../lancamentos'" <%if pagina_atual = "lancamentos" then %> style="color:#FF3;"<%end if%>>LANÇAMENTOS</li>
            <li id="obras" onclick="location.href='../andamento'" <%if pagina_atual = "andamento" then %> style="color:#FF3;"<%end if%>>OBRAS EM ANDAMENTO</li>
            <li id="entregues" onclick="location.href='../entregues'" <%if pagina_atual = "entregues" then %> style="color:#FF3;"<%end if%>>ENTREGUES</li>
            <li id="empreendedores" onclick="location.href='../empreendedores'" <%if pagina_atual = "empreendedores" then %> style="color:#FF3;"<%end if%>>EMPREENDEDORES</li>
            <li id="faleconosco" onclick="location.href='../faleconosco'" <%if pagina_atual = "faleconosco" then %> style="color:#FF3;"<%end if%>>FALE CONOSCO</li>
        </ul>
  </div>
</div>
