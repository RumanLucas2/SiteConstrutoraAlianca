<?php
$nome = "SAT - Construtora Aliança";
$arquivo = $_FILES["arquivo"];

// Para quem vai ser enviado o email
$email = "sat@construtoraalianca.com.br";
$exibir_apos_enviar='enviado.html';
$assunto = "Arquivo recebido pelo Site";

$arquivo = isset($_FILES["arquivo"]) ? $_FILES["arquivo"] : FALSE;

if(file_exists($arquivo["tmp_name"]) and !empty($arquivo)){

$fp = fopen($_FILES["arquivo"]["tmp_name"],"rb");
$anexo = fread($fp,filesize($_FILES["arquivo"]["tmp_name"])); 
$anexo = base64_encode($anexo); 

fclose($fp);

$anexo = chunk_split($anexo); 

$boundary = "XYZ-" . date("dmYis") . "-ZYX"; 

$mensagem =" 
--------------------------------------------------------<br />
TERMO | ASSISTÊNCIA TÉCNICA<br />
--------------------------------------------------------<br />
<br />
Olá Administrador,<br />
\n
Um novo termo foi enviado.<br />
<br />
O arquivo encontra-se anexo para a análise.<br />
<br /> <br /> <br /> <br /> <br /> 
-------------------------------------------------------- <br />
Não responda este email. Ele foi gerado automaticamente. <br /><br />";

$mens = "--$boundary\n";
$mens .= "Content-Transfer-Encoding: 8bits\n";
$mens .= "Content-Type: text/html; charset=\"ISO-8859-1\"\n\n"; //plain
$mens .= "$mensagem\n";
$mens .= "--$boundary\n";
$mens .= "Content-Type: ".$arquivo["type"]."\n"; 
$mens .= "Content-Disposition: attachment; filename=\"".$arquivo["name"]."\"\n"; 
$mens .= "Content-Transfer-Encoding: base64\n\n"; 
$mens .= "$anexo\n"; 
$mens .= "--$boundary--\r\n"; 

$headers = "MIME-Version: 1.0\n"; 
$headers .= "From: \"$nome\" <$email_from>\r\n"; 
$headers .= "Content-type: multipart/mixed; boundary=\"$boundary\"\r\n"; 
$headers .= "$boundary\n";


//envio o email com o anexo 
mail($email,$assunto,$mens,$headers); 

echo "<script>window.location='$exibir_apos_enviar'</script>";

}