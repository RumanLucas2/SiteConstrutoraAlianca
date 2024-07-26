<% if (Session("forgot") <> "") then mensagem = Session("forgot") end if%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="../css/adm.css" rel="stylesheet" type="text/css" />
<title><!--#include file="../inc/titulo.asp"--></title>
</head>
<script language="javascript">

		function valida_forgot(form){
			
			if( form.txtEmail.value.indexOf("@") == -1 || form.txtEmail.value.indexOf( "." ) ==-1 ) { 
				alert( ' Preencha corretamente o campo E-mail...'); 
				form.txtEmail.focus(); 
				form.txtEmail.select();
				return false; 
			} 
			
			if ( confirm ( 'Confima o envio das informações acima?' )) { return true; } else { return false; }
			
		}

	</script>
<body>

<!-- DIV MASTER -->
<div id="master" align="center">

<!-- DIV TOPO -->
<div id="header" align="center"><!--#include file="../inc/header.asp"--></div>

<!-- DIV LOGO -->
<div id="logo"><!--#include file="../inc/logo.asp"--></div>

<!-- DIV CONTEUDO -->
<div id="conteudo">
  <table width="700" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td valign="top" align="left" style="padding-left:30px; padding-right:30px;">
		<table width="700" height="276" border="0" cellpadding="0" cellspacing="0">
			<tr>
			  <td height="110" colspan="2" valign="top">
              <font class="rodape" size="2">
              <strong >Por seguran&ccedil;a o sistema automaticamente registra em nossa base de dados todos os acessos a esta p&aacute;gina.</strong><br />
				Seu IP: <%=request.ServerVariables("REMOTE_ADDR")%>
				<% dt=Now()
				formated_dt=day(dt)&"/"&month(dt)&"/"&year(dt)&" "&FormatDateTime(dt,3)
				%><br />Momento do acesso: <%=formated_dt%></font></p><br /><br />
		      <font class="subtitulo"><strong>Painel de Controle - Solicitação de Senha</strong></font><br />
              <div style="width:700px; height:1px; border-bottom:1px dotted #CCCCCC;"></div></td>
			</tr>
			<tr>
			<td width="350" height="147" align="left" valign="middle">
               <table width="262" border="0" cellspacing="0" cellpadding="0">
<tr>
											<td height="28" class="textoMsg"><%= mensagem %></td>
			      </tr>
										<tr align="center" valign="bottom">
											<td height="30" align="right">&nbsp;</td>
				  </tr>
										<tr align="center" valign="bottom">
										  <td height="30" align="left">
                                          <a href="../login/" class="subtitulo">&lt;&lt; retornar ao login</a></td>
				    </tr>
		      </table>							  </td>
							  <td width="350" align="left" valign="middle"><p class="rodape">Bem-vindo ao <strong>Painel de Controle</strong>.

Aqui, você tem acesso a todas as informações 
contidas dentro do seu website, podendo assim 
editar, inserir ou apagar de acordo com a sua
necessidade.

Essas informações são armazenadas
em um banco de Dados, proporcionando
a você, segurança e mobilidade.</p>
			    <p class="rodape">* Para sua segurança, digite a senha utilizando o <strong>teclado virtual</strong>.</p>						      </td>
							</form>
							</tr>
			<tr>
			  <td height="19" align="left" valign="top" class="rodape"><a href="../senha/forgot.asp" class="rodape">Esqueci minha senha!</a> | <a href="../senha/forgot.asp" class="rodape">Fale Conosco</a></td>
			  <td align="left" valign="top" class="texto">&nbsp;</td>
		    </tr>
		  </table>
        </td>
    </tr>
  </table>
</div>

<!-- DIV RODAPE -->
<div id="rodape"><!--#include file="../inc/rodape.asp"--></div>

</div>



</body>
</html>
