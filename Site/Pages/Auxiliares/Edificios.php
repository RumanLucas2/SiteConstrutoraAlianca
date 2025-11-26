<?php
require_once __DIR__ . '/obras-data.php';
$works = loadWorksFromImages(__DIR__ . '/../../images/Obras/Predios', __DIR__ . '/../Predios', '../Predios/');
?>
<!DOCTYPE html>
<!--[if IE 8]> <html lang="pt-br" class="ie8"> <![endif]-->
<!--[if !IE]><!--> <html lang="pt-br"> <!--<![endif]-->
    <head>
        <meta charset="iso-8859-1">
        <title>Construtora Alian&ccedil;a</title>
        <link rel="icon" href="../../images/logo_mini.ico" type="image/x-icon">
        <script type="application/ld+json">
            {
              "@context": "https://schema.org",
              "@type": "Organization",
              "url": "https://construtoralianca.com.br",
              "logo": "https://construtoraalianca.com.br/images/logo_mini.ico"
            }
        </script>
        <!-- Mobile Specific Meta -->
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
        <!-- Custom Fonts -->
        <link rel="stylesheet" href="../../custom-font/fonts.css" />
        <!-- Bootstrap -->
        <link rel="stylesheet" href="../../css/bootstrap.min.css" />
        <!-- Font Awesome -->
        <link rel="stylesheet" href="../../css/font-awesome.min.css" />
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.0/css/all.min.css">
        <!-- Bootsnav -->
        <link rel="stylesheet" href="../../css/bootsnav.css">
        <!-- Fancybox -->
        <link rel="stylesheet" type="text/css" href="../../css/jquery.fancybox.css?v=2.1.5" media="screen" />	
        <!-- Custom stylesheet -->
        <link rel="stylesheet" href="../../css/custom.css" />
        <!--[if lt IE 9]>
                <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
        <![endif]-->
    </head>
    <body>
        <!-- Preloader -->
        <div id="loading">
            <div id="loading-center">
                <div id="loading-center-absolute">
                    <div class="object"></div>
                    <div class="object"></div>
                    <div class="object"></div>
                    <div class="object"></div>
                    <div class="object"></div>
                    <div class="object"></div>
                    <div class="object"></div>
                    <div class="object"></div>
                    <div class="object"></div>
                    <div class="object"></div>
                </div>
            </div>
        </div>
        <div id="header"></div>

        <div class="container portfolio_area text-center" >
            <h2>Edif&iacute;cios Realizados</h2>
            <h6>Clique na imagem para abrir</h6>
                <div class="grid">
                    <div class="grid-sizer"></div>
                    <?php foreach ($works as $work): ?>
                        <div class="grid-item">
                            <h3><?php echo htmlspecialchars($work['title'], ENT_QUOTES, 'ISO-8859-1'); ?></h3>
                            <a href="<?php echo htmlspecialchars($work['link'], ENT_QUOTES, 'ISO-8859-1'); ?>">
                                <?php if (!empty($work['cover'])): ?>
                                    <img alt="<?php echo htmlspecialchars($work['title'], ENT_QUOTES, 'ISO-8859-1'); ?>" src="<?php echo htmlspecialchars($work['cover'], ENT_QUOTES, 'ISO-8859-1'); ?>"/>
                                <?php else: ?>
                                    <div class="no-cover text-center">Capa indispon&iacute;vel</div>
                                <?php endif; ?>
                            </a>
                        </div>
                    <?php endforeach; ?>
                    <?php if (count($works) === 0): ?>
                        <p class="text-muted">Nenhuma obra cadastrada ainda.</p>
                    <?php endif; ?>
                </div>                   
            </div>
        </div>
        <!-- Portfolio end -->
         
        <!-- Footer -->
        <div id="footer"></div>
        <!-- JavaScript -->
        <script src="../../js/jquery-1.12.1.min.js"></script>
        <script src="../../js/bootstrap.min.js"></script>

        <!-- Bootsnav js -->
        <script src="../../js/bootsnav.js"></script>

        <!--Auto Header+Footer-->
        <script src="../../js/includeHeader.js"></script>   
        <script src="../../js/IncludeFooter.js"></script> 

        <!-- JS Implementing Plugins -->
        <script src="../../js/isotope.js"></script>
        <script src="../../js/isotope-active.js"></script>
        <script src="../../js/jquery.fancybox.js?v=2.1.5"></script>
        <script src="../../js/main.js"></script>

        <script src="../../js/jquery.scrollUp.min.js"></script>
    </body>	
</html>	
