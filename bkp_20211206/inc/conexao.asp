<%

	With Response
	 .expires = 0
	 .expiresabsolute = Now() - 1
	 .addHeader "pragma","no-cache"
	 .addHeader "cache-control","private"
	 .CacheControl = "no-cache"
	End With

	' CONEXAO ACCESS
	Set conexao = Server.CreateObject("ADODB.Connection")
	conn = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source="& Server.MapPath("../../Dados/db.mdb")
	conexao.Open(conn)
	
	tmpFilePath = Request.ServerVariables("SCRIPT_NAME")
	var_path1 = mid(tmpFilePath,InstrRev(tmpFilePath,"/")+1)

	IF var_path1 = "noticias.asp" OR var_path1 = "noticias_det.asp" THEN
		Session.LCID = 1046
	ELSE
		Session.LCID = 1033
	END IF

%>