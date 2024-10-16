"use strict";
jQuery(document).ready(function ($) {

//==========================================
// MOBILE MENU
//==========================================

    $('#navbar-menu').find('a[href*="#"]:not([href="#"])').click(function () {
        if (location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '') && location.hostname == this.hostname) {
            var target = $(this.hash);
            target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');
            if (target.length) {
                $('html,body').animate({
                    scrollTop: (target.offset().top - 0)
                }, 1000);
                $(this).parents('.container').find(".navbar-toggle").trigger("click");
            }
        }
    });


//==========================================
//ScrollUp
//==========================================

    $('#scrollUp').click(function () {
        $("html, body").animate({scrollTop: 0}, 0);
        return false;
    });



//==========================================
// For fancybox active
//==========================================

    $('.fancybox').fancybox();
    
    

//==========================================
// Loading
//==========================================

    $(window).load(function () {
        $("#loading").fadeOut(1000);
    });
});

//==========================================
// Pop Up
//==========================================


// Elementos
const openBtn = document.getElementById('open-video-btn');
const popup = document.getElementById('video-popup');
const closeBtn = document.querySelector('.close-popup');
const iframe = document.getElementById('video-iframe');
const HomeVideo = document.getElementById('HomeVideo');

// Abrir o PopUp ao clicar no botão
openBtn.addEventListener('click', function() {
    popup.style.display = 'flex';
    iframe.src = 'https://www.youtube.com/embed/zR9F_TN2b50?autoplay=1'; // URL do vídeo
});

// Fechar o PopUp ao clicar no botão de fechar
closeBtn.addEventListener('click', function() {
    popup.style.display = 'none';
    iframe.src = ''; // Para parar o vídeo quando o PopUp for fechado
});

// Fechar o PopUp ao clicar fora do vídeo
popup.addEventListener('click', function(e) {
    if (e.target == popup) {
        popup.style.display = 'none';
        iframe.src = ''; // Para parar o vídeo
    }
});