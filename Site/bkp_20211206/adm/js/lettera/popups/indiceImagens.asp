<%
	default_nivel = "/aofarmaceutico/backend/"
	default_modulo = 8
%>
<!--#include virtual="/aofarmaceutico/backend/global.asp"-->
<!--#include virtual="/aofarmaceutico/backend/inc_conexao.asp"-->
<!--#include virtual="/aofarmaceutico/backend/inc_funcoes.asp"-->
<!--#include virtual="/aofarmaceutico/backend/includes/template/tpl_getpost.asp"-->
<!--#include virtual="/aofarmaceutico/backend/includes/template/tpl_valvars.asp"-->
<%
	call fun_seguranca(session(session_iduser), session(session_idgrupo), default_modulo, "C", default_nivel)   	
%>
<!--#include virtual="/aofarmaceutico/backend/includes/template/tpl_headers.asp"-->
<!--#include virtual="/aofarmaceutico/backend/includes/inc_menu.asp"-->

<%
	var_campo 	= request.form("campo")
	filtro		= request.form("descricao")
	ordem		= request.form("ordem")
	busca		= request.form("descricao")
	pagina		= request.form("pagina")
	itens		= request.form("itens")
	
	if ordem="" then
		ordem	= request("ordem")
	end if
	
	if itens="" then
		itens	= request("itens")
	end if
	
	if itens="" then
		itens	= 10
	end if
	
	if busca="" then
		busca	= request("busca")
	end if
	
	if pagina="" then
		pagina	= request("pagina")
	end if
	
	if pagina="" then
		pagina	= "1"
	end if
	
	if itens="" then
		itens	= request("itens")
	end if
	
	
	titulo		= "Imagens"
	tabela		= "tbLettera_Imagens"
	campos		= "imagens estão cadastradas no sistema."
%>

<script language="JavaScript" type="text/javascript">
	function jValidaBusca(form)
	{
		if (form.busca.value == "")
		{
			alert("Por favor, preencha o campo BUSCA corretamente.");
			form.busca.focus();
			return false;
		}
	}
	function jValidaExclusao(jURL)
	{
		jMsg = "Deseja Realmente excluir o Arquivo?";
		input_box=confirm(jMsg);
		if (input_box==true)
		{
			// Output when OK is clicked
			location.href = jURL;
		}
	}
</script>

