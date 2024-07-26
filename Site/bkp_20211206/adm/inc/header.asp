    <div id="header">
    	
        <div class="header_title">
        
            <div class="header_title_bg1"></div>
            <div class="header_title_bg2"></div>
            <div class="header_title_bg3"></div>
        
            <div class="header_title_content">
                <h2>Painel Administrativo</h2>
                <h1>Construtora Alian&ccedil;a</h1>
            </div>
        
        </div>

        <% if(login_page = false) then %>
        
        <div class="header_login"><a href="../login/act_logout.asp"><img src="../img/header_logout_bt.png" alt="Logout" /></a></div>
        
        <% else %>
        
        <div class="header_login"><a href="../login/index.asp"><img src="../img/header_login_bt.png" alt="Login" /></a></div>
        
        <% end if %>
        <!--
        <div class="header_logo"><a href="#" target="_blank"><span class="displace"></span></a></div>-->
        
    </div>
