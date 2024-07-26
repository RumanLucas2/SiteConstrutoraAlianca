<%
	If Not Session("logged") = True OR Session("iduser") = "" Then
		Session("ref") = True
		Response.Redirect "../home/"
	End If
%>
