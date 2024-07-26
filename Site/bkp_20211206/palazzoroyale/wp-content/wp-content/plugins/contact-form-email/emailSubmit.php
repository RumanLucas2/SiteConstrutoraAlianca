<?php
/*
	$nonce=$_REQUEST['_wpnonce'];
	echo $nonce;

    	if (! wp_verify_nonce($nonce) ) die("Security check");
*/
	$to = $_REQUEST['to_email'];
	$email = $_REQUEST['email'] ;
	$name= $_REQUEST['name'] ;
	$subject = $_REQUEST['subject'] ;
	$message = $_REQUEST['message'] ;
	$headers = 'From: '.$name.' Web Contact <'.$email.'>' . "\r\n";
	$referrer = $_SERVER['HTTP_REFERER'];
	/*
	echo $to;
	echo $email;
	echo $subject;
	echo $message;
	echo $headers;
	echo $referrer;
	*/
	
	mail( $to, $subject, $message, $headers);
?>
<html>
	<head>
		<title>
			Email Submission
		</title>
		<script type="text/JavaScript">
			<!--
			setTimeout("location.href = '<?php echo $referrer ?>';",1500);
			-->
		</script>
	</head>
	<body>
		Thank you for contact us.  We will get back with you soon.
	</body>
</html>