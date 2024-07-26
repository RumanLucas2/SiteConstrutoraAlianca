<%
	function anti_inje(valor)
	
    	valor = replace(valor, chr(39) , "''")
    	valor = replace(valor, chr(34) , "&quot;")
	
		inje  = array ( "select" , "drop" ,  ";" , "--" , "insert" , "delete" ,  "xp_")
			
			for i = 0 to uBound(inje)
				valor = replace(valor,inje(i) ,"")
			next
	
		anti_inje = valor

	end function
	
	function ap(valor)
		
    	valor = replace(valor, "''",chr(39))
		ap = valor
					
	end function
	
	function tira_acentos()
	
		palavra = Lcase("a·‡„‚‰eÈËÍÎiÌÏÓÔoÛÚıÙˆu˙˘˚¸")
		acentos = "a·‡„‚‰eÈËÍÎiÌÏÓÔoÛÚıÙˆu˙˘˚¸"
		
		nvoltas = len(acentos)
		for voltas = 1 to nvoltas step 1
			select case voltas
				case 1,2,3,4,5,6
					str = "a"
				case 7,8,9,10,11
					str = "e"
				case 12,13,14,15,16
					str = "i"
				case 17,18,19,20,21,22
					str = "o"
				case 23,24,25,26,27
					str = "u"
			end select
			palavra = replace(palavra,right(left(acentos,voltas),1),str)
		next
	
		tira_acentos=palavra

	end function
		
	function nl2br(valor)
	
		valor = replace(valor,vbNewline,"<br />")
		nl2br = valor
		
	end function
	
	'********************************************
	'FUN«√O PARA A DATA NO SQL SERVER (RECUPERAR)
	'********************************************
	Function PrepareDAT(datData, Forma) 
	 If Not IsDate(datData) Then 
	  datData = datData
	 End If 
	 Dia = "" & Right("00" & Cstr(Day(datData)), 2) 
	 Mes = "" & Right("00" & Cstr(Month(datData)), 2) 
	 Ano = "" & Right("0000" & Cstr(Year(datData)), 4) 
	 Hora = "" & Right("00" & Cstr(Hour(datData)), 2) 
	 Minuto = "" & Right("00" & Cstr(Minute(datData)), 2) 
	 If Forma = 1 Then 
	 
		url = Request.ServerVariables("SERVER_NAME")
		Select Case url
			Case "localhost"
				PrepareDAT = CStr(Trim(Dia) & "/" & Trim(Mes) & "/" & Trim(Ano)) 
			Case Else
				PrepareDAT = CStr(Trim(Dia) & "/" & Trim(Mes) & "/" & Trim(Ano)) 
		End Select
	 
	 ElseIf Forma = 2 Then 
	  PrepareDAT = CStr(Trim(Hora) & ":" & Trim(Minuto)) 
	 End If 
	End Function
	
	
	'******************************************
	'FUN«√O PARA A DATA NO SQL SERVER (INSERIR)
	'******************************************
	Function PrepareDAT2(datData, Forma) 
	 If Not IsDate(datData) Then 
	  datData = datData
	 End If 
	 Dia = "" & Right("00" & Cstr(Day(datData)), 2)
	 Mes = "" & Right("00" & Cstr(Month(datData)), 2)
	 Ano = "" & Right("0000" & Cstr(Year(datData)), 4)
	 Hora = "" & Right("00" & Cstr(Hour(datData)), 2)
	 Minuto = "" & Right("00" & Cstr(Minute(datData)), 2)
	 If Forma = 1 Then 
	 
		url = Request.ServerVariables("SERVER_NAME")
		Select Case url
			Case "localhost"
			  PrepareDAT2 = CStr(Trim(Dia) & "/" & Trim(Mes) & "/" & Trim(Ano))
			Case Else
			  PrepareDAT2 = CStr(Trim(Ano) & "/" & Trim(Mes) & "/" & Trim(Dia))
		End Select
	 
	 ElseIf Forma = 2 Then 
	  PrepareDAT2 = CStr(Trim(Hora) & ":" & Trim(Minuto)) 
	 End If 
	End Function
	
	
	'********************************
	' SELECT MARCADO
	'********************************
	Function Seleciona(valor1, valor2)
	 If CStr(valor1) = CStr(valor2) Then
	  Response.Write "selected"
	 End If
	End Function

	'Download de arquivos por causa de problema de acentuaÁ„o
	function download2(arquivo, pasta) 
		
		dim objStream 
		   
		set objStream = server.createObject("ADODB.Stream") 
		   
		with (response) 
			   
			.buffer = true 
			.addHeader "Content-Type","application/x-msdownload" 
			.addHeader "Content-Disposition","attachment; filename="&arquivo 
			.ContentType = "application/octet-stream"
			.flush 
		   
		end with 
		  
		with (objStream) 
			   
			.open 
			.type = 1 
			.loadFromFile server.mapPath(pasta) 
			
		end with 
		   
		response.binaryWrite objStream.read 
			
		set objStream = nothing 
		   
		response.flush 
		
	end function

	function download(arquivo, pasta)  
		 '-- set absolute file location  
		 strAbsFile = Server.MapPath(pasta & "\" & arquivo)  
		 '-- create FSO object to check if file exists and get properties  
		 Set objFSO = Server.CreateObject("Scripting.FileSystemObject")  
		 '-- check to see if the file exists  
		 If objFSO.FileExists(strAbsFile) Then  
			 Set objFile = objFSO.GetFile(strAbsFile)  
			 '-- first clear the response, and then set the appropriate headers  
			 Response.Clear  
			 '-- the filename you give it will be the one that is shown  
			 ' to the users by default when they save  
			Response.AddHeader "Content-Disposition", "attachment; filename=" & objFile.Name  
			 Response.AddHeader "Content-Length", objFile.Size  
			 Response.ContentType = "application/octet-stream"  
			 Set objStream = Server.CreateObject("ADODB.Stream")  
			 objStream.Open  
			 '-- set as binary  
			 objStream.Type = 1  
			 Response.CharSet = "UTF-8"  
			 '-- load into the stream the file  
			 objStream.LoadFromFile(strAbsFile)  
			 '-- send the stream in the response  
			 Response.BinaryWrite(objStream.Read)  
			 objStream.Close  
			 Set objStream = Nothing  
			 Set objFile = Nothing  
		 Else 'objFSO.FileExists(strAbsFile)  
			 Response.Clear  
			 Response.Write("No such file exists.")  
		 End If  
		 Set objFSO = Nothing  
		 
	End function  

	function DownloadFile(file)  
		 '--declare variables  
		 Dim strAbsFile  
		 Dim strFileExtension  
		 Dim objFSO  
		 Dim objFile  
		 Dim objStream  
		 '-- set absolute file location  
		 strAbsFile = Server.MapPath(file)  
		 '-- create FSO object to check if file exists and get properties  
		 Set objFSO = Server.CreateObject("Scripting.FileSystemObject")  
		 '-- check to see if the file exists  
		 If objFSO.FileExists(strAbsFile) Then  
			 Set objFile = objFSO.GetFile(strAbsFile)  
			 '-- first clear the response, and then set the appropriate headers  
			 Response.Clear  
			 '-- the filename you give it will be the one that is shown  
			 ' to the users by default when they save  
			Response.AddHeader "Content-Disposition", "attachment; filename=" & objFile.Name  
			 Response.AddHeader "Content-Length", objFile.Size  
			 Response.ContentType = "application/octet-stream"  
			 Set objStream = Server.CreateObject("ADODB.Stream")  
			 objStream.Open  
			 '-- set as binary  
			 objStream.Type = 1  
			 Response.CharSet = "UTF-8"  
			 '-- load into the stream the file  
			 objStream.LoadFromFile(strAbsFile)  
			 '-- send the stream in the response  
			 Response.BinaryWrite(objStream.Read)  
			 objStream.Close  
			 Set objStream = Nothing  
			 Set objFile = Nothing  
		 Else 'objFSO.FileExists(strAbsFile)  
			 Response.Clear  
			 Response.Write("No such file exists.")  
		 End If  
		 Set objFSO = Nothing  
	End function  
	
	Function TirarAcento(Palavra)
		CAcento = "‡·‚„‰ËÈÍÎÏÌÓÔÚÛÙıˆ˘˙˚¸¿¡¬√ƒ»… ÀÃÕŒ“”‘’÷Ÿ⁄€‹Á«Ò—"
		SAcento = "aaaaaeeeeiiiiooooouuuuAAAAAEEEEIIIOOOOOUUUUcCnN"
		Texto = ""
		If Palavra <> "" then
				For X = 1 To Len(Palavra)
					   Letra = Mid(Palavra,X,1)
					   Pos_Acento = InStr(CAcento,Letra)
					   If Pos_Acento > 0 Then Letra = mid(SAcento,Pos_Acento,1)
					   Texto = Texto & Letra
				Next
				TirarAcento = Texto
		End If
	End Function  
	
	Function TrocarAcento(Palavra)
		CAcento = "‡·‚„‰ËÈÍÎÏÌÓÔÚÛÙıˆ˘˙˚¸¿¡¬√ƒ»… ÀÃÕŒ“”‘’÷Ÿ⁄€‹Á«Ò—"
		Texto = ""
		If Palavra <> "" Then
				For X = 1 to Len(Palavra)
					   Letra = Mid(Palavra,X,1)
					   Pos_Acento = InStr(CAcento,Letra)
					  If Pos_Acento > 0 Then 
					 
						Select Case Letra
						
							Case "·","¡","‡","¿","„","√","‚","¬","‚"
							Letra = "a"
							
							Case "È","…","Í"," "
							Letra = "e"
							
							Case "Ì","Õ"
							Letra = "i"
							
							Case "Û","”","Ù","‘","ı","’"
							Letra = "o"
							
							Case "˙","⁄"
							Letra = "u"
							
							Case "Á","«"
							Letra = "c"
						
							Case "Ò","—"
							Letra = "n"
						
						End Select

					  
					  End if
					  
					 Texto = Texto & Letra
				Next
			  TrocarAcento = Texto
		End If
	End Function 
	
%>

