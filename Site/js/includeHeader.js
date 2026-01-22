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
                        <li class="search"><a href="#" aria-label="Acesso admin"><i class="fa fa-user-shield"></i></a></li>
                    </ul>
                </div>
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle" aria-label="Abrir menu" data-toggle="collapse" data-target="#navbar-menu">
                        <i class="fa fa-bars" aria-hidden="true"></i>
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

    <div id="adminModal" class="admin-modal" aria-hidden="true">
        <div class="admin-card">
            <h4>&Aacute;rea Administrativa</h4>
            <p>Acesso restrito. Informe suas credenciais.</p>
            <form class="admin-form">
                <div>
                    <label for="admin-user">Login</label>
                    <input id="admin-user" name="user" type="text" autocomplete="username" placeholder="Seu usu&aacute;rio">
                </div>
                <div>
                    <label for="admin-pass">Senha</label>
                    <input id="admin-pass" name="pass" type="password" autocomplete="current-password" placeholder="Sua senha">
                </div>
                <div class="admin-actions">
                    <button type="button" class="admin-close">Fechar</button>
                    <button type="submit" class="admin-submit">Entrar</button>
                </div>
            </form>
        </div>
    </div>
    `;
    if (document.getElementById("header"))document.getElementById("header").innerHTML = headerHTML;

    // Modal admin
    const adminModal = document.getElementById('adminModal');
    const openAdmin = () => {
        if (!adminModal) return;
        adminModal.classList.add('show');
        adminModal.setAttribute('aria-hidden','false');
        const user = adminModal.querySelector('#admin-user');
        if (user) user.focus();
    };
    const closeAdmin = () => {
        if (!adminModal) return;
        adminModal.classList.remove('show');
        adminModal.setAttribute('aria-hidden','true');
    };
    const searchLink = document.querySelector('.attr-nav .search a');
    if (searchLink) {
        searchLink.addEventListener('click', function(e){
            e.preventDefault();
            openAdmin();
        });
    }
    if (adminModal) {
        adminModal.addEventListener('click', function(e){
            if (e.target === adminModal) closeAdmin();
        });
        const closeBtn = adminModal.querySelector('.admin-close');
        if (closeBtn) closeBtn.addEventListener('click', closeAdmin);
        const form = adminModal.querySelector('.admin-form');
        if (form) form.addEventListener('submit', function(e){
            e.preventDefault();
            const user = (form.user && form.user.value || '').trim();
            const pass = (form.pass && form.pass.value) || '';
            fetch('/Admin/auth.php', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: 'user=' + encodeURIComponent(user) + '&pass=' + encodeURIComponent(pass)
            }).then(async (res) => {
                const txt = await res.text();
                if (res.ok) { window.location.href = "admin-obra.html"; return; }
                alert(`Falhou (${res.status}): ${txt}`);
            }).catch(() => alert('Erro ao conectar. Tente novamente.'));
        });
    }

    // Controle do menu (abrir/fechar no mobile)
    var $navMenu = window.jQuery ? window.jQuery('#navbar-menu') : null;
    var $toggle = window.jQuery ? window.jQuery('.navbar-toggle') : null;
    // Remove o delay padrão de 350ms do Bootstrap Collapse
    if (window.jQuery && window.jQuery.fn && window.jQuery.fn.collapse && window.jQuery.fn.collapse.Constructor) {
        window.jQuery.fn.collapse.Constructor.TRANSITION_DURATION = 0;
    }
    if ($toggle && $navMenu) {
        $toggle.on('click', function(){
            $navMenu.collapse('toggle');
        });
        // Fecha ao clicar em qualquer link do menu ou ícones de ação
        window.jQuery('.nav.navbar-nav.menu a, .attr-nav a').on('click', function(){
            $navMenu.collapse('hide');
        });
    }
});



