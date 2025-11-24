$(document).ready(function(e) {
	
	$('li').hover(function() {

		if ($(this).attr('id') == 'empresa')
		{
			$(this).parent().parent().find('.arrow').stop(false,true).animate({marginLeft: '110px'}, {duration:400, easing: 'easeOutQuad'});
		} 
		else if ($(this).attr('id') == 'lancamentos') 
		{
			$(this).parent().parent().find('.arrow').stop(false,true).animate({marginLeft: '220px'}, {duration:400, easing: 'easeOutQuad'});
		}
		else if ($(this).attr('id') == 'obras') 
		{
			$(this).parent().parent().find('.arrow').stop(false,true).animate({marginLeft: '365px'}, {duration:400, easing: 'easeOutQuad'});
		}
		else if ($(this).attr('id') == 'entregues') 
		{
			$(this).parent().parent().find('.arrow').stop(false,true).animate({marginLeft: '495px'}, {duration:400, easing: 'easeOutQuad'});
		}
		else if ($(this).attr('id') == 'empreendedores') 
		{
			$(this).parent().parent().find('.arrow').stop(false,true).animate({marginLeft: '610px'}, {duration:400, easing: 'easeOutQuad'});
		}
		else if ($(this).attr('id') == 'faleconosco') 
		{
			$(this).parent().parent().find('.arrow').stop(false,true).animate({marginLeft: '740px'}, {duration:400, easing: 'easeOutQuad'});
		}
	}, function() {
                    
		if (menuatual == 'empresa')
		{
			$(this).parent().parent().find('.arrow').stop(false,true).animate({marginLeft: '110px'}, {duration:400, easing: 'easeOutQuad'});
		} 
		else if (menuatual == 'lancamentos') 
		{
			$(this).parent().parent().find('.arrow').stop(false,true).animate({marginLeft: '220px'}, {duration:400, easing: 'easeOutQuad'});
		}
		else if (menuatual == 'obras') 
		{
			$(this).parent().parent().find('.arrow').stop(false,true).animate({marginLeft: '365px'}, {duration:400, easing: 'easeOutQuad'});
		}
		else if (menuatual == 'entregues') 
		{
			$(this).parent().parent().find('.arrow').stop(false,true).animate({marginLeft: '495px'}, {duration:400, easing: 'easeOutQuad'});
		}
		else if (menuatual == 'empreendedores') 
		{
			$(this).parent().parent().find('.arrow').stop(false,true).animate({marginLeft: '610px'}, {duration:400, easing: 'easeOutQuad'});
		}
		else if (menuatual == 'faleconosco') 
		{
			$(this).parent().parent().find('.arrow').stop(false,true).animate({marginLeft: '740px'}, {duration:400, easing: 'easeOutQuad'});
		}
	});	
		
	/* FEATURED SESSION 1 BOX • HOVER */	
	$('#featured_session1 ul li .frame').hover(function() {
		$(this).parent().find('.img').stop(false,true).fadeTo(200, 0.5);
	},
	function() {
		$(this).parent().find('.img').stop(false,true).fadeTo(200, 1);
	});
	
	/* FEATURED SESSION 2 BOX • HOVER */	
	$('#featured_session2 ul li .frame').hover(function() {
		$(this).parent().find('.img').stop(false,true).fadeTo(200, 0.5);
	},
	function() {
		$(this).parent().find('.img').stop(false,true).fadeTo(200, 1);
	});
	
	/* GALERY • HOVER */	
	$('.wrapper ul li').hover(function() {
		$(this).find('.img').stop(false,true).fadeTo(200, 0.5);
	},
	function() {
		$(this).find('.img').stop(false,true).fadeTo(200, 1);
	});
	
});
// END DOCUMENT READY

function showFeature(value)
{
	if (value == 1)
	{
		$('#tab1').addClass('on');
		$('#tab2').removeClass('on');
		$('#tab3').removeClass('on');
		
		$('#feat2').fadeOut();
		$('#feat3').fadeOut();
		$('#feat1').delay(400).fadeIn();
	}
	
	if (value == 2)
	{
		$('#tab1').removeClass('on');
		$('#tab2').addClass('on');
		$('#tab3').removeClass('on');
		
		$('#feat1').fadeOut();
		$('#feat3').fadeOut();
		$('#feat2').delay(400).fadeIn();
	}
	
	if (value == 3)
	{
		$('#tab1').removeClass('on');
		$('#tab2').removeClass('on');
		$('#tab3').addClass('on');
		
		$('#feat1').fadeOut();
		$('#feat2').fadeOut();
		$('#feat3').delay(400).fadeIn();
	}
}

// FUNCTION • VALIDATE LOGIN
function loginValidate(form,evento)
{
	if (form.txtEmail.value=="E-mail"|| form.txtEmail.value=="") {
		//alert("Enter your username.");
		$('#msg_login').text('Digite seu e-mail.');
		form.txtEmail.focus();
		return false;
	}

	if (form.txtPassword.value=="Senha" || form.txtPassword.value=="") {
		//alert("Enter your password.");
		$('#msg_login').text('Digite sua senha.');
		form.txtPassword.focus();
		return false;
	}
	
	$('#msg_login').text('');
}

// CONTACT VALIDATE
function contactValidate(form,evento)
{
	tipo = $('input[name=txtTipo]:checked', '#form').val()
	
	if (tipo == '1') {
		
		if (form.txtAutor.value==""){
			//alert("Atenção!\nO campo NOME deve ser preenchido.");
			$('#msg_contact').text('Digite seu nome.');
			form.txtAutor.focus();
			form.txtAutor.select();
			return false;
		}
	
		if (form.txtEmail.value==""){
			//alert("Atenção!\nO campo E-MAIL deve ser preenchido.");
			$('#msg_contact').text('Digite seu e-mail.');
			form.txtEmail.focus();
			form.txtEmail.select();
			return false;
		}
		
		if (form.txtTelefone.value==""){
			//alert("Atenção!\nO campo E-MAIL deve ser preenchido.");
			$('#msg_contact').text('Digite seu telefone.');
			form.txtTelefone.focus();
			form.txtTelefone.select();
			return false;
		}
		
		if (form.txtAssunto.value==""){
			//alert("Atenção!\nO campo E-MAIL deve ser preenchido.");
			$('#msg_contact').text('Digite o assunto.');
			form.txtAssunto.focus();
			form.txtAssunto.select();
			return false;
		}
			
		if (form.txtMensagem.value==""){
			//alert("Atenção!\nO campo MENSAGEM deve ser preenchido.");
			$('#msg_contact').text('Escreva sua mensagem.');
			form.txtMensagem.focus();
			form.txtMensagem.select();
			return false;
		}
	}
	
	if ( confirm ( 'Confirma o envio da sua mensagem?' )) { return true; } else { return false; }
}