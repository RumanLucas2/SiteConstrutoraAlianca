document.addEventListener("DOMContentLoaded", () => {
    // HTML do cabeçalho como uma string
    const headerHTML = `
        <header>
            <div class="top_nav">
                <div class="container">
                    <ul class="list-inline social_icon">
                        <li><a href="https://www.facebook.com/construtoralianca" target="_blank"><span class="fa fa-facebook"></span></a></li>
                        <li><a href="https://www.instagram.com/aliancaconstrutora" target="_blank"><span class="fa fa-instagram"></span></a></li>
                        <li><a href="https://api.whatsapp.com/send?phone=5519989152390&text=Ola, fiquei interessado na empresa e gostaria de saber mais" target="_blank"><span class="fa fa-whatsapp"></span></a></li>
                        <li><a href="tel:+551938258969" target="_blank"><span class="fa fa-phone"></span></a></li>
                        <li><a href="mailto:danielrruman@gmail.com" target="_blank"><span class="fa fa-envelope"></span></a></li>
                    </ul>
                </div>
            </div>
            <nav class="navbar">
                <div class="container">
                    <ul class="nav navbar-nav menu">
                        <li><a href="index.html#">Home</a></li>
                        <li><a href="index.html#about">A Empresa</a></li>
                        <li><a href="index.html#services">Serviços</a></li>
                        <li><a href="center.html">Projetos</a></li>
                        <li><a href="#footer">Fale Conosco</a></li>
                    </ul>
                </div>
            </nav>
        </header>
    `;

    // Insere o HTML no placeholder
    document.getElementById("header-placeholder").innerHTML = headerHTML;
});