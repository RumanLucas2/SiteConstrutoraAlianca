"use strict";
jQuery(document).ready(function ($) {

//==========================================
// MOBAILE MENU
//=========================================

    $('#navbar-menu').find('a[href*="#"]:not([href="#"])').click(function () {
        if (location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '') && location.hostname == this.hostname) {
            var target = $(this.hash);
            target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');
            if (target.length) {
                $('html,body').animate({
                    scrollTop: (target.offset().top - 0)
                }, 1000);
                if ($('.navbar-toggle').css('display') != 'none') {
                    $(this).parents('.container').find(".navbar-toggle").trigger("click");
                }
                return false;
            }
        }
    });


//==========================================
//ScrollUp
//=========================================

    $('#scrollUp').click(function () {
        $("html, body").animate({scrollTop: 0}, 0);
        return false;
    });



//==========================================
// For fancybox active
//=========================================

    $('.fancybox').fancybox();
    
    

//==========================================
// Loading
//=========================================

    $(window).load(function () {
        $("#loading").fadeOut(1000);
    });
});


document.getElementById('casas').addEventListener('click', function() {
    var secao = document.getElementById('sectionEncoded');
    if (secao.style.display === 'none') {
        secao.style.display = 'block';
        document.getElementById('casas').style = 'filter: invert()';
    } else {
        secao.style.display = 'none';
        document.getElementById('casas').style = 'filter: none';
    }
});
