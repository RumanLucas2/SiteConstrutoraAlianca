<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/fn.asp"-->
<!-- #include file="../inc/logado.asp"-->
<!-- #include file="inc.asp"-->
<%
	'Variável recebe Id do usuário
	id = Request.QueryString("id")
	'Se a Id do usuário for vazia ou nula ou não for numérica
	If id = "" Or IsNull(id) Or Not IsNumeric(id) Then
		id = 0	'Variável da Id do usuário recebe "0"
	End If	'Finaliza Se a Id do usuário for vazia ou nula ou não for numérica
	
	tem_foto	= anti_inje(request.querystring("txtArquivo"))
			
	'Cria Objeto Upload
	Set Upload = Server.CreateObject("Dundas.Upload.2")
	Upload.UseUniqueNames = false
	
   'Cria objeto para Pastas
	Set FSO = Server.CreateObject("scripting.FileSystemObject")
	
	'Cria instancia
	Set JPEG = Server.CreateObject("Persits.Jpeg")
	JPEG.Quality = 90
	
	Upload.Save(tmp)
	
	IF Upload.Form("txtRemover") = 1 THEN
		IF FSO.FolderExists(pasta & "\" & id) THEN
			'Deleta antiga pasta
			FSO.DeleteFolder pasta & "\" & id, true
			conexao.execute("UPDATE tbl_banner SET foto = '' WHERE id_banner = " & id)
		END IF
	END IF
	
	if tem_foto <> "" then

		nome_arquivo 	= Trim(Upload.GetFileName(Upload.Files(0).Path))	
		
		'Verifica extensão
		set img = loadpicture(tmp & "\" & nome_arquivo)
		
		'Imagem de exibição é o segundo arquivo do upload
		iWidthImg = round(img.width / 26.4583)
		iHeightImg = round(img.height / 26.4583)
		
		'Se imagem for maior que 3000px, cancela Upload
		If iWidthImg > 3000 then
		
			'Apaga arquivos temporários
			FSO.DeleteFile(tmp & "\" & nome_arquivo)
		
			Response.Redirect "frm_edt.asp?msg=A dimensão da imagem não deve ultrapassar 3000px de largura!&erro=sim&id=" & id
			
		end if
		
		paisagem = ""
		retrato  = ""
		
		IF iWidthImg > iHeightImg THEN
			paisagem 	= "X"
		END IF
		
		IF iWidthImg < iHeightImg THEN
			retrato		= "X"
		END IF
		
	end if 'TERMINA FOTO
	
	'inicia Recordset
	Set Rs = Server.CreateObject("ADODB.RecordSet")
	'Inicia Busca dos campos pela Id
	
	sql = "UPDATE tbl_banner SET id_empreendimento = '" & Upload.Form("txtEmpreendimento") & "', " &_
			"nome = '" & Upload.Form("txtNome") & "', " &_
			"status = '" & Upload.Form("txtStatus") & "' " &_									
			"WHERE id_banner = " & id
	'Executa
	Rs.Open  sql, conexao, 1, 3
	
	if tem_foto <> "" then
		
		IF FSO.FolderExists(pasta & "\" & id) THEN
			'Deleta antiga pasta
			FSO.DeleteFolder pasta & "\" & id, true
		END IF
		
		'Cria pasta
		FSO.CreateFolder(pasta & "\" & id)
		
		'Cria pasta
		FSO.CreateFolder(pasta & "\" & id & "\th")
		
		'Salva arquivos na pasta correta (origem, destino)
		FSO.MoveFile tmp & "\" & Trim(Upload.GetFileName(Upload.Files(0).Path)), pasta & "\" & id & "\" & TrocarAcento(Trim(Upload.GetFileName(Upload.Files(0).Path)))
		
		'Nome dos arquivos
		nome_arquivo 	= TrocarAcento(Trim(Upload.GetFileName(Upload.Files(0).Path)))
	
		Set Rs_upd = Server.CreateObject("ADODB.Recordset")
		sql_upd = "UPDATE tbl_banner SET foto = '" & nome_arquivo & "' WHERE id_banner = " & id
		Rs_upd.Open sql_upd, conexao
		
	end if
	
	if tem_foto <> "" then
	
		'Abre imagem
		JPEG.Open pasta & "\" & id & "\" & nome_arquivo
		
		'Nova largura ou altura
		L = 1920
		H = 450
		
		IF paisagem = "X" THEN
			'Redimensiona mantendo padrão da imagem quando paisagem
			JPEG.Width 	= L
			JPEG.Height = round(JPEG.OriginalHeight * L / JPEG.OriginalWidth)
			ELSE IF retrato = "X" THEN
				'Redimensiona mantendo padrão da imagem quando retrato
				JPEG.Height = H
				JPEG.Width	= round(JPEG.OriginalWidth * H / JPEG.OriginalHeight)
			END IF
		END IF
		
		'Salva foto GRANDE
		JPEG.Save pasta & "\" & id & "\" & nome_arquivo
	
	end if 'ENCERRA TRATAMENTO
	
	
	if tem_foto <> "" then
	
		'Abre imagem
		JPEG.Open pasta & "\" & id & "\" & nome_arquivo
		
		'Nova largura ou altura
		L = 360
		H = 84
		
		IF paisagem = "X" THEN
			'Redimensiona mantendo padrão da imagem quando paisagem
			JPEG.Width 	= L
			JPEG.Height = round(JPEG.OriginalHeight * L / JPEG.OriginalWidth)
			ELSE IF retrato = "X" THEN
				'Redimensiona mantendo padrão da imagem quando retrato
				JPEG.Height = H
				JPEG.Width	= round(JPEG.OriginalWidth * H / JPEG.OriginalHeight)
			END IF
		END IF
		
		'Salva foto GRANDE
		JPEG.Save pasta & "\" & id & "\th\" & nome_arquivo
	
	end if 'ENCERRA TRATAMENTO
	
	'Finaliza conexao
	conexao.close
	Set conexao = nothing
	Set Upload = Nothing
	
	
	'Redireciona pra página de Adicionar Novo Usuário com mensagem OK
	Response.Redirect "frm_edt.asp?msg=ok&id=" & id
			
%>