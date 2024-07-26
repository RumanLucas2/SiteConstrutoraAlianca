<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/fn.asp"-->
<!-- #include file="../inc/logado.asp"-->
<!-- #include file="inc.asp"-->
<%
	'Variável recebe Id do usuário
	id = Request.QueryString("id_galeria")
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
	
	Upload.Save(tmp)
	
	'Verifica extensão
	'Foto
	Set img = loadpicture(tmp & "\" & Trim(Upload.GetFileName(Upload.Files(0).Path)))
	
	'Imagem de exibição é o segundo arquivo do upload
	iWidthImg = round(img.width / 26.4583)
	iHeightImg = round(img.height / 26.4583)
	
	If iWidthImg > 3000 then
		'Apaga arquivos temporários
		FSO.DeleteFile(tmp & "\" & Trim(Upload.GetFileName(Upload.Files(0).Path)))
		Response.Redirect "lista_fot.asp?id_galeria=" & id & "&msg=A dimensão da imagem não deve ultrapassar 3.000px de largura!"
	end if
	
	paisagem = ""
	retrato  = ""
	
	IF iWidthImg > iHeightImg THEN
		paisagem 	= "X"
	END IF
	
	IF iWidthImg < iHeightImg THEN
		retrato		= "X"
	END IF

	'inicia Recordset
	Set Rs = Server.CreateObject("ADODB.RecordSet")
	
	'Inicia Busca dos campos pela Id
	sql = "SELECT * FROM tbl_galeria_planta_foto WHERE id_foto = 0"
	
	'Executa
	Rs.Open  sql, conexao, 1, 3
	
	'Se não for encontrado ninguém
	If Rs.Eof Then
		Rs.ADDNew	'Adiciona novo registro
	End If	'Finaliza Se não for encontrado ninguém
	
	'Atribui valores
	Rs("status")	= 1
	
	'Executa Update
	Rs.Update
	'Finaliza Recordset
	Rs.Close 
	Set Rs = Nothing
	
	'Verifica ultimo ID inserido
	Set Rs_max = Server.CreateObject("ADODB.Recordset")
	sql_max = "SELECT MAX(id_foto) as id_foto FROM tbl_galeria_planta_foto"
	Rs_max.Open sql_max, conexao
	
	'Se houver ID, gera-se seu relacionamento com o MENU
	if not Rs_max.eof then
		id_foto = Rs_max("id_foto")
	end if
	
	'Cria pasta
	FSO.CreateFolder(pasta & "\" & id & "\" & id_foto)
	'Salva arquivos na pasta correta (origem, destino)
	FSO.MoveFile tmp & "\" & Trim(Upload.GetFileName(Upload.Files(0).Path)), pasta & "\" & id & "\" & id_foto & "\" & TrocarAcento(Trim(Upload.GetFileName(Upload.Files(0).Path)))
	
	'Nome dos arquivos
	nome_arquivo 	= TrocarAcento(Trim(Upload.GetFileName(Upload.Files(0).Path)))
	descricao		= anti_inje(Upload.Form("txtNome"))
	
	'Inicia redimensionamento foto GRANDE
	'Foto de pe 	338 X 450
	'Foto deitada	600 X 450	
	
	'Abre imagem
	JPEG.Open pasta & "\" & id & "\" & id_foto & "\" & nome_arquivo
	
	'Nova largura ou altura
	L = 1024
	H = 768
	
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
	JPEG.Save pasta & "\" & id & "\" & id_foto & "\" & nome_arquivo
	
	'Inicia redimensionamento foto THUMBNAIL
	'Foto de pe 		86 X 65
	'Foto deitada		115 X 86	
	
	'Cria pasta de Thumb
	FSO.CreateFolder(pasta & "\" & id & "\" & id_foto & "\th")
	
	'Abre imagem
	JPEG.Open pasta & "\" & id & "\" & id_foto & "\" & nome_arquivo
	
	'Nova largura ou altura
	L = 420
	H = 420
	
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
	
	' create thumbnail and save it to disk
	JPEG.Save pasta & "\" & id & "\" & id_foto & "\th\" & nome_arquivo

	Set Rs_upd = Server.CreateObject("ADODB.Recordset")
	sql_upd = "UPDATE tbl_galeria_planta_foto SET arquivo = '" & nome_arquivo & "', nome = '" & descricao & "', id_galeria = '" & id & "', data_cadastro = '" & PrepareDAT2(Now,1) & " " & PrepareDAT2(Now,2) & "' WHERE id_foto = " & id_foto
	Rs_upd.Open sql_upd, conexao
	
	'Finaliza conexao
	conexao.close
	Set conexao = Nothing
	Set Upload = Nothing
	
	'Redireciona pra página de Adicionar Novo Usuário com mensagem OK
	Response.Redirect "lista_fot.asp?msg=ok&id_galeria="&id
			
%>