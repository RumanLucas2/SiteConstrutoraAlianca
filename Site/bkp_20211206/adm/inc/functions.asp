<%
function calculaPaginacao(argRPP,argRT,argPA,argURL,argParametros)
	resultadosPorPagina = argRPP
	resultadosTotal 	= argRT
	paginaAtual 		= argPA
	parametros 			= argParametros

	numeroPaginas 		= Int(resultadosTotal / resultadosPorPagina)
	if (resultadosTotal mod resultadosPorPagina) > 0 then
		numeroPaginas = numeroPaginas + 1
	end if
	resultadosMostradosMin = (paginaAtual * resultadosPorPagina) - resultadosPorPagina
	if resultadosMostradosMin < 1 then
		resultadosMostradosMin = 1
	end if
	if paginaAtual > 1 then
		resultadosMostradosMin = resultadosMostradosMin + 1
	end if
	resultadosMostradosMax = (paginaAtual * resultadosPorPagina)
	if resultadosMostradosMax > resultadosTotal then
		resultadosMostradosMax = resultadosTotal
	end if
	if not paginaAtual = 1 then
		primeiraPagina = "<a href="""&argURL&"page=1"&parametros&"""><font style='color:#00AAAF;'>primeira</font></a>"
		paginaAnterior = "<a href="""&argURL&"page="&paginaAtual-1&parametros&"""><font style='color:#00AAAF;'>&lt; anterior</font></a>"
	else
		primeiraPagina = "primeira"
		paginaAnterior = "&lt; anterior"
	end if
	if not paginaAtual = numeroPaginas then
		ultimaPagina = "<a href="""&argURL&"page="&numeroPaginas&parametros&"""><font style='color:#00AAAF;'>&uacute;ltima</font></a>"
		paginaProxima = "<a href="""&argURL&"page="&paginaAtual+1&parametros&"""><font style='color:#00AAAF;'>pr&oacute;xima &gt;</font></a>"
	else
		ultimaPagina = "&uacute;ltima"
		paginaProxima = "pr&oacute;xima &gt;"
	end if
end function

function loginRedirect(argURLAnterior)
	if session("usuario.logado") = "" then
		if login <> "" then
			falhou="&falhou=1"
		end if
		response.Redirect("login.asp?surl="&argURLAnterior&falhou)
	end if
end function

function admLoginRedirect(argURLAnterior)
	if session("logado") = true then
	
		sqlID 	= "SELECT cd_usuario "&_
			"FROM t_sib_usuarios_adm "&_
			"WHERE cd_usuario='"&session("usuario.cd_usuario")&+"'"
			
		set rsAdmLogin = Server.CreateObject("ADODB.Recordset")
		rsAdmLogin.Open sqlID, Cn,1,3
		isAdm	= ""
		
		if not rsAdmLogin.EOF then
			isAdm	= "SIM"
		end if
		rsAdmLogin.close
		
		if isAdm = "" then
			response.Redirect("../def/epm_default.asp")
		end if
	else
		response.Redirect("../includes/adm_login.asp?surl="&argURLAnterior&falhou)
	end if
end function

%>