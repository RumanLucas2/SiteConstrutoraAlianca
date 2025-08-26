document.addEventListener("DOMContentLoaded", function () {
    const Watell = "551938258969";
    const faceId = "construtoralianca";
    const insta = "aliancaconstrutora";
    const tell = "1938258969";
    const mail = "danielrruman@gmail.com"
    const youtube = "AliancaEngenharia";

    const WaMessage = "Ola, Fiquei interessado na empresa e gostaria de saber mais";
    const footerHTML = `
    <!-- Footer -->
        <footer id="footer">
            <!-- Footer top -->
            <div class="container footer_top">
                <div class="row">
                    <div class="col-lg-9 col-sm-9">
                        <div class="footer_item">
                            <h4>Sobre a Empresa</h4>
                            <img class="logo" src="../../images/logo_size1.png" alt="Construction" />
                            <p>O nome Alian&ccedil;a foi escolhido para simbolizar o v&iacute;nculo que constru&iacute;mos e mantemos com nossos clientes. Assim, a empresa executa servi&ccedil;os de Gest&agrave;o de obras, Engenharia e constru&ccedil;&atilde;o focada exclusivamente no segmento alto padr&atilde;;o, com modelo de gest&atilde;o financeira e acompanhamento diferenciados, acabamento primoroso, qualidade nos materiais, qualidade na m&atilde;o-de-obra e pontualidade na entrega.</p>

                            <ul class="list-inline footer_social_icon">
                                ${faceId?`<li><a href="https://www.facebook.com/${faceId}" target="_blank"><i class="fa fab fa-facebook-f social facebook"></i></a></li>`:''}
                                ${Watell?`<li><a href="https://api.whatsapp.com/send?phone=${Watell}&text=${WaMessage}" target="_blank"><span class="fa fab fa-whatsapp social wpp"></span></a></li>`:''}
                                ${insta?`<li><a href="https://www.instagram.com/${insta}" target="_blank"><i class="fa fab fa fa-instagram social insta "></i></a></li>`:''}
                                ${tell?`<li><a href="tel:+${tell}" target="_blank"><span class="fa fa-phone social tell"></span></a></li>`:''}
                                ${mail?`<li><a href="mailto:${mail}" target="_blank"><i class="fa fa-envelope social mail"></i></a></li>`:''}
                                ${youtube?`<li><a href="https://youtube.com/@${youtube}" target="_blank"><i class="fa fab fa-youtube social youtube"></i></a></li>`:''}
                            </ul>
                        </div>
                    </div>

                    <div class="col-lg-3 col-sm-3">
                        <div class="footer_item">
                            <h4>Fale Conosco</h4>
                            <ul class="list-unstyled footer_contact">
                                <li><a href="https://goo.gl/maps/fnTJjaekYoPdYycNA" target="_blank"><span class="fa fa-map-marker"></span> Rua Dom Pedro I, 346 <br />Cidade Nova - Indaiatuba/SP</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </footer><!-- Footer top end -->
    `;

    if(document.getElementById("footer"))document.getElementById("footer").innerHTML = footerHTML;
});