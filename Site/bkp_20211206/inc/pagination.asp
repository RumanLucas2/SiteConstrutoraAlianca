<%
	pagina_url = Request.ServerVariables("URL")
	pagina_url_array = Split(pagina_url, "/")
	pagina_atual = pagina_url_array(ubound(pagina_url_array))
%>


            <div class="pagination">
                
                <div class="block">
                
                    <div class="corner_left"></div>
                    
                    <div class="content2">
                    
                    <form name="List" action="" method="GET">
                        <% If Page <> 1 Then %>
                            <div class="first"><a href="javascript: ChangePage('F', '<%=pagina_atual%>');"><span class="displace">Primeira</span></a></div>
                            <div class="previous"><a href="javascript: ChangePage('P', '<%=pagina_atual%>')"><span class="displace">Anterior</span></a></div>
                        <% Else %>
                             <div class="first_off"><a href="#" style="cursor:default"></a></div><div class="previous_off"><a href="#" style="cursor:default"></a></div>
                        <% End If %>
	                    	<div class="page">Página <span><%=Page%></span> de <span><%=Rs.PageCount%></span></div>
                        <% If Page <> Rs.PageCount Then %>
                            <div class="next"><a href="javascript: ChangePage('N', '<%=pagina_atual%>');"><span class="displace">Próxima</span></a></div>
                            <div class="last"><a href="javascript: ChangePage('L', '<%=pagina_atual%>')"><span class="displace">Última</span></a></div>
                        <% Else %>
                             <div class="next_off"><a href="#" style="cursor:default"></a></div><div class="last_off"><a href="#" style="cursor:default"></a></div>
                        <% End If %>
                        <input type="hidden" name="Pagina" value="<%= Page %>" id="Hidden1" />
                        <input type="hidden" name="UltimaPagina" value="<%= Rs.PageCount %>" id="Hidden2" />
                    </form>
                    
                    </div>
                    
                    <div class="corner_right"></div>
                
            	</div>    
                
            </div>