	<div id="menu">
    
    	<div class="menu_bg"></div>
    
    	<div class="menu_bt_home"><a href="../login/main.asp" class="icon home"><span class="displace">Home</span></a></div>
    
    	<ul class="menu_list smooth_menu clearfix" id="navigation">
        	<li><a href="../usuario_adm/lista.asp" class="shadow">Usu&aacute;rios ADM</a></li>
            <li><a href="../usuario/lista.asp" class="shadow">Usu&aacute;rios / Clientes</a></li>
            <li><a href="#" class="shadow">Empreendimentos</a>
            	<ul>
            		<li><a href="../empreendimento/lista.asp" class="shadow">Empreendimentos</a></li>
                    <li><a href="../banner/lista.asp" class="shadow">Banners</a></li>
            		<li><a href="../galeria/lista.asp" class="shadow">Galerias</a></li>
                    <li><a href="../planta/lista.asp" class="shadow">Plantas</a></li>
            	</ul>
            </li>
            <li><a href="../contato/lista.asp" class="shadow">Contatos</a></li>
        </ul>
   
    </div>
    
	<script type="text/javascript">
		$(function () {
			$('#navigation > li').smoothMenu({
				direction: 'vertical',
				zIndex: 10
			});
		});
	</script>