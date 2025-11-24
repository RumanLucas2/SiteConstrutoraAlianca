<%
	If Not Session("logado") = True OR Session("Codigo") = "" Then
		Session("ref") = True
		Response.Redirect "../login/index.asp"
	End If
%>