<form action="indiceImagens.asp" name="formItens" id="formItens">
<table width="617" border="0" align="center" cellpadding="3" cellspacing="1" bgcolor="#CCCCCC">
<tr>
		<th colspan="5">Cadastro de <%=titulo%></th>
	</tr>
  <tr bgcolor="#EBEBEB">
      <td align="center">
      	<input type="hidden" name="pagina" id="pagina" value="<%=pagina%>" />
      	<input type="hidden" name="ordem" id="ordem" value="<%=ordem%>" />
	  	<input type="text" name="itens" id="itens" value="<%=itens%>" size="2" maxlength="2" style="font: xx-small Trebuchet MS;" />
      	<input style="border: 0px;" type="image" src="<%=folders_icones%>ico_seta.gif" alt="Itens" />	  </td>
      <td colspan="2" align="center" bgcolor="#EBEBEB"><a href="first.asp"><img src="<%=folders_icones%>ico_lista.gif" alt="Listar todos os registros" title="Listar todos os registros" hspace="5" border="0" align="right" /></a>
        <input style="border: 0px;" type="image" src="<%=folders_icones%>ico_buscar.gif" alt="Buscar" title="Buscar" align="right" />
        Buscar:</font> <input name="busca" type="text" id="busca" value="<%=busca%>" size="24" maxlength="24" />      </td>
    	<td width="60" align="center">&nbsp;</td>
	</tr>
    <tr bgcolor="#F7F7F7">
		<td width="83" align="center"><strong>C&oacute;digo</strong></td>
	  <td align="center"><strong>Arquivo</strong></td>
		<td width="308" align="center">
			<a href="?ordem=descricao&amp;pagina=<%=pagina%>&amp;itens=<%=itens%>&amp;busca=<%=busca%>">
				<img src="<%=folders_icones%>ico_ordem_decres.gif" border="0" align="right" alt="Ordem Decrescente" />			</a>
			<a href="?ordem=descricao%20DESC&amp;pagina=<%=pagina%>&amp;itens=<%=itens%>&amp;busca=<%=busca%>">
				<img src="<%=folders_icones%>ico_ordem_cres.gif" border="0" align="right" alt="Ordem Crescente" />			</a>
			<strong>Descri&ccedil;&atilde;o</strong></td>
	  <td align="center">&nbsp;</td>
    </tr>
	<%
			strSQL			= "SELECT id, arquivo, descricao, tipo,  "&_
					"convert(char(10), data_cadastro, 103)+' '+SUBSTRING(convert(char(10), data_cadastro, 108),1,5) datacadastro "&_
				"FROM tblettera_imagens "
			
			strBusca		= ""
					
			if busca<>"" then 
				busca		= "WHERE descricao LIKE '%"&busca&"%' "
			end if
			
			strSQL			= strSQL & " " & busca
			set rs 			= Server.CreateObject("ADODB.Recordset")
			rs.pagesize 	= cint(itens)
		  
			rs.Open strSQL,conn,1,3, &H0001 
			int counterRec	= 0
			tot_registros	= rs.recordcount
			
			if tot_registros>0 then
				rs.absolutepage = cint(pagina)
			end if
			
			counter			= 1

			do while not rs.eof and counter<=cint(itens)
				counter		= counter+1
		%>
		<tr bgcolor="#FFFFFF" onMouseOver="this.bgColor='#ededed';" onMouseOut="this.bgColor='#ffffff';">
			<td align="center"><%=rs("id")%></td>
			<td width="137" align="center">
				<img src="../../../../_files/dbimagens/<%=rs("arquivo")%>" alt="<%=rs("descricao")%>" title="<%=rs("descricao")%>" border="0" width="60" height="45" />			</td>
		  <td align="center"><%=rs("descricao")%></td>
			<td align="center"><a href="#">
            <img src="<%=folders_icones%>ico_seta.gif" title="Escolher esta imagem" alt="Escolher esta imagem" border="0" 
            onClick="window.opener.document.formCadastro.imageurl.value='<%=rs("arquivo")%>';window.close();" /></a></td>
		</tr>
		<%
				rs.movenext
			loop
		%>

	<tr align="left" bgcolor="#F7F7F7">
		<td colspan="6">
			<font size="2" face="Trebuchet MS"><strong>
				<%=rs.recordcount%></strong>&nbsp;<%=campos%></font>		</td>
	</tr>
	<tr align="left" bgcolor="#FFFFFF">
		<td colspan="6" align=right>


			
							<table border="0" cellpadding="4" cellspacing="1" bgcolor="#B0B0B0"><tr align="center" bgcolor="#E5E5E5">

				<%
				   if cint(pagina)>1 then
					  v_ordem = replace(ordem, " ", "%20")
				%>
					<td style="font-size: 8pt;"> 
						<a href="?pagina=1&amp;ordem=<%=ordem%>&amp;busca=<%=busca%>&amp;itens=<%=itens%>" class="txt_col">
							Primeira						</a>					</td> 
					<td style="font-size: 8pt;">
						<a href="?pagina=1&amp;itens=<%=itens%>&amp;ordem=<%=ordem%>&amp;busca=<%=busca%>">
							Anterior						</a>					</td>
				<% else  %>
					<td style="font-size: 8pt;"> 
						Primeira					</td>
					<td style="font-size: 8pt;"> 
						Anterior					</td>
				<%
				   end if   
				   
				   final = pagina + 9
				   
				   if final >= rs.pagecount then
					  final = rs.pagecount
				   end if
				   
				   
				   
				   for i=cint(pagina) to final
					  if cint(pagina)=i then
				%>		
						<td class="paginacao"><%=i%></td>
				<%
					  else	 
				%>
						<td style="font-size: 8pt;" width="15">
							<a href="?pagina=<%=i%>&amp;ordem=<%=ordem%>&amp;busca=<%=busca%>&amp;itens=<%=itens%>" ><%=i%></a>						</td>
				<%
					  end if
				   next 
				   
				   'Proxima
				   if pagina=rs.pagecount then
				%>
					<td style="font-size: 8pt;"> 
						<a href="?pagina=<%=pagina+1%>&amp;itens=<%=itens%>&amp;ordem=<%=ordem%>&amp;busca=<%=busca%>"<%=pag_class%>" class="txt_col">Pr&oacute;xima</a>					</td>
					<td style="font-size: 8pt;"> 
						<a href="?pagina=<%=rs.pagecount%>&amp;itens=<%=itens%>&amp;ordem=<%=ordem%>&amp;busca=<%=busca%>"<%=pag_class%>" class="txt_col">&Uacute;ltima</a>					</td>	  
					</tr></table>
				<%
				   else
				%>					</tr>
                    </table>
<%   
				   end if
				   rs.close
				   conn.close
				%>	
					</td>
				</tr>
			</table>
			

		</td>
	</tr>
</table>
</form>
