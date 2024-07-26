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
	
   'Cria Objeto Upload
	Set Upload = Server.CreateObject("Dundas.Upload.2")
	Upload.UseUniqueNames = false
	
   'Cria objeto para Pastas
	Set FSO = Server.CreateObject("scripting.FileSystemObject")
	
	'Cria instancia
	Set JPEG = Server.CreateObject("Persits.Jpeg")
	JPEG.Quality = 90
	
	Upload.Save(tmp)
	
	IF request.querystring("foto") <> "" THEN
		tem_foto = true
	ELSE
		tem_foto = false
	END IF
		
	IF tem_foto THEN
	
		nome_arquivo 	= Trim(Upload.GetFileName(Upload.Files(0).Path))	
		
		'Verifica extensão
		'Foto Notícia
		set img = loadpicture(tmp & "\" & nome_arquivo)
		
		'Imagem de exibição é o segundo arquivo do upload
		iWidthImg = round(img.width / 26.4583)
		iHeightImg = round(img.height / 26.4583)
		
		If iWidthImg > 3000 then
		
			Session("nome")			= Upload.Form("txtNome")
			Session("status")		= request.querystring("txtStatus")
		
			'Apaga arquivos temporários
			FSO.DeleteFile(tmp & "\" & nome_arquivo)
		
			Response.Redirect "frm_add.asp?msg=A dimensão da imagem não deve ultrapassar 3000px de largura!&erro=sim"
			
		end if
		
		paisagem = ""
		retrato  = ""
		
		IF iWidthImg > iHeightImg THEN
			paisagem 	= "X"
		END IF
		
		IF iWidthImg < iHeightImg THEN
			retrato		= "X"
		END IF

	END IF 'TERMINA FOTO
	
	'inicia Recordset
	Set Rs = Server.CreateObject("ADODB.RecordSet")
	'Inicia Busca dos campos pela Id
	
	sql = "SELECT * FROM tbl_banner WHERE id_banner = 0"
	
	'Executa
	Rs.Open  sql, conexao, 1, 3
	
	'Se não for encontrado ninguém
	If Rs.Eof Then
		Rs.ADDNew	'Adiciona novo registro
	End If	'Finaliza Se não for encontrado ninguém
	
	'Atribui valores
	Rs("id_empreendimento")	= Upload.Form("txtEmpreendimento")
	Rs("nome")				= Upload.Form("txtNome")
	
	IF tem_foto THEN	
		Rs("foto")			= nome_arquivo
	END IF
	
	Rs("data_cadastro")		= PrepareDAT2(Now,1) & " " & PrepareDAT2(Now,2)
	Rs("status")			= Upload.Form("txtStatus")
	
	'Executa Update
	Rs.Update
	'Finaliza Recordset
	Rs.Close 
	
	'Verifica ultimo ID inserido
	Set Rs_max = Server.CreateObject("ADODB.Recordset")
	sql_max = "SELECT MAX(id_banner) as id_banner FROM tbl_banner"
	Rs_max.Open sql_max, conexao
	
	'Se houver ID, gera-se seu relacionamento com o MENU
	if not Rs_max.eof then
		id_banner = Rs_max("id_banner")
	end if
	
	IF tem_foto THEN	
		'Cria pasta
		FSO.CreateFolder(pasta & "\" & id_banner)
		
		'Cria pasta
		FSO.CreateFolder(pasta & "\" & id_banner & "\th")
		
		FSO.MoveFile tmp & "\" & nome_arquivo, pasta & "\" & id_banner & "\" & TrocarAcento(Trim(Upload.GetFileName(Upload.Files(0).Path)))
	END IF
	
	if tem_foto then
	
		'Abre imagem
		JPEG.Open pasta & "\" & id_banner & "\" & nome_arquivo
		
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
		JPEG.Save pasta & "\" & id_banner & "\" & nome_arquivo
	
	end if 'ENCERRA TRATAMENTO
	
	if tem_foto then
	
		'Abre imagem
		JPEG.Open pasta & "\" & id_banner & "\" & nome_arquivo
		
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
		JPEG.Save pasta & "\" & id_banner & "\th\" & nome_arquivo
	
	end if 'ENCERRA TRATAMENTO
	
	'Finaliza conexao
	conexao.close
	Set conexao = nothing
	Set Upload = Nothing
	
	'Redireciona pra página de Adicionar Novo Usuário com mensagem OK
	Response.Redirect "lista.asp"
%>