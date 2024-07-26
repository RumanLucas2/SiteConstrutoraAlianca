<%@LANGUAGE="VBSCRIPT" CODEPAGE="1252"%>
<!-- #include file="../inc/logged.asp"-->
<!-- #include file="../inc/conexao.asp"-->
<%
	if session("iduser") <> "" then
		
		strLast = now()
		sql = "UPDATE tbl_usuario SET data_ultimoacesso ='" & strLast & "' WHERE id_usuario = " & Session("iduser") & ""
		set Rs = conexao.execute(sql)
		
		Session("logged") = False
		Session("msg_login") = ""
      	Session.Contents.RemoveAll()
	 	response.Redirect("../home/")
	else
		Session("msg_login") = ""
		conexao.close
		response.Redirect("../home/")
	end if	
%>