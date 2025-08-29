document.addEventListener("DOMContentLoaded", function () {
    const Watell = "551938258969";
    const faceId = "construtoralianca";
    const insta = "aliancaconstrutora";
    const tell = "1938258969";
    const mail = "danielrruman@gmail.com"
    const youtube = "AliancaEngenharia";

    const WaMessage = "Ola, Fiquei interessado na empresa e gostaria de saber mais";
    const headerHTML = `
    <!-- Header -->
    <header>
        <!-- Top Navbar -->
        <div class="top_nav">
            <div class="container">
                <ul class="list-inline info"></ul>
                <ul class="list-inline social_icon">
                    ${faceId?`<li class="social_icon_facebook"><a href="https://www.facebook.com/${faceId}" target="_blank"><span class="fab fa-facebook-f topItem"></span></a></li>`:''} 
                    ${insta?`<li><a href="https://www.instagram.com/${insta}" target="_blank"><span class="fab fa-instagram topItem"></span></a></li>`:''}
                    ${Watell?`<li><a href="https://api.whatsapp.com/send?phone=${Watell}&text=${WaMessage}" target="_blank"><span class="fab fa-whatsapp topItem"></span></a></li>`:''}
                    ${tell?`<li><a href="tel:+551938258969" target="_blank"><span class="fa fa-phone topItem"></span></a></li>`:''}
                    ${mail?`<li><a href="mailto:danielrruman@gmail.com" target="_blank"><span class="fa fa-envelope topItem"></span></a></li>`:''}
                    ${youtube?`<li><a href="https://youtube.com/@${youtube}" target="_blank"><span class="fab fa-youtube topItem"></span></a></li>`:''}
                </ul>			
            </div>
        </div>
        <!-- Navbar -->
        <nav class="navbar bootsnav">
            <div class="top-search">
                <div class="container">
                    <div class="input-group">
                        <span class="input-group-addon"><i class="fa fa-search"></i></span>
                        <input type="text" class="form-control" placeholder="Pesquisar">
                        <span class="input-group-addon close-search"><i class="fa fa-times"></i></span>
                    </div>
                </div>
            </div>
            <div class="container">
                <div class="attr-nav">
                    <ul>
                        <li class="search"><a href="#"><i class="fa fa-search"></i></a></li>
                    </ul>
                </div>
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#navbar-menu">
                        <i class="fa fa-bars"></i>
                    </button>
                    <a class="navbar-brand" href="../Auxiliares/index.html"><img class="logo" src="../../images/logo.png" alt=""></a>
                </div>
                <div class="collapse navbar-collapse" id="navbar-menu">
                    <ul class="nav navbar-nav menu">
                        <li><a href="../Auxiliares/index.html#">Home</a></li>                    
                        <li><a href="../Auxiliares/index.html#about">A Empresa</a></li>
                        <li><a href="../Auxiliares/index.html#services">Servi&ccedil;os</a></li>
                        <li><a href="../Auxiliares/center.html">Projetos</a></li>
                        <li><a href="#footer">Fale Conosco</a></li>
                        <li><a href="../Auxiliares/Enterprise.html">Enterprise</a></li>
                    </ul>
                </div>
            </div>   
        </nav>
    </header>
    `;
    if (document.getElementById("header"))document.getElementById("header").innerHTML = headerHTML;
});
