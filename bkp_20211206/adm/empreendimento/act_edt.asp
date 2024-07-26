<!-- #include file="../inc/conexao.asp"-->
<!-- #include file="../inc/fn.asp"-->
<!-- #include file="../inc/logado.asp"-->
<%
	'Variável recebe Id do usuário
	id = Request.QueryString("id")
	'Se a Id do usuário for vazia ou nula ou não for numérica
	If id = "" Or IsNull(id) Or Not IsNumeric(id) Then
		id = 0	'Variável da Id do usuário recebe "0"
	End If	'Finaliza Se a Id do usuário for vazia ou nula ou não for numérica
			
	'inicia Recordset
	sql = "UPDATE tbl_empreendimento SET id_tipo = '" & Request.Form("txtTipo") & "', " &_
			"id_fase = '" & Request.Form("txtFase") & "', " &_
			"nome = '" & anti_inje(Request.Form("txtNome")) & "', " &_
			"frase = '" & anti_inje(Request.Form("txtFrase")) & "', " &_
			"conceito = '" & anti_inje(Request.Form("txtConceito")) & "', " &_
			"descricao = '" & anti_inje(nl2br(Request.Form("txtDescricao"))) & "', " &_
			"lazer = '" & anti_inje(Request.Form("txtLazer")) & "', " &_
			"seguranca = '" & anti_inje(Request.Form("txtSeguranca")) & "', " &_
			"diferencial = '" & anti_inje(Request.Form("txtDiferencial")) & "', " &_
			"endereco = '" & anti_inje(Request.Form("txtEndereco")) & "', " &_
			"bairro = '" & anti_inje(Request.Form("txtBairro")) & "', " &_
			"cidade = '" & anti_inje(Request.Form("txtCidade")) & "', " &_
			"estado = '" & anti_inje(Request.Form("txtEstado")) & "', " &_
			"geolocalizacao = '" & anti_inje(Request.Form("txtGeolocalizacao")) & "', " &_
			"destaque = '" & Request.Form("txtDestaque") & "', " &_
			"status = '" & Request.Form("txtStatus") & "' " &_									
			"WHERE id_empreendimento = " & id
						
	'Executa
	conexao.execute(sql)
	
	'Finaliza conexao
	conexao.close
	Set conexao = nothing
	
	Response.Redirect "lista.asp"
%>